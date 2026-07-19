#!/usr/bin/env python3
"""Render sienna_camper_build_plan.md to a print-ready PDF.

Converts the markdown build plan to styled HTML (with a dedicated
overhead-floorplan section pulled out for visibility), then shells
out to headless Chrome to print it to PDF.
"""
import re
import subprocess
import sys
from pathlib import Path

import markdown

ROOT = Path(__file__).parent
MD_PATH = ROOT / "sienna_camper_build_plan.md"
HTML_PATH = ROOT / "build_plan.html"
PDF_PATH = ROOT / "Project_Smores.pdf"

CSS = """
@page { size: Letter; margin: 0.65in; }
* { box-sizing: border-box; }
body {
    font-family: -apple-system, "Segoe UI", Helvetica, Arial, sans-serif;
    color: #1a1a1a;
    line-height: 1.45;
    font-size: 10.5pt;
    max-width: 100%;
}
h1 { font-size: 22pt; margin-bottom: 2pt; }
h1.doctitle { border-bottom: 3px solid #2c3e50; padding-bottom: 10pt; margin-bottom: 4pt; }
.subtitle { color: #555; font-size: 11pt; margin-top: 0; margin-bottom: 18pt; }
h2 {
    font-size: 15pt;
    color: #1a3a5c;
    border-bottom: 1.5px solid #b8c4d0;
    padding-bottom: 4pt;
    margin-top: 26pt;
    page-break-before: always;
}
h2:first-of-type { page-break-before: avoid; }
h3 { font-size: 12.5pt; color: #26496b; margin-top: 16pt; }
p { margin: 6pt 0; }
hr { display: none; }
table {
    border-collapse: collapse;
    width: 100%;
    margin: 10pt 0 14pt 0;
    font-size: 9.3pt;
    page-break-inside: avoid;
}
th, td {
    border: 1px solid #b8c0c8;
    padding: 5pt 7pt;
    text-align: left;
    vertical-align: top;
}
th { background: #eaf0f6; font-weight: 600; }
tr:nth-child(even) td { background: #f7f9fb; }
figure {
    margin: 10pt 0 14pt 0;
    text-align: center;
    page-break-inside: avoid;
}
/* IMPORTANT: these are OpenSCAD-exported SVGs with tiny intrinsic
   physical sizes (OpenSCAD maps 1 model unit = 1mm, so a drawing
   spanning ~70 units is declared as width="70mm" ~= 2.76in). A
   plain max-width only caps the size — it does NOT stretch a
   naturally-small image up to fill its container, so every figure
   was rendering at its tiny native mm size regardless of the page
   width available. Forcing `width` (not max-width) is what
   actually scales these up to fill the page. */
figure img { width: 100%; height: auto; }
/* The floorplan is a tall, narrow (portrait) drawing by nature —
   the van's own 96in x 48.5in proportions, not a styling choice —
   so forcing it to full page WIDTH like the wide/short renders
   above makes it taller than one printed page, splitting its
   bottom captions onto the next page. Capping by height instead
   (with width:auto) keeps the whole drawing, captions included,
   on one page; it ends up slightly narrower than full width,
   which a portrait drawing can afford. */
.floorplan-figure img { width: auto; height: auto; max-width: 100%; max-height: 9in; }
figcaption {
    font-size: 9pt;
    color: #555;
    margin-top: 4pt;
    font-style: italic;
}
code { background: #f0f0f0; padding: 1pt 3pt; border-radius: 2pt; font-size: 9pt; }
a { color: #1a5276; text-decoration: none; }
strong { color: #111; }
.step-diagram { width: 90%; height: auto; }
.toc { background: #f7f9fb; border: 1px solid #d7dfe6; border-radius: 4pt; padding: 10pt 18pt; margin: 14pt 0; }
.toc ul { margin: 4pt 0; }
/* Instruction-manual step cards (Section 6), woodworking-plan
   styling: paper-tone card, black-ink line-art diagrams. The card
   itself may break across pages; each STEP row is the unbreakable
   unit. Parts thumbnail left, exploded assembly right. */
.lego-card { background: #faf8f2; border: 1.5px solid #444; border-radius: 2pt; padding: 4pt 10pt; margin: 12pt 0; }
.lego-step { display: flex; align-items: center; gap: 10pt; padding: 8pt 0; border-bottom: 1px dashed #999; page-break-inside: avoid; }
.lego-step:last-child { border-bottom: none; }
.lego-num { flex: 0 0 auto; width: 22pt; font-size: 17pt; font-weight: 700; color: #111; text-align: center; }
.lego-parts { flex: 0 0 30%; background: #fff; border: 1px solid #666; border-radius: 2pt; padding: 4pt; align-self: center; }
.lego-parts img { width: 100%; height: auto; }
.lego-noparts { font-size: 8.5pt; color: #555; font-style: italic; margin: 4pt 2pt; }
.lego-main { flex: 1; min-width: 0; }
.lego-main img { width: 100%; height: auto; }
.lego-caption { font-size: 9pt; color: #222; margin: 3pt 0 0 0; }
/* purchase-links table: full URLs shown for copy-paste — break
   anywhere so an 80-char Amazon URL can't blow out the page width */
.buy-links td { word-break: break-all; }
.buy-links td:first-child, .buy-links td:nth-child(2) { word-break: normal; }
.buy-links a { font-size: 8pt; font-family: monospace; }
"""

