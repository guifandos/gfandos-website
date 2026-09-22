"""Generate the SVG hero graphic for the home page (and the design previews).

The figure is a heavy-tailed dispersal kernel: many short displacements and a
few very long ones, drawn as trajectories radiating from a ringing site. This
is the empirical pattern reported in Fandos et al. (2023, J. Anim. Ecol.), so
the site's main visual element encodes the research rather than decorating it.

Seeded for reproducibility. Run: python3 design/generate_kernel.py

Outputs: design/kernel-{light,dark}.svg.part (git-ignored, used by design/build.py)
and _includes/hero-kernel.qmd, the copy the site renders. The SVG is inlined
rather than linked so the theme tokens colour the strokes and the CSS
stroke-dashoffset animation can run; no standalone .svg is written.
"""

import math
import random

SEED = 20261052
W, H = 1200, 700
# The ringing site sits at the bottom of the open gap between the hero text
# column and the portrait. The SVG is sliced to the hero at xMidYMid: at 1440 px
# the viewBox is scaled 1.2x and cropped vertically, so viewBox y 65-635 is what
# shows. The fan leans up and to the right, through the gap and into the empty
# area above the bottom-aligned portrait, so the traces stay off the lede, the
# identity links and the portrait caption (design/BRIEF.md section 3). The
# horizontal mask in styles/lattice.scss (.hero .kernel) only guards the text
# column; the fan itself starts right of where the mask is fully opaque.
# Check with design/tools/snap.sh after changing any of these numbers.
ORIGIN = (735, 612)
# Geometry: heavy-tailed log-normal distances, with the tail compressed above
# TAIL_KNEE so the longest events still terminate inside the viewBox. The
# class/opacity of each trace is taken from the raw distance, so what counts
# as "long distance" does not depend on the compression.
TAIL_KNEE, TAIL_K = 280, 90
TAIL_K_LONG = 400          # long-distance events are compressed less, so they leave
                           # the frame at the top or right edge instead of ending in a dot
ANGLES = (-165, -15)       # degrees; a radial fan, open to the left and right,
                           # so it reads as a kernel over a landscape. Traces
                           # that run behind the portrait are occluded by it.
LONG_ANGLES = (-110, -25)  # long-distance events: exit the frame at the top or
                           # the right edge rather than ending above the portrait
LONG_DIST = 520            # raw distance above which a trace is "long"
BOW = 0.16                 # max perpendicular bow as a fraction of chord length


def compress(dist, k=TAIL_K):
    """Log-compress distances above TAIL_KNEE (identity below it)."""
    if dist <= TAIL_KNEE:
        return dist
    return TAIL_KNEE + k * math.log1p((dist - TAIL_KNEE) / k)


def kernel_paths(n=90, seed=SEED):
    """Trajectories with log-normal step lengths (heavy right tail)."""
    rng = random.Random(seed)
    paths = []
    for _ in range(n):
        # log-normal distance: median ~modest, occasional long-distance events
        dist = rng.lognormvariate(mu=5.0, sigma=0.95)
        dist = min(dist, 1500)
        angle = math.radians(rng.uniform(*(LONG_ANGLES if dist > LONG_DIST else ANGLES)))
        bow_frac = rng.uniform(-BOW, BOW)
        drawn = compress(dist, TAIL_K_LONG if dist > LONG_DIST else TAIL_K)
        x2 = ORIGIN[0] + drawn * math.cos(angle)
        y2 = ORIGIN[1] + drawn * math.sin(angle)
        # control point offset perpendicular to the chord -> gentle arcs
        mx, my = (ORIGIN[0] + x2) / 2, (ORIGIN[1] + y2) / 2
        dx, dy = x2 - ORIGIN[0], y2 - ORIGIN[1]
        norm = math.hypot(dx, dy) or 1
        bow = bow_frac * norm
        cx, cy = mx - dy / norm * bow, my + dx / norm * bow
        paths.append((dist, f"M{ORIGIN[0]:.0f},{ORIGIN[1]:.0f} Q{cx:.1f},{cy:.1f} {x2:.1f},{y2:.1f}"))
    paths.sort(key=lambda p: p[0])
    return paths


