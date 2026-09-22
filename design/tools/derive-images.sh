#!/usr/bin/env bash
# Make downscaled WebP copies of large photographs for the page banners.
#
#   design/tools/derive-images.sh            default: the list below
#   design/tools/derive-images.sh SRC DST W  one image, W = target width (px)
#
# The originals under images/ are never modified (design/BRIEF.md section 2);
# derived copies go to images/derived/. Resizing goes through headless Chromium
# (draw the image on a canvas, toDataURL('image/webp', 0.85)), the same route
# as export-figures.sh, since the environment has no PIL or ImageMagick.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CHROME=/opt/pw-browsers/chromium-1194/chrome-linux/chrome

derive() {
  local src="$1" dst="$2" w="$3" tmp
  tmp="$(mktemp -d)"
  mkdir -p "$(dirname "$dst")"
  cat > "$tmp/h.html" <<HTML
<meta charset="utf-8">
<img id="i" src="file://$ROOT/$src">
<script>
// onload rather than img.decode(): the promise does not settle under
// --virtual-time-budget, the load event does.
var i = document.getElementById('i');
function go() {
  var w = $w, h = Math.round(i.naturalHeight * w / i.naturalWidth);
  var c = document.createElement('canvas'); c.width = w; c.height = h;
  var ctx = c.getContext('2d');
  ctx.imageSmoothingEnabled = true; ctx.imageSmoothingQuality = 'high';
  ctx.drawImage(i, 0, 0, w, h);
  var o = document.createElement('output'); o.id = 'out';
  o.textContent = c.toDataURL('image/webp', 0.85);
  document.body.appendChild(o);
}
if (i.complete && i.naturalWidth) go(); else i.onload = go;
</script>
HTML
  "$CHROME" --headless --no-sandbox --disable-gpu --allow-file-access-from-files \
    --virtual-time-budget=8000 --window-size=800,600 --dump-dom "file://$tmp/h.html" \
    > "$tmp/dom.html" 2>/dev/null
  python3 - "$tmp/dom.html" "$dst" <<'PY'
import base64, re, sys, pathlib
dom = pathlib.Path(sys.argv[1]).read_text()
m = re.search(r'<output id="out">data:image/webp;base64,([^<]+)</output>', dom)
if not m:
    sys.exit("derive-images.sh: no image produced — check the harness")
out = pathlib.Path(sys.argv[2]); out.write_bytes(base64.b64decode(m.group(1)))
print(f"wrote {out} ({out.stat().st_size} bytes)")
PY
  rm -rf "$tmp"
}

cd "$ROOT"
if [ $# -eq 3 ]; then
  derive "$1" "$2" "$3"
else
  # outreach banner: shown at <= 1140 px wide, capped at 420 px tall
  derive images/outreach-field.jpg images/derived/outreach-field-1400.webp 1400
fi
