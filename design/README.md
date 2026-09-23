# Design previews

Two homepage directions for gfandos.com, as self-contained HTML files. Open
either one directly in a browser — no build step, no Quarto needed.

| File | Direction | Register |
|---|---|---|
| `preview-lattice.html` | **Lattice** | Light, quiet, modelling-grid structure |
| `preview-signal.html` | **Signal** | Dark, bioacoustic, high contrast |

Both use real content from the current site (projects, papers, affiliations).
Neither is wired into the Quarto build yet — that comes once a direction is
chosen.

## Lattice

- **Ground** pale blue-grey `#eceff1`, taken from the sky in `images/banner.png`,
  with slate ink `#16252d` rather than black.
- **Type** Familjen Grotesk for headings over Literata for running text — the
  inversion of the usual academic default (serif headings, sans body). DM Mono
  carries data labels, sources and years.
- **Structure** the page sits on a visible 56 px lattice, which is the grid a
  distribution model actually works on. Sections use a left rail that holds
  something true — the *data source* for each research line, the *year* for each
  paper — instead of decorative numbering.
- **Hero** as originally previewed: a dispersal kernel of simulated natal
  dispersal trajectories drawn over the lattice. **Superseded** by
  `BRIEF.md` section 10 (23 September 2026): the site's hero is now person
  first — eyebrow, name, role line, motto, lede, identity links and a
  rectangular portrait — with no lattice, no kernel and no Fig. 1 legend, and
  a feathered landscape band (`images/derived/cabaneros-band-1800.webp`)
  directly under it. `generate_kernel.py`, its `.part` outputs and
  `_includes/hero-kernel.qmd` were removed; `_tpl_lattice.html` keeps an
  empty `{{KERNEL}}` slot so `build.py` still runs. The current visual
  reference for the home page is `preview-home-A-cabaneros.html`.
- **Figures** every research line carries its own plot. See below.

## The figure system

`_figures.js` draws five figures on canvas from a fixed seed, so the page looks
the same on every load. They share one colour ramp (slate → teal → olive →
ochre → pale), which is also where the page's accent colours come from, so the
figures and the interface read as one system.

| `data-fig` | Figure | Used for |
|---|---|---|
| `kernel` | Log-normal dispersal kernel, linear distance axis, tail past 100 km shaded | Movement and dispersal |
| `sdm` | Habitat suitability surface with occurrence records and a colourbar | Monitoring and modelling |
| `range` | Occupied area against a projected contour | Conservation and global change |
| `acoustic` | Spectrogram of a dawn chorus, frequency against time | Field technology |
| `strip` | Landscape permeability surface, full-bleed divider | No longer used or exported (BRIEF.md section 10); kept in `_figures.js` only |

The kernel is drawn on a **linear** distance axis on purpose: on a log axis a
log-normal is symmetric, so the heavy tail — the thing the figure exists to
show — disappears.

**These are schematics, and every caption says so.** They are not fitted to
data and carry no numbers that could be read as results. They are placeholders
in the strongest sense: each one should be replaced by a real figure from the
corresponding paper. To swap one in, replace the `<canvas data-fig="...">` with
an `<img>`; the surrounding markup and captions stay as they are.

The fourth research row (monitoring) on the site now carries a photograph
rather than the `acoustic` schematic: `images/derived/audiomoth-fig-1200.webp`,
with a factual caption and no "Schematic." label. The `acoustic` figure
remains exported for the research subpages.

## Signal

- **Ground** deep blue-green `#0a1418`, the floor colour of a spectrogram, with
  a teal→gold data ramp used for accents so the accent colour comes out of the
  same ramp as the graphic.
- **Type** Syne at display sizes (wide, high-contrast), Archivo for text, Azeret
  Mono for data.
- **Structure** asymmetric: section titles hang in the left third, content runs
  in the right two-thirds. A vertical wordmark rail runs down the left edge on
  wide screens. Publications are a dense index with the year flush right.
- **Hero** a synthetic spectrogram drawn on canvas from a seeded signal — the
  view an AudioMoth gives you of a dawn chorus. Labelled as synthetic in the
  page.

## What was deliberately avoided

The current site reads as template output, and so do most of the obvious
alternatives. Specifically excluded from both directions:

- Bootstrap/Quarto default chrome: rounded cards with a soft shadow and a
  `translateY(-2px)` lift on hover, the round avatar, the three-column
  "What I Do" grid.
- The current AI-design house style: warm cream `#F4F1EA` grounds with a serif
  display and a terracotta accent; near-black with a single acid-green accent;
  Inter and Space Grotesk; emoji as section markers; `01 / 02 / 03` numbering
  on things that are not a sequence; everything centred.
- Invented figures. No publication counts, no "records analysed" statistics, no
  fitted curves. Both hero graphics are generated from seeded synthetic signals
  and say so on the page.

## Regenerating

```sh
python3 design/build.py
```

`preview-signal.html` is hand-maintained and self-contained; only the Lattice
preview is assembled from a template. The home-page drafts
(`preview-home-*.html`, `preview-bands.html`, `preview-hero-options.html`)
are hand-maintained snapshots of the decision in `BRIEF.md` section 10 and
are not rebuilt.

Site figures: `tools/export-figures.sh images/figures webp` exports `kernel`,
`sdm`, `range` and `acoustic`. Photographs are downscaled with
`tools/derive-images.sh` and cropped with `tools/crop-image.sh` into
`images/derived/`; originals under `images/` are never modified.

Screenshots: `tools/snap.sh <outdir>` renders to `_preview/` and shoots six
pages at 1440 and 390 px. Capture runs through Playwright (the global install
under `/opt/node22`, driving the Chromium in `/opt/pw-browsers`), one load per
page, full-page, after fonts and images settle; it fails if fonts do not load,
if a page scrolls horizontally, or if the footer does not end at the document
bottom. `design/snaps/` is git-ignored.