def bbox(paths, pad=28):
    """Bounding box of the fan (control points bound a quadratic curve),
    padded, for the cropped phone view."""
    xs, ys = [ORIGIN[0]], [ORIGIN[1]]
    for _, d in paths:
        for tok in d.replace("M", "").replace("Q", "").split():
            x, y = tok.split(",")
            xs.append(float(x)); ys.append(float(y))
    x0, y0 = max(0, min(xs) - pad), max(0, min(ys) - pad)
    x1, y1 = min(W, max(xs) + pad), min(H, max(ys) + pad)
    return x0, y0, x1 - x0, y1 - y0


def svg(theme):
    """theme: 'dark' or 'light'. Returns the full-bleed hero SVG followed by a
    second, phone-only SVG that reuses the same paths through <use> with a
    viewBox cropped to the fan (styles/lattice.scss shows one or the other)."""
    paths = kernel_paths()
    longest = max(d for d, _ in paths)
    out = [
        f'<svg class="kernel" viewBox="0 0 {W} {H}" preserveAspectRatio="xMidYMid slice" '
        f'aria-hidden="true" focusable="false">',
        '<g id="kernel-paths">',
    ]
    for i, (dist, d) in enumerate(paths):
        t = dist / longest              # 0 = short hop, 1 = longest movement
        width = 0.6 + 2.1 * t
        op = (0.12 + 0.58 * t) if theme == "dark" else (0.18 + 0.56 * t)
        cls = "trace long" if t > 0.55 else "trace"
        dash = 2200
        delay = i * 0.028
        out.append(
            f'<path class="{cls}" d="{d}" stroke-width="{width:.2f}" '
            f'style="opacity:{op:.3f};stroke-dasharray:{dash};stroke-dashoffset:{dash};'
            f'animation-delay:{delay:.2f}s"/>'
        )
        if t > 0.62:  # mark the arrival point of a long-distance event, but only
            # when it ends inside the visible frame (viewBox y 65-635 at 1440 px);
            # events that leave the frame get no dot, so nothing reads as a seed head
            end = d.split()[-1]
            ex, ey = (float(v) for v in end.split(","))
            if 40 < ex < 1160 and 100 < ey < 640:
                out.append(f'<circle class="node" cx="{ex:.1f}" cy="{ey:.1f}" r="{2.2 + 2 * t:.1f}"/>')
    out.append(f'<circle class="origin" cx="{ORIGIN[0]}" cy="{ORIGIN[1]}" r="5"/>')
    out.append("</g>")
    out.append("</svg>")
    bx, by, bw, bh = bbox(paths)
    out.append(
        f'<svg class="kernel kernel-m" viewBox="{bx:.0f} {by:.0f} {bw:.0f} {bh:.0f}" '
        f'preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false">'
        f'<use href="#kernel-paths"/></svg>'
    )
    return "\n".join(out)


if __name__ == "__main__":
    import pathlib
    here = pathlib.Path(__file__).parent
    root = here.parent
    (here / "kernel-dark.svg.part").write_text(svg("dark"))
    (here / "kernel-light.svg.part").write_text(svg("light"))
    print("wrote kernel-dark.svg.part and kernel-light.svg.part")

    # Quarto include for the home page hero (styled by styles/lattice.scss).
    light = svg("light")
    inc = root / "_includes" / "hero-kernel.qmd"
    inc.parent.mkdir(exist_ok=True)
    inc.write_text(
        "<!-- Generated by design/generate_kernel.py. Do not edit by hand:\n"
        "     run `python3 design/generate_kernel.py` to regenerate.\n"
        "     90 simulated trajectories from one ringing site, log-normal\n"
        "     distances (tail compressed to fit the frame), seeded. The second,\n"
        "     phone-only <svg> reuses the same paths through <use> with a\n"
        "     viewBox cropped to the fan. -->\n"
        "```{=html}\n" + light + "\n```\n"
    )
    print(f"wrote {inc.relative_to(root)}")
