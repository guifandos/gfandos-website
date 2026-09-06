# Guillermo Fandos · gfandos.com

Research-group website built with [Quarto](https://quarto.org/) and published from `docs/` on GitHub Pages.

## Working on the site

```bash
quarto preview                      # English, live preview
QUARTO_PROFILE=es quarto preview    # Spanish, live preview
./build.sh                          # render both languages into docs/ (commit the result)
```

Requires Quarto 1.7 or newer. The rendered `docs/` folder is committed: run `./build.sh` before pushing.

## Two languages

The site is bilingual. English lives at the root and Spanish under `es/`, with the same file names, so `/people.html` and `/es/people.html` are translations of each other and the ES/EN button in the navbar switches between them.

- `_quarto.yml` holds everything shared (theme, format, site URL).
- `_quarto-en.yml` and `_quarto-es.yml` are Quarto profiles with the language-specific navbar, footer and render list. `en` is the default profile.
- `es/_metadata.yml` sets `lang: es-ES` for the Spanish tree.
- When you add or change a page, edit both `page.qmd` and `es/page.qmd`. News posts go in `news/posts/` and `es/news/posts/` with the same file name.

## Structure

```
index.qmd            Homepage (full-bleed hero, research lines, projects, news, team)
es/                  Spanish version of every page (same paths)
research/            Research lines: dispersal, forecasting, conservation, fieldtech
projects/            INTRADISP, RIMed-Fauna, SHAREPOINT and the projects index
people.qmd           PI, current members, alumni, collaborators, join us
publications.qmd     Selected papers by year (hand-maintained)
teaching.qmd         Courses and materials
news/posts/          One .qmd per news item; listed automatically on News and Home
cv.qmd               Summary CV (also answers /outreach.html for old links)
styles/custom.scss   Design system: palette, typography, hero, cards, people, pubs
_templates/          EJS template for the news listing
images/              Optimised assets (hero, research crops, data graphics, logos, favicon)
images/data/         Synthetic SDM surface and movement graphics (replace with real figures)
_source-images/      Original illustrations (not published)
```

## Adding content

- **News item**: create `news/posts/YYYY-MM-slug.qmd` with `title`, `date`, `description` and a short body.
- **Paper**: add a `::: {.pub}` block under the right year in `publications.qmd`; wrap group members in `<span class="pub-me">`.
- **Team member**: add a `.person` card in `people.qmd`. Replace the `avatar-initials` span with `<img class="avatar" src="images/people/name.jpg">` when a photo is available.
- **Project**: add a `.card-project` card on the homepage and a page in `projects/`.

## Contact

Guillermo Fandos · gfandos@ucm.es
