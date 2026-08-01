// ============================================================
// Anchor board — ACCESSORY INSTALL MAP (A-G) + BUILD ORDER (2D)
// ============================================================
// The banner (renders/steps/comp-11-header) lists accessories A-G as
// isolated icons, which says WHAT to buy but not WHERE any of it goes.
// This sheet closes that gap:
//
// the one-piece board in plan, with every accessory drawn in its real
// position and ballooned with its banner letter. The per-letter
// descriptions and the 7-step build order are in Section 8 as document
// text — see the note at the bottom of this file for why they are not
// drawn here.
//
// The board itself is ONE comb-shaped piece of 3/4" ply (46"x33", no
// wood joints — see the assembly sheet's V1/V5). Every fastener on
// this sheet therefore holds HARDWARE to the ply, never ply to ply.
//
// Positions were ASSUMED; the F1-F8 floor survey (Aug 1 2026) confirmed
// them — striker row 44.5" from the hatch, rail ends 42".
//
// Render with: openscad -o renders/anchor-board-install.svg anchor_board_install.scad
// ============================================================

include <params.scad>
include <colors.scad>

stroke = 0.22;

// ---- shared line-art helpers (same style as anchor_board_assembly) --
module label(txt, x, y, size = 1.2) {
    color("black") translate([x, y]) text(txt, size = size, halign = "center", valign = "center");
}

module label_left(txt, x, y, size = 1.05) {
    color("black") translate([x, y]) text(txt, size = size, halign = "left", valign = "center");
}

// the board draws as a single outline: one piece, so no butt lines
module board_poly(pts) {
    xs = [for (p = pts) p[0]];  ys = [for (p = pts) p[1]];
    x0 = min(xs); y0 = min(ys); w = max(xs) - x0; l = max(ys) - y0;
    color("Peru") difference() {
        polygon(pts);
        offset(delta = -0.15) polygon(pts);
    }
    color("Tan") intersection() {
        offset(delta = -0.3) polygon(pts);
        union() {
            for (d = [2 : 4 : w + l])
                translate([x0, y0 + d]) rotate(-45) square([(w + l) * 1.5, 0.08]);
        }
    }
}

module dring_icon(x, y) {
    color("Black") translate([x, y]) difference() { circle(r = 0.55, $fn = 28); circle(r = 0.3, $fn = 20); }
}

module bolt_dot(x, y, r = 0.28) {
    color("Black") translate([x, y]) circle(r = r, $fn = 18);
}

module dash_v(x, y0, y1, w = 0.15) {
    for (dy = [0 : 1.6 : y1 - y0 - 0.8]) color("Gray") translate([x, y0 + dy]) square([w, 0.8]);
}

// lettered balloon + leader line back to what it points at. Drawn as
// an OPEN ring (like the D-ring icon) rather than a white-filled disc:
// a white fill over the hatch doesn't survive the 2D export, and the
// leader is trimmed to the ring's edge so it never crosses the letter.
module balloon(letter, bx, by, tx, ty) {
    d = [tx - bx, ty - by];
    len = max(norm(d), 0.001);
    u = [d[0]/len, d[1]/len];
    r = 1.45;
    color("Black") hull() {                          // leader: ring edge -> target
        translate([bx + u[0]*r, by + u[1]*r]) circle(r = 0.11, $fn = 12);
        translate([tx, ty]) circle(r = 0.11, $fn = 12);
    }
    color("Black") difference() {                    // the ring itself
        translate([bx, by]) circle(r = r, $fn = 36);
        translate([bx, by]) circle(r = r - 0.26, $fn = 36);
    }
    color("Black") translate([bx, by]) text(letter, size = 1.6, halign = "center", valign = "center");
}

// ============================================================
// LEFT — the board in plan, every accessory in its real position
// ============================================================
module install_map() {
    ds_w = 2.5;   cs_x0 = 19.35; cs_w = 4.65; rs_x0 = 44.5; rs_w = 1.5;
    y0 = 2;  br_y0 = 29;  br_d = aboard_bridge_d;   // strips Y 2-29, bridge Y 29-35
    br_top = br_y0 + br_d;

    // ---- the one-piece comb ----
    comb = [[0, y0], [ds_w, y0], [ds_w, br_y0],
            [cs_x0, br_y0], [cs_x0, y0], [cs_x0 + cs_w, y0],
            [cs_x0 + cs_w, br_y0], [rs_x0, br_y0], [rs_x0, y0],
            [rs_x0 + rs_w, y0], [panel_width, br_top], [0, br_top]];
    board_poly(comb);

    // ---- E: rubber mat, cut to the board's own outline and laid under
    // it — a thin gray band FOLLOWING the comb, so the comb shape still
    // reads (a rectangle here would make the board look like a pan) ----
    color("DarkGray") difference() {
        offset(delta = 0.5) polygon(comb);
        polygon(comb);
    }

