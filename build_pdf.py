#!/usr/bin/env python3
"""Render sienna_camper_build_plan.md to a print-ready PDF.

Converts the markdown build plan to styled HTML (with a dedicated
overhead-floorplan section pulled out for visibility), then shells
out to headless Chrome to print it to PDF, and finally stamps a
footer with page numbers onto every page after the cover.

The page-number stamp is a post-process rather than CSS because
Chrome's print-to-PDF does not implement CSS paged-media margin
boxes — `@bottom-center { content: counter(page) }` silently does
nothing there. Chrome's own --print-to-pdf header/footer is the
other option, but the CLI only exposes it as all-or-nothing (it
drags in the URL and the date), so the footer is drawn with
reportlab and merged in with pypdf instead.
"""
import io
import re
import subprocess
import sys
from pathlib import Path

import markdown
from pypdf import PdfReader, PdfWriter
from reportlab.pdfgen import canvas

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
h3.appendix { page-break-before: always; margin-top: 0; }
/* Appendix H's STORE COPY: a hand-it-across-the-counter section that has to
   be printable by page range, so every one of its pages starts on a fresh
   sheet and nothing else shares the page. Written into the markdown as
   <div class="pagebreak"></div>. */
.pagebreak { page-break-before: always; height: 0; margin: 0; }
/* The per-sheet cut diagrams for Appendix H-S. Sized as a PERCENTAGE, not in
   inches: headless Chrome lays this document out at a viewport wider than the
   printable area and scales the result to fit (~0.66x), so a `width: 6in` here
   prints at ~4in while a percentage of the content column is exact. 85% of the
   column x this figure's 1:1.05 aspect leaves the table above it on the page,
   which is the whole point of a one-sheet-per-page store copy. */
