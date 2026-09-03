// ============================================================
// Plywood cutting layout — what to ask Home Depot to cut (Section 3)
// ============================================================
// Every cut here is a STRAIGHT, full-width or full-length cut, in an
// order a store panel saw can actually follow. The point is to come home
// with rectangles instead of sheets: the only cuts left for the shop are
// the shaped one (the anchor board's comb) and the narrow strips.
//
// TWO POLICIES BAKED INTO THIS SHEET:
//
//  1. TRIM ALL FOUR FACTORY EDGES ~1/2" FIRST (cuts T1-T4 on every
//     sheet). Factory edges are chipped, out of square and often not
//     straight; every part cut off them inherits that. Trimming first
//     means every subsequent cut references a known-straight edge.
//     Usable size after trimming is 47 x 95 — every part below is
//     checked against THAT, not 48.
//
//  2. THERE IS NO 3/8" PURCHASE AT ALL (owner, Aug 2026). The four parts
//     that used to be 3/8" now come out of the two sheets already being
//     bought: Panel C's front wall and the fridge tray from the 1/2"
//     sheet's big 47x44 leftover, and the battery drawer's 4 walls from
//     the 3/4" sheet — 1 side + 1 front out of its 47x19 strip, the
//     other 2 out of the anchor board's own comb gaps. Two sheets, two
//     columns. (History: the plan called for a 3/8" HALF sheet, which
//     was 2 sq ft short of the 18.0 sq ft of parts; that was corrected
//     to two 4x4 handy panels, and then deleted outright when the
//     leftovers turned out to cover it.)
//
// Store cuts are numbered S1, S2... in the order they must be made, and
// drawn HEAVY RED. Trim cuts are T. Shop-only cuts are dashed.
//
// Render with: openscad -o renders/sheet-cut-layout.svg sheet_cut_layout.scad
// ============================================================
// LEGIBILITY (Aug 2026): 2 prose line(s) moved out of this
// sheet into the document, and every text size scaled x1.0. Those
// sentences were setting the sheet's width, and a figure's printed
// text height is size x (page_width / sheet_width) — so they were
// holding every other label on the sheet down to 3-6pt on paper.
// Keep prose in the markdown; this sheet carries geometry and short
// labels only.

include <params.scad>
include <van_plan.scad>   // also pulls in sheet2d.scad

// Two sheets, side by side, one row. (History: four sheets across took
// this figure to 227 units wide and every label to ~4.7pt on paper; a
// 2x2 grid halved that; deleting the 3/8" buy removed the bottom row.)
// That halves the sheet's height, and since a figure's printed text
// height is size x (page_width / sheet_width), dropping the unused row
// buys every label on this page real size on paper.
// ONLY selects what this file draws:
//   -1 = both sheets side by side (the figure in Section 3)
//    0 = the 3/4" sheet alone, big, with its cut key beside it
//    1 = the 1/2" sheet alone, same
// The single-sheet variants are the STORE COPY pages in Appendix H — one
// sheet per page at ~2.2x the combined scale, so a label that prints at
// ~5pt on the 2-up figure prints at ~11pt at the saw. Set on the command
// line: openscad -D ONLY=0 -o renders/sheet-cut-1.svg sheet_cut_layout.scad
ONLY = -1;
SOLO = (ONLY >= 0);

// A solo sheet is 47x95 -> 1:2.02, which is far taller than a page. The
// cut key printed to its right brings the whole figure to ~1:1.1, so it
// fills a portrait page instead of overflowing it.
SW = SOLO ? 150 : 112;
SH = SOLO ? 158 : 104;   // header block sits above the sheet titles
K  = SOLO ? 1.35 : 0.62; // sheet units per plywood inch

// column origins: 3/4", 1/2" (a solo sheet always draws at the left)
COLX = SOLO ? [8, 8] : [8, 66];
COLY = SOLO ? [8, 8] : [8, 8];

// text sizes scale with the drawing
TS_NAME = SOLO ? 3.4 : 2.0;   // part name
TS_SIZE = SOLO ? 3.0 : 2.1;   // part dimensions / spare labels
TS_CUT  = SOLO ? 3.0 : 2.1;   // cut badge number
TS_TTL  = SOLO ? 4.2 : 2.5;   // sheet title
BADGE_R = SOLO ? 3.4 : 2.2;

function cx(col, x) = COLX[col] + x * K;
function cy(col, y) = COLY[col] + y * K;