    // ---- riser-angle footprints + their bolt patterns (D, F) ----
    for (rx = [0.15, 19.85]) {
        dash_v(rx, 3, 27); dash_v(rx + 2, 3, 27);
        for (by = [5, 12, 19, 26]) bolt_dot(rx + 1, by);
    }

    // ---- A: L-track on the two kitchen-side strips, with B in its slots ----
    for (lx = [23, 44.75]) {
        color("DimGray") difference() {
            translate([lx, 3.5]) square([1, 23]);
            translate([lx + 0.12, 3.62]) square([0.76, 22.76]);
        }
        for (dy = [5 : 3 : 25]) bolt_dot(lx + 0.5, dy, 0.16);
    }
    dring_icon(23.5, 6); dring_icon(23.5, 24); dring_icon(45.25, 6); dring_icon(45.25, 24);

    // ---- B: the bridge's 3 striker-strap D-rings ----
    for (sx = [8, 23, 38]) dring_icon(sx, 32);

    // ---- steel tongues under the bridge, running forward (G at their tips) ----
    for (tx = [15, 30]) {
        dash_v(tx - 1, br_y0 + 0.3, br_top - 0.3); dash_v(tx + 0.85, br_y0 + 0.3, br_top - 0.3);
        color("DimGray") difference() {
            translate([tx - 1, br_top]) square([2, 6]);
            translate([tx - 0.85, br_top]) square([1.7, 5.85]);
        }
        bolt_dot(tx, br_y0 + 1.5); bolt_dot(tx, br_y0 + 4.5);   // D: T-nut bolts up into the bridge
        bolt_dot(tx, br_top + 4.6, 0.34);                        // G: the rail-end bolt
    }
    // kept above the straps' arrowheads so nothing crosses the red lines
    // Stacked above the board and left-aligned outboard of it: these
    // lines are long, and centred/inboard they printed over the title.
    label_left("2 STEEL TONGUES -> the 2nd-row FLOOR RAILS' rear ends, MEASURED 42\" (F8a)", -12, br_top + 15, 1.25);
    label_left("how they engage the track: see the tongue-to-rail connection detail", -12, br_top + 13, 1.15);

    // ---- C: the 3 striker straps leaving the bridge D-rings ----
    color("Firebrick") for (sx = [8, 38]) {
        hull() { translate([sx, 32.6]) circle(r = 0.22, $fn = 16); translate([sx, br_top + 8]) circle(r = 0.22, $fn = 16); }
        translate([sx, br_top + 8]) polygon([[0, 1.5], [-0.85, 0], [0.85, 0]]);
    }
    color("Firebrick") translate([-12, br_top + 10.8]) text("3 RATCHET STRAPS -> the 3rd-row STRIKER LOOPS, MEASURED 44.5\" (F4a)", size = 1.25);

    // ---- balloons: banner letter -> real position ----
    balloon("A", 50.6, 15, 45.6, 15);         // L-track
    balloon("B", 50.6, 32, 39, 32);           // stud D-ring (bridge)
    balloon("C", 43.5, br_top + 7.5, 38.4, br_top + 6);  // ratchet strap
    balloon("D", -4.6, 12, 0.9, 12);          // bolt into T-nut
    balloon("E", -4.6, 25, -0.5, 26);         // rubber mat
    balloon("F", -4.6, 19, 0.9, 19);          // threadlocker, on every machine screw
    balloon("G", 11, br_top + 6.6, 14.7, br_top + 4.9);  // rail-end bolt

    // ---- orientation ----
    label_left("fwd ->", -9.5, br_top + 1, 1.35);
    label_left("tailgate ->", -12.5, 4, 1.35);
    label("ONE-PIECE 3/4\" PLY BOARD, 46\" x 33\" — assembly sheet V1 for dimensions, V5 for the cut", panel_width/2, y0 - 3.4, 1.35);
}

// ============================================================
// sheet layout — THE MAP ONLY
// ============================================================
// The A-G descriptions and the 7-step build order used to live on this
// sheet as two more columns of prose. That doubled the sheet's width to
// ~130 units, and since a rendered figure is scaled to the page, it
// drove every text label down to about 4pt on paper — unreadable.
//
// They are markdown now (Section 8: the accessory table and the build
// order list), where they render at the document's own 9-10.5pt and are
// selectable and searchable. With only the map left, the sheet is ~60
// units wide and the same labels land at ~11pt. Resist putting
// paragraphs back on a drawing: a figure can only ever be as legible as
// page_width / sheet_width allows.
install_map();
label("ANCHOR BOARD — ACCESSORY INSTALL MAP (A-G), Section 8", panel_width/2, 58, 2.2);
label("Every letter matches the ACCESSORY LIST in Section 8 and the anchor-board banner icons.", panel_width/2, 54.4, 1.35);
label("The board is ONE piece of ply: every fastener holds HARDWARE to it, never ply to ply.", panel_width/2, 52.2, 1.35);
