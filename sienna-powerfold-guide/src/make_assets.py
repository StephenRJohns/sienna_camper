#!/usr/bin/env python3
"""
Regenerate every derived image the guide needs, from the raw sources in src/images.

Outputs land in src/assets/ and are consumed by build_guide.py.

Two kinds of derived asset:
  1. Crops of forum screenshots, trimmed to their photographic content so the
     guide shows the photo rather than a page full of ads and post chrome.
  2. Vector diagrams, produced by make_diagrams.py.

Run:  python src/make_assets.py
"""
import os
import subprocess
import sys

from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(HERE, "images")
OUT = os.path.join(HERE, "assets")

# --------------------------------------------------------------------------
# Crop table.
#
# Each entry: (source file, (left, top, right, bottom), output name, upscale)
#
# The boxes were determined by eye against the original screenshots. If you
# re-capture the forum pages at a different window width these WILL need
# re-tuning -- run this script, then eyeball src/assets/_contact_sheet.png.
# --------------------------------------------------------------------------
CROPS = [
    # --- manufacturer wiring figures (the kit's de-facto instruction sheet) ---
    ("Screenshot_from_20260807_154625.png", (72, 86, 410, 676),   "fig3_wiring.png",  2.6),
    ("Screenshot_from_20260807_154632.png", (5, 25, 528, 706),    "fig4_switch.png",  2.4),

    # --- mirror glass ---
    ("Screenshot_from_20260807_155352.png", (18, 470, 866, 1140), "f_glassback.jpg",  1.8),
    ("Screenshot_from_20260807_155410.png", (18, 0, 866, 800),    "f_glassback2.jpg", 1.6),
    ("Screenshot_from_20260807_155414.png", (18, 148, 605, 915),  "f_brokenmotor.jpg", 1.8),
    ("Screenshot_from_20260807_155420.png", (18, 198, 450, 780),  "f_mirrorconn.jpg", 1.8),

    # --- spring / lock collar ---
    ("Screenshot_from_20260807_155427.png", (18, 125, 866, 1140), "f_springtool.jpg", 1.6),
    ("Screenshot_from_20260807_155434.png", (18, 305, 866, 1140), "f_visegrip.jpg",   1.6),
    ("Screenshot_from_20260807_155453.png", (205, 388, 690, 935), "f_lockring.jpg",   2.0),
    ("Screenshot_from_20260807_155359.png", (18, 225, 866, 1140), "f_lockring2.jpg",  1.6),

    # --- housing ---
    ("Screenshot_from_20260807_155405.png", (18, 185, 866, 1140), "f_covercradle.jpg", 1.6),
    ("Screenshot_from_20260807_154722.png", (20, 200, 900, 700),  "f_coverinside.jpg", 1.8),

    # --- wiring ---
    ("Screenshot_from_20260807_155508.png", (18, 215, 866, 850),  "f_extrawire.jpg",  1.6),

    # --- right door, three stacked photos in one screenshot ---
    ("Screenshot_from_20260807_154548.png", (77, 72, 318, 388),   "f_rdoor_a.jpg",    3.0),
    ("Screenshot_from_20260807_154548.png", (77, 398, 318, 716),  "f_rdoor_b.jpg",    3.0),
    ("Screenshot_from_20260807_154548.png", (77, 726, 318, 1046), "f_rdoor_c.jpg",    3.0),

    # --- left door, three stacked photos ---
    ("Screenshot_from_20260807_154606.png", (80, 128, 316, 433),  "f_ldoor_a.jpg",    3.2),
    ("Screenshot_from_20260807_154606.png", (80, 462, 316, 768),  "f_ldoor_b.jpg",    3.2),
    ("Screenshot_from_20260807_154606.png", (80, 794, 316, 1098), "f_ldoor_c.jpg",    3.2),

    # --- switch panel, three stacked photos ---
    ("Screenshot_from_20260807_154611.png", (80, 10, 316, 281),   "f_sw_a.jpg",       3.2),
    ("Screenshot_from_20260807_154611.png", (77, 296, 318, 618),  "f_sw_b.jpg",       3.0),
    ("Screenshot_from_20260807_154611.png", (77, 628, 318, 950),  "f_sw_c.jpg",       3.0),

    # --- zoom on the kit's spring tool, cropped out of the bench photo ---
    ("DBE5E93AE5344C24998313D194DEB392.jpeg", (620, 530, 840, 800), "tool_zoom.png",  4.0),
]


def build_crops():
    made = []
    for src, box, out, scale in CROPS:
        path = os.path.join(SRC, src)
        if not os.path.exists(path):
            print(f"  !! missing source: {src}", file=sys.stderr)
            continue
        im = Image.open(path).crop(box)
        if scale != 1:
            im = im.resize((int(im.width * scale), int(im.height * scale)), Image.LANCZOS)
        if out.lower().endswith((".jpg", ".jpeg")):
            im = im.convert("RGB")
            im.save(os.path.join(OUT, out), quality=92)
        else:
            im.save(os.path.join(OUT, out))
        made.append(out)
        print(f"  {out:22s} {im.size}")
    return made


def contact_sheet(names):
    """Eyeball check: one image showing every crop, so bad boxes are obvious."""
    import math
    thumb = 260
    cols = 5
    rows = math.ceil(len(names) / cols)
    sheet = Image.new("RGB", (cols * thumb, rows * thumb), "white")
    from PIL import ImageDraw
    d = ImageDraw.Draw(sheet)
    for i, n in enumerate(names):
        im = Image.open(os.path.join(OUT, n))
        im.thumbnail((thumb - 8, thumb - 22))
        x, y = (i % cols) * thumb, (i // cols) * thumb
        sheet.paste(im.convert("RGB"), (x + 4, y + 18))
        d.text((x + 4, y + 4), n, fill="black")
    sheet.save(os.path.join(OUT, "_contact_sheet.png"))
    print("  _contact_sheet.png  (open this to verify crop boxes)")


def main():
    os.makedirs(OUT, exist_ok=True)
    print("Cropping forum screenshots ->", OUT)
    made = build_crops()

    print("\nGenerating vector diagrams ...")
    subprocess.run([sys.executable, os.path.join(HERE, "make_diagrams.py")], check=True)

    print("\nBuilding contact sheet ...")
    contact_sheet(made)

    print(f"\nDone. {len(made)} crops + 2 diagrams in src/assets/")


if __name__ == "__main__":
    main()
