# Site Audit Report: gfandos.com

**Date**: February 2026
**Scope**: Full audit of Quarto academic website
**Overall assessment**: Strong foundation, well-written content, solid structure. Key improvements needed in SEO metadata, image assets, and a few technical fixes.

---

## 1. Technical Audit

### 1.1 _quarto.yml Configuration

| Item | Status | Notes |
|------|--------|-------|
| Open Graph | OK | Enabled |
| Twitter Card | OK | Creator and site set |
| site-url | OK | Set to gfandos.com |
| favicon | OK | Present |
| logo | **BROKEN** | `images/logo.png` referenced but file does not exist |
| lang | OK | Set to `en` |
| author metadata | OK | Name, email, ORCID, affiliation set |
| output-dir | OK | Set to `docs` (GitHub Pages compatible) |

**Missing SEO elements:**
- No per-page `description` meta tags (only site-level description exists)
- No structured data / JSON-LD for `Person` or `ScholarlyArticle`
- No `robots.txt` or `sitemap.xml` configuration
- No Google Analytics or equivalent tracking
- No canonical URLs per page
- Font imports for Source Sans Pro and Merriweather are not declared (relying on system fallbacks)

**Score: 6/10**

### 1.2 Navigation

| Item | Status | Notes |
|------|--------|-------|
| Navbar structure | Good | Clear hierarchy, research dropdown works well |
| Internal links | OK | All .qmd cross-references are valid |
| External links | OK | All URLs point to real resources |
| Social icons | Minor issue | Twitter/X icon uses `twitter` (Bootstrap Icons has it, but consider updating branding to "X") |
| ORCID link | Missing from navbar | Only in footer; should be in navbar icons too |
| ResearchGate | Missing | Not linked anywhere on the site |

**Score: 7/10**

### 1.3 Accessibility

