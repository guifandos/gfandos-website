# Design brief — gfandos.com redesign in Quarto

This is the working brief for the redesign. Agents implementing or critiquing
the site read this first and treat it as the source of truth. Where this brief
and an agent's taste disagree, the brief wins; where the brief is silent, choose
the quieter option.

## 1. What the site is for

A personal academic site for Guillermo Fandos, spatial ecologist and Assistant
Professor at the Universidad Complutense de Madrid. Movement ecology, species
distribution modelling, conservation under global change, field monitoring
technology.

Readers, in order of how much they matter:

1. **Prospective PhD and MSc students** deciding whether to write to him. They
   need to understand in under a minute what the group works on, with what data
   and methods, and whether it looks like a place where careful work happens.
2. **Collaborators and reviewers** checking who he is, what he has published,
   and how to reach him. They want the publication list and the contact block
   and nothing in the way.
3. **Journalists and funders** who land from a paper or a news item and need a
   credible one-line summary and a portrait.

The site's single job: make a careful, quantitative ecologist legible at a
glance, and make his work easy to find. Visual impact serves that job; it is
not the job.

## 2. Non-negotiables

- **Quarto stays.** The site is a Quarto website rendered to `docs/` and served
  by GitHub Pages. Every page remains a `.qmd` file that a non-designer can
  edit in markdown. No forked Quarto templates, no custom Pandoc templates, no
  build step beyond `quarto render`.
- **Survive Quarto upgrades.** Style through the sanctioned surface: a Bootswatch
  or `default` base theme plus one SCSS file with `/*-- scss:defaults --*/` and
  `/*-- scss:rules --*/`, `include-in-header` for fonts, fenced divs with
  classes for layout. Do not depend on Quarto's internal class names beyond the
  stable ones (`navbar`, `quarto-title`, `nav-footer`, `content`).
- **Keep what Quarto gives for free**: site search, navbar with the Research
  dropdown and social icons, footer links, sitemap, per-page descriptions, TOC
  on long pages (publications, research subpages).
- **No content invention.** Reorganise and tighten existing text; do not add
  claims, numbers, quotes, affiliations or achievements that are not already
  on the site. Where a section needs content that does not exist yet (people
  photos, a software page), leave an HTML comment `<!-- TODO: ... -->`, never
  filler.
- **Schematic figures are labelled as such** in their caption, every time.
- **Never touch the data.** `images/` originals are not resized or overwritten;
  derived assets go in new paths.

## 3. Visual system (from the "Lattice" preview)

The preview at `design/preview-lattice.html` is the visual reference. Match its
feel; do not transcribe its markup.

**Tokens**

| Role | Value | Notes |
|---|---|---|
| ground | `#eceff1` | pale blue-grey, lifted from `images/banner.png` |
| paper | `#f7f8f8` | alternate band |
| ink | `#16252d` | slate, never pure black |
| ink-soft | `#4a616c` | body on ground |
| ink-faint | `#8298a3` | metadata |
| rule | `#ccd6da` | hairlines |
| grid | `#dde5e8` | the lattice |
| accent | `#0f5f58` | deep teal — links, hover rules |
| mark | `#b87309` | ochre — reserved for long-distance events and figure labels |
| deep | `#0f1e26` | footer, figure grounds |

Body text on ground must meet WCAG AA (4.5:1). `ink-faint` is for metadata at
≥ 0.72 rem only.

**Type**

- Headings, nav, brand: **Familjen Grotesk** 600/700, tight tracking
  (−0.018 em; −0.035 em on the hero name).
- Running text: **Literata** 400, 17 px, line-height 1.62, measure ≤ 65 ch.
- Data and metadata (sources, years, codes, captions): **DM Mono** 400/500,
  uppercase with 0.08–0.12 em tracking for labels.
- All three from Google Fonts with real fallback stacks. No Inter, no Space
  Grotesk, no Merriweather, no Source Sans.

**Structure**

- One gutter, one measure: `max-width: 1140px`, side padding `clamp(18px, 4vw,
  44px)`.
- A visible **lattice** (56 px grid) in the hero only, masked out towards the
  bottom. It is the grid a distribution model works on; it is not wallpaper.
- Sections are separated by full-width hairlines and alternate ground/paper.
- **Left rail carries information, not decoration**: the data source for each
  research line, the year for each publication, the date for each news item.
  No `01 / 02 / 03` numbering on anything that is not a sequence.
- No cards with shadows, no rounded corners over 2 px, no hover lift, no round
  avatar. The portrait is rectangular, `aspect-ratio: 4/4.4`, slight
  desaturation, hairline border, mono caption.
- Motion: the hero traces draw once on load (CSS `stroke-dashoffset`), and
  nothing else moves. `prefers-reduced-motion` disables it.

**Hero**

Left: mono eyebrow (department · university), name at `clamp(2.9rem, 8.2vw,
5.4rem)`, a one-sentence thesis in Literata italic with a 2 px teal left rule,
a short lede, a row of mono identity links (email, Scholar, ORCID, GitHub).
Right: portrait. Behind: the dispersal-kernel SVG from
`design/generate_kernel.py` (light theme), teal traces with ochre long-distance
events, over the lattice. Below the hero, a "Fig. 1" legend strip in mono
explaining what the graphic is and that it is schematic.

## 4. Figures

Five generated figures exist in `design/_figures.js`, exported to PNG by
`design/tools/export-figures.sh` (seeded, byte-identical on re-run):

| Figure | Where it goes |
|---|---|
| `kernel` | Research line: animal movement in dynamic landscapes |
| `sdm` | Research line: improving biodiversity monitoring and modelling |
| `range` | Research line: conservation under global change |
| `acoustic` | Research line: field technology for monitoring |
| `strip` | Full-bleed divider between research and projects |