img.cutsheet { display: block; margin: 8pt auto 0; width: 85%; height: auto; }
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
h4 { font-size: 11pt; color: #26496b; margin: 14pt 0 4pt 0; }
/* h5 exists only inside Appendix A (the measurement survey): its own
   V1-V10 / F1-F8 items sit one level deeper than the other appendices
   need, because the whole survey was demoted when it moved out of
   Appendix A. Without this it would inherit the browser default and
   render SMALLER than body text. */
h5 { font-size: 10.5pt; color: #1a3a5c; margin: 12pt 0 3pt 0; }
th { background: #eaf0f6; font-weight: 600; }
tr:nth-child(even) td { background: #f7f9fb; }
figure {
    margin: 10pt 0 14pt 0;
    text-align: center;
    page-break-inside: avoid;
}
/* NOTE: do NOT add a blanket `img { max-width: 100% }` here as a
   safety net for un-wrapped images. It interacts badly with the
   percentage-width figure rules below and inflates the document by
   ~38 pages (measured). Every render is 1200-1800px wide, i.e. 13-18in
   at 96dpi, so an image that lands in neither a <figure> nor the
   Component-banner rule WILL run off the right edge of the page —
   the fix is to wrap it, not to cap it globally. */

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
/* per-component IKEA-style header banner (hero + accessory list + part
   list), embedded as a plain markdown image whose alt starts
   "Component " — full width, bordered card, sits right under the h3. */
img[alt^="Component "] { display: block; width: 100%; height: auto;
    border: 1.5px solid #444; border-radius: 2pt; background: #fff;
    padding: 4pt; margin: 4pt 0 10pt; page-break-inside: avoid; }
/* purchase-links table: full URLs shown for copy-paste — break
   anywhere so an 80-char Amazon URL can't blow out the page width */
.buy-links td { word-break: break-all; }
.buy-links td:first-child, .buy-links td:nth-child(2) { word-break: normal; }
.buy-links a { font-size: 8pt; font-family: monospace; }

/* COVER SHEET — its own page, ahead of the document title page. The
   whole point of it is the liability disclaimer, so the warning box
   gets the visual weight, not the title. `page-break-after` on the
   wrapper is what keeps the build plan's own h1 off this page. */
/* NOTE: don't try to bottom-anchor the footer with flex + min-height
   here — Chrome's print layout doesn't stretch the box to the page, so
   the rule is dead weight. The cover simply flows from the top. */
.cover { page-break-after: always; }
.cover-head { border-bottom: 3px solid #2c3e50; padding-bottom: 12pt; }
.cover-head h1 { font-size: 30pt; margin: 0 0 4pt; letter-spacing: -0.5pt; }
.cover-head .cover-sub { color: #555; font-size: 13pt; margin: 0; }
.cover-head .cover-meta { color: #777; font-size: 9.5pt; margin: 10pt 0 0; }
.cover-warn { border: 2.5px solid #8a1c1c; border-radius: 3pt;
    background: #fdf6f5; padding: 14pt 18pt; margin: 26pt 0 0; }
.cover-warn h2 { border: none; color: #8a1c1c; font-size: 14pt;
    margin: 0 0 8pt; padding: 0; page-break-before: avoid;
    text-transform: uppercase; letter-spacing: 0.4pt; }
.cover-warn p { font-size: 9.7pt; margin: 7pt 0; }
.cover-warn ul { font-size: 9.7pt; margin: 7pt 0 7pt 0; padding-left: 16pt; }
.cover-warn li { margin: 4pt 0; }
.cover-warn .accept { margin-top: 12pt; padding-top: 10pt;
    border-top: 1px solid #d8bcbc; font-weight: 600; color: #111; }
.cover-foot { margin-top: 22pt; padding-top: 12pt; color: #666;
    font-size: 8.5pt; border-top: 1px solid #d7dfe6; }
"""

# The cover sheet. Deliberately plain HTML rather than markdown in the
# source document: it is a legal/safety page, not build content, and it
# must not land in the TOC or be reflowed by the markdown pipeline.
COVER = """
<div class="cover">
  <div class="cover-head">
    <h1>Project S'mores</h1>
    <p class="cover-sub">Toyota Sienna Modular Camper Conversion — Full Build Plan</p>
    <p class="cover-meta">Vehicle measurements surveyed and verified Aug 1, 2026.
       Dimensions in this document drive real cuts — re-measure your own vehicle before building.</p>
  </div>

  <div class="cover-warn">
    <h2>Read this first — disclaimer of liability</h2>

    <p><strong>This document is provided for general informational purposes only.
    It is not professional engineering, automotive, electrical, or safety advice,
    and it has not been reviewed or certified by any engineer, manufacturer, or
    regulatory body.</strong> No part of it has been crash-tested or validated
    against any vehicle safety standard.</p>

    <p><strong>If you build from this plan, you do so entirely at your own risk,
    and you accept full and sole responsibility for the outcome.</strong> The
    author and JJJJJ Enterprises, LLC make no warranty of any kind — express or
    implied — as to the accuracy, completeness, safety, legality, or fitness for
    any purpose of anything described here, and <strong>disclaim all liability
    for any personal injury, death, illness, property damage, damage to your
    vehicle, financial loss, or legal consequence</strong> arising directly or
    indirectly from its use, whether or not such harm was foreseeable.</p>

    <p>Work of this kind carries real and serious risks, including but not
    limited to:</p>
    <ul>
      <li><strong>Damage to the vehicle</strong> — trim, wiring, floor pan,
          upholstery, seat mechanisms and finish. Modifications may void some or
          all of your manufacturer warranty, and may affect insurance coverage,
          roadworthiness, inspection status, or resale value.</li>
      <li><strong>Airbag, seatbelt and restraint systems.</strong> Seat removal
          and any work near SRS components, pretensioners, or their wiring can
          disable, damage, or unexpectedly deploy safety systems. Airbags can
          cause severe injury or death if triggered during service. Anything
          touching these systems is work for a qualified technician.</li>
      <li><strong>Cargo becoming a projectile.</strong> Furniture, appliances,
          batteries and gear that are not restrained to a genuine crash-rated
          standard can move, break loose, or kill occupants in a collision or
          rollover. Nothing in this plan is crash-rated, and no statement about
          straps, anchors, or load paths here should be read as a safety rating.</li>
      <li><strong>Electrical hazard.</strong> Battery, inverter, and DC wiring
          work risks short circuit, arc flash, burns, lithium battery fire, and
          electrocution. Sizing, fusing, and installation should be checked by a
          qualified person.</li>
      <li><strong>Cooking, heat, and carbon monoxide.</strong> Cooking or running
          any fuel-burning appliance in or near an enclosed vehicle risks fire,
          burns, and carbon monoxide poisoning, which can be fatal while you
          sleep. Ventilate, and fit working CO and smoke alarms.</li>
      <li><strong>Weight, handling and load limits.</strong> Added weight affects
          braking, handling, tire load, and your vehicle's GVWR and axle ratings.
          Verify all figures against your own vehicle's door-jamb placard.</li>
      <li><strong>Tools and materials.</strong> Power tools, sharp edges, dust,
          adhesives, and finishes cause injury. Follow every manufacturer's
          instructions and use appropriate protective equipment.</li>
      <li><strong>Law and regulation.</strong> Vehicle modification, occupancy,
          and where you may sleep in a vehicle are governed by local law. Confirm
          what applies to you; compliance is your responsibility alone.</li>
    </ul>

    <p><strong>Verify every dimension on your own vehicle before cutting
    anything.</strong> The measurements here were taken on one specific van and
    may not match yours, and errors — in measurement, in transcription, or in the
    drawings — are possible throughout.</p>

    <p class="accept">By reading further, building from, or relying on this
    document, you acknowledge and accept these risks and this disclaimer. If you
    are not willing to accept them, do not use this document. When in doubt,
    stop and hire a qualified professional.</p>
  </div>

  <div class="cover-foot">
    Free to view, share, and build from for personal, non-commercial use only.
    Commercial use, resale, or redistribution for profit is prohibited without
    prior written permission. &copy; 2026 JJJJJ Enterprises, LLC — all rights reserved.
  </div>
</div>
"""

TEMPLATE = """<!doctype html>
<html><head><meta charset="utf-8"><title>Project S'mores Build Plan</title>
<style>{css}</style></head>
<body>
{cover}
<h1 class="doctitle">Project S'mores</h1>
<p class="subtitle">Full Build Plan — Modular Lift-Out Design</p>
{toc}
{body}
</body></html>
"""

FOOTER_TITLE = "Project S'mores — Sienna Camper Build Plan"
FOOTER_NOTE = "Build at your own risk — see the disclaimer on the cover"


def build_toc(headings):
    items = "".join(f'<li>{h}</li>' for h in headings)
    return f'<div class="toc"><strong>Contents</strong><ul>{items}</ul></div>'


def stamp_footers(pdf_path, skip_first=True):
    """Draw a footer (title / page N of M / risk note) on each page.

    The cover sheet is left unnumbered — page 1 is the document's own
    title page — so the numbering a reader sees matches "page 1 of N"
    of the actual build plan rather than counting the legal page.
    """
    reader = PdfReader(pdf_path)
    first_body = 1 if skip_first else 0
    total = len(reader.pages) - first_body
    writer = PdfWriter()

    for index, page in enumerate(reader.pages):
        if index >= first_body:
            width = float(page.mediabox.width)
            height = float(page.mediabox.height)
            buf = io.BytesIO()
            pen = canvas.Canvas(buf, pagesize=(width, height))
            pen.setFont("Helvetica", 7.5)
            pen.setFillGray(0.45)
            # 0.65in page margin; sit the footer inside the bottom of it
            baseline = 30
            pen.drawString(47, baseline, FOOTER_TITLE)
            pen.drawCentredString(width / 2, baseline,
                                  f"Page {index - first_body + 1} of {total}")
            pen.drawRightString(width - 47, baseline, FOOTER_NOTE)
            pen.setStrokeGray(0.8)
            pen.setLineWidth(0.4)
            pen.line(47, baseline + 9, width - 47, baseline + 9)
            pen.save()
            page.merge_page(PdfReader(buf).pages[0])
        writer.add_page(page)

    with open(pdf_path, "wb") as handle:
        writer.write(handle)
    return total


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

*Side profile of the van, front at left and tailgate at right, with the cargo envelope, liftgate opening and platform drawn to scale inside an illustrative body outline. **Numbered callouts:** **1** sitting headroom, mattress top to ceiling. **2** Panels A / B / C with the mattress above. **3** the rear pantry (prefab drawer cluster), **4** sitting on Panel C's deck. **5** the fridge and kitchen unit, hidden under Panel C's deck. Body outline illustrative; the interior and platform dimensions are to scale. The names were moved off the sheet — its geometry is already 258 units long, so its own labels were holding every one of them to ~5pt on the page.*

### Overhead Floorplan

![No-drill anchor platform — overhead detail](renders/anchor-platform-overhead.png)

*The no-drill rail platform (Section 8) in plan view, before the whole-van floorplan below: the mat + ply anchor board under Panel C, its 2 steel tongues bolted to the rear ends of the 2nd-row long-slide floor rails, and its 3 ratchet straps dropping into the crash-rated 3rd-row striker loops. Tailgate at the bottom, forward at the top.*

**What this platform is.** A skeleton of 3/4" plywood on a non-slip rubber mat,
laid on the van floor. It is **ONE comb-shaped piece** — a full-width BRIDGE
with 3 narrow STRIPS running back from it (the hatched shape on the sheet), cut
from a single 46"×33" blank. There are **no joints in it**: nothing is glued or
screwed to another piece of ply. It is **not** a full plywood floor — nothing
sits under the fridge tray or the kitchen unit, where the van floor stays bare.

**The appliances anchor to the BOARD.** The fridge slide's steel riser angles
bolt to the two rail-line strips (1/4-20 T-nuts), and the kitchen's 4 ratchet
straps criss-cross into L-track D-rings on its two flanking strips.

**The board anchors to the VAN at two factory hardpoints — zero new holes.**

- **RAILS:** 2 steel tongues (2"×3/16" flat bar) bolt under the bridge and bolt/clamp to the 2nd-row floor rails' rear ends → takes the FORWARD crash load.
- **STRIKERS:** 3 ratchet straps run from bridge D-rings into the 3rd-row striker loops → takes REARWARD + LIFT loads, and they pin the board down.

Rail-end and striker positions are **ASSUMED** until the Appendix A F1–F8
survey. (This explanation used to be printed as a 20-line block below the
drawing. It is what made that sheet 101 units tall, and since sheet height sets
printed text size, it was holding its own lines — and every label on the drawing
— to about 5pt on paper.)

![Overhead floorplan](renders/top-down.png)

*Top-down view: Panel A/B/C plus the fridge and kitchen unit living inside Panel C's footprint, drawn to scale inside the interior envelope. Front of the vehicle is at the top, tailgate at the bottom. Seam bumpers, alignment pins, and grab-handle positions are all marked.*
"""
    # The md carries its own copy of the anchor-platform overhead
    # figure (for GitHub readers); the PDF shows it inside the
    # Overhead Floorplan section above instead — strip the md copy
    # so the figure doesn't appear twice.
    md_text = re.sub(
        r'### No-Drill Anchor Platform — Overhead Detail.*?renders/anchor-platform-overhead\.svg\)\n*',
        '', md_text, flags=re.DOTALL)

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
    html_body = html_body.replace("<h3>Appendix", '<h3 class="appendix">Appendix')
    # Appendix H-S's per-sheet cut diagrams: bounded height (see .cutsheet)
    # so each store-copy page keeps its table and its diagram together.
    html_body = re.sub(
        r'<img alt="(Sheet \d cut diagram)" src="([^"]+)"([^>]*)/?>',
        r'<img class="cutsheet" alt="\1" src="\2">',
        html_body,
    )

    # wrap step-diagram images (renders/steps/) so they render smaller/centered
    html_body = re.sub(
        r'<img alt="Step (\d+) diagram" src="(renders/steps/[^"]+)"[^>]*/?>',
        r'<figure><img class="step-diagram" alt="Step \1 diagram" src="\2"><figcaption>Step \1 diagram</figcaption></figure>',
        html_body,
    )
    # isometric/side-profile/fit-check images as captioned figures too —
    # match the whole enclosing <p> so we don't nest a block-level
    # <figure> inside it (invalid HTML that Chrome silently mangles)
    for alt in ["Side profile", "Rear view", "Rear view — deployed",
                "Driver-side elevation", "Passenger-side elevation",
                "Plywood cutting layout",
                "Tongue to 2nd-row rail connection detail",
                "Fridge install detail", "Fridge wiring diagram", "Fridge slide detail",
                "Kitchen drawer detail", "Seam draw-latch positioning",
                "Anchor board — assembly and connection details",
                "Anchor board — accessory install map and build order"]:
        html_body = re.sub(
            rf'<p><img alt="{re.escape(alt)}" src="([^"]+)"[^>]*/?></p>',
            rf'<figure><img src="\1"><figcaption>{alt}</figcaption></figure>',
            html_body,
        )

    # the 8 rear-floor survey plans (Appendix A, one per F1-F8 section) —
    # matched by pattern rather than listed, so adding a survey section
    # doesn't need a change here. Full page width: they're ~1.45:1.
    html_body = re.sub(
        r'<p><img alt="((?:Survey F|Van measurement V)\d[^"]*)" src="([^"]+)"[^>]*/?></p>',
        r'<figure><img src="\2"><figcaption>\1</figcaption></figure>',
        html_body,
    )

    # measurement guides are much taller than wide (3 stacked
    # sub-views each) — full page WIDTH would make them many pages
    # tall. Cap by height instead, same treatment as the whole-vehicle
    # overview/floorplan.
    for alt in ["Measurement guide: the van", "Measurement guide: fridge and kitchen",
                "DELTA 3 and WAVE 3 stowage detail", "Electrical layout",
                "Rear pantry layout", "Spare tire stowage", "Panel A detail", "Panel B detail",
                "Panel C detail", "Bed frame detail",
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
        r'<p>(<img alt="(?:Overhead floorplan|Whole vehicle overview'
        r'|No-drill anchor platform — overhead detail)" src="[^"]+"[^>]*/?>)</p>\s*'
        r'<p><em>(.*?)</em></p>',
        r'<figure class="floorplan-figure">\1<figcaption>\2</figcaption></figure>',
        html_body,
        flags=re.DOTALL,
    )

    toc_html = build_toc(headings)
    full_html = TEMPLATE.format(css=CSS, cover=COVER, toc=toc_html, body=html_body)
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
    numbered = stamp_footers(PDF_PATH)
    print(f"wrote {PDF_PATH} ({PDF_PATH.stat().st_size} bytes) "
          f"— cover sheet + {numbered} numbered pages")


if __name__ == "__main__":
    main()
