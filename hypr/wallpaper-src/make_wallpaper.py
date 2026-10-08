#!/usr/bin/env python3
"""Generate the minimal 'horizon ring' wallpaper as SVG.

  python3 make_wallpaper.py > horizon.svg
  rsvg-convert -w 3840 -h 2400 horizon.svg -o ~/Pictures/wallpapers/horizon-ring.png
"""
import math
import sys

W, H = 1920, 1200
CX, CY = 1180, 560          # ring centre
R = 290                     # ring radius
HORIZON = 820               # horizon line y
VPX = CX                    # vanishing point x

out = []
a = out.append
a(f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}">')
a('''<defs>
  <linearGradient id="bg" x1="0" y1="0" x2="0" y2="1">
    <stop offset="0" stop-color="#04060b"/>
    <stop offset="0.68" stop-color="#070c16"/>
    <stop offset="1" stop-color="#03050a"/>
  </linearGradient>
  <radialGradient id="glow" cx="0.5" cy="0.5" r="0.5">
    <stop offset="0" stop-color="#1b6f8a" stop-opacity="0.35"/>
    <stop offset="0.5" stop-color="#0d3346" stop-opacity="0.15"/>
    <stop offset="1" stop-color="#05070d" stop-opacity="0"/>
  </radialGradient>
  <linearGradient id="accent" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" stop-color="#33ccff"/>
    <stop offset="1" stop-color="#00ff99"/>
  </linearGradient>
  <linearGradient id="hline" x1="0" y1="0" x2="1" y2="0">
    <stop offset="0" stop-color="#33ccff" stop-opacity="0"/>
    <stop offset="0.5" stop-color="#5fe0ff" stop-opacity="0.55"/>
    <stop offset="1" stop-color="#00ff99" stop-opacity="0"/>
  </linearGradient>
  <filter id="blur" x="-50%" y="-50%" width="200%" height="200%"><feGaussianBlur stdDeviation="14"/></filter>
  <filter id="softblur" x="-50%" y="-50%" width="200%" height="200%"><feGaussianBlur stdDeviation="4"/></filter>
  <filter id="grain" x="0" y="0" width="100%" height="100%">
    <feTurbulence type="fractalNoise" baseFrequency="0.9" numOctaves="2" seed="7"/>
    <feColorMatrix type="saturate" values="0"/>
  </filter>
  <clipPath id="above"><rect x="0" y="0" width="1920" height="''' + str(HORIZON) + '''"/></clipPath>
</defs>''')

a(f'<rect width="{W}" height="{H}" fill="url(#bg)"/>')
a(f'<ellipse cx="{CX}" cy="{CY}" rx="760" ry="620" fill="url(#glow)"/>')

# Perspective grid below the horizon
g = [f'<g transform="translate(0 {HORIZON})" stroke="#3fb8e0" stroke-width="1" fill="none">']
gh = H - HORIZON
for i in range(-26, 27):
    x_bottom = VPX + i * 150
    op = 0.16 if i else 0.22
    g.append(f'<line x1="{VPX}" y1="0" x2="{x_bottom}" y2="{gh}" stroke-opacity="{op}"/>')
y, step = 6.0, 6.0
while y < gh:
    g.append(f'<line x1="0" y1="{y:.1f}" x2="{W}" y2="{y:.1f}" stroke-opacity="0.13"/>')
    step *= 1.32
    y += step
g.append('</g>')
out.append('\n'.join(g))
# Fade the grid out near the horizon and towards the bottom edge
a(f'''<linearGradient id="hz" x1="0" y1="0" x2="0" y2="1">
  <stop offset="0" stop-color="#070c16" stop-opacity="1"/>
  <stop offset="0.35" stop-color="#070c16" stop-opacity="0.25"/>
  <stop offset="1" stop-color="#03050a" stop-opacity="0.85"/>
</linearGradient>
<rect x="0" y="{HORIZON}" width="{W}" height="{gh}" fill="url(#hz)"/>''')

# Ring: soft glow + crisp arc, clipped at the horizon (sunset feel)
a('<g clip-path="url(#above)">')
a(f'<circle cx="{CX}" cy="{CY}" r="{R}" fill="none" stroke="url(#accent)" stroke-width="10" opacity="0.55" filter="url(#blur)"/>')
a(f'<circle cx="{CX}" cy="{CY}" r="{R}" fill="none" stroke="url(#accent)" stroke-width="2.2"/>')
a(f'<circle cx="{CX}" cy="{CY}" r="{R-34}" fill="none" stroke="#9fe9ff" stroke-width="1" stroke-opacity="0.10"/>')
a(f'<circle cx="{CX}" cy="{CY}" r="{R+46}" fill="none" stroke="#9fe9ff" stroke-width="1" stroke-opacity="0.06" stroke-dasharray="2 10"/>')
a('</g>')

# Horizon line with glow
a(f'<rect x="0" y="{HORIZON-1}" width="{W}" height="2" fill="url(#hline)" filter="url(#softblur)"/>')
a(f'<rect x="0" y="{HORIZON}" width="{W}" height="1" fill="url(#hline)"/>')

# Small accent node on the ring (upper-left, 220 deg)
ang = math.radians(220)
nx, ny = CX + R * math.cos(ang), CY + R * math.sin(ang)
a(f'<circle cx="{nx:.1f}" cy="{ny:.1f}" r="9" fill="#33ccff" opacity="0.6" filter="url(#softblur)"/>')
a(f'<circle cx="{nx:.1f}" cy="{ny:.1f}" r="3" fill="#dff8ff"/>')

# Film grain to kill gradient banding
a(f'<rect width="{W}" height="{H}" filter="url(#grain)" opacity="0.045"/>')
a('</svg>')

sys.stdout.write('\n'.join(out))