Rules:

- Export to `images/figures/`. Keep the total under ~1.5 MB: drop the per-pixel
  noise term in `acoustic` or export as WebP (`toDataURL('image/webp', 0.9)`)
  if PNG stays large.
- Every figure caption begins with **Schematic.** in ochre and says what the
  figure shows in one sentence. No numbers that could be read as results.
- Markup is designed to be swapped: a real figure from a paper replaces the
  `<img>`; caption and layout do not change. Say this in a comment next to the
  first figure.
- The figure ground is `deep`; figures read as dark panels on a light page, the
  way figures do in a paper.

## 5. Page by page

**index.qmd** — Hero, Fig. 1 legend, Research (four rows: rail · text ·
figure), permeability strip, Projects (three, with a mono `<dl>` of role /
years / PI / funder), Selected publications (six, year rail), News, footer
with contact. Drop the `about: trestles` block and the "What I Do" grid. Keep
`page-layout: full` or equivalent so the hero can bleed.

**research/index.qmd** — Same four rows, longer text, each linking to its
subpage. The approach and collaborators sections stay.

**research/*.qmd** — Title, a figure at the top where one exists, then the
existing text. TOC on.

**projects/index.qmd** — Active / past. Each project is a block with a mono
code line, title, one paragraph, `<dl>` metadata. No cards.

**people.qmd** — Grid of people, each a block with a rectangular photo slot
(hairline placeholder box, not a broken image, when the photo is missing),
name, mono role, one paragraph. `<!-- TODO: photo -->` stays.

**publications.qmd** — Year rail, title, authors with Fandos in medium weight,
journal in italic, DOI as a mono link. Keep the grouping by theme or switch to
chronological — choose one and say why in the commit. TOC on.

**teaching.qmd / outreach.qmd** — Restyle only; the existing banner images
become full-width, hairline-bordered, with a mono caption.

**Footer** — `deep` ground, three columns: address · elsewhere · a fine-print
line on open science. The UCM SVG is currently broken in the render; fix the
path or drop it.

## 6. What to avoid, explicitly

The current site reads as a template. So do most obvious alternatives. Do not
ship any of the following:

- Bootstrap defaults: `.card` with `box-shadow`, `border-radius: 8px`,
  `translateY(-2px)` on hover, the primary-blue `#2c5aa0`, badge pills.
- The current AI-design house style: warm cream with serif display and
  terracotta; near-black with acid green; Inter / Space Grotesk; emoji as
  section markers; numbered `01/02/03` sections; everything centred; gradient
  heroes; icon grids of three.
- Stock decoration: the `images/banner*.png` illustrations are not used on the
  home page. They may stay as page banners elsewhere only if they read as
  illustration, not as a hero.
- Invented figures or statistics of any kind.

## 7. Acceptance criteria

The redesign is done when all of the following hold:

1. `design/tools/snap.sh design/snaps/final` completes without Quarto
   warnings about missing resources, and every page renders at 1440 px and
   390 px with no horizontal scroll and no clipped text.
2. Every screenshot in `design/snaps/final/` passes the three critique lenses
   in §8 with zero blocking findings.
3. `git diff --stat` touches `_quarto.yml`, `styles/`, the `.qmd` files, new
   assets under `images/figures/` and `images/hero/`, and nothing under
   `docs/` until the final render. Originals under `images/` are unchanged.
4. A non-designer can add a publication or a news item by copying one existing
   block in the `.qmd` — no HTML knowledge beyond a fenced div.
5. Search, navbar dropdown, social icons, footer links and sitemap still work
   in the rendered output.

## 8. Critique lenses

Critics read this brief, the screenshots in `design/snaps/before/` (baseline)
and the latest round, and the source. Each finding names the page, the
evidence (which screenshot, which file and line), the problem and a concrete
fix. Severity:

- **blocking** — violates §2 or §6, breaks a page, or makes text unreadable.
- **should** — clearly weakens the brief's intent; fix in the next round.
- **nice** — polish; carry into a later pass.

**Design director.** Identity, hierarchy, typographic rhythm, spacing
consistency, whether the figures and interface read as one system, whether
anything reads as template or as the AI house style. Be demanding: the client
has already rejected work that felt generic.

**Academic reader.** Play three people in turn — a prospective PhD student,
a reviewer looking for a paper, a journalist looking for a portrait and a
one-liner. For each: what did you understand in the first ten seconds, what
did you look for and how many steps did it take, what undermined credibility.
Check honesty: every figure labelled schematic, no invented content, TODOs
where content is missing.

**Front-end engineer.** Quarto-idiomatic (§2), maintainable by a non-designer
(§7.4), accessible (contrast, focus states, reduced motion, alt text, heading
order), responsive at 390 px, asset weight, no broken resources, no dependence
on fragile Quarto internals. Run `quarto render --output-dir _preview` yourself
if the screenshots leave a question open.

## 9. Tooling

- `quarto` 1.10.18 is installed. Render previews with
  `quarto render --output-dir _preview` (git-ignored); render `docs/` only at
  the very end.
- `design/tools/snap.sh <outdir>` renders and screenshots six pages at two
  widths.
- `design/tools/export-figures.sh <outdir>` exports the five figures as PNG.
- `python3 design/generate_kernel.py` regenerates the hero SVG parts.
- Headless Chromium is at `/opt/pw-browsers/chromium-1194/chrome-linux/chrome`.
- No R, no PIL, no ImageMagick. Image processing goes through Chromium or
  pure Python.