| Item | Status | Notes |
|------|--------|-------|
| Alt text on images | Partial | `teaching-group.jpg` and `outreach-field.jpg` have alt text; `avatar.jpg` and `ucm.svg` do not |
| Heading hierarchy | Good | Logical H1 > H2 > H3 structure throughout |
| Color contrast | Good | Primary blue (#2c5aa0) on white passes WCAG AA |
| aria-label | Partial | Google Scholar icon has aria-label; others (GitHub, Twitter, Email) do not |
| Link text | Minor issue | "More about my research" is good; but DOI links just say "DOI" (not descriptive) |

**Score: 7/10**

### 1.4 CSS/SCSS

| Item | Status | Notes |
|------|--------|-------|
| SCSS variables | Good | Color palette well-defined |
| Custom CSS | Good | Clean, well-organized with clear sections |
| Font loading | **Missing** | Fonts declared in CSS but never imported via `@import` or `<link>` |
| Unused CSS classes | Note | `.research-card`, `.badge-pi`, `.badge-team`, `.pub-item`, `.metric-box` are defined but never used in any .qmd file |
| Responsive design | Good | Mobile breakpoint at 768px, hero image resizes |
| Print styles | Good | Navbar/footer hidden in print |

**Score: 7/10**

---

## 2. Content Audit

### 2.1 Tone and Voice

The tone is excellent: personal, approachable, confident without being arrogant. First person is used consistently. No em dashes found (as requested). The writing quality is notably high for an academic website.

**Minor inconsistencies:**
- Some pages use British spelling ("colonisation", "modelling") which is fine and consistent, but worth being intentional about
- Outreach page title is just "Outreach" but content is really "Outreach & Field Technology"
- The news section uses emoji (party, globe, people) while the rest of the site does not

**Score: 9/10**

### 2.2 Page Balance

| Page | Words (approx) | Assessment |
|------|----------------|------------|
| index.qmd | ~300 | Good length for homepage |
| research/index.qmd | ~350 | Good overview |
| research/dispersal.qmd | ~350 | Good |
| research/forecasting.qmd | ~280 | Slightly thin; could use one more subsection |
| research/conservation.qmd | ~300 | Good |
| projects/index.qmd | ~280 | Good |
| projects/intradisp.qmd | ~220 | Slightly thin |
| projects/remined.qmd | ~200 | Slightly thin |
| people.qmd | ~250 | Good |
| publications.qmd | ~400 | Good |
| teaching.qmd | ~350 | Good |
| outreach.qmd | ~250 | Slightly thin |

**Score: 7/10**

### 2.3 Content Gaps and Redundancy

**Redundancies:**
- Student descriptions appear in both `people.qmd` and `teaching.qmd` (David Notario, Claudia Mediavilla, Hugo Diaz)
- Open science commitment mentioned in both `research/index.qmd` and `outreach.qmd`
- Collaborators listed in both `people.qmd` and `research/index.qmd`
- Selected publications repeated across research subpages and `publications.qmd`

**Gaps:**
- No CV/Resume page or downloadable PDF
- No brief "About" or bio paragraph visible on landing without scrolling into the hero section
- Publications page has no mention of h-index, citation count, or total publications
- No "Software" or "R packages" section (if applicable)
- No blog/news archive (news items on homepage will grow stale)
- SHAREPOINT project (projects/index.qmd) has no dedicated subpage unlike INTRADISP and REMINED

**Score: 7/10**

### 2.4 Clarity of Message (30-second test)

A visitor landing on the homepage would understand within 30 seconds:
- Who you are (name, title, institution)
- What you do (movement ecology, dispersal, field tech)
- Your current projects
- How to contact you

This passes the clarity test well.

**Score: 9/10**

---

## 3. Visual Audit

### 3.1 Images

| Image | Used in | Status |
|-------|---------|--------|
| avatar.jpg | index.qmd | Exists, no alt text |
| logo.png | _quarto.yml navbar | **MISSING FILE** |
| favicon.png | _quarto.yml | Exists |
| teaching-group.jpg | teaching.qmd | Exists, has alt text |
| outreach-field.jpg | outreach.qmd | Exists, has alt text |
| ucm.svg | index.qmd | Exists, no alt text |

**Missing images (referenced in HTML comments):**
- `images/research/dispersal.jpg`
- `images/research/forecasting.jpg`
- `images/research/conservation.jpg`
- `images/people/david.jpg`
- `images/people/claudia.jpg`
- `images/people/hugo.jpg`

**Assessment:** The site is image-poor. Only 2 content images on 12 pages. Research line cards, project pages, and people profiles all lack images. This significantly reduces visual impact.

**Score: 4/10**

### 3.2 Design

| Item | Assessment |
|------|-----------|
| Color scheme | Good: professional blue (#2c5aa0) with neutral grays |
| Typography | Intended pairing (Merriweather + Source Sans Pro) is good, but fonts are not actually loading from Google Fonts |
| Whitespace | Good use of horizontal rules and spacing |
| Card hover effects | Nice touch, adds interactivity |
| Grid layout | Well-implemented for research lines and projects |
| Visual hierarchy | Clear; headings, bold text, and links create good scanning patterns |

**Score: 6/10** (penalized for missing fonts and sparse images)

### 3.3 Responsive Design

The CSS includes a 768px breakpoint for mobile. The grid classes (`g-col-12 g-col-md-4/6`) ensure proper stacking. Hero image is constrained to 200px on mobile. Footer should be tested for three-column layout on small screens.

**Score: 7/10**

---

## 4. SEO Audit

### 4.1 Current State

| Element | Status |
|---------|--------|
| Site title | Good: "Guillermo Fandos" |
| Site description | Good but generic |
| Open Graph | Enabled (site-level) |
| Twitter cards | Configured |
| Per-page titles | Good (set in frontmatter) |
| Per-page descriptions | **MISSING** on all pages |
| Per-page keywords | **MISSING** on all pages |
| Sitemap | **NOT CONFIGURED** |
| robots.txt | **NOT CONFIGURED** |
| Structured data | **MISSING** |
| Image alt text | Partial |
| URL structure | Good: clean, descriptive paths |

### 4.2 Keyword Analysis

**Target keywords (missing from metadata but present in content):**

| Keyword | Search Volume | Present in Content | In Metadata |
|---------|--------------|-------------------|-------------|
| spatial ecology | High | Yes | Only site description |
| species distribution modelling | High | Yes | No |
| animal dispersal | Medium | Yes | No |
| bird ringing data | Medium | Yes | No |
| biodiversity forecasting | Medium | Yes | No |
| EURING | Niche | Yes | No |
| dispersal kernels | Niche | Yes | No |
| movement ecology | High | Yes | No |
| camera trapping | Medium | Yes | No |
| Bayesian ecology | Medium | Yes | No |

### 4.3 Academic Profile Integration

| Platform | Status |
|----------|--------|
| Google Scholar | Linked (navbar + footer) |
| ORCID | Linked (footer only) |
| ResearchGate | **NOT LINKED** |
| Web of Science | **NOT LINKED** |
| UCM Profile | Linked (hero + footer) |
| GitHub | Linked (navbar + hero) |
| Twitter/X | Linked (navbar + hero) |

**Score: 4/10**

---

## 5. Summary Scores

| Category | Score | Priority |
|----------|-------|----------|
| Technical / Config | 6/10 | High |
| Navigation | 7/10 | Low |
| Accessibility | 7/10 | Medium |
| CSS / Design system | 7/10 | Medium |
| Tone & Voice | 9/10 | Low (maintain) |
| Page Balance | 7/10 | Low |
| Content Completeness | 7/10 | Medium |
| Message Clarity | 9/10 | Low (maintain) |
| Images & Visual Impact | 4/10 | High |
| SEO & Discoverability | 4/10 | High |

**Overall: 6.7/10** - A solid academic website with excellent writing that needs SEO metadata, images, and a few technical fixes to reach its potential.
