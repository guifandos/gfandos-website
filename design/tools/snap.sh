#!/usr/bin/env bash
# Render the Quarto site to a preview dir and screenshot key pages.
#
#   design/tools/snap.sh [outdir]      default outdir: design/snaps
#
# Produces <outdir>/<page>-<width>.png for each page at desktop (1440) and
# phone (390) widths. Renders to _preview/ (git-ignored), never to docs/.
#
# Harness notes (all three matter for an honest screenshot):
# - Pages are loaded over file://, and Quarto's quarto.js is an ES module, which
#   Chrome refuses to import from file:// without --allow-file-access-from-files
#   (symptom: an empty "On this page" TOC).
# - Headless Chrome has a 500 px minimum window width, so widths under 500 are
#   shot through a same-size <iframe> in a wrapper page.
# - CSS animations do not advance under --virtual-time-budget, so the hero's
#   stroke-dashoffset traces would be captured undrawn. --force-prefers-reduced-motion
#   captures their final state instead (the same state a reduced-motion user sees).
# - Web fonts are self-hosted (fonts/), so they load over file:// like any
#   other resource. The font check below fails loudly if they do not, since a
#   screenshot in fallback fonts is worthless for judging typography.
# - Headless Chrome ignores HTTPS_PROXY; if one is set it is passed explicitly
#   so any remaining network resources resolve in a proxied harness.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
OUT="${1:-$ROOT/design/snaps}"
CHROME=/opt/pw-browsers/chromium-1194/chrome-linux/chrome
mkdir -p "$OUT"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

cd "$ROOT"
quarto render --output-dir _preview --quiet

FLAGS=(--headless --no-sandbox --disable-gpu --hide-scrollbars
       --allow-file-access-from-files --force-prefers-reduced-motion
       --virtual-time-budget=6000)
if [ -n "${HTTPS_PROXY:-}" ]; then
  FLAGS+=(--proxy-server="$HTTPS_PROXY" --ignore-certificate-errors)
fi

# Font check: a page that uses the site's own font stylesheet and reports which
# families actually loaded. Fewer than three means the screenshots would show
# fallback fonts.
cat > "$TMP/fontcheck.html" <<HTML
<!doctype html><meta charset="utf-8">
<link rel="stylesheet" href="file://$ROOT/_preview/fonts/fonts.css">
<p style="font-family:'Familjen Grotesk';font-weight:700">Ag</p>
<p style="font-family:'Literata'">Ag <i>Ag</i></p>
<p style="font-family:'DM Mono'">Ag</p>
<div id="loaded"></div>
<script>
document.fonts.ready.then(() => {
  const fams = new Set([...document.fonts].filter(f => f.status === 'loaded').map(f => f.family.replace(/"/g, '')));
  document.getElementById('loaded').textContent = 'LOADED:' + [...fams].sort().join(',');
});
</script>
HTML
loaded="$("$CHROME" "${FLAGS[@]}" --dump-dom "file://$TMP/fontcheck.html" 2>/dev/null | grep -o '<div id="loaded">LOADED:[^<]*' | sed 's/.*>//' || true)"
echo "fonts ${loaded:-LOADED:(none)}"
if [ "$(echo "${loaded#LOADED:}" | tr ',' '\n' | grep -c .)" -lt 3 ]; then
  echo "snap.sh: web fonts did not load; screenshots would show fallback fonts" >&2
  exit 1
fi

PAGES=(index research/index publications people projects/index teaching)
for p in "${PAGES[@]}"; do
  name="${p//\//-}"
  for w in 1440 390; do
    h=$([ "$w" = 1440 ] && echo 3400 || echo 4200)
    url="file://$ROOT/_preview/$p.html"
    if [ "$w" -lt 500 ]; then
      cat > "$TMP/frame-$name-$w.html" <<HTML
<!doctype html><meta charset="utf-8">
<style>html,body{margin:0;padding:0;background:#fff}iframe{display:block;border:0;width:${w}px;height:${h}px}</style>
<iframe src="$url"></iframe>
HTML
      url="file://$TMP/frame-$name-$w.html"
    fi
    "$CHROME" "${FLAGS[@]}" --window-size="$w,$h" \
      --screenshot="$OUT/$name-$w.png" "$url" 2>/dev/null
  done
done
ls -1 "$OUT"
