#!/usr/bin/env python3
"""Strip OpenSCAD's default cream (255,255,229) PNG background to
transparent, so renders match the "white or transparent background"
line-drawing look. Run after render.sh's openscad calls.
"""
import sys
from pathlib import Path
from PIL import Image

BG = (255, 255, 229)

MARGIN = 15  # px, keeps stroke anti-aliasing and text descenders from clipping

def strip(path):
    im = Image.open(path).convert("RGBA")
    data = im.getdata()
    new_data = [
        (r, g, b, 0) if (r, g, b) == BG else (r, g, b, a)
        for (r, g, b, a) in data
    ]
    im.putdata(new_data)

    # OpenSCAD's fixed --imgsize camera frame leaves the actual drawing
    # as a small island in a mostly-transparent canvas — crop to the
    # content's bounding box (plus a margin) so the PDF's `width:100%`
    # figure styling scales the real drawing, not empty padding.
    bbox = im.getchannel("A").getbbox()
    if bbox:
        l, t, r, b = bbox
        l = max(0, l - MARGIN)
        t = max(0, t - MARGIN)
        r = min(im.width, r + MARGIN)
        b = min(im.height, b + MARGIN)
        im = im.crop((l, t, r, b))

    im.save(path)

if __name__ == "__main__":
    root = Path(sys.argv[1] if len(sys.argv) > 1 else "renders")
    for png in root.rglob("*.png"):
        strip(png)
        print(f"transparent bg: {png}")