TEMPLATE = """<!doctype html>
<html><head><meta charset="utf-8"><title>Project Smores Build Plan</title>
<style>{css}</style></head>
<body>
<h1 class="doctitle">Project Smores</h1>
<p class="subtitle">Full Build Plan — Modular Lift-Out Design</p>
{toc}
{body}
</body></html>
"""

def build_toc(headings):
    items = "".join(f'<li>{h}</li>' for h in headings)
    return f'<div class="toc"><strong>Contents</strong><ul>{items}</ul></div>'


def main():
    md_text = MD_PATH.read_text()

    # pull out section 2/3-level headings for a simple TOC
    headings = re.findall(r'^## (.+)$', md_text, flags=re.MULTILINE)
    # the five appendices are ###-level under one ## heading — list them
    # individually in the TOC so none of them (esp. the weight budget)
    # hides behind the single "Appendices" line
    appendices = re.findall(r'^### (Appendix .+)$', md_text, flags=re.MULTILINE)
    headings = [h for h in headings if not h.startswith('Appendices')] + appendices

    # Insert a dedicated "Overhead Floorplan" callout right after
    # the existing Renders intro paragraph, before the render table,
    # so the top-down view gets full-size real estate instead of a
    # cramped thumbnail.
    floorplan_block = """
### Whole-Vehicle Overview

![Whole vehicle overview](renders/vehicle-overview.png)

*Side profile of the van itself (illustrative exterior body outline — hood, windshield, roofline, tailgate, wheels) with the cargo interior envelope, liftgate opening, and platform assembly drawn to scale inside it. Front at left, tailgate at right.*

### Overhead Floorplan

![Overhead floorplan](renders/top-down.png)

*Top-down view: Panel A/B/C plus the fridge and kitchen unit living inside Panel C's footprint, drawn to scale inside the interior envelope. Front of the vehicle is at the top, tailgate at the bottom. Seam bumpers, alignment pins, and grab-handle positions are all marked.*
"""
    md_text = md_text.replace(
        "Parametric 3D model: [`platform.scad`](platform.scad) (dimensions in [`params.scad`](params.scad) — edit one file to regenerate every view via `./render.sh`).",
        "Parametric 3D model: `platform.scad` (dimensions in `params.scad` — edit one file to regenerate every view via `./render.sh`)."
        + floorplan_block,
    )

    # Replace the top-down/side-profile 2-column table (top-down also
    # has its own full-size floorplan section above) with a single
    # full-width side-profile figure — the murky 3D isometric and
    # fit-check projections were dropped as low-value.
    md_text = md_text.replace(
        "| Top-down | Side profile |\n|---|---|\n"
        "| ![Top-down view](renders/top-down.svg) | ![Side profile](renders/side-profile.svg) |",
        "![Side profile](renders/side-profile.png)",
    )

    # split the rear-view line
    md_text = md_text.replace(
        "Rear view, looking forward from the open tailgate at Panel C with the fridge and kitchen unit both stowed for driving: ![Rear view](renders/rear-view.svg)",
        "Rear view, looking forward from the open tailgate at Panel C with the fridge and kitchen unit both stowed for driving:\n\n![Rear view](renders/rear-view.png)",
    )

    # Every other renders/*.svg reference (sheet/lumber cutting layouts,
    # step diagrams) still points at the .svg export. OpenSCAD's SVG
    # backend (2021.01) discards all color() information — every
    # colored path gets flattened into one black-stroke/lightgray-fill
    # path — while the .png renders (same camera-rendered preview
    # pipeline as isometric/top-down above) preserve real color. Swap
    # every remaining reference to the .png sibling render.sh already
    # generates for it.
    md_text = re.sub(r'(renders/(?:steps/)?[\w.-]+)\.svg', r'\1.png', md_text)

    html_body = markdown.markdown(md_text, extensions=["tables", "fenced_code", "sane_lists"])

    # wrap step-diagram images (renders/steps/) so they render smaller/centered
    html_body = re.sub(
        r'<img alt="Step (\d+) diagram" src="(renders/steps/[^"]+)"[^>]*/?>',
        r'<figure><img class="step-diagram" alt="Step \1 diagram" src="\2"><figcaption>Step \1 diagram</figcaption></figure>',
        html_body,
    )
    # isometric/side-profile/fit-check images as captioned figures too —
    # match the whole enclosing <p> so we don't nest a block-level
    # <figure> inside it (invalid HTML that Chrome silently mangles)
    for alt in ["Side profile", "Rear view",
                "Fridge install detail", "Fridge wiring diagram", "Fridge slide detail",
                "Kitchen drawer detail", "Seam draw-latch positioning"]:
        html_body = re.sub(
            rf'<p><img alt="{re.escape(alt)}" src="([^"]+)"[^>]*/?></p>',
            rf'<figure><img src="\1"><figcaption>{alt}</figcaption></figure>',
            html_body,
        )

    # measurement guides are much taller than wide (3 stacked
    # sub-views each) — full page WIDTH would make them many pages
    # tall. Cap by height instead, same treatment as the whole-vehicle
    # overview/floorplan.
    for alt in ["Measurement guide: the van", "Measurement guide: fridge and kitchen",
                "DELTA 3 and WAVE 3 stowage detail", "Electrical layout",
                "Rear pantry layout", "Spare tire stowage", "Panel A detail", "Panel B detail",
                "Panel C detail", "Cabinet door detail", "Bed frame detail",
                "Leveling foot detail", "Panel C front wall detail",
                "Joinery and fastener guide"]:
        html_body = re.sub(
            rf'<p><img alt="{re.escape(alt)}" src="([^"]+)"[^>]*/?></p>',
            rf'<figure class="floorplan-figure"><img src="\1"><figcaption>{alt}</figcaption></figure>',
            html_body,
        )

    # the overhead floorplan and whole-vehicle overview get their own
    # larger, unbordered figures — find the paragraph containing each
    # image + the italic caption that follows and wrap them together
    html_body = re.sub(
        r'<p>(<img alt="(?:Overhead floorplan|Whole vehicle overview)" src="[^"]+"[^>]*/?>)</p>\s*'
        r'<p><em>(.*?)</em></p>',
        r'<figure class="floorplan-figure">\1<figcaption>\2</figcaption></figure>',
        html_body,
        flags=re.DOTALL,
    )

    toc_html = build_toc(headings)
    full_html = TEMPLATE.format(css=CSS, toc=toc_html, body=html_body)
    HTML_PATH.write_text(full_html)
    print(f"wrote {HTML_PATH}")

    result = subprocess.run(
        [
            "google-chrome", "--headless=new", "--disable-gpu",
            "--no-pdf-header-footer",
            f"--print-to-pdf={PDF_PATH}",
            "--print-to-pdf-no-header",
            "--virtual-time-budget=10000",
            f"file://{HTML_PATH}",
        ],
        capture_output=True, text=True, cwd=ROOT,
    )
    if result.returncode != 0 or not PDF_PATH.exists():
        print("Chrome PDF export failed:", result.returncode, file=sys.stderr)
        print(result.stdout, file=sys.stderr)
        print(result.stderr, file=sys.stderr)
        sys.exit(1)
    print(f"wrote {PDF_PATH} ({PDF_PATH.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
