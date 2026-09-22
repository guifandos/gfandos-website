#!/usr/bin/env bash
# Export the canvas figures in design/_figures.js as static PNGs for Quarto.
#
#   design/tools/export-figures.sh [outdir]     default: images/figures
#
# Renders each figure in headless Chromium at 2x, converts the canvases to
# data URLs in-page, dumps the DOM and writes one PNG per figure. Seeded, so
# re-running gives byte-identical images.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
OUT="${1:-$ROOT/images/figures}"
CHROME=/opt/pw-browsers/chromium-1194/chrome-linux/chrome
TMP="$(mktemp -d)"
mkdir -p "$OUT"

# width x height in CSS px for each figure (2x device pixels in the output)
cat > "$TMP/h.html" <<HTML
<meta charset="utf-8">
<style>body{margin:0;background:#fff}canvas{display:block}
#kernel,#sdm,#range,#acoustic{width:640px;height:480px}
#strip{width:1600px;height:160px}
#hero{width:1400px;height:800px}</style>
<canvas id="kernel" data-fig="kernel"></canvas>
<canvas id="sdm" data-fig="sdm"></canvas>
<canvas id="range" data-fig="range"></canvas>
<canvas id="acoustic" data-fig="acoustic"></canvas>
<canvas id="strip" data-fig="strip"></canvas>
<script>window.devicePixelRatio = 2;</script>
<script>
$(cat "$ROOT/design/_figures.js")
</script>
<script>
document.querySelectorAll('canvas[data-fig]').forEach(function (c) {
  var o = document.createElement('output');
  o.setAttribute('data-name', c.id);
  o.textContent = c.toDataURL('image/png');
  document.body.appendChild(o);
});
</script>
HTML

"$CHROME" --headless --no-sandbox --disable-gpu --virtual-time-budget=8000 \
  --window-size=1700,2400 --dump-dom "file://$TMP/h.html" > "$TMP/dom.html" 2>/dev/null

python3 - "$TMP/dom.html" "$OUT" <<'PY'
import base64, re, sys, pathlib
dom = pathlib.Path(sys.argv[1]).read_text()
out = pathlib.Path(sys.argv[2])
n = 0
for name, data in re.findall(r'<output data-name="([a-z]+)">data:image/png;base64,([^<]+)</output>', dom):
    (out / f"{name}.png").write_bytes(base64.b64decode(data))
    n += 1
    print(f"wrote {out / (name + '.png')}")
if n == 0:
    sys.exit("no figures exported — check the harness")
PY
rm -rf "$TMP"
