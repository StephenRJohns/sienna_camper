// ============================================================
// Shared 2D drafting primitives for the measurement/survey sheets
// ============================================================
// The small building blocks every one of the bordered, banded sheets
// needs: outline shapes, dashed lines, text, dimension lines with ticks,
// numbered badges and inset boxes. They were copy-pasted between
// floor_survey_keys.scad and van_measure_keys.scad (and, in a vp_*
// prefixed form, van_plan.scad); this is the single copy.
//
// INCLUDE ORDER: this file is pulled in by van_plan.scad, and the sheets
// include van_plan.scad — so do NOT include it again there. OpenSCAD's
// `include` pastes the file, so a second include just redefines every
// module and warns about it.
//
// What deliberately stays OUT of here: anything that depends on a
// particular sheet's layout. `callout()` is the obvious one — it anchors
// to that sheet's own CO_X/CO_Y band — so each sheet keeps its own.
// ============================================================

// ---- house style ---------------------------------------------
THIN = 0.34;    // interior / context lines
MED  = 0.6;     // body outline, secondary emphasis
HEAVY = 1.5;    // the thing this drawing is actually about
RED  = "Firebrick";   // ...which is always drawn in this
GRY  = "DimGray";     // context that must not compete with it

// ---- outlines -------------------------------------------------
// An outline, not a filled shape: the polygon minus an inset copy.
module ol(pts, t = THIN) {
    difference() { polygon(pts); offset(delta = -t) polygon(pts); }
}

module rect_ol(x0, y0, w, h, t = THIN) {
    ol([[x0, y0], [x0 + w, y0], [x0 + w, y0 + h], [x0, y0 + h]], t);
}

module round_ol(x0, y0, w, h, r, t = THIN) {
    difference() {
        offset(r = r) translate([x0 + r, y0 + r]) square([w - 2*r, h - 2*r]);
        offset(r = r - t) translate([x0 + r, y0 + r]) square([w - 2*r, h - 2*r]);
    }
}

// ---- dashed lines ---------------------------------------------
// dash_x runs ALONG x at a constant y; dash_y runs along y at constant x.
// (Mixing these up draws a line straight off the sheet — it has happened.)
module dash_x(y, x0, x1, t = THIN, seg = 3) {
    for (x = [x0 : seg * 1.9 : x1 - 0.4]) translate([x, y]) square([min(seg, x1 - x), t]);
}

module dash_y(x, y0, y1, t = THIN, seg = 3) {
    for (y = [y0 : seg * 1.9 : y1 - 0.4]) translate([x, y]) square([t, min(seg, y1 - y)]);
}

module dash_rect(x0, y0, w, h, t = THIN) {
    dash_x(y0, x0, x0 + w, t); dash_x(y0 + h - t, x0, x0 + w, t);
    dash_y(x0, y0, y0 + h, t); dash_y(x0 + w - t, y0, y0 + h, t);
}

// ---- text -----------------------------------------------------
module txt(s, x, y, size = 3.0, halign = "left", col = "Black") {
    color(col) translate([x, y]) text(s, size = size, halign = halign, valign = "center");
}

// ---- dimensions -----------------------------------------------
// Fore-aft dimension line with end ticks and a centred label. `drop`
// extends dashed witness lines back down to the feature being measured.
module dim_x(x0, x1, y, s, size = 2.9, col = RED, drop = 0) {
    color(col) {
        translate([min(x0, x1), y - 0.3]) square([abs(x1 - x0), 0.6]);
        for (x = [x0, x1]) {
            translate([x - 0.3, y - 2.4]) square([0.6, 4.8]);
            if (drop > 0) dash_y(x - 0.17, y - drop, y - 2.4, 0.34, 2.2);
        }
    }
    txt(s, (x0 + x1) / 2, y + 3.9, size, "center", col);
}

// Lateral dimension. `side` picks which end of the line the label sits
// on, so a dimension near a sheet edge can throw its label inboard.
module dim_y(y0, y1, x, s, size = 2.9, col = RED, side = "left") {
    color(col) {
        translate([x - 0.3, min(y0, y1)]) square([0.6, abs(y1 - y0)]);
        for (y = [y0, y1]) translate([x - 2.4, y - 0.3]) square([4.8, 0.6]);
    }
    txt(s, side == "left" ? x - 3.4 : x + 3.4, (y0 + y1) / 2, size,
        side == "left" ? "right" : "left", col);
}

// ---- annotation ------------------------------------------------
// Filled circle with the section's code in it, matching the numbered
// bubbles on the reference sheets.
module badge(n, x, y, r = 3.6) {
    color(RED) translate([x, y]) circle(r = r, $fn = 32);
    txt(n, x, y - 0.2, r * 0.95, "center", "White");
}

// A titled box for a detail that can't be shown in the main view —
// a section, an elevation, a close-up. Children draw inside it.
module inset(x, y, w, h, title) {
    color("Black") rect_ol(x, y, w, h, 0.45);
    txt(title, x + 2.5, y + h - 3.6, 2.7, "left", "Black");
    children();
}
