#!/usr/bin/env bash
# Crop and/or resize a photograph to WebP through headless Chromium.
#
#   design/tools/crop-image.sh SRC DST OUT_W [SX SY SW SH]
#
# SX SY SW SH are the crop rectangle in source pixels (omit to keep the whole
# frame). Output width OUT_W; height follows the crop's aspect ratio.
# Originals are never modified; SRC may be an absolute path outside the repo.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CHROME=/opt/pw-browsers/chromium-1194/chrome-linux/chrome
src="$1"; dst="$2"; w="$3"; sx="${4:-0}"; sy="${5:-0}"; sw="${6:-0}"; sh="${7:-0}"
case "$src" in /*) ;; *) src="$ROOT/$src";; esac
tmp="$(mktemp -d)"; mkdir -p "$(dirname "$dst")"
cat > "$tmp/h.html" <<HTML
<meta charset="utf-8"><img id="i" src="file://$src">
<script>
var i=document.getElementById('i');
function go(){
  var sx=$sx, sy=$sy, sw=$sw||i.naturalWidth, sh=$sh||i.naturalHeight;
  var w=$w, h=Math.round(sh*w/sw);
  var c=document.createElement('canvas'); c.width=w; c.height=h;
  var x=c.getContext('2d'); x.imageSmoothingEnabled=true; x.imageSmoothingQuality='high';
  x.drawImage(i,sx,sy,sw,sh,0,0,w,h);
  var o=document.createElement('output'); o.id='out'; o.textContent=c.toDataURL('image/webp',0.86);
  document.body.appendChild(o);
}
if(i.complete&&i.naturalWidth) go(); else i.onload=go;
</script>
HTML
"$CHROME" --headless --no-sandbox --disable-gpu --allow-file-access-from-files \
  --virtual-time-budget=10000 --window-size=800,600 --dump-dom "file://$tmp/h.html" 2>/dev/null > "$tmp/dom.html"
python3 - "$tmp/dom.html" "$dst" <<'PY'
import base64,re,sys,pathlib
m=re.search(r'<output id="out">data:image/webp;base64,([^<]+)</output>',pathlib.Path(sys.argv[1]).read_text())
if not m: sys.exit("no output — image did not load")
pathlib.Path(sys.argv[2]).write_bytes(base64.b64decode(m.group(1))); print("wrote",sys.argv[2])
PY
rm -rf "$tmp"
