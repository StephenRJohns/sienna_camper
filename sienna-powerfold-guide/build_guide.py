from reportlab.lib.pagesizes import letter
from reportlab.platypus import (SimpleDocTemplate, Paragraph, Spacer, Image as RLImage,
                                Table, TableStyle, HRFlowable, PageBreak, KeepTogether)
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from reportlab.lib import colors
from PIL import Image as PILImage
import os

HERE = os.path.dirname(os.path.abspath(__file__))
IMG = os.path.join(HERE, "src", "assets") + os.sep
RAW = os.path.join(HERE, "src", "images") + os.sep
OUT = os.path.join(HERE, "output", "Sienna_PowerFold_Mirror_Install_Guide.pdf")
MAIN = "https://www.siennachat.com/threads/power-folding-side-mirror-extra-features.70616/"
VIDEO = "https://www.youtube.com/watch?v=CE5dYUq1FOg"

NAVY = colors.HexColor('#16324f')
ACCENT = colors.HexColor('#1a5fb4')

styles = getSampleStyleSheet()
title_s = ParagraphStyle('T', parent=styles['Title'], fontSize=22, leading=26,
                         textColor=NAVY, spaceAfter=4)
sub_s = ParagraphStyle('Sub', parent=styles['Normal'], fontSize=12.5, leading=16,
                       alignment=1, textColor=colors.HexColor('#555555'), spaceAfter=14)
h1 = ParagraphStyle('H1', parent=styles['Heading1'], fontSize=15, leading=19,
                    textColor=NAVY, spaceBefore=16, spaceAfter=8)
h2 = ParagraphStyle('H2', parent=styles['Heading2'], fontSize=12, leading=15,
                    textColor=colors.HexColor('#2b4c6f'), spaceBefore=12, spaceAfter=5)
h3 = ParagraphStyle('H3', parent=styles['Heading3'], fontSize=10.5, leading=13,
                    textColor=colors.HexColor('#333333'), spaceBefore=9, spaceAfter=3)
body = ParagraphStyle('B', parent=styles['Normal'], fontSize=10, leading=14, spaceAfter=7)
bullet = ParagraphStyle('Bul', parent=body, leftIndent=16, bulletIndent=4, spaceAfter=3)
cap = ParagraphStyle('Cap', parent=styles['Normal'], fontSize=8.5, leading=11,
                     alignment=1, textColor=colors.HexColor('#5a5a5a'), spaceBefore=3, spaceAfter=10)
note = ParagraphStyle('Note', parent=styles['Normal'], fontSize=9.5, leading=13, spaceAfter=9, spaceBefore=9,
                      backColor=colors.HexColor('#fff8e1'), borderPadding=7,
                      borderColor=colors.HexColor('#e0c46c'), borderWidth=0.6)
warn = ParagraphStyle('Warn', parent=styles['Normal'], fontSize=9.5, leading=13, spaceAfter=9, spaceBefore=9,
                      backColor=colors.HexColor('#fdecea'), borderPadding=7,
                      borderColor=colors.HexColor('#d9756c'), borderWidth=0.6)
tip = ParagraphStyle('Tip', parent=styles['Normal'], fontSize=9.5, leading=13, spaceAfter=9, spaceBefore=9,
                     backColor=colors.HexColor('#e8f4ec'), borderPadding=7,
                     borderColor=colors.HexColor('#7fb08e'), borderWidth=0.6)
link_s = ParagraphStyle('L', parent=styles['Normal'], fontSize=9.5, leading=13, spaceAfter=5)
small = ParagraphStyle('S', parent=styles['Normal'], fontSize=8.5, leading=11,
                       textColor=colors.grey)

# Front-matter credit / disclaimer styles. These mirror the cover sheet of the
# Project S'mores build plan: the liability box carries the visual weight, so it
# gets its own red-bordered frame rather than being folded into body text.
DISC_RED = colors.HexColor('#8a1c1c')
disc_h = ParagraphStyle('DiscH', parent=styles['Heading2'], fontSize=12, leading=15,
                        textColor=DISC_RED, spaceBefore=0, spaceAfter=7)
disc_b = ParagraphStyle('DiscB', parent=styles['Normal'], fontSize=9.3, leading=12.4,
                        spaceAfter=6)
disc_li = ParagraphStyle('DiscLi', parent=disc_b, leftIndent=14, bulletIndent=3, spaceAfter=4)
disc_accept = ParagraphStyle('DiscA', parent=disc_b, fontSize=9.3, leading=12.4,
                             textColor=colors.HexColor('#111111'), spaceBefore=4, spaceAfter=0)
credit_li = ParagraphStyle('CredLi', parent=body, fontSize=9.5, leading=13,
                           leftIndent=16, bulletIndent=4, spaceAfter=5)

st = []


def B(text):
    return Paragraph(text, body)


def li(text):
    return Paragraph(text, bullet, bulletText='\u2022')


def _find(fn):
    """Derived assets live in src/assets; original photos in src/images."""
    for base in (IMG, RAW):
        p = os.path.join(base, fn)
        if os.path.exists(p):
            return p
    raise FileNotFoundError(f"image not found in assets or images: {fn}")


def photo(fn, caption, maxw=6.0, maxh=6.4):
    path = _find(fn)
    iw, ih = PILImage.open(path).size
    maxw *= inch
    maxh *= inch
    sc = min(maxw / iw, maxh / ih)
    img = RLImage(path, width=iw * sc, height=ih * sc)
    img.hAlign = 'CENTER'
    return KeepTogether([img, Paragraph(caption, cap)])


def pair(fn1, cap1, fn2, cap2, h=2.7):
    """Two photos side by side."""
    cells = []
    for fn, c in ((fn1, cap1), (fn2, cap2)):
        p = _find(fn)
        iw, ih = PILImage.open(p).size
        sc = min((2.9 * inch) / iw, (h * inch) / ih)
        img = RLImage(p, width=iw * sc, height=ih * sc)
        img.hAlign = 'CENTER'
        cells.append([img, Paragraph(c, cap)])
    t = Table([[cells[0][0], cells[1][0]], [cells[0][1], cells[1][1]]],
              colWidths=[3.05 * inch, 3.05 * inch])
    t.setStyle(TableStyle([('ALIGN', (0, 0), (-1, -1), 'CENTER'),
                           ('VALIGN', (0, 0), (-1, 0), 'BOTTOM'),
                           ('VALIGN', (0, 1), (-1, 1), 'TOP'),
                           ('BOTTOMPADDING', (0, 0), (-1, 0), 2),
                           ('TOPPADDING', (0, 1), (-1, 1), 0)]))
    return KeepTogether([t, Spacer(1, 6)])