// ---- one part rectangle with its label ------------------------
module part(col, x, y, w, h, name, size) {
    color(GRY) rect_ol(cx(col, x), cy(col, y), w * K, h * K, MED);
    // Anything under ~7" wide cannot carry a two-line label at this
    // scale without printing over its neighbour — those get a short
    // code and are spelled out in the key beneath the column.
    if (w >= 7) {
        txt(name, cx(col, x) + 1.2, cy(col, y + h) - TS_NAME * 1.5, TS_NAME, "left", "Black");
        txt(size, cx(col, x) + 1.2, cy(col, y + h) - TS_NAME * 1.5 - TS_SIZE * 1.15, TS_SIZE, "left", GRY);
    } else {
        }
}
// leftover area, hatched-free but marked
module spare(col, x, y, w, h, label) {
    color("Black") dash_rect(cx(col, x), cy(col, y), w * K, h * K, THIN);
    txt(label, cx(col, x) + 1.2, cy(col, y) + TS_SIZE * 1.05, TS_SIZE, "left", GRY);
}
// a numbered store cut: dir "x" = a rip along the length, "y" = a crosscut
module scut(col, n, dir, at, from, to) {
    if (dir == "y")
        color(RED) translate([cx(col, from), cy(col, at) - 0.45]) square([(to - from) * K, 0.9]);
    else
        color(RED) translate([cx(col, at) - 0.45, cy(col, from)]) square([0.9, (to - from) * K]);
    bx = (dir == "y") ? cx(col, to) + BADGE_R * 1.2 : cx(col, at);
    by = (dir == "y") ? cy(col, at) : cy(col, to) + BADGE_R * 1.2;
    color(RED) translate([bx, by]) circle(r = BADGE_R, $fn = 32);
    txt(n, bx, by - 0.2, TS_CUT, "center", "White");
}

module sheet_block(col, title, sub, w, h) {
    // the raw sheet, and the trim margin inside it
    color("Black") rect_ol(cx(col, -0.5), cy(col, -0.5), (w + 1) * K, (h + 1) * K, MED);
    color("Black") dash_rect(cx(col, 0), cy(col, 0), w * K, h * K, THIN);
    // Titles used to be STAGGERED in y by column, back when they were
    // long enough to overprint each other. They aren't anymore, and the
    // stagger was landing the 1/2" title on top of its own S5 badge —
    // so both columns now sit on one line, clear of the badges.
    ty = cy(col, h) + (SOLO ? 13 : 9.5);
    txt(title, COLX[col], ty, TS_TTL, "left", "Black");
    txt(sub, COLX[col], ty - TS_TTL * 1.1, TS_SIZE, "left", GRY);
}

// ============================================================
module sheet_A(col) {
    // ---------------- 3/4" full sheet ------------------------
    // Now also carries all 4 battery-drawer walls (3/8" buy deleted):
    // 1 side + 1 front out of the 47x19 bottom strip, the other 2 out
    // of the anchor board's comb gaps once the comb is cut.
    sheet_block(col, "3/4\" — one 4x8", "deck + anchor board + walls", 47, 95);
    part(col, 0, 62, 46, 33, "ANCHOR BOARD blank", "46 x 33 — face grain along the 33\"");
    // the comb's two gaps, drawn where they fall out of the blank
    spare(col, 2.5, 68, 16.85, 27, "");
    spare(col, 24, 68, 20.5, 27, "");
    txt("gap A", cx(col, 2.5) + 1.2, cy(col, 74), 2.1, "left", GRY);
    txt("gap B", cx(col, 24) + 1.2, cy(col, 74), 2.1, "left", GRY);
    part(col, 0, 19, 33, 43, "PANEL C DECK", "33 x 43");
    spare(col, 33, 19, 14, 43, "-> bearer cleats");
    // the side wall's length IS drawer_depth — it came down 25 -> 22 when
    // the lapped legs narrowed Panel A's bay, so it is read from the
    // parameter now instead of being a literal that can go stale
    part(col, 0, 4.5, drawer_depth, 14.5, "BATT SIDE", str(drawer_depth, " x 14.5"));
    part(col, drawer_depth, 4.5, drawer_travel, 14.5, "BATT FRONT", str(drawer_travel, " x 14.5"));
    spare(col, 0, 0, 47, 4.5, "-> pantry cleats");
    scut(col, "S1", "y", 62, 0, 47);
    scut(col, "S2", "y", 19, 0, 47);
    scut(col, "S3", "x", 46, 62, 95);
    scut(col, "S4", "x", 33, 19, 62);
}

