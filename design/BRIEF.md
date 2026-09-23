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

---

## 10. Home page revision (decided 23 September 2026)

This section supersedes §3 "Hero", §4's use of the `strip` figure and the
home-page rows of §5. The visual reference is
`design/preview-home-A-cabaneros.html`; match it, do not paste its markup.

**Hero — person first, nothing animated.** No lattice grid, no kernel SVG,
no Fig. 1 legend. Two columns at ≥ 821 px, `minmax(0,1fr) 272px`, gap
`clamp(28px,5vw,72px)`, aligned to the end, padding-block
`clamp(48px,7vw,84px) clamp(32px,4vw,48px)`.

Left column, in order:
- eyebrow, DM Mono .74rem uppercase: `Dept. Biodiversidad, Ecología y Evolución · Universidad Complutense de Madrid`
- h1 `Guillermo Fandos`, `clamp(2.7rem,7vw,4.6rem)`, weight 700, tracking −0.035em
- role line, Familjen Grotesk 500 `clamp(1rem,1.6vw,1.2rem)` ink-soft: `Quantitative ecologist · Assistant Professor`
- motto, Literata italic `clamp(1.15rem,2.1vw,1.45rem)`, 2 px teal left rule, max 30ch: `Understanding where species live, how they move, and how that is changing.`
- lede, ink-soft, max 58ch: `I study the processes that shape the distribution and abundance of animal populations, combining fieldwork, large-scale data synthesis and statistical modelling to address questions in biogeography, movement ecology and conservation.`
- identity links, DM Mono .8rem, hairline underline: gfandos@ucm.es · Google Scholar · ORCID · GitHub

Right column: `images/avatar.jpg`, rectangular, `aspect-ratio: 4/4.6`,
`object-position: 50% 28%`, `filter: grayscale(.25) contrast(1.03)`, hairline
border, **no caption**. At ≤ 820 px one column, portrait first at max 220 px.

**Landscape band — quiet, directly under the hero.** `images/derived/
cabaneros-band-1800.webp` as a full-width figure, `height: clamp(170px,
24vw, 260px)`, `object-fit: cover`, `object-position: 50% 42%`,
`filter: saturate(.8)`. No hairline, no caption. Top and bottom edges
feather into the page over 38 px:
`mask-image: linear-gradient(180deg, transparent 0, #000 38px, #000 calc(100% - 38px), transparent 100%)`
(with the `-webkit-` prefix). The generated permeability `strip` is removed.

**Research section.** Head: kicker `Research`, h2 `Understanding and
forecasting where species live, and how that is changing`. Four `.line`
rows, rail · text · figure. The rail no longer lists data sources; it reads
`Themes` (kicker) and two sub-disciplines. Exact copy:

1. Rail: Movement ecology / Biogeography. Title: **Movement and the geography
   of species** → research/dispersal.qmd. Text: *Animals move at every scale,
   from a morning's foraging to a lifetime's dispersal, and those movements
   set where populations persist, how connected they are and how fast ranges
   can shift. I study how individual movement scales up to population and
   range dynamics, and why individuals of the same species differ so much in
   how far they go.* Figure: `images/figures/kernel.webp`, caption
   **Schematic.** Dispersal kernel: most individuals settle nearby, a few
   travel an order of magnitude farther.
2. Rail: Statistical ecology / Species distribution modelling. Title:
   **Biodiversity modelling and forecasting** → research/forecasting.qmd.
   Text: *Most models of species distributions describe where a species is
   found, not the processes that put it there. I develop models that carry
   ecological process explicitly — dispersal, population dynamics, species
   interactions, imperfect detection — and that integrate heterogeneous data,
   so that forecasts of biodiversity change rest on mechanism rather than
   correlation.* Figure: `images/figures/sdm.webp`, caption **Schematic.**
   Habitat suitability surface with occurrence records.
3. Rail: Conservation biology / Global change. Title: **Conservation under
   global change** → research/conservation.qmd. Text: *Habitat loss and
   climate change are redrawing species distributions. I work on anticipating
   which species are most exposed and why, and on turning that understanding
   into spatial priorities: where and when problems will emerge, and where
   intervention is most likely to matter.* Figure: `images/figures/range.webp`,
   caption **Schematic.** Occupied area today against a projected contour.
4. Rail: Ecological monitoring / Emerging technologies. Title: **Monitoring
   biodiversity at scale** → outreach.qmd#field-technology. Text: *Good
   inference needs good observation. I work on how autonomous sensors,
   citizen science and long-term surveys can be designed and combined to
   monitor wildlife at the scales that conservation decisions require, and on
   the analytical pipelines that turn raw observations into evidence.*
   Figure: `images/derived/audiomoth-fig-1200.webp` — a real photograph, so
   the caption is factual, not "Schematic": *Deploying an AudioMoth acoustic
   recorder on an almond tree. Photo: Guillermo Fandos.*

Projects, selected publications and news continue as built.