def trio(items, h=2.0):
    cells_img, cells_cap = [], []
    for fn, c in items:
        p = _find(fn)
        iw, ih = PILImage.open(p).size
        sc = min((1.9 * inch) / iw, (h * inch) / ih)
        img = RLImage(p, width=iw * sc, height=ih * sc)
        img.hAlign = 'CENTER'
        cells_img.append(img)
        cells_cap.append(Paragraph(c, cap))
    t = Table([cells_img, cells_cap], colWidths=[2.03 * inch] * 3)
    t.setStyle(TableStyle([('ALIGN', (0, 0), (-1, -1), 'CENTER'),
                           ('VALIGN', (0, 0), (-1, 0), 'BOTTOM'),
                           ('VALIGN', (0, 1), (-1, 1), 'TOP'),
                           ('BOTTOMPADDING', (0, 0), (-1, 0), 2)]))
    return KeepTogether([t, Spacer(1, 4)])


def url(label, u):
    return Paragraph(f"{label}<br/><link href='{u}' color='#1a5fb4'>{u}</link>", link_s)


# ============================== COVER ==============================
st.append(Spacer(1, 8))
st.append(Paragraph("Power-Folding Mirror Retrofit", title_s))
st.append(Paragraph("Installation Reference Guide &nbsp;&middot;&nbsp; Toyota Sienna (2021&ndash;2026)", sub_s))

st.append(Paragraph(
    "This guide covers the aftermarket power-fold conversion kit sold for the fourth-generation "
    "Sienna &mdash; the version that replaces the fold bracket <i>inside</i> each mirror housing, adds a "
    "controller module in each front door, and swaps the driver's window-switch panel for one with a "
    "fold control. It is assembled from the manufacturer's own wiring figures, a step-by-step video "
    "walkthrough, first-hand installer photos, and the experience reported by owners who have done "
    "this job on their own vans.", body))

st.append(Spacer(1, 6))
vid = Table([[Paragraph(
    "<b>Video walkthrough &mdash; watch this before you start</b><br/>"
    f"<link href='{VIDEO}' color='#1a5fb4'>{VIDEO}</link><br/>"
    "<font size=9 color='#555555'>Multiple installers have said the same thing: the mirror teardown is "
    "very difficult to figure out without seeing it done. Expect to replay the spring/lock-ring "
    "section several times.</font>", body)]], colWidths=[6.5 * inch])
vid.setStyle(TableStyle([
    ('BACKGROUND', (0, 0), (-1, -1), colors.HexColor('#eef3fa')),
    ('BOX', (0, 0), (-1, -1), 0.8, ACCENT),
    ('LEFTPADDING', (0, 0), (-1, -1), 10), ('RIGHTPADDING', (0, 0), (-1, -1), 10),
    ('TOPPADDING', (0, 0), (-1, -1), 9), ('BOTTOMPADDING', (0, 0), (-1, -1), 4)]))
st.append(vid)
st.append(Spacer(1, 10))

facts = [
    ["Difficulty", "Advanced DIY \u2014 rated about 7/10 by an experienced installer"],
    ["Time", "First mirror 2\u20133 hours; second mirror ~1 hour once you know the sequence"],
    ["Whole job", "Realistically 4\u20136 hours for both sides including wiring and testing"],
    ["Hardest step", "Compressing the detent spring and releasing the lock ring inside the mirror"],
    ["Wiring", "Mostly plug-and-play; only the two motor leads and one optional feature wire are extra"],
    ["Battery", "Disconnect recommended before pulling door panels, though some skip it"],
    ["Risk", "Broken plastic clips and cracked motor housings are the most common damage"],
]
ft = Table([[Paragraph(f"<b>{a}</b>", body), Paragraph(b, body)] for a, b in facts],
           colWidths=[1.25 * inch, 5.25 * inch])
ft.setStyle(TableStyle([
    ('VALIGN', (0, 0), (-1, -1), 'TOP'),
    ('LINEBELOW', (0, 0), (-1, -2), 0.4, colors.HexColor('#dddddd')),
    ('TOPPADDING', (0, 0), (-1, -1), 5), ('BOTTOMPADDING', (0, 0), (-1, -1), 5),
    ('LEFTPADDING', (0, 0), (0, -1), 0)]))
st.append(ft)

st.append(Spacer(1, 10))
st.append(Paragraph(
    "Photos are the owner's own install shots plus images shared by installers in the SiennaChat "
    "community thread; the two figures are the kit manufacturer's supplied diagrams. Full source "
    "links are at the end of this guide.<br/><br/>"
    "<b>This document is a compilation of other people's work.</b> Credits, acknowledgements, "
    "ownership of rights, and the disclaimer of liability are on the following page &mdash; "
    "please read that page before starting the job.", small))

# ================== CREDITS / RIGHTS / DISCLAIMER ==================
# Front matter, deliberately ahead of the content. Two jobs on this page:
# credit the people whose work this document is assembled from, and carry the
# liability disclaimer. The disclaimer box is styled after the Project S'mores
# cover sheet so the two documents read as a set.
st.append(PageBreak())
st.append(Paragraph("Acknowledgements, Credits, and Disclaimer", h1))

st.append(B(
    "<b>There is almost nothing original in this guide.</b> The procedure, the photographs, the "
    "wiring figures, and the hard-won details &mdash; which nut turns which way, why the spring is not "
    "really what you are fighting, what a cracked motor housing looks like when it goes wrong &mdash; "
    "were all worked out and published by other people. They did this install first, often badly the "
    "first time, and then took the trouble to write it up for strangers who would never thank them "
    "in person. This document only gathers that scattered material into one ordered sequence and "
    "paraphrases it in a consistent voice."))
st.append(B(
    "To everyone listed below: <b>thank you. Your work is what made this possible, and it is greatly "
    "appreciated.</b>"))

