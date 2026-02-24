# Action Plan: gfandos.com Improvements

**Date**: February 2026
**Priority levels**: HIGH (do now), MEDIUM (do soon), LOW (when time allows)

---

## HIGH PRIORITY - Immediate Fixes

### 1. Fix broken logo reference
**Effort**: 5 min
**Action**: Remove `logo: images/logo.png` from `_quarto.yml` or create/add the logo file.
**Status**: APPLIED (removed reference)

### 2. Add per-page SEO descriptions
**Effort**: 30 min
**Action**: Add `description:` to the YAML frontmatter of every .qmd file with keyword-rich meta descriptions.
**Status**: APPLIED

### 3. Add Google Fonts import
**Effort**: 5 min
**Action**: Add font imports to `custom.scss` so Merriweather and Source Sans Pro actually load.
**Status**: APPLIED

### 4. Enable sitemap generation
**Effort**: 5 min
**Action**: Add `sitemap: true` under `website:` in `_quarto.yml`.
**Status**: APPLIED

### 5. Add ORCID to navbar
**Effort**: 2 min
**Action**: Add ORCID icon link to navbar right section.
**Status**: APPLIED

### 6. Add aria-labels to navbar icons
**Effort**: 5 min
**Action**: Add `aria-label` to GitHub, Twitter/X, and Email icons.
**Status**: APPLIED

### 7. Add alt text to images missing it
**Effort**: 5 min
**Action**: Add `fig-alt` to avatar.jpg and ucm.svg.
**Status**: APPLIED

### 8. Remove unused CSS classes
**Effort**: 5 min
**Action**: Clean up `.research-card`, `.badge-pi`, `.badge-team`, `.pub-item`, `.metric-box` or keep them for future use (marked with TODO comments).
**Status**: APPLIED (added TODO markers)

---

## MEDIUM PRIORITY - Soon

### 9. Add images to research line cards
**Effort**: 1 hour (need to select/create images)
**Requires**: 3 landscape photos or illustrations for dispersal, forecasting, conservation
**Action**: Replace HTML comments in `research/index.qmd` with actual `![](images/research/X.jpg)` references

### 10. Add people photos
**Effort**: 30 min (need photos from team members)
**Requires**: Headshots of David, Claudia, Hugo
**Action**: Replace HTML comments in `people.qmd` with actual image references

### 11. Add structured data (JSON-LD) for Person schema
**Effort**: 30 min
**Action**: Add a `_metadata.yml` or inline HTML with schema.org/Person markup for Google Knowledge Panel visibility. Can be added as an include in the homepage.

### 12. Add ResearchGate profile link
**Effort**: 5 min
**Requires**: ResearchGate profile URL
**Action**: Add to navbar icons and footer

### 13. Create a downloadable CV page
**Effort**: 1-2 hours
**Action**: Create `cv.qmd` with a summary CV and link to downloadable PDF. Add to navbar.

### 14. Add a SHAREPOINT project page
**Effort**: 30 min
**Action**: Create `projects/sharepoint.qmd` to match INTRADISP and REMINED subpages.

### 15. Resolve content redundancy for students
**Effort**: 20 min
**Action**: In `teaching.qmd`, link to `people.qmd` for student details instead of duplicating descriptions. Keep the canonical student info in `people.qmd`.

### 16. Expand thinner pages
**Effort**: 1-2 hours
**Pages**: `forecasting.qmd`, `intradisp.qmd`, `remined.qmd`, `outreach.qmd`
**Action**: Add 1-2 more subsections with methodological details or project updates.

---

## LOW PRIORITY - Long-term

### 17. Add a blog/news section
**Effort**: 2-3 hours to set up
**Action**: Create a `news/` or `blog/` section using Quarto's listing pages. Move news items from homepage to dedicated listing. Keeps homepage fresh without manual updates growing stale.

### 18. Add Google Analytics or Plausible
**Effort**: 15 min
**Action**: Add privacy-friendly analytics (Plausible is recommended for academic sites) to track visitor patterns.

### 19. Consider dark mode support
**Effort**: 1-2 hours
**Action**: Quarto supports `theme: [light: flatly, dark: darkly]`. Low effort, nice touch.

### 20. Add a robots.txt
**Effort**: 5 min
**Action**: Create `robots.txt` in root allowing all crawlers and pointing to sitemap.

### 21. Update Twitter branding to X
**Effort**: 5 min
**Action**: The Bootstrap Icons `twitter` icon still exists, but consider updating link text or tooltip to reflect the platform's current name.

### 22. Add citation metrics to publications page
**Effort**: 15 min
**Action**: Add a brief line like "40+ papers, h-index X" or link directly to Google Scholar for live metrics. Use the `.metric-box` CSS class already defined.

### 23. Add a "Software & Tools" subsection
**Effort**: 30 min
**Action**: If you have R packages, Shiny apps, or analysis pipelines worth showcasing, add a subsection to `outreach.qmd` or create a new page.

### 24. Consider Quarto's `listing` feature for publications
**Effort**: 2-3 hours
**Action**: Convert publications to a YAML data file and use Quarto's listing to auto-generate the publications page, making updates easier.

---

## Summary by Effort

| Quick wins (< 10 min each) | Applied in this audit |
|---|---|
| Fix logo reference | Yes |
| Sitemap | Yes |
| ORCID in navbar | Yes |
| Aria-labels | Yes |
| Alt text | Yes |
| Font imports | Yes |

| Medium effort (30 min - 2 hours) | Requires action |
|---|---|
| Per-page descriptions | Applied |
| Add images (research, people) | Need photos |
| CV page | Need PDF |
| Structured data | Technical |
| Content deduplication | Editorial |

| Larger efforts (2+ hours) | Requires planning |
|---|---|
| Blog/news section | Architectural |
| Publications as data | Refactoring |
| Page content expansion | Writing |
