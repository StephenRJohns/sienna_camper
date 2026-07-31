// ============================================================
// Rear-floor survey (F1-F8) — per-row KEY MAPS, overhead (2D)
// ============================================================
// One small thumbnail per row of the "what does the anchor board sit
// on and strap to?" survey table (Section 0). Each map is the SAME
// base floorplan of the rear cargo zone, with only the thing that row
// asks you to measure picked out in RED — so the eight read as a set
// at thumbnail size, and the row's own text carries the wording.
//
// These are ~1in wide in the PDF, so there is deliberately NO text
// inside them: base geography in thin black/gray, measurement in
// heavy red. The legend above the table decodes the symbols once.
//
// Datum matches the table and the rest of Section 0: Y = 0 at the
// CLOSED HATCH, +Y forward; X = 0 at the DRIVER side. Every forward
// feature (well, striker row, rail ends) is ASSUMED until the survey
// itself is done — that is the whole point of the table — so they are
// drawn dashed.
//
// Render with: openscad -o renders/survey-f1.svg -D key=1 floor_survey_keys.scad
//   key = 1..8  ->  F1..F8
// ============================================================

include <params.scad>

key = 1;

W  = panel_width;      // 46 — floor width across the zone
D  = 52;               // survey zone depth, hatch -> forward of the striker row
PC = panel_c_length;   // 36 — Panel C's footprint depth

// ASSUMED forward geography (this is what F2/F4/F7/F8 go and measure)
well_y0 = 8;   well_y1 = 30;  well_x0 = 3;  well_x1 = 43;
striker_y = 48;  striker_x = [8, 23, 38];
railend_y = 44;  rail_x = [15, 30];
step_y = 46;

THIN = 0.30;
HEAVY = 0.95;
RED = "Firebrick";

// ---- helpers -------------------------------------------------
module rect_ol(x0, y0, w, l, s = THIN) {
    difference() {
        translate([x0, y0]) square([w, l]);
        translate([x0 + s, y0 + s]) square([w - 2*s, l - 2*s]);
    }
}

module dash_h(y, x0, x1, s = THIN, seg = 2.2) {
    for (x = [x0 : seg * 1.8 : x1 - seg * 0.5])
        translate([x, y]) square([min(seg, x1 - x), s]);
}

module dash_v(x, y0, y1, s = THIN, seg = 2.2) {
    for (y = [y0 : seg * 1.8 : y1 - seg * 0.5])
        translate([x, y]) square([s, min(seg, y1 - y)]);
}

module dash_rect(x0, y0, w, l, s = THIN) {
    dash_h(y0, x0, x0 + w, s); dash_h(y0 + l - s, x0, x0 + w, s);
    dash_v(x0, y0, y0 + l, s); dash_v(x0 + w - s, y0, y0 + l, s);
}

// double-headed fore-aft dimension arrow
module arrow_v(x, y0, y1, s = HEAVY, head = 2.0) {
    translate([x - s/2, y0]) square([s, y1 - y0]);
    translate([x, y0]) polygon([[0, 0], [-head*0.7, head], [head*0.7, head]]);
    translate([x, y1]) polygon([[0, 0], [-head*0.7, -head], [head*0.7, -head]]);
}

// double-headed lateral dimension arrow
module arrow_h(y, x0, x1, s = HEAVY, head = 2.0) {
    translate([x0, y - s/2]) square([x1 - x0, s]);
    translate([x0, y]) polygon([[0, 0], [head, head*0.7], [head, -head*0.7]]);
    translate([x1, y]) polygon([[0, 0], [-head, head*0.7], [-head, -head*0.7]]);
}

module loop(x, y, r = 1.5, s = 0.5) {
    difference() { translate([x, y]) circle(r = r, $fn = 24); translate([x, y]) circle(r = r - s, $fn = 24); }
}

// ---- the shared base map -------------------------------------
module base() {
    color("Black") {
        rect_ol(0, 0, W, D, THIN);            // the zone's outer floor
        translate([0, 0]) square([W, 1.1]);   // CLOSED HATCH = the Y datum, heavy
    }
    color("Gray") {
        dash_rect(0, 0, W, PC, THIN);         // Panel C's footprint
        dash_rect(well_x0, well_y0, well_x1 - well_x0, well_y1 - well_y0, THIN);  // the well (assumed)
        dash_h(striker_y, 0, W, THIN);        // the striker row (assumed)
        for (sx = striker_x) loop(sx, striker_y, 1.5, 0.45);
        for (rx = rail_x) {                   // 2nd-row rail rear ends (assumed)
            translate([rx - 0.9, railend_y]) square([1.8, 0.35]);
            dash_v(rx - 0.15, railend_y, D, THIN);
        }
    }
}

