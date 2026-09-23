#!/usr/bin/env bash
# Render the Quarto site to a preview dir and screenshot key pages.
#
#   design/tools/snap.sh [outdir]      default outdir: design/snaps
#
# Produces <outdir>/<page>-<width>.png for each page at desktop (1440) and
# phone (390) widths. Renders to _preview/ (git-ignored), never to docs/.
#
# Harness notes (all of them matter for an honest screenshot):
# - Capture goes through Playwright (installed globally under /opt/node22),
#   driving the same headless Chromium as before. Each page is loaded ONCE and
#   shot full-page in that same load, after web fonts and images have settled.
#   The earlier two-pass harness (measure the height in a 600 px iframe, then
#   reload at that height) left the tail of long phone pages unpainted, so the
#   footer was cut mid-sentence over a white block: a harness artefact, not the
#   layout. Full-page capture in one load has no second layout to drift from.
# - Pages are loaded over file://, and Quarto's quarto.js is an ES module, which
#   Chrome refuses to import from file:// without --allow-file-access-from-files
#   (symptom: an empty "On this page" TOC).
# - Nothing on the site animates any more, but reducedMotion is still forced so
#   a future transition is captured in its final state.
# - Web fonts are self-hosted (fonts/), so they load over file:// like any other
#   resource. The font check fails loudly if fewer than three families load,
#   since a screenshot in fallback fonts is worthless for judging typography.
# - The script also asserts that no page scrolls horizontally at either width
#   (acceptance §7.1) and that the footer ends where the document ends.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
OUT="${1:-$ROOT/design/snaps}"
export PLAYWRIGHT_BROWSERS_PATH="${PLAYWRIGHT_BROWSERS_PATH:-/opt/pw-browsers}"
export NODE_PATH="${NODE_PATH:-/opt/node22/lib/node_modules}"
mkdir -p "$OUT"

cd "$ROOT"
quarto render --output-dir _preview --quiet

ROOT="$ROOT" OUT="$OUT" node - <<'JS'
const { chromium } = require('playwright');
const path = require('path');
const fs = require('fs');
const os = require('os');
const ROOT = process.env.ROOT, OUT = process.env.OUT;
const PAGES = ['index', 'research/index', 'publications', 'people', 'projects/index', 'teaching'];
const WIDTHS = [1440, 390];

(async () => {
  const browser = await chromium.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-gpu', '--allow-file-access-from-files'],
  });
  const settle = async (page) => {
    await page.evaluate(async () => {
      await document.fonts.ready;
      await Promise.all([...document.images].map(img => img.complete ? null :
        new Promise(res => { img.addEventListener('load', res, { once: true }); img.addEventListener('error', res, { once: true }); })));
    });
    await page.waitForTimeout(300);   // quarto.js post-load work (TOC, anchors)
  };

  // Font check on the site's own stylesheet. Written to a file so it shares
  // the file:// origin of the stylesheet (about:blank cannot load file:// CSS).
  {
    const fc = path.join(fs.mkdtempSync(path.join(os.tmpdir(), 'snap-')), 'fontcheck.html');
    fs.writeFileSync(fc, `<!doctype html><meta charset="utf-8">
      <link rel="stylesheet" href="file://${ROOT}/_preview/fonts/fonts.css">
      <p style="font-family:'Familjen Grotesk';font-weight:700">Ag</p>
      <p style="font-family:'Literata'">Ag <i>Ag</i></p>
      <p style="font-family:'DM Mono'">Ag</p>`);
    const page = await browser.newPage({ viewport: { width: 800, height: 400 } });
    await page.goto('file://' + fc, { waitUntil: 'load' });
    const fams = await page.evaluate(async () => {
      await document.fonts.ready;
      return [...new Set([...document.fonts].filter(f => f.status === 'loaded').map(f => f.family.replace(/"/g, '')))].sort();
    });
    console.log('fonts LOADED:' + fams.join(','));
    if (fams.length < 3) {
      console.error('snap.sh: web fonts did not load; screenshots would show fallback fonts');
      process.exit(1);
    }
    await page.close();
    fs.rmSync(path.dirname(fc), { recursive: true, force: true });
  }

  let failed = false;
  for (const p of PAGES) {
    const name = p.replace(/\//g, '-');
    for (const w of WIDTHS) {
      const page = await browser.newPage({ viewport: { width: w, height: 900 }, reducedMotion: 'reduce' });
      await page.goto(`file://${ROOT}/_preview/${p}.html`, { waitUntil: 'load' });
      await settle(page);
      const m = await page.evaluate(() => {
        const de = document.documentElement;
        const f = document.querySelector('footer.footer');
        return {
          h: de.scrollHeight,
          overflowX: de.scrollWidth > de.clientWidth,
          footerBottom: f ? Math.round(f.getBoundingClientRect().bottom + window.scrollY) : null,
        };
      });
      const file = path.join(OUT, `${name}-${w}.png`);
      await page.screenshot({ path: file, fullPage: true });
      const notes = [];
      if (m.overflowX) { notes.push('HORIZONTAL SCROLL'); failed = true; }
      if (m.footerBottom !== null && Math.abs(m.footerBottom - m.h) > 1) { notes.push(`footer ends at ${m.footerBottom}, document at ${m.h}`); failed = true; }
      console.log(`${name}-${w} ${w}x${m.h}${notes.length ? '  ** ' + notes.join('; ') : ''}`);
      await page.close();
    }
  }
  await browser.close();
  if (failed) { console.error('snap.sh: layout checks failed (see ** above)'); process.exit(1); }
})().catch(e => { console.error(e); process.exit(1); });
JS
ls -1 "$OUT"