st.append(Paragraph("With thanks to", h2))
for who, what in [
    ("jays3l33t", "who started the SiennaChat thread &ldquo;Power Folding Side Mirror + Extra "
     "features&rdquo; in April 2022. That thread is the backbone of this guide."),
    ("The installers of the SiennaChat community", "who posted their own teardowns, mistakes, and "
     "photographs across eight pages of discussion &mdash; the 13&nbsp;mm / 19&nbsp;mm distinction, the "
     "insight that you are clearing the cylinder's ears from a pocket rather than overpowering the "
     "spring, door wiring photographs for both sides, and the honest reports of vibration and "
     "angle-adjustment problems afterwards. Several of these details appear nowhere else."),
    ("The author of the kit installation video walkthrough", "whose full teardown-and-reassembly "
     "recording is the single most useful reference for this job. More than one installer has said "
     "the mirror teardown cannot realistically be understood without watching it."),
    ("The Fly-to-the-sky channel", "for careful door-trim disassembly footage covering this "
     "generation of Sienna."),
    ("Contributors to the Toyota Nation threads", "on power-folding mirror installation, who "
     "documented the same job independently and provided a useful cross-check."),
    ("The kit manufacturer and seller", "whose two supplied figures &mdash; the wiring diagram and the "
     "switch-panel diagram &mdash; are reproduced here because no clearer version of that information "
     "exists."),
]:
    st.append(Paragraph(f"<b>{who}</b> &mdash; {what}", credit_li, bulletText='•'))

st.append(Paragraph("Rights and ownership", h2))
st.append(B(
    "<b>All rights are retained by their specific owners.</b> Every photograph, diagram, video, and "
    "forum post referred to in this document remains the property of the person or company who "
    "created it. Nothing here is claimed as the compiler's own work beyond the arrangement and the "
    "wording of the explanatory text, and no ownership of any third-party material is asserted or "
    "implied."))
st.append(B(
    "This material is gathered and paraphrased for personal, non-commercial reference only. This "
    "document is <b>not</b> an official publication of Toyota, or of any kit manufacturer, seller, or "
    "forum, and no affiliation with or endorsement by any of them is claimed. If you own material "
    "used here and would prefer it credited differently, attributed by name, or removed entirely, "
    "that request will be honoured."))

# ---- liability box ----
# The box is a single-row table, so it cannot split across a page break: it will
# always jump whole to the next page. Break explicitly so the disclaimer owns a
# full page by design (as it does on the Project S'mores cover sheet) instead of
# leaving an accidental half-empty page behind it.
st.append(PageBreak())
_disc = [
    Paragraph("Read this first &mdash; disclaimer of liability", disc_h),
    Paragraph(
        "<b>This document is provided for general informational purposes only. It is not "
        "professional automotive, electrical, or safety advice, and it has not been reviewed or "
        "certified by Toyota, by any kit manufacturer or seller, or by any qualified technician or "
        "regulatory body.</b> It is an amateur compilation of third-party accounts, and errors in "
        "those accounts, in their interpretation, or in transcription are possible throughout.",
        disc_b),
    Paragraph(
        "<b>If you carry out this work, you do so entirely at your own risk, and you accept full and "
        "sole responsibility for the outcome.</b> The author and JJJJJ Enterprises, LLC make no "
        "warranty of any kind &mdash; express or implied &mdash; as to the accuracy, completeness, safety, "
        "legality, or fitness for any purpose of anything described here, and <b>disclaim all "
        "liability for any personal injury, death, property damage, damage to your vehicle, "
        "financial loss, or legal consequence</b> arising directly or indirectly from its use, "
        "whether or not such harm was foreseeable.", disc_b),
    Paragraph("This job carries real and serious risks, including but not limited to:", disc_b),
]
for risk in [
    "<b>Stored spring energy.</b> The fold cylinder is released against a compressed detent "
    "spring. Parts can slip or launch without warning. Wear eye protection, and keep your face "
    "out of line with the assembly.",
    "<b>Airbag and restraint systems.</b> Front door trim and pillar areas on this vehicle carry "
    "SRS wiring and impact sensors. Disturbing, pinching, or wrongly reconnecting them can "
    "disable, damage, or unexpectedly deploy safety systems, which can cause severe injury or "
    "death. Anything touching these systems is work for a qualified technician.",
    "<b>Electrical damage and fire.</b> Reversed polarity, a pinched harness, a shorted feed, or a "
    "wrongly chosen tap point can destroy control modules, blow fuses, or start a fire. The "
    "optional extra-features wire is the only step that taps a factory circuit and is the "
    "riskiest part of the job &mdash; it is genuinely optional, and skipping it costs you nothing but "
    "convenience features.",
    "<b>Broken and unavailable parts.</b> Cracked motor housings, snapped trim clips, stripped "
    "tool lugs, and broken mirror glass are the most commonly reported damage. Some of these "
    "parts are slow or difficult to source, and a vehicle with a broken mirror may not be legal "
    "to drive.",
    "<b>Loss of mirror function or view.</b> Faulty reassembly can leave a mirror that vibrates, "
    "will not adjust, loses its heater or blind-spot function, folds when it should not, or "
    "obstructs your view. Functioning mirrors are a legal requirement for road use.",
    "<b>Water intrusion.</b> A housing that is not correctly reseated and sealed can admit water "
    "into the mirror electronics and into the door.",
    "<b>Warranty, insurance, and inspection.</b> Modifications may void some or all of your "
    "manufacturer warranty, and may affect insurance coverage, roadworthiness, inspection "
    "status, or resale value.",
    "<b>Kit variation.</b> Parts, wiring, and switch behaviour differ between sellers of "
    "superficially identical kits. What is described here may not match what arrives in your box. "
    "Verify every step against the kit and vehicle in front of you.",
]:
    _disc.append(Paragraph(risk, disc_li, bulletText='•'))
_disc.append(HRFlowable(width="100%", thickness=0.5, color=colors.HexColor('#d8bcbc'),
                        spaceBefore=8, spaceAfter=6))
_disc.append(Paragraph(
    "<b>By reading further, or by relying on this document in any way, you acknowledge and accept "
    "these risks and this disclaimer. If you are not willing to accept them, do not use this "
    "document. When in doubt, stop and hire a qualified professional.</b>", disc_accept))

dbox = Table([[_disc]], colWidths=[6.5 * inch])
dbox.setStyle(TableStyle([
    ('BACKGROUND', (0, 0), (-1, -1), colors.HexColor('#fdf6f5')),
    ('BOX', (0, 0), (-1, -1), 1.6, DISC_RED),
    ('VALIGN', (0, 0), (-1, -1), 'TOP'),
    ('LEFTPADDING', (0, 0), (-1, -1), 12), ('RIGHTPADDING', (0, 0), (-1, -1), 12),
    ('TOPPADDING', (0, 0), (-1, -1), 11), ('BOTTOMPADDING', (0, 0), (-1, -1), 11)]))