// ---- F1: map the load surface into its three zones -----------
module f1() {
    color(RED) {
        rect_ol(0, 0, W, PC, HEAVY);
        dash_h(well_y0, 0, W, HEAVY);         // where the well starts
        dash_h(well_y1, 0, W, HEAVY);         // where it ends
        // three surface textures across the footprint: solid pan / well /
        // seatback — clipped to the footprint so none of it escapes
        intersection() {
            translate([1, 1]) square([W - 2, PC - 2]);
            union() {
                for (x = [2 : 5 : W - 2]) translate([x, 3.5]) circle(r = 0.6, $fn = 12);
                for (x = [2 : 5 : W - 2]) for (y = [12 : 6 : well_y1 - 3]) translate([x, y]) square([2.4, 0.5]);
                for (x = [-6 : 5 : W]) translate([x, well_y1 + 1]) rotate(35) square([9, 0.5]);
            }
        }
    }
}

// ---- F2: fore-aft position of the well's two edges -----------
module f2() {
    color(RED) {
        dash_h(well_y0, well_x0, well_x1, HEAVY);
        dash_h(well_y1, well_x0, well_x1, HEAVY);
        arrow_v(9, 1.1, well_y0);             // hatch datum -> near edge
        arrow_v(37, 1.1, well_y1);            // hatch datum -> far edge
    }
}

// ---- F3: the well's width, and its depth (measured in section) ----
module f3() {
    color(RED) {
        rect_ol(well_x0, well_y0, well_x1 - well_x0, well_y1 - well_y0, HEAVY);
        arrow_h((well_y0 + well_y1)/2, well_x0, well_x1);
        // section marks: depth is taken on a cut, not in plan
        for (sx = [well_x0 - 2.2, well_x1 + 0.6]) {
            translate([sx, (well_y0 + well_y1)/2 - 4]) square([1.6, 8]);
            translate([sx + 0.8, (well_y0 + well_y1)/2 + 4]) polygon([[0, 0], [-1.6, -2.4], [1.6, -2.4]]);
        }
    }
}

// ---- F4: the 3 striker loops, fore-aft + lateral -------------
module f4() {
    color(RED) {
        for (sx = striker_x) loop(sx, striker_y, 2.3, 0.85);
        arrow_v(23, 1.1, striker_y - 2.6);                     // distance from the hatch
        arrow_h(striker_y - 5.2, striker_x[0], striker_x[2]);   // lateral spread (kept inside the floor outline)
    }
}

// ---- F5: what Panel C's 4 legs and the kitchen bear on -------
module f5() {
    kx0 = 24.5;
    color(RED) {
        for (lx = [1.5, W - 4.5]) for (ly = [1.5, PC - 4.5])
            translate([lx, ly]) square([3, 3]);         // the 4 leg pads
        rect_ol(kx0, 0, 20, 26, HEAVY);                 // the kitchen unit's footprint
    }
}

// ---- F6: fold the 3rd row, or remove it? --------------------
module f6() {
    color(RED) {
        rect_ol(0, PC, W, D - PC, HEAVY);               // the whole 3rd-row region
        // hatched, clipped to that region (an unclipped rotate() sweeps
        // the bars straight out of the floor outline)
        intersection() {
            translate([1, PC + 1]) square([W - 2, D - PC - 2]);
            union() for (y = [PC - 14 : 4 : D]) translate([1, y]) rotate(20) square([W * 1.6, 0.7]);
        }
    }
}

// ---- F7: the step/riser at the striker row ------------------
module f7() {
    color(RED) {
        translate([2, step_y]) square([W - 4, HEAVY * 1.6]);   // the hard vertical face
        for (x = [4 : 4 : W - 6]) translate([x, step_y - 2.4]) square([0.7, 2.4]);  // riser hatching below it
        // its HEIGHT is a section dimension, not a plan one — same
        // section-mark convention as F3's well depth
        for (sx = [3, W - 4.6]) {
            translate([sx, step_y - 9]) square([1.6, 7]);
            translate([sx + 0.8, step_y - 2]) polygon([[0, 0], [-1.6, -2.4], [1.6, -2.4]]);
        }
    }
}

// ---- F8: the 2nd-row rails' rear ends ----------------------
module f8() {
    color(RED) {
        for (rx = rail_x) {
            translate([rx - 1.6, railend_y - 0.8]) square([3.2, 2.2]);   // the end hardware
            translate([rx - 0.5, railend_y + 1.4]) square([1, D - railend_y - 1.4]);
        }
        arrow_v(41.5, 1.1, railend_y - 1.2);            // distance from the hatch (clear of the x=38 striker loop)
        arrow_h(railend_y - 4.4, rail_x[0], rail_x[1]); // lateral spacing
    }
}

base();
if      (key == 1) f1();
else if (key == 2) f2();
else if (key == 3) f3();
else if (key == 4) f4();
else if (key == 5) f5();
else if (key == 6) f6();
else if (key == 7) f7();
else               f8();
