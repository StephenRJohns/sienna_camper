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
//     Usable size after trimming is 47 x 95 (full sheet) or 47 x 47
//     (handy panel) — every part below is checked against THAT, not 48.
//
//  2. THE 3/8" MATERIAL IS *TWO 4x4 HANDY PANELS*, NOT A HALF SHEET.
//     The plan used to call for "a 3/8" half-sheet, ~18 sq ft, so a half
//     4x8 covers it" — but half a 4x8 is 16 sq ft, so the four parts
//     never fitted. Two handy panels (32 sq ft) do, they trim to 47x47,
//     and they fit in a car. See the note band at the bottom.
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

// 2x2 grid, not 4 across: four columns took the sheet to 227 units wide,
// and a figure's printed text height is size x (page_width / sheet_width),
// so every label sat at ~4.7pt. Two columns halves the width.
SW = 125;
SH = 152;   // room for the header above the top row of sheets
K = 0.62;                 // sheet units per plywood inch

// column origins: 3/4", 1/2", 3/8" panel 1, 3/8" panel 2
COLX = [8, 66, 8, 66];
COLY = [64, 64, 8, 8];    // bottom of each sheet drawing: full sheets up, handy panels down

function cx(col, x) = COLX[col] + x * K;
function cy(col, y) = COLY[col] + y * K;

// ---- one part rectangle with its label ------------------------
module part(col, x, y, w, h, name, size) {
    color(GRY) rect_ol(cx(col, x), cy(col, y), w * K, h * K, MED);
    // Anything under ~7" wide cannot carry a two-line label at this
    // scale without printing over its neighbour — those get a short
    // code and are spelled out in the key beneath the column.
    if (w >= 7) {
        txt(name, cx(col, x) + 1.2, cy(col, y + h) - 3.0, 2.0, "left", "Black");
        txt(size, cx(col, x) + 1.2, cy(col, y + h) - 5.4, 2.1, "left", GRY);
    } else {
        }
}
// leftover area, hatched-free but marked
module spare(col, x, y, w, h, label) {
    color("Black") dash_rect(cx(col, x), cy(col, y), w * K, h * K, THIN);
    txt(label, cx(col, x) + 1.2, cy(col, y) + 2.2, 2.1, "left", GRY);
}
// a numbered store cut: dir "x" = a rip along the length, "y" = a crosscut
module scut(col, n, dir, at, from, to) {
    if (dir == "y")
        color(RED) translate([cx(col, from), cy(col, at) - 0.45]) square([(to - from) * K, 0.9]);
    else
        color(RED) translate([cx(col, at) - 0.45, cy(col, from)]) square([0.9, (to - from) * K]);
    bx = (dir == "y") ? cx(col, to) + 2.6 : cx(col, at);
    by = (dir == "y") ? cy(col, at) : cy(col, to) + 2.6;
    color(RED) translate([bx, by]) circle(r = 2.2, $fn = 24);
    txt(n, bx, by - 0.2, 2.1, "center", "White");
}

module sheet_block(col, title, sub, w, h) {
    // the raw sheet, and the trim margin inside it
    color("Black") rect_ol(cx(col, -0.5), cy(col, -0.5), (w + 1) * K, (h + 1) * K, MED);
    color("Black") dash_rect(cx(col, 0), cy(col, 0), w * K, h * K, THIN);
    // Titles are STAGGERED in y by column: at 29 units wide per sheet
    // and ~45 wide per title, neighbouring titles would otherwise
    // overprint each other.
    ty = cy(col, h) + ((col % 2 == 0) ? 9.5 : 4.5);
    txt(title, COLX[col], ty, 2.5, "left", "Black");
    txt(sub, COLX[col], ty - 2.6, 2.1, "left", GRY);
}

