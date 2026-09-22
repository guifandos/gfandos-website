#!/usr/bin/env bash
# Render the Quarto site to a preview dir and screenshot key pages.
#
#   design/tools/snap.sh [outdir]      default outdir: design/snaps
#
# Produces <outdir>/<page>-<width>.png for each page at desktop (1440) and
# phone (390) widths. Renders to _preview/ (git-ignored), never to docs/.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
OUT="${1:-$ROOT/design/snaps}"
CHROME=/opt/pw-browsers/chromium-1194/chrome-linux/chrome
mkdir -p "$OUT"

cd "$ROOT"
quarto render --output-dir _preview --quiet

PAGES=(index research/index publications people projects/index teaching)
for p in "${PAGES[@]}"; do
  name="${p//\//-}"
  for w in 1440 390; do
    h=$([ "$w" = 1440 ] && echo 3400 || echo 4200)
    "$CHROME" --headless --no-sandbox --disable-gpu --hide-scrollbars \
      --virtual-time-budget=6000 --window-size="$w,$h" \
      --screenshot="$OUT/$name-$w.png" "file://$ROOT/_preview/$p.html" 2>/dev/null
  done
done
ls -1 "$OUT"