st.append(Spacer(1, 6))
st.append(dbox)

st.append(Spacer(1, 10))
st.append(Paragraph(
    "Free to view and share for personal, non-commercial use. Commercial use or resale is not "
    "permitted. The compilation and original explanatory text are &copy;&nbsp;2026 JJJJJ "
    "Enterprises, LLC; all third-party material remains the property of its respective owners.",
    small))

# ============================== KIT ==============================
st.append(PageBreak())
st.append(Paragraph("1. What's in the Kit", h1))
st.append(B(
    "Everything arrives as two mirror-side subassemblies plus the electronics that tie them into the "
    "van. Lay it all out and identify each piece before touching the vehicle &mdash; several parts look "
    "similar and are side-specific."))

st.append(photo("F6F9BD38685B4B76A368E62D02BD0ADC.jpeg",
                "The complete kit laid out. Left/right fold bracket assemblies with their springs and "
                "actuator motors, two controller modules, the mounting bolt and pivot hardware, the "
                "blue mirror-side connector, and the fused main harness with its green switched lead.",
                maxw=5.2, maxh=6.2))

st.append(Paragraph("Part-by-part", h2))
kit = [
    ("Fold bracket assemblies (2)", "Cast aluminium frames with the fold motor and detent spring "
     "already built in. Marked DDZD-221-L and DDZD-221-R \u2014 confirm you are holding the correct side "
     "before disassembly."),
    ("Controller modules (2)", "One per door. Small black boxes labelled for the 2022 Sienna. They sit "
     "between the door harness and the mirror, and drive the fold motor."),
    ("Main harness", "Fused piggyback harness with matching Toyota-style connectors. It plugs inline "
     "with the factory door connector, so no factory wires are cut."),
    ("Replacement switch panel", "Driver's-side window/lock switch trim with an added fold control "
     "built into the mirror selector knob."),
    ("Pivot bolt and lock hardware", "The bolt that retains the fold cylinder, plus the notched lock "
     "washer/ring. A lock-ring tool is normally included \u2014 confirm yours is present, since it is the "
     "single most important tool in the box."),
]
for a, b in kit:
    st.append(Paragraph(f"<b>{a}</b> &mdash; {b}", bullet, bulletText='\u2022'))

st.append(Spacer(1, 6))
st.append(pair("1EE6338432E34F99A4A7298FA6377FF1.jpeg",
               "One of the two controller modules. Note the barcode label \u2014 record it in case you "
               "need to reorder or contact the seller about a fault.",
               "C0A854D9032A4A289A277C63162F84DE.jpeg",
               "The piggyback harness. The factory door connector unplugs, the harness goes in "
               "between, and everything downstream stays original.", h=2.6))

st.append(Paragraph(
    "<b>Confirm the spring tool is in the box.</b> The kit includes a purpose-made spring compressor / "
    "lock-collar tool, and there is no aftermarket equivalent \u2014 the lug pattern is specific to this "
    "pivot. More than one installer has stripped theirs partway through the first mirror and been left "
    "stuck mid-job. Check it is present and undamaged before you start, and consider asking the seller "
    "for a spare when you order.", warn))

# ============================== DIAGRAMS ==============================
st.append(PageBreak())
st.append(Paragraph("2. Manufacturer Wiring Figures", h1))
st.append(B(
    "These two figures are effectively the kit's instruction sheet. Read them before starting; the "
    "steps that follow will make far more sense afterwards. Figure 3 shows the in-door wiring for one "
    "mirror; Figure 4 shows the switch-panel swap and where each of its three leads goes."))

st.append(photo("fig3_wiring.png",
                "<b>Figure 3 &mdash; Right rearview mirror wiring.</b> (1) the pair of white connectors "
                "plug into the factory mirror circuit; (2) the small black connector is the fold motor "
                "lead that passes into the mirror; (3) the controller module mounts inside the door. "
                "The lower photo shows all three positions on the door shell.",
                maxw=4.3, maxh=7.2))

st.append(PageBreak())
st.append(photo("fig4_switch.png",
                "<b>Figure 4 &mdash; Switch panel swap.</b> (1) forward connector near the mirror "
                "harness; (2) the green fold-signal lead; (3) rear connector; (4) the replacement "
                "switch assembly with the fold control built into the mirror selector knob.",
                maxw=4.6, maxh=7.4))

# ============================== TOOLS ==============================
st.append(PageBreak())
st.append(Paragraph("3. Tools and Preparation", h1))

st.append(Paragraph("Tools", h2))
tools = [
    "Plastic trim/pry tools \u2014 for the door panel. (For the mirror glass itself, most installers "
    "ended up using bare hands; see Step 3.)",
    "Phillips and small flat screwdrivers",
    "Socket set including 10 mm, 13 mm and 19 mm; a stubby ratchet helps inside the housing",
    "Locking pliers or a small vise \u2014 useful for holding the fold cylinder while compressing the spring",
    "The kit's lock-ring/spring tool, plus a fallback (long threaded rod, two nuts, washers)",
    "Zip ties, self-adhesive Velcro pads, electrical tape",
    "Small parts tray and a phone for progress photos",
]
for t in tools:
    st.append(li(t))

st.append(Paragraph("Before you touch anything", h2))
prep = [
    "Photograph every connector and clip position as you go. Reassembly is far easier with reference shots.",
    "Do the passenger side first if you want the driver's-side experience to be the smoother one \u2014 "
    "or do the driver's side first if you would rather get the switch-panel wiring settled early. "
    "Either way, the second mirror will take roughly a third of the time.",
    "Work in the shade and warm, not cold, conditions. Cold plastic clips break more readily.",
    "Disconnect the battery before pulling door panels, particularly since you will be unplugging "
    "connectors that share the door harness.",
]
for t in prep:
    st.append(li(t))

st.append(Paragraph(
    "<b>Set expectations.</b> An installer who describes himself as a proficient DIYer called this "
    "one of the hardest modifications he has attempted, and rated it 7/10 for difficulty &mdash; not "
    "because any single step is beyond reach, but because of how many small plastic pieces can break "
    "and how much extra time recovery takes.", note))

# ============================== DOOR PANEL ==============================
st.append(PageBreak())
st.append(Paragraph("4. Step 1 &mdash; Door Panel and Switch Panel Removal", h1))
st.append(B(
    "Both front doors have to come apart: the driver's side for the switch panel and controller, the "
    "passenger side for its controller and mirror wiring."))