module sheet_B(col) {
    // ---------------- 1/2" full sheet ------------------------
    // Now also carries Panel C's front wall and the fridge tray, out of
    // what used to be logged as "spare (most of the sheet)".
    sheet_block(col, "1/2\" — one 4x8", "k-drawer, wall, tray", 47, 95);
    part(col, 0, 69, 18, 26, "K-DRAWER BOTTOM", "18 x 26");
    part(col, 18, 69, 5.45, 26, "", "");
    part(col, 23.45, 69, 5.45, 26, "", "");
    part(col, 28.9, 69, 4, 26, "", "");
    part(col, 32.9, 69, 4, 26, "", "");
    part(col, 36.9, 78, 4, 17, "", "");
    part(col, 40.9, 78, 4, 17, "", "");
    part(col, 0, 44, 20, 25, "BATT BOTTOM", "20 x 25");
    spare(col, 20, 44, 27, 25, "spare");
    part(col, 0, 27, 46, 17, "PANEL C FRONT WALL", "46 x 17");
    part(col, 0, 9, 29, 18, "FRIDGE TRAY", "29 x 18 blank");
    spare(col, 29, 9, 18, 18, "spare");
    spare(col, 0, 0, 47, 9, "spare");
    scut(col, "S1", "y", 69, 0, 47);
    scut(col, "S2", "y", 44, 0, 47);
    scut(col, "S3", "y", 27, 0, 47);
    scut(col, "S4", "y", 9, 0, 47);
    scut(col, "S5", "x", 18, 69, 95);
    scut(col, "S6", "x", 20, 44, 69);
    scut(col, "S7", "x", 46, 27, 44);
    scut(col, "S8", "x", 29, 9, 27);
    // the narrow-strip key for this column is Section 3 prose now — it was
    // outside any column scope here, so it also broke cy()'s new signature
}

// ---- the numbered cut list, printed beside a solo sheet ----------------
// This is what makes the solo figure usable on its own at the saw: the
// drawing shows WHERE, this shows IN WHAT ORDER. Kept to short lines —
// the same width rule as the header (see sheet()).
KEY_A = [
    "T1-T4  trim ~1/2\" off all 4 factory edges",
    "S1  crosscut 33\" off one end",
    "S2  crosscut 43\" off what's left",
    "S3  rip the 47x33 piece to 46\" wide",
    "      = ANCHOR BOARD blank 46 x 33",
    "S4  rip the 47x43 piece to 33\" wide",
    "      = PANEL C DECK, cut 1/8\" OVER",
    "",
    "KEEP: the 14x43 and 47x19 offcuts",
    "(cleats + 2 drawer walls, shop cuts)",
];
KEY_B = [
    "T1-T4  trim ~1/2\" off all 4 factory edges",
    "S1  crosscut 26\" off one end",
    "S2  crosscut 25\" off what's left",
    "S3  crosscut 17\" off what's left",
    "S4  crosscut 18\" off what's left",
    "S5  rip the 47x26 piece to 18\" wide",
    "      = KITCHEN DRAWER BOTTOM",
    "      KEEP the 29x26 - do not cut it",
    "S6  rip the 47x25 piece to 20\" wide",
    "      = BATTERY DRAWER BOTTOM",
    "S7  rip the 47x17 piece to 46\" wide",
    "      = FRONT WALL, cut 1/8\" OVER",
    "S8  rip the 47x18 piece to 29\" wide",
    "      = FRIDGE TRAY blank, oversize",
];

module cut_key(lines_, x, y) {
    txt("CUT ORDER", x, y, 4.2, "left", "Black");
    for (i = [0 : len(lines_) - 1])
        txt(lines_[i], x, y - 8 - i * 5.2, 3.0, "left", "Black");
    // legend, parked low enough to clear the longer of the two key lists
    txt("RED = store cut, in the order listed.", x, 30, 3.0, "left", GRY);
    txt("Dashed line = sheet after trimming.", x, 25, 3.0, "left", GRY);
    txt("Where it says OVER: cut ~1/8\" big.", x, 20, 3.0, "left", RED);
}

module sheets() {
    if (ONLY == 0) { sheet_A(0); cut_key(KEY_A, 78, 118); }
    else if (ONLY == 1) { sheet_B(0); cut_key(KEY_B, 78, 118); }
    else { sheet_A(0); sheet_B(1); }
}

// The two note blocks that used to sit here ("what to say at the saw"
// and "still a shop cut") are Section 3 prose — they were also part of
// what made this sheet 227 units wide.

module sheet() {
    color("Black") rect_ol(0, 0, SW, SH, 0.5);
    // Every line here is kept under ~50 characters ON PURPOSE. Measured
    // in this font, an advance is ~0.85 x the text size, so the old
    // 47-character title alone ran to x=141 — 29 units past the frame —
    // and since printed text height is size x (page_width / sheet_width),
    // that one line was shrinking every label on the page by ~26%.
    if (!SOLO) {
        txt("PLYWOOD CUTTING LAYOUT", 6, 99, 3.4, "left", "Black");
        txt("Bring this page to the panel saw.", 6, 94.5, 2.2, "left", GRY);
        txt("RED = a numbered store cut, in order.", 6, 91.5, 2.2, "left", GRY);
        txt("Dashed inner line = the sheet after trimming.", 6, 88.5, 2.2, "left", GRY);
        txt("CHANGED Aug 2026: NO 3/8\" SHEET IS BOUGHT.", 6, 84.5, 2.2, "left", RED);
        txt("Its 4 parts come from these 2 sheets' leftovers.", 6, 81.5, 2.2, "left", RED);
    }
    sheets();
}

sheet();
