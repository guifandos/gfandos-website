#!/usr/bin/env bash
# Export the canvas figures in design/_figures.js as static PNGs for Quarto.
#
#   design/tools/export-figures.sh [outdir] [format]   default: images/figures png
#
# Renders each figure in headless Chromium at 2x once the DM Mono web font has
# loaded (labels are drawn in it), converts the canvases to data URLs in-page, dumps the DOM and writes one image per figure. Seeded, so
# re-running gives byte-identical images. Format is "png" (lossless) or
# "webp" (lossy, quality 0.9) — the site uses webp to keep the figure set
# under ~1.5 MB; the noise fields (sdm, range) compress poorly as PNG.
# The `strip` figure in _figures.js is no longer exported (BRIEF.md section 10).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
OUT="${1:-$ROOT/images/figures}"
FMT="${2:-png}"
case "$FMT" in png|webp) ;; *) echo "format must be png or webp" >&2; exit 2;; esac
CHROME=/opt/pw-browsers/chromium-1194/chrome-linux/chrome
TMP="$(mktemp -d)"
mkdir -p "$OUT"

# width x height in CSS px for each figure (2x device pixels in the output)
cat > "$TMP/h.html" <<HTML
<meta charset="utf-8">
<link rel="stylesheet" href="file://$ROOT/fonts/fonts.css">
<style>body{margin:0;background:#fff}canvas{display:block}
#kernel,#sdm,#range,#acoustic{width:640px;height:480px}
#hero{width:1400px;height:800px}</style>
<canvas id="kernel" data-fig="kernel"></canvas>
<canvas id="sdm" data-fig="sdm"></canvas>
<canvas id="range" data-fig="range"></canvas>
<canvas id="acoustic" data-fig="acoustic"></canvas>
<script>window.devicePixelRatio = 2;</script>
<script>
// The labels are set in DM Mono (fonts/fonts.css). Canvas text uses whatever
// face is loaded at draw time, so the figures are drawn only once both DM Mono
// weights have loaded; a failed load still resolves and falls back to the
// stack's system monospace, which the console line below reports.
Promise.all([document.fonts.load('400 12px "DM Mono"'), document.fonts.load('500 12px "DM Mono"')])
  .then(function () { return document.fonts.ready; })
  .then(function () {
    var ok = document.fonts.check('400 12px "DM Mono"');
    var f = document.createElement('output'); f.id = 'fontstate';
    f.textContent = ok ? 'FONT:DM Mono' : 'FONT:fallback';
    document.body.appendChild(f);
$(sed 's/^/    /' "$ROOT/design/_figures.js")
    document.querySelectorAll('canvas[data-fig]').forEach(function (c) {
      var o = document.createElement('output');
      o.setAttribute('data-name', c.id);
      o.textContent = c.toDataURL('image/$FMT', 0.9);
      document.body.appendChild(o);
    });
  });
</script>
HTML

"$CHROME" --headless --no-sandbox --disable-gpu --virtual-time-budget=8000 \
  --window-size=1700,2400 --dump-dom "file://$TMP/h.html" > "$TMP/dom.html" 2>/dev/null

python3 - "$TMP/dom.html" "$OUT" "$FMT" <<'PY'
import base64, re, sys, pathlib
dom = pathlib.Path(sys.argv[1]).read_text()
m = re.search(r'<output id="fontstate">([^<]+)</output>', dom)
print("labels drawn in", m.group(1).replace("FONT:", "") if m else "unknown font")
if not m or "fallback" in m.group(1):
    sys.exit("export-figures.sh: DM Mono did not load; labels would be in a fallback face")
out = pathlib.Path(sys.argv[2])
fmt = sys.argv[3]
n = 0
for name, data in re.findall(r'<output data-name="([a-z]+)">data:image/' + fmt + r';base64,([^<]+)</output>', dom):
    (out / f"{name}.{fmt}").write_bytes(base64.b64decode(data))
    n += 1
    print(f"wrote {out / (name + '.' + fmt)}")
if n == 0:
    sys.exit("no figures exported — check the harness")
PY
rm -rf "$TMP"