steps = [
    "Pry the driver's switch/trim panel up from the armrest. It lifts as an assembly; work from the "
    "rear edge forward and support it as it releases.",
    "Unplug the connectors behind the switch panel and set it aside \u2014 you will be transferring the "
    "window and lock switches into the new panel later.",
    "Remove the door panel screws (behind the pull-cup, behind the handle bezel, and along the lower "
    "edge), then release the perimeter clips.",
    "Lift the panel up and off the window ledge, unplug the remaining connectors, and set it face-down "
    "on a soft surface.",
    "Peel back only as much of the vapour barrier as you need. Keep the butyl sealant clean so it "
    "reseals properly.",
]
for i, s in enumerate(steps, 1):
    st.append(Paragraph(f"<b>{i}.</b> {s}", bullet))

st.append(Spacer(1, 4))
st.append(photo("723A10D0BAA14821A0ADB34520CA412F.jpeg",
                "Driver's door with the panel off and the kit installed. Circled, clockwise from top "
                "left: the mirror harness at the sail-panel grommet, the controller module mounted on "
                "the door shell, the inline connector at the main door harness, and the lower "
                "connector near the latch.", maxw=6.2, maxh=4.8))

st.append(trio([
    ("f_rdoor_a.jpg", "Controller mounted with Velcro inside the passenger door trim cavity."),
    ("f_rdoor_b.jpg", "Passenger door with harness routed and connectors seated."),
    ("f_rdoor_c.jpg", "The same door before any work \u2014 useful as a reference photo."),
], h=2.3))

st.append(trio([
    ("f_ldoor_a.jpg", "Driver's door, behind the speaker: the factory connector the harness taps into."),
    ("f_ldoor_b.jpg", "Fold-motor lead and mirror connector routed together above the speaker."),
    ("f_ldoor_c.jpg", "Both connectors plugged in, harness dressed along the factory loom."),
], h=2.3))

# ============================== MIRROR OFF ==============================
st.append(PageBreak())
st.append(Paragraph("5. Step 2 &mdash; Removing the Mirror Assembly", h1))
st.append(B(
    "With the door panel off, the mirror's three nuts and its connector are accessible from inside the "
    "sail-panel area. Support the mirror from outside before you remove the last nut."))

st.append(li("Unplug the mirror connector at the grommet."))
st.append(li("Hold the mirror body from outside, remove the retaining nuts, and lift the assembly away "
             "from the door."))
st.append(li("Take the mirror to a bench. Everything from here is easier with the assembly in your "
             "hands rather than at arm's length on the vehicle."))

st.append(Paragraph(
    "<b>Alternative:</b> one installer removed the outer mirror cover with the mirrors still on the "
    "van and found that easier, with a drop sheet underneath to catch the cover. Either approach "
    "works; the bench route gives you better control during the spring step.", tip))

st.append(pair("4A9271E51A1144F180EBD049A3927BC4.jpeg",
               "The factory mirror connector at the door grommet, unplugged.",
               "DAA77A26F6CF420CB934DBB00E0DE7F7.jpeg",
               "The new harness fed through the same grommet. The green and grey leads are the fold "
               "motor and feature wires that continue into the cabin.", h=2.8))

# ============================== GLASS ==============================
st.append(PageBreak())
st.append(Paragraph("6. Step 3 &mdash; Removing the Mirror Glass", h1))
st.append(B(
    "The glass and its plastic backing plate clip onto the adjustment motor. There is no hidden "
    "fastener &mdash; it simply unclips, but the force required is alarming the first time."))

st.append(Paragraph(
    "<b>Use your hands, not a pry bar.</b> The installers who did both sides consistently reported "
    "that plastic pry tools were useless here and did more harm than good. The method that works: "
    "tilt the glass fully in using the mirror adjuster (or by hand), get your fingers into the gap at "
    "the top edge, slide as much of your hand behind the glass as fits, and pull slowly and steadily "
    "outward. Increase pressure gradually &mdash; it will pop.", tip))

st.append(li("Tilt the glass down/inward to open a gap at the top."))
st.append(li("Work your fingers behind the backing plate, spreading load across as much of the plate as "
             "you can reach."))
st.append(li("Pull straight out with slow, increasing force until the centre clips release."))
st.append(li("Disconnect the two spade terminals for the heated-mirror element as the glass comes free."))

st.append(pair("f_glassback.jpg",
               "Back of the mirror glass. The ring of clips around the centre hub is what grips the "
               "adjustment motor; the two white spade terminals at the right feed the heater element.",
               "f_glassback2.jpg",
               "Same plate from a different angle. Note how many clips there are \u2014 this is why the "
               "glass takes real force to release.", h=2.9))

st.append(Paragraph(
    "<b>Two things go wrong here.</b> First, the small heater wires can pull off their tabs as the "
    "glass releases &mdash; note which terminal each goes to <i>before</i> pulling, because reconnecting "
    "them blind afterwards is genuinely difficult. Second, prying at random can separate the "
    "adjustment motor housing itself.", warn))

st.append(pair("f_brokenmotor.jpg",
               "What prying badly looks like: the adjustment motor housing pulled apart with the "
               "glass. It snapped back together, but it took real force and shed broken plastic.",
               "f_mirrorconn.jpg",
               "Behind the glass \u2014 the connector and the two loose leads that plug onto the metal "
               "tabs. Photograph this before disturbing anything.", h=2.9))

# ============================== TEARDOWN ==============================
st.append(PageBreak())
st.append(Paragraph("7. Step 4 &mdash; Opening the Mirror Housing", h1))
st.append(B(
    "With the glass off, the adjustment motor and the housing screws are exposed. The goal is to "
    "separate the outer cover and the plastic base from the cast bracket so the factory fold pivot can "
    "be replaced with the kit's motorised one."))

st.append(li("Remove the screws holding the adjustment motor and lift it clear, leaving its wiring "
             "attached where possible."))
st.append(li("Release the outer cover from the housing. Take your time on the clips \u2014 these are the "
             "pieces most often broken."))
st.append(li("Separate the plastic base from the cast bracket, keeping every screw grouped by location."))

st.append(pair("f_covercradle.jpg",
               "Inside the housing with the glass and motor removed, showing the cradle the "
               "adjustment motor sits in.",
               "f_coverinside.jpg",
               "The cover shell off the vehicle. Every one of these clips is a potential breakage "
               "point on reassembly.", h=2.7))

