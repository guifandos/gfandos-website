"""Assemble the self-contained design previews.

    python3 design/build.py

Regenerates the kernel SVG, inlines it plus the portrait into the "Lattice"
template, and writes design/preview-lattice.html. The "Signal" preview is
already self-contained and is not touched.
"""
import base64
import pathlib
import subprocess
import sys

here = pathlib.Path(__file__).parent
root = here.parent

subprocess.run([sys.executable, str(here / "generate_kernel.py")], check=True)

avatar = "data:image/jpeg;base64," + base64.b64encode(
    (root / "images" / "avatar.jpg").read_bytes()
).decode()

html = (here / "_tpl_lattice.html").read_text()
html = html.replace("{{KERNEL}}", (here / "kernel-light.svg.part").read_text())
html = html.replace("{{AVATAR}}", avatar)
(here / "preview-lattice.html").write_text(html)
print("wrote design/preview-lattice.html")
