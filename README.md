# Guillermo Fandos - Personal Website

Academic website built with [Quarto](https://quarto.org/).

## Quick Start

```bash
# 1. Add your photo
cp /path/to/your/photo.jpg images/avatar.jpg

# 2. Preview locally
quarto preview

# 3. Build
quarto render
```

## Deploy to GitHub Pages

1. Create a new repository on GitHub
2. Push this folder
3. Go to Settings > Pages > Source: GitHub Actions
4. The workflow will deploy automatically on each push

## Images to Add Later

When you have them, add these images:

```
images/
├── avatar.jpg              ✅ Required (your portrait)
├── hero-field.jpg          Optional (fieldwork photo for homepage)
├── logo.png                Optional (navbar logo)
├── favicon.png             Optional (browser tab icon)
├── people/
│   ├── david.jpg           Optional (team photos)
│   ├── claudia.jpg
│   └── hugo.jpg
└── research/
    ├── dispersal.jpg       Optional (research line images)
    ├── forecasting.jpg
    └── conservation.jpg
```

After adding images, uncomment the relevant lines in:
- `index.qmd` (hero image)
- `people.qmd` (team photos)
- `research/index.qmd` (research line images)

## Customize

- Edit `_quarto.yml` for site settings
- Edit `.qmd` files for content
- Edit `styles/custom.scss` for colors/fonts

## Contact

Guillermo Fandos - gfandos@ucm.es