st.append(photo("47F2D5E996AB41148CB396BFAD48F057.jpeg",
                "Fully disassembled: cast bracket at top, plastic base in the middle, outer cover at "
                "the bottom, with the spring and washer set aside at right. Keep the parts in this "
                "order and reassembly goes much faster.", maxw=5.6, maxh=4.2))

# ============================== SPRING ==============================
st.append(PageBreak())
st.append(Paragraph("8. Step 5 &mdash; The Spring and Lock Ring (the hard part)", h1))
st.append(B(
    "The mirror pivots on a spring-loaded cylinder held by a notched lock ring. To free it, the spring "
    "has to be compressed just far enough that the ring can be rotated out of its locked position. "
    "Nearly every installer who has documented this job identified this as the step that consumes the "
    "time and causes the damage."))

st.append(Paragraph("First, understand what you are actually doing", h2))
st.append(B(
    "The most useful reframing posted on the thread: <b>ignore the spring.</b> It is only there to "
    "provide tension. What you are really doing is compressing the <i>cylinder</i> far enough that "
    "its ears clear a pocket in the housing, so the cylinder can rotate free. There is no target "
    "compression to reach and no force to aim for \u2014 you are feeling for the moment the ears clear."))

st.append(B(
    "The tool that does this comes with the kit. It is a flanged, lug-drive hex socket: a wide flange "
    "that bears on the lock collar, a hex boss so a wrench can turn it, and a through-bore ringed by "
    "drive lugs that engage slots in the collar. It does <b>two different jobs</b>, and knowing which "
    "feature does which is what keeps you from stripping it."))

st.append(photo("diag_stack.png",
                "<b>The stack, top to bottom.</b> The <b>nut</b> on the threaded rod does the "
                "compressing; the <b>hex boss on the tool body</b> does the rotating. They are "
                "different sizes \u2014 13 mm and 19 mm \u2014 so you can tell at a glance which "
                "operation you are performing.", maxw=5.9, maxh=3.6))

st.append(Paragraph("The sequence \u2014 work in small increments", h2))
st.append(B(
    "This is the part to get right. Do <b>not</b> compress hard and then try to turn. Alternate "
    "between the two nuts in small steps and let the cylinder tell you when it is ready:"))
seq = [
    "Fit the tool over the collar on top of the cylinder, lugs seated in their slots. Check the pin "
    "at the bottom is centred in its opening before you load anything.",
    "Snug the <b>13 mm nut</b> down until it is just tight.",
    "Try to turn the <b>19 mm</b>. If it will not move, do not force it.",
    "Give the 13 mm nut <b>one more full turn</b>, then try the 19 mm again. Repeat this alternation "
    "until the 19 mm turns.",
    "When it goes, the 19 mm rotates only about a quarter turn (90 degrees) \u2014 that is the ears "
    "walking out of their pocket. It will not turn further, and it does not need to.",
    "Back the compression off and loosen the retaining bolt. The spring pushes the cylinder up and out.",
    "Keep the spring, washer and nut together \u2014 the kit reuses the same arrangement in reverse.",
]
for i, s in enumerate(seq, 1):
    st.append(Paragraph(f"<b>{i}.</b> {s}", bullet))

st.append(Paragraph(
    "<b>This alternating method is the whole trick.</b> The installers who stripped their tools did so "
    "by cranking the 13 mm nut down hard before checking whether the 19 mm would turn \u2014 by the time "
    "the collar was free, the threads were already gone. Checking every turn costs a few seconds and "
    "is the difference between a working tool and a stalled install. One installer also found it "
    "easier on the second mirror by looking underneath at the hooks to see how far he had gone.", tip))

st.append(Paragraph(
    "<b>Two sizes to have ready:</b> a 13&nbsp;mm for the compression nut and a 19&nbsp;mm for the "
    "collar. Confirm both against your own tool \u2014 kit revisions vary \u2014 and follow the video for "
    "the exact order on yours.", note))

st.append(pair("99C088AB9D474BF0B8276D62D4E2E4B3.jpeg",
               "The supplied tool seated on the notched lock ring, threaded rod through the centre.",
               "4E527D38B37F4F2B9309F9CFCEE6375A.jpeg",
               "Compressing the detent spring on the cylinder. Note how little travel is actually "
               "needed.", h=3.1))

st.append(PageBreak())
st.append(pair("30D133B107C647388646B21AE5D5867F.jpeg",
               "The washer and ring under load, ready to be rotated clear.",
               "457FD7CD4B9B4814B6B3AA91F1E94096.jpeg",
               "Close-up of the ring seated in the housing \u2014 the tabs you are trying to rotate out "
               "of their slots.", h=3.1))

st.append(photo("DBE5E93AE5344C24998313D194DEB392.jpeg",
                "Everything that comes out: the detent spring, its nut, the flat washer, and the "
                "notched lock ring with the tool. Bag these together.", maxw=3.4, maxh=4.6))

st.append(PageBreak())
st.append(photo("tool_zoom.png",
                "The kit's tool close up. The four drive lugs around the central bore are what "
                "actually grip and turn the lock collar; the hex flats outside take the wrench.",
                maxw=2.7, maxh=2.8))

st.append(pair("f_lockring.jpg",
               "The area to focus on inside the bracket, circled. Getting light and a clear line of "
               "sight here makes the ring rotation much easier.",
               "f_lockring2.jpg",
               "The lock ring and spring assembly seated in the housing, viewed from above.", h=2.5))

st.append(Paragraph(
    "<b>If you unlock and relock the cylinder, verify it fully seats.</b> One installer traced a "
    "mirror that vibrated at speed back to a pivot that had play in it after being unlocked and "
    "relocked. Grab the finished mirror and try to rock it by hand before buttoning up the door.", warn))


# ============================== BRACKET ==============================
st.append(PageBreak())
st.append(Paragraph("9. Step 6 &mdash; Installing the Power-Fold Bracket", h1))
st.append(B(
    "The kit's bracket takes the place of the factory pivot, carrying its own fold motor and detent "
    "spring. Installation is the removal sequence in reverse, with the motor lead routed out to meet "
    "the harness."))

st.append(li("Confirm you have the correct side. The castings are marked; L and R are not interchangeable."))
st.append(li("Seat the new bracket into the mirror base and fit the pivot bolt and lock hardware."))
st.append(li("Compress the spring and rotate the lock ring back into its locked position \u2014 the reverse "
             "of Step 5."))
st.append(li("Route the fold motor's lead so it cannot chafe against the moving pivot, then out through "
             "the base towards the door."))
