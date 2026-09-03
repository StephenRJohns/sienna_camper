#!/usr/bin/env python3
"""Render legs_guide.md to a standalone, print-ready subset PDF.

A cut-down sibling of build_pdf.py: same page CSS, same cover-sheet
disclaimer and same reportlab page-number stamp, over the leg/leveling-
foot subset of the build plan instead of the whole document.

The subset markdown carries its own <figure> blocks (rather than plain
markdown images fixed up by regex afterwards, as the full document does)
because there are only a dozen of them and each one wants a specific
caption — so the figure-wrapping passes in build_pdf.py have no
counterpart here.
"""
import re
import subprocess
import sys
from pathlib import Path

import markdown

from build_pdf import CSS, COVER, stamp_footers

ROOT = Path(__file__).parent
MD_PATH = ROOT / "legs_guide.md"
HTML_PATH = ROOT / "legs_guide.html"
PDF_PATH = ROOT / "Project_Smores_Legs.pdf"

# Additions on top of build_pdf.CSS. Three things the full document has
# no need for: callout/spec/warn boxes (this subset leans on them where
# the full plan can afford a whole section), a cap on the step-diagram
# figures (they are ~1.3:1 and would otherwise eat a page each), and an
# h2 that does NOT force a page break — twelve short sections would
# print as twelve near-empty pages.
EXTRA_CSS = """
h2 { page-break-before: auto; margin-top: 22pt; }
h2:first-of-type { margin-top: 8pt; }
.callout { border-left: 4px solid #1a3a5c; background: #f2f6fa;
    padding: 9pt 13pt; margin: 12pt 0; font-size: 10pt;
    page-break-inside: avoid; }
.spec { border: 1.5px solid #1a3a5c; background: #fff;
    padding: 8pt 13pt; margin: 11pt 0; font-size: 10.5pt;
    text-align: center; page-break-inside: avoid; }
.warn { border: 2px solid #8a1c1c; background: #fdf6f5;
    padding: 10pt 14pt; margin: 12pt 0; font-size: 10pt;
    page-break-inside: avoid; }
.warn strong:first-child { color: #8a1c1c; }
.lego-figure img { width: auto; height: auto; max-width: 100%; max-height: 4.6in; }
.floorplan-figure img { max-height: 6.2in; }
/* Shop photographs. They are portrait phone shots, so the blanket
   `figure img { width: 100% }` rule would blow one up to a full page
   each; cap the HEIGHT and let the width follow. */
.photo-figure { text-align: center; }
.photo-figure img { width: auto; height: auto; max-width: 100%; max-height: 4in; }
h3 { page-break-after: avoid; }
"""

COVER_SUB = ("Legs &amp; Leveling Feet — a working subset of the full build plan")

TEMPLATE = """<!doctype html>
<html><head><meta charset="utf-8"><title>Project S'mores — Legs &amp; Leveling Feet</title>
<style>{css}</style></head>
<body>
{cover}
{body}
</body></html>
"""

FOOTER_TITLE = "Project S'mores — Legs & Leveling Feet"


def main():
    md_text = MD_PATH.read_text()

    # The subset references the .png siblings directly (see build_pdf.py's
    # note on OpenSCAD's SVG backend discarding color), but keep the same
    # rewrite so a .svg reference can't silently ship a colorless drawing.
    md_text = re.sub(r'(renders/(?:steps/)?[\w.-]+)\.svg', r'\1.png', md_text)

    html_body = markdown.markdown(
        md_text, extensions=["tables", "fenced_code", "sane_lists"])

    # Retitle the cover for the subset, and say plainly that it is one.
    cover = COVER.replace(
        "Toyota Sienna Modular Camper Conversion — Full Build Plan",
        "Toyota Sienna Modular Camper Conversion — " + COVER_SUB,
    ).replace(
        "Vehicle measurements surveyed and verified Aug 1, 2026.",
        "Extracted from the full build plan. Vehicle measurements surveyed "
        "and verified Aug 1, 2026.",
    )

    full_html = TEMPLATE.format(css=CSS + EXTRA_CSS, cover=cover, body=html_body)
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

    # stamp_footers reads build_pdf's module-level FOOTER_TITLE; point it
    # at this document's own title for the duration of the call.
    import build_pdf
    build_pdf.FOOTER_TITLE = FOOTER_TITLE
    numbered = stamp_footers(PDF_PATH)
    print(f"wrote {PDF_PATH} ({PDF_PATH.stat().st_size} bytes) "
          f"— cover sheet + {numbered} numbered pages")


if __name__ == "__main__":
    main()
