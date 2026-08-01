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

include <params.scad>
include <van_plan.scad>   // also pulls in sheet2d.scad

SW = 210;
SH = 150;
K = 0.62;                 // sheet units per plywood inch

// column origins: 3/4", 1/2", 3/8" panel 1, 3/8" panel 2
COLX = [8, 58, 108, 158];
COLY = 34;                // bottom of every sheet drawing

function cx(col, x) = COLX[col] + x * K;
function cy(y) = COLY + y * K;

// ---- one part rectangle with its label ------------------------
module part(col, x, y, w, h, name, size) {
    color(GRY) rect_ol(cx(col, x), cy(y), w * K, h * K, MED);
    // Anything under ~7" wide cannot carry a two-line label at this
    // scale without printing over its neighbour — those get a short
    // code and are spelled out in the key beneath the column.
    if (w >= 7) {
        txt(name, cx(col, x) + 1.2, cy(y + h) - 3.0, 2.0, "left", "Black");
        txt(size, cx(col, x) + 1.2, cy(y + h) - 5.4, 1.8, "left", GRY);
    } else {
        }
}
// leftover area, hatched-free but marked
module spare(col, x, y, w, h, label) {
    color("Black") dash_rect(cx(col, x), cy(y), w * K, h * K, THIN);
    txt(label, cx(col, x) + 1.2, cy(y) + 2.2, 1.7, "left", GRY);
}
// a numbered store cut: dir "x" = a rip along the length, "y" = a crosscut
module scut(col, n, dir, at, from, to) {
    if (dir == "y")
        color(RED) translate([cx(col, from), cy(at) - 0.45]) square([(to - from) * K, 0.9]);
    else
        color(RED) translate([cx(col, at) - 0.45, cy(from)]) square([0.9, (to - from) * K]);
    bx = (dir == "y") ? cx(col, to) + 2.6 : cx(col, at);
    by = (dir == "y") ? cy(at) : cy(to) + 2.6;
    color(RED) translate([bx, by]) circle(r = 2.2, $fn = 24);
    txt(n, bx, by - 0.2, 2.1, "center", "White");
}

module sheet_block(col, title, sub, w, h) {
    // the raw sheet, and the trim margin inside it
    color("Black") rect_ol(cx(col, -0.5), cy(-0.5), (w + 1) * K, (h + 1) * K, MED);
    color("Black") dash_rect(cx(col, 0), cy(0), w * K, h * K, THIN);
    // Titles are STAGGERED in y by column: at 29 units wide per sheet
    // and ~45 wide per title, neighbouring titles would otherwise
    // overprint each other.
    ty = cy(h) + ((col % 2 == 0) ? 9.5 : 4.5);
    txt(title, COLX[col], ty, 2.5, "left", "Black");
    txt(sub, COLX[col], ty - 2.6, 1.8, "left", GRY);
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
    part(1, 0, 69, 16, 26, "K-DRAWER BOTTOM", "16 x 26");
    part(1, 16, 69, 5.45, 26, "C1", "");
    part(1, 21.45, 69, 5.45, 26, "C2", "");
    part(1, 26.9, 69, 4, 26, "S1", "");
    part(1, 30.9, 69, 4, 26, "S2", "");
    part(1, 34.9, 80, 4, 15, "F", "");
    part(1, 38.9, 80, 4, 15, "B", "");
    part(1, 0, 44, 20, 25, "BATTERY DRAWER BOTTOM", "20 x 25");
    spare(1, 0, 0, 47, 44, "spare (most of the sheet)");
    scut(1, "S1", "y", 69, 0, 47);
    scut(1, "S2", "y", 44, 0, 47);
    scut(1, "S3", "x", 16, 69, 95);
    scut(1, "S4", "x", 20, 44, 69);
    // key for this column's narrow strips
    txt("left to right after S3: 2 cheeks 5.45 x 26, 2 sides 4 x 26,", COLX[1], cy(-0.5) - 3.0, 1.8, "left", GRY);
    txt("then front + back 4 x 15 (upper strip)", COLX[1], cy(-0.5) - 5.4, 1.8, "left", GRY);

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

// ============================================================
module notes() {
    txt("WHAT TO SAY AT THE SAW", 8, 23, 2.9, "left", "Black");
    lines = [
      "1.  \"Trim about 1/2 inch off all four edges of each sheet first.\"   (cuts T1-T4)",
      "2.  Then the numbered cuts IN ORDER: crosscuts before rips. A crosscut on a full",
      "     sheet is easier to hold straight, and it makes each following piece handleable.",
      "3.  Ask ~1/8\" OVERSIZE on parts that must end up exact — store saws hold about +/-1/8\".",
      "     Trim those at home: the deck, the front wall and the fridge tray are the ones that matter.",
      "4.  If they will not rip under ~4\", bring the cheeks and sides home as one wide strip",
      "     and rip them yourself — easy fence cuts once the sheet is already broken down.",
    ];
    for (i = [0 : len(lines) - 1])
        txt(lines[i], 8, 18.5 - i * 3.1, 2.05, "left", "Black");

    txt("STILL A SHOP CUT (do NOT ask the store):", 150, 23, 2.4, "left", RED);
    shop = ["- the anchor board's COMB outline (jigsaw, from the 46 x 33 blank)",
            "- the 3/4 x 3/4 deck bearer cleats and the pantry cleats",
            "- the fridge tray's final trim to 17.72 x 28.74",
            "- every hole: fan, grommets, finger holes"];
    for (i = [0 : len(shop) - 1])
        txt(shop[i], 150, 18.5 - i * 3.1, 1.8, "left", RED);
}

module sheet() {
    color("Black") rect_ol(0, 0, SW, SH, 0.5);
    txt("PLYWOOD CUTTING LAYOUT — STORE CUTS vs SHOP CUTS", 6, SH - 8, 3.5, "left", "Black");
    txt("Bring this page to the panel saw. Dashed inner line = the sheet after its factory edges are trimmed off; RED = a numbered store cut.",
        6, SH - 13, 2.4, "left", GRY);
    txt("CHANGED Aug 2026: the 3/8\" material is now TWO 4x4 handy panels, not one half sheet — the four 3/8\" parts total 18.0 sq ft and half a 4x8 is only 16.0.",
        6, SH - 17.5, 2.4, "left", RED);
    sheets();
    notes();
}

sheet();
