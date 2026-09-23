"""Assemble the self-contained design previews.

    python3 design/build.py

Inlines the portrait and the figure script into the "Lattice" template and
writes design/preview-lattice.html. The "Signal" preview is already
self-contained and is not touched.

The hero kernel SVG (design/generate_kernel.py) was removed with the home page
revision of BRIEF.md section 10; the template's {{KERNEL}} slot is now left
empty, so the regenerated preview shows the hero without the traces.
"""
import base64
import pathlib

here = pathlib.Path(__file__).parent
root = here.parent

avatar = "data:image/jpeg;base64," + base64.b64encode(
    (root / "images" / "avatar.jpg").read_bytes()
).decode()

html = (here / "_tpl_lattice.html").read_text()
html = html.replace("{{KERNEL}}", "<!-- hero kernel removed (BRIEF.md section 10) -->")
html = html.replace("{{AVATAR}}", avatar)
html = html.replace("{{FIGURES}}", (here / "_figures.js").read_text())
(here / "preview-lattice.html").write_text(html)
print("wrote design/preview-lattice.html")
