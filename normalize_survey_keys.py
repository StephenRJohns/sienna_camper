#!/usr/bin/env python3
"""Normalize the F1-F8 survey key-map PNGs to one common scale.

Why this exists: OpenSCAD's `--viewall` zooms 2D geometry inconsistently
between runs even when the model extents are identical (the SVG exports
all declare the same 46x52 viewBox, but the PNG previews come out at
scales differing by up to 1.4x). The thumbnails sit side by side down a
table column, so an inconsistent scale is immediately visible.

The SVG exports can't be used instead: OpenSCAD's SVG backend discards
color(), and these maps depend on red to mark the measurement.

Every key draws the same full-zone outline as its outermost ink, so each
PNG's content bounding box IS that outline. Cropping to it and resizing
every image to identical pixel dimensions therefore makes the drawing
scale identical too.

Run after make_bg_transparent.py (this re-crops, so the margin that
script adds is discarded and replaced with a uniform one).
"""
import sys
from pathlib import Path

from PIL import Image

SIZE = (460, 520)   # 46 x 52 model units at 10 px/unit
MARGIN = 8          # uniform transparent margin, in output pixels


def normalize(path: Path) -> None:
    im = Image.open(path).convert("RGBA")
    bbox = im.getchannel("A").getbbox()
    if not bbox:
        print(f"  {path.name}: empty, skipped")
        return
    inner = (SIZE[0] - 2 * MARGIN, SIZE[1] - 2 * MARGIN)
    art = im.crop(bbox).resize(inner, Image.LANCZOS)
    out = Image.new("RGBA", SIZE, (0, 0, 0, 0))
    out.paste(art, (MARGIN, MARGIN))
    out.save(path)
    print(f"  {path.name}: {bbox[2]-bbox[0]}x{bbox[3]-bbox[1]} -> {SIZE[0]}x{SIZE[1]}")


def main() -> int:
    root = Path(sys.argv[1] if len(sys.argv) > 1 else "renders")
    paths = sorted(root.glob("survey-f*.png"))
    if not paths:
        print(f"no survey-f*.png under {root}", file=sys.stderr)
        return 1
    print(f"normalizing {len(paths)} survey key maps to {SIZE[0]}x{SIZE[1]}:")
    for p in paths:
        normalize(p)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