st.append(li("Refit the adjustment motor and reconnect the heater terminals to the glass."))

st.append(pair("20F8E842F9744DB8B593697B1D22A8DA.jpeg",
               "The new bracket assembled into the mirror base, its actuator visible at left and the "
               "mounting studs projecting through.",
               "F011A1DB5F6143BB8136ABA405917884.jpeg",
               "Housing open with the kit installed: the fold motor at left, the marked casting "
               "(DDZD-221-L) at right, and the motor lead routed across the top.", h=3.0))

st.append(Paragraph(
    "<b>Before you close the housing:</b> put the mirror back on the door, plug it in, and power-cycle "
    "the fold once. Discovering a mis-routed or pinched lead now costs minutes; discovering it after "
    "reassembly costs another teardown.", tip))

st.append(B(
    "Then refit the cover and clip the glass back on &mdash; press the backing plate onto the "
    "adjustment motor hub squarely until the centre clips snap home. Reconnect the heater terminals "
    "first."))

# ============================== WIRING ==============================
st.append(PageBreak())
st.append(Paragraph("10. Step 7 &mdash; Wiring and Controller Mounting", h1))
st.append(B(
    "This is the part of the job that surprises people by being easy. The harness piggybacks onto the "
    "factory door connector, so on a Sienna that already has power windows and power mirrors, nothing "
    "needs to be cut or spliced for the basic fold function."))

st.append(li("Feed the mirror-side harness through the sail-panel grommet into the door cavity."))
st.append(li("Unplug the factory door connector, insert the kit's piggyback connectors inline, and "
             "reseat both halves until they click."))
st.append(li("Connect the fold motor lead (the small black connector) to the mirror."))
st.append(li("Mount the controller module on a flat area of the door shell &mdash; Velcro pads or a zip "
             "tie both work &mdash; well clear of the window travel path."))
st.append(li("Dress all new wiring along the existing loom with zip ties. Check the window's full "
             "up-and-down travel by hand before reinstalling the panel."))

st.append(pair("f_rdoor_a.jpg",
               "Controller mounted inside the door with adhesive-backed Velcro \u2014 flat surface, clear "
               "of the window travel path, harness dressed alongside the factory loom.",
               "BC45070C37D3A08A4E5510C035B70BFF.jpg",
               "The connector detail worth double-checking: the circled green pin is the fold-signal "
               "position. A pin that is not fully home is a common cause of 'folding doesn't work'.",
               h=2.9))

st.append(Paragraph(
    "<b>Route away from the window.</b> The most avoidable failure on this install is a harness left "
    "where the glass can catch it. Run the window fully up and fully down before the door panel goes "
    "back on.", warn))

# ============================== SWITCH ==============================
st.append(PageBreak())
st.append(Paragraph("11. Step 8 &mdash; Switch Panel Swap", h1))
st.append(B(
    "The factory Sienna panel has no fold control, so the kit supplies a complete replacement trim "
    "assembly. Your existing window and lock switches transfer across into it."))

st.append(li("Compare the new panel with the original before removing anything &mdash; confirm the "
             "cut-outs match your trim level."))
st.append(li("Transfer the window switch bank, the lock switches, and the mirror selector into the new "
             "panel."))
st.append(li("Connect the panel's three leads per Figure 4: forward connector, green fold-signal lead, "
             "and rear connector."))
st.append(li("Test all functions before clipping the panel down: every window, both locks, mirror "
             "adjust, and fold."))

st.append(pair("2AF3C3A1CB1F48D2A40DF06FE2FEA097.jpeg",
               "New panel (left, with switches transferred) beside the empty replacement trim. The "
               "fold function lives in the selector knob rather than a separate button.",
               "755AD88FC62D4120939A6065415986C0.jpeg",
               "Installed and lit at night. Backlighting and switch feel match the factory panel "
               "closely.", h=3.0))

st.append(trio([
    ("f_sw_a.jpg", "Back of the switch panel, showing the connector block that carries over."),
    ("f_sw_b.jpg", "Front face of the replacement panel with the fold-capable selector."),
    ("f_sw_c.jpg", "Panel connectors plugged in during test-fit, before final seating."),
], h=2.3))

st.append(Paragraph(
    "<b>Trim colour is worth checking.</b> Installers have noted the replacement panel's finish does "
    "not always match every Sienna interior exactly. Hold it against your door in daylight before "
    "committing.", note))

# ============================== EXTRAS ==============================
st.append(PageBreak())
st.append(Paragraph("12. Step 9 &mdash; The Optional Extra-Features Wire", h1))
st.append(B(
    "The controller has one additional lead beyond what the fold function needs. Connected to the "
    "vehicle's window-control circuit, it enables a set of convenience behaviours that owners "
    "discovered after the fact &mdash; the kit's documentation does not explain it."))

st.append(Paragraph("What it reportedly enables", h2))
for t in ["All windows (and the moonroof, where fitted) roll up automatically when the vehicle is locked.",
          "One-touch auto up and down for all four door windows.",
          "Hazard lights flash when the vehicle is shifted to Park and a door is opened."]:
    st.append(li(t))

st.append(pair("f_extrawire.jpg",
               "The extra lead as it appears in the door, circled. It is a distinct connector, not "
               "part of the main plug-in harness.",
               "0CD25CF37BA9B22EA1CC5D0093E6C3DA.jpg",
               "Where the connection is made at the kick-panel side, using an insulated tap onto the "
               "window-control circuit.", h=3.0))

st.append(Paragraph(
    "<b>This step is genuinely optional and carries the most risk in the whole job.</b> Unlike the "
    "rest of the install, it involves tapping a factory circuit rather than plugging into it. If you "
    "are not certain which wire you are tapping on your specific vehicle and model year, leave this "
    "lead disconnected and insulated &mdash; the power-fold function works perfectly without it.", warn))

# ============================== OPERATION ==============================
st.append(PageBreak())
st.append(Paragraph("13. Operation and Testing", h1))

st.append(Paragraph(
    "<b>The single most important operating detail:</b> the mirror selector knob must be in its "
    "<b>centre</b> position for folding to work. Turned to L or R, the fold function is disabled by "
    "design. Many 'the folding stopped working' reports are simply a knob left off-centre.", note))

st.append(Paragraph("How it behaves", h2))
for t in ["Pull the control back towards the lock position &mdash; mirrors fold inboard.",
          "Push the control forward &mdash; mirrors return to the outboard driving position.",
          "With the selector centred, folding works consistently; there is no reported interference "
          "with Bluetooth or with locking and unlocking the van."]:
    st.append(li(t))

