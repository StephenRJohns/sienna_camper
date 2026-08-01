#!/usr/bin/env python3
"""Crop the uniform background border off a rendered PNG.

Why this exists: OpenSCAD's --viewall fits the model then adds its own
fixed padding, so a bordered sheet ends up occupying only ~75% of the
image width. The PDF scales the *image* to the page, so that padding is
dead space — it shrinks the drawing by ~25% and takes the smallest text
with it. Trimming to the drawn extents buys that back with no change to
the drawing itself.

Only worth running on the BORDERED sheets (the ones with an outer frame,
where the crop is unambiguous). Leave the exploded isometrics alone: they
have no frame, and their whitespace is doing compositional work.

Usage: python3 trim_render.py renders/foo.png [renders/bar.png ...]
"""
import sys
from pathlib import Path

from PIL import Image, ImageChops

PAD = 6  # px of breathing room to keep around the frame


def trim(path: Path) -> None:
    im = Image.open(path).convert("RGB")
    # the background colour is whatever sits in the very corner
    bg = Image.new("RGB", im.size, im.getpixel((2, 2)))
    mask = ImageChops.difference(im, bg).convert("L").point(lambda p: 255 if p > 25 else 0)
    box = mask.getbbox()
    if box is None:
        print(f"{path.name}: blank, left alone")
        return
    l, t, r, b = box
    l, t = max(0, l - PAD), max(0, t - PAD)
    r, b = min(im.width, r + PAD), min(im.height, b + PAD)
    if (r - l, b - t) == im.size:
        print(f"{path.name}: already tight")
        return
    im.crop((l, t, r, b)).save(path)
    pct = 100 * (1 - ((r - l) * (b - t)) / (im.width * im.height))
    print(f"{path.name}: {im.width}x{im.height} -> {r-l}x{b-t} ({pct:.0f}% padding removed)")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit("usage: trim_render.py renders/foo.png [...]")
    for arg in sys.argv[1:]:
        trim(Path(arg))