// ============================================================
module sheets() {
    // ---------------- 3/4" full sheet ------------------------
    sheet_block(0, "3/4\" — one 4x8", "deck + anchor board blank", 47, 95);
    part(0, 0, 62, 46, 33, "ANCHOR BOARD blank", "46 x 33 — face grain along the 33\"");
    part(0, 0, 19, 33, 43, "PANEL C DECK", "33 x 43");
    spare(0, 33, 19, 14, 43, "-> deck bearer cleats");
    spare(0, 0, 0, 47, 19, "-> pantry cleats + spare");
    scut(0, "S1", "y", 62, 0, 47);
    scut(0, "S2", "y", 19, 0, 47);
    scut(0, "S3", "x", 46, 62, 95);
    scut(0, "S4", "x", 33, 19, 62);

    // ---------------- 1/2" full sheet ------------------------
    sheet_block(1, "1/2\" — one 4x8", "kitchen drawer + battery bottom", 47, 95);
    part(1, 0, 69, 18, 26, "K-DRAWER BOTTOM", "18 x 26");
    part(1, 18, 69, 5.45, 26, "", "");
    part(1, 23.45, 69, 5.45, 26, "", "");
    part(1, 28.9, 69, 4, 26, "", "");
    part(1, 32.9, 69, 4, 26, "", "");
    part(1, 36.9, 78, 4, 17, "", "");
    part(1, 40.9, 78, 4, 17, "", "");
    part(1, 0, 44, 20, 25, "BATTERY DRAWER BOTTOM", "20 x 25");
    spare(1, 0, 0, 47, 44, "spare (most of the sheet)");
    scut(1, "S1", "y", 69, 0, 47);
    scut(1, "S2", "y", 44, 0, 47);
    scut(1, "S3", "x", 18, 69, 95);
    scut(1, "S4", "x", 20, 44, 69);
    // the narrow-strip key for this column is Section 3 prose now — it was
    // outside any column scope here, so it also broke cy()'s new signature

    // ---------------- 3/8" handy panel 1 ---------------------
    sheet_block(2, "3/8\" — panel 1 of 2", "front wall + drawer sides", 47, 47);
    part(2, 0, 30, 46, 17, "PANEL C FRONT WALL", "46 x 17");
    part(2, 0, 15, 25, 14.5, "BATT DRAWER SIDE", "25 x 14.5");
    part(2, 0, 0, 25, 14.5, "BATT DRAWER SIDE", "25 x 14.5");
    spare(2, 25, 0, 22, 29.5, "spare");
    scut(2, "S1", "y", 30, 0, 47);
    scut(2, "S2", "y", 15, 0, 47);
    scut(2, "S3", "x", 25, 0, 30);

    // ---------------- 3/8" handy panel 2 ---------------------
    sheet_block(3, "3/8\" — panel 2 of 2", "fridge tray + front/back", 47, 47);
    part(3, 0, 16, 18, 29, "FRIDGE TRAY", "17.72 x 28.74 — cut oversize, trim to fit");
    part(3, 0, 0, 20, 14.5, "BATT FRONT", "20 x 14.5");
    part(3, 20, 0, 20, 14.5, "BATT BACK", "20 x 14.5");
    spare(3, 18, 16, 29, 29, "spare");
    scut(3, "S1", "y", 16, 0, 47);
    scut(3, "S2", "x", 18, 16, 47);
    scut(3, "S3", "x", 20, 0, 16);
}

// The two note blocks that used to sit here ("what to say at the saw"
// and "still a shop cut") are Section 3 prose — they were also part of
// what made this sheet 227 units wide.

module sheet() {
    color("Black") rect_ol(0, 0, SW, SH, 0.5);
    txt("PLYWOOD CUTTING LAYOUT — STORE CUTS vs SHOP CUTS", 6, 146, 3.4, "left", "Black");
    txt("Bring this to the panel saw. Dashed inner line = the sheet after its", 6, 141.5, 2.2, "left", GRY);
    txt("factory edges come off; RED = a numbered store cut, in order.", 6, 138.5, 2.2, "left", GRY);
    txt("CHANGED Aug 2026: the 3/8\" material is TWO 4x4 handy panels, not one", 6, 134.5, 2.2, "left", RED);
    txt("half sheet — the four 3/8\" parts total 18.0 sq ft, half a 4x8 is 16.0.", 6, 131.5, 2.2, "left", RED);
    sheets();
}

sheet();
