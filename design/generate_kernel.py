"""Generate the SVG hero graphics used in the design previews.

The figure is a heavy-tailed dispersal kernel: many short displacements and a
few very long ones, drawn as trajectories radiating from a ringing site. This
is the empirical pattern reported in Fandos et al. (2023, J. Anim. Ecol.), so
the site's main visual element encodes the research rather than decorating it.

Seeded for reproducibility. Run: python3 design/generate_kernel.py
"""

import math
import random

SEED = 20260921
W, H = 1200, 700
ORIGIN = (150, 560)


def kernel_paths(n=90, seed=SEED):
    """Trajectories with log-normal step lengths (heavy right tail)."""
    rng = random.Random(seed)
    paths = []
    for _ in range(n):
        # log-normal distance: median ~modest, occasional long-distance events
        dist = rng.lognormvariate(mu=5.0, sigma=0.95)
        dist = min(dist, 1500)
        angle = math.radians(rng.uniform(-72, 14))  # mostly up and to the right
        x2 = ORIGIN[0] + dist * math.cos(angle)
        y2 = ORIGIN[1] + dist * math.sin(angle)
        # control point offset perpendicular to the chord -> gentle arcs
        mx, my = (ORIGIN[0] + x2) / 2, (ORIGIN[1] + y2) / 2
        dx, dy = x2 - ORIGIN[0], y2 - ORIGIN[1]
        norm = math.hypot(dx, dy) or 1
        bow = rng.uniform(-0.28, 0.28) * norm
        cx, cy = mx - dy / norm * bow, my + dx / norm * bow
        paths.append((dist, f"M{ORIGIN[0]:.0f},{ORIGIN[1]:.0f} Q{cx:.1f},{cy:.1f} {x2:.1f},{y2:.1f}"))
    paths.sort(key=lambda p: p[0])
    return paths


def svg(theme):
    """theme: 'dark' or 'light'."""
    paths = kernel_paths()
    longest = max(d for d, _ in paths)
    out = [
        f'<svg class="kernel" viewBox="0 0 {W} {H}" preserveAspectRatio="xMidYMid slice" '
        f'aria-hidden="true" focusable="false">'
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
        if t > 0.62:  # mark the arrival point of long-distance events
            end = d.split()[-1]
            ex, ey = end.split(",")
            out.append(f'<circle class="node" cx="{ex}" cy="{ey}" r="{2.2 + 2 * t:.1f}"/>')
    out.append(f'<circle class="origin" cx="{ORIGIN[0]}" cy="{ORIGIN[1]}" r="5"/>')
    out.append("</svg>")
    return "\n".join(out)


if __name__ == "__main__":
    import pathlib
    here = pathlib.Path(__file__).parent
    (here / "kernel-dark.svg.part").write_text(svg("dark"))
    (here / "kernel-light.svg.part").write_text(svg("light"))
    print("wrote kernel-dark.svg.part and kernel-light.svg.part")