st.append(Paragraph("Test checklist before final reassembly", h2))
checks = [
    "Both mirrors fold fully in and return fully out, several cycles.",
    "Mirror angle adjustment still works on both sides, in all four directions.",
    "Heated mirror function works (check the element draws current, or verify defrost clears it).",
    "Blind-spot monitor indicator still illuminates normally, if fitted.",
    "Turn signal repeater in the mirror still works, if fitted.",
    "All four windows and both lock switches operate from the new panel.",
    "Grab each mirror head and rock it \u2014 no play, no rattle.",
    "Windows run fully up and down with no contact against new wiring.",
]
for c in checks:
    st.append(Paragraph(f"\u25a1 &nbsp;{c}", bullet))

# ============================== TROUBLE ==============================
st.append(PageBreak())
st.append(Paragraph("14. Troubleshooting", h1))

issues = [
    ("Folding works but mirror angle adjustment does not",
     "Reported after installing the aftermarket switch panel on one side only. The seller's position "
     "was that both sides need to be installed for the angle function to work correctly. Reinstalling "
     "the original switch restored angle control but lost folding, which points to the switch panel "
     "rather than the mirror. If you hit this, complete the second side before troubleshooting further."),
    ("Mirror vibrates at speed",
     "Usually the fold pivot not fully re-locked after the spring/lock-ring step, rather than a failed "
     "motor \u2014 one owner replaced the actuator entirely and still had the vibration. Grab the mirror "
     "assembly and try to rock it by hand; any play means going back into the housing and reseating "
     "the lock ring."),
    ("Folding does nothing at all",
     "Check the selector knob is centred first. Then check the inline connector pins are fully seated "
     "(see the connector photo in Step 7) and that the module's fuse is intact."),
    ("Heater or blind-spot function lost after the glass went back on",
     "The two small leads behind the glass pull off their tabs easily during removal. Take the glass "
     "back off and reseat both spade terminals."),
    ("Broken clips and cracked plastic",
     "Expect some. The cover clips and the adjustment-motor housing are the usual casualties. Work "
     "warm, work slowly, and photograph before disassembly so you know what a correct reassembly "
     "looks like."),
    ("Spring compressor stripped mid-job",
     "Documented more than once, and almost always a technique problem rather than a defective tool. "
     "Use the half-turn method in Step 5 \u2014 forcing the compression nut against a collar that is not "
     "ready to turn is what strips the threads. If yours is already stripped, stop: there is no "
     "aftermarket substitute for this tool, so contact the seller for a replacement."),
]
for t, d in issues:
    st.append(Paragraph(t, h3))
    st.append(B(d))

# ============================== SOURCES ==============================
st.append(PageBreak())
st.append(Paragraph("15. Sources and Further Reading", h1))
st.append(B(
    "The step sequence in this guide is written in the author's own words, based on the video "
    "walkthrough and the installer accounts in the threads below. If a detail here does not match "
    "what you have in hand, the threads are the place to ask &mdash; several of the people who did "
    "these installs still answer questions."))

st.append(Paragraph("Video", h2))
st.append(url("Kit installation walkthrough \u2014 full teardown and reassembly", VIDEO))

st.append(Paragraph("Community threads", h2))
for label, u in [
    ("Main thread &mdash; \"Power Folding Side Mirror + Extra features\"", MAIN),
    ("Page 2 &mdash; kit sourcing and video reference", MAIN + "page-2"),
    ("Page 4 &mdash; door wiring photos, switch panel swap, connector detail", MAIN + "page-4"),
    ("Page 5 &mdash; mirror glass removal, OEM part numbers", MAIN + "page-5"),
    ("Page 6 &mdash; vibration and angle-adjustment issue reports", MAIN + "page-6"),
    ("Page 8 &mdash; spring and lock-ring release explanation", MAIN + "page-8"),
    ("Companion thread &mdash; \"a quest to find a complete guide for a newbie\"",
     "https://www.siennachat.com/threads/power-folding-mirrors-a-quest-to-find-a-complete-guide-for-a-newbie.71100/"),
    ("Toyota Nation &mdash; \"Power Folding Mirror Installation\"",
     "https://www.toyotanation.com/threads/power-folding-mirror-installation.1713897/"),
    ("Toyota Nation &mdash; \"DIY: Power Folding Mirrors\"",
     "https://www.toyotanation.com/threads/diy-power-folding-mirrors.1723392/"),
]:
    st.append(url(label, u))

st.append(Spacer(1, 14))
st.append(HRFlowable(width="100%", thickness=0.5, color=colors.HexColor('#cccccc'), spaceAfter=8))
st.append(Paragraph(
    "Prepared as a personal reference document. The text summarises and paraphrases publicly posted "
    "community discussion and a publicly posted video; photographs and the manufacturer figures were "
    "supplied by the document owner. This is not an official publication of Toyota or of any kit "
    "manufacturer or seller. Wiring, switch behaviour, and included parts vary between sellers of "
    "similar kits &mdash; verify every step against your own kit and vehicle before relying on it.", small))


# ============================== PAGE FURNITURE ==============================
def deco(canvas, doc):
    canvas.saveState()
    canvas.setFont('Helvetica', 8)
    canvas.setFillColor(colors.HexColor('#888888'))
    if doc.page > 1:
        canvas.drawString(0.75 * inch, 0.5 * inch,
                          "Sienna Power-Folding Mirror Retrofit \u2014 Installation Guide")
        canvas.drawRightString(letter[0] - 0.75 * inch, 0.5 * inch, str(doc.page))
        canvas.setStrokeColor(colors.HexColor('#dddddd'))
        canvas.setLineWidth(0.4)
        canvas.line(0.75 * inch, 0.66 * inch, letter[0] - 0.75 * inch, 0.66 * inch)
    canvas.restoreState()


doc = SimpleDocTemplate(OUT, pagesize=letter,
                        topMargin=0.7 * inch, bottomMargin=0.85 * inch,
                        leftMargin=0.75 * inch, rightMargin=0.75 * inch,
                        title="Toyota Sienna Power-Folding Mirror Retrofit - Installation Guide",
                        author="Personal reference document")
os.makedirs(os.path.dirname(OUT), exist_ok=True)
doc.build(st, onFirstPage=deco, onLaterPages=deco)
print("built", OUT)