**Photo credits block at the end of the page**, before the footer: kicker
`Photographs`, one paragraph in DM Mono .72rem ink-faint on the paper ground:
`Portrait: Guillermo Fandos, PhD in Ecology 2017, Universidad Complutense de Madrid. · Landscape: Sierras de Cabañeros, Parque Nacional de Cabañeros — photo FrDr, CC BY-SA 4.0, via Wikimedia Commons. · Field: deploying an AudioMoth acoustic recorder on an almond tree, photo Guillermo Fandos. · Research figures marked Schematic are generated illustrations, not fitted to data.`
"FrDr" links to https://commons.wikimedia.org/wiki/File:Parque_nacional_de_Caba%C3%B1eros_40.jpg.
The CC BY-SA attribution is a licence obligation, not decoration.

**Wording site-wide.** Replace "spatial ecologist" / "spatial ecology" with
"quantitative ecologist" / "quantitative ecology" wherever it appears
(`index.qmd` description and image-alt, `_quarto.yml` description,
`people.qmd` twice).

**research/index.qmd.** Same four lines and rails as the home page, with the
longer existing text where it exists; the head reads `Research lines` /
`Understanding and forecasting where species live, and how that is changing`.
Approach and collaborators sections stay.

**Remove.** `_includes/hero-kernel.qmd`, the hero-kernel output of
`design/generate_kernel.py` (delete the script and its `.part` outputs;
update `design/README.md`), the `.strip` markup and CSS, the `.legend`
markup and CSS, and any hero-lattice CSS. Keep `design/_figures.js` and the
export tools; `strip` in `_figures.js` may stay but is no longer exported.

## 11. Projects as tiles, stronger section rhythm (decided 24 September 2026)

Visual reference: `design/preview-home-E-projects.html` (version 2, the
lighter band). Supersedes the home-page projects block of §5/§10 and
`projects/index.qmd`'s active-projects list.

**Section rhythm.** `section.band > .wrap` padding-block becomes
`clamp(64px, 9vw, 112px)`; `.head` margin-bottom `clamp(34px, 5vw, 56px)`;
`.head h2` `clamp(1.7rem, 3.8vw, 2.5rem)`. The home-page sequence of grounds
is: hero ground → band photo → research ground → **projects mid-slate** →
publications paper → news ground → credits ground → footer deep.

**Projects band.** New token `$slate-mid: #2b3f49` (CSS `--slate-mid`).
`.projects-band { background: var(--slate-mid); color: #dfe8ea }`; kicker
`#a6c2c0`, h2 white. Tiles in `.tiles { grid; repeat(auto-fit,
minmax(min(100%,280px),1fr)); gap: 22px }`.

Each `.tile` is one link (the whole tile clickable) to the project page:
- `background: rgba(255,255,255,.06)`, `border: 1px solid rgba(255,255,255,.14)`,
  `border-radius: 2px`, `overflow: hidden`; hover: border `.4`, background
  `.09`. **No shadow, no transform.**
- `.img` top, `aspect-ratio: 3/2`, background `#1f3038`, image `object-fit:
  cover`, `filter: saturate(.75)`. A tile without a photo uses `.img.blank`:
  a quiet gradient `linear-gradient(135deg, #243a44, #1f3038)` and **nothing
  written in it** — no "photo pending" text on the live site. Swapping a
  photo in later means replacing the `.blank` div with an `<img>`.
- `.body` padding `20px 22px 22px`, gap 10px: `.code` (DM Mono .7rem
  uppercase, `#9fdccf`, e.g. `INTRADISP · 2024–2026`), `h3` white 1.15rem,
  one paragraph `#c9d6d8` .92rem, then `dl` (DM Mono .7rem, hairline top
  `rgba(255,255,255,.14)`, dt `#93acb2` uppercase .64rem, dd `#eaf0f1`).
- Contrast: all tile text must meet AA against `#2b3f49` blended with the
  tile background; verify.

**Content of the three tiles** (from the existing site, no additions):
1. INTRADISP · 2024–2026 — *Why individuals of one species disperse
   differently* — Synthesising intraspecific dispersal variation using
   European bird ringing data to improve predictions of biodiversity
   responses to global change. Role Principal investigator · Host UCM ·
   With Potsdam University, BTO. Image: **blank** for now (a ringing
   photograph will replace it; the kernel figure is not reused here).
2. RIMed-Fauna · 2024–2027 — *Wildlife in Mediterranean rivers* —
   Mediterranean rivers flood in winter and run dry in summer. Camera
   trapping and distribution modelling in National Parks to see how
   terrestrial wildlife copes with that variability. Role Team member ·
   PI M. M. Sánchez-Montoya · Funder Red de Parques Nacionales. Image:
   `images/derived/monfrague-card-900.webp` (author's photo, Monfragüe).
3. SHAREPOINT · 2025–2027 — *Social organisation and parasite sharing* —
   Rainforest understory birds in French Guiana: field-based research
   combining network analysis with disease ecology. Role Team member ·
   PI J. Pérez-Tris · Funder CEBA. Image: **blank** for now.

Below the tiles: `.more` link `All projects, including past ones →` to
projects/index.qmd, colour `#9fdccf`.

**projects/index.qmd.** Active projects use the same `.tiles` on the page
ground (tile background `var(--paper)`, border `var(--rule)`, text tokens as
elsewhere; the `.blank` gradient becomes `var(--ground)` → `var(--paper)`).
Past and applied projects keep the existing rail rows.

**Credits block** gains: `Project tile: Salto del Gitano and the Tajo,
Parque Nacional de Monfragüe, photo Guillermo Fandos.`
