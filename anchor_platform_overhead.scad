// ============================================================
// No-drill anchor platform — OVERHEAD detail (2D, plan view)
// ============================================================
// Companion to the Overhead Floorplan: the whole securing system
// for the fridge + kitchen (Section 8) seen from above, INCLUDING
// the factory hardpoints forward of Panel C that the whole design
// hangs off — the rear ends of the 2nd-row long-slide floor rails
// (the tongues bolt to them) and the 3 crash-rated 3rd-row striker
// loops (the straps drop into them). fridge_install_detail.scad
// zooms into Panel C's footprint for per-component coordinates;
// THIS drawing exists to show the load paths leaving Panel C.
//
// NOTHING here bolts to the van: mat + 3/4in ply board, tongues to
// the rails' existing end hardware, straps into the loops.
//
// COORDINATE SYSTEM: same as fridge_install_detail.scad — origin
// at Panel C's tailgate-facing DRIVER-side corner, X 0-46 toward
// the passenger side, Y forward from the tailgate (Panel C is
// Y 0-36; everything above Y=36 sits under Panel B).
//
// UNVERIFIED geometry (drawn at the plan's assumptions): striker
// row ~46-50in fwd of the hatch (F4), rail rear ends reaching that
// same zone (F8), rail lateral spacing (F8). Re-render after the
// Appendix A survey pins the real numbers.
//
// Render with: openscad -o renders/anchor-platform-overhead.svg anchor_platform_overhead.scad
// ============================================================
// LEGIBILITY (Aug 2026): 4 prose line(s) moved out of this
// sheet into the document, and every text size scaled x1.8. Those
// sentences were setting the sheet's width, and a figure's printed
// text height is size x (page_width / sheet_width) — so they were
// holding every other label on the sheet down to 3-6pt on paper.
// Keep prose in the markdown; this sheet carries geometry and short
// labels only.

include <params.scad>
include <colors.scad>

stroke = 0.25;

module rect_outline(w, l, s = stroke) {
    color("black")
    difference() {
        square([w, l]);
        translate([s, s]) square([w - 2*s, l - 2*s]);
    }
}

module label(txt, x, y, size = 2.34) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "center", valign = "center");
}

module label_left(txt, x, y, size = 1.98) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "left", valign = "center");
}

// anchor-board piece: outline + diagonal section hatch (line art —
// same technique as fridge_install_detail.scad)
module board_piece(x0, y0, w, l) {
    board_poly([[x0, y0], [x0 + w, y0], [x0 + w, y0 + l], [x0, y0 + l]]);
}

// the board is ONE comb-shaped piece, so its outline is a single
// polygon — no internal butt lines between the bridge and the strips
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
                translate([x0, y0 + d]) rotate(-45) square([(w + l) * 1.5, 0.1]);
        }
    }
}

module dring_icon(x, y) {
    color("Black") translate([x, y]) difference() { circle(r = 0.55, $fn = 28); circle(r = 0.3, $fn = 20); }
}

// a 3rd-row striker: the crash-rated wire latch loop, drawn as a
// stubby U seen from above
module striker_icon(x, y) {
    color("Black") translate([x, y]) {
        difference() { circle(r = 0.9, $fn = 32); circle(r = 0.55, $fn = 28); }
        translate([-1.45, -0.35]) square([0.55, 0.7]);
        translate([0.9, -0.35]) square([0.55, 0.7]);
    }
}

module dash_y(x, y0, y1, w = 0.2) {
    for (dy = [0 : 1.8 : y1 - y0 - 0.9]) color("Gray") translate([x, y0 + dy]) square([w, 0.9]);
}

module dash_x(x0, x1, y, h = 0.2) {
    for (dx = [0 : 1.8 : x1 - x0 - 0.9]) color("Gray") translate([x0 + dx, y]) square([0.9, h]);
}

module drawing() {
    kitchen_x0 = x_kitchen - kitchen_box_width/2 + panel_width/2;   // 24.5
    fridge_x0  = x_fridge_module - fridge_ext_length/2 + panel_width/2; // 2
    rail_cx = [fridge_x0 - fridge_slide_margin - fridge_rail_t/2,
               fridge_x0 + fridge_ext_length + fridge_slide_margin + fridge_rail_t/2];
    striker_y = 48;        // ASSUMED striker row / floor step (F4/F7)
    railend_y = 44;        // ASSUMED rail rear ends (F8)
    tongue_x  = [15, 30];  // follows the rails' ASSUMED lateral spacing (F8)
    striker_x = [8, 23, 38];

    // ---- context: Panel C + Panel B footprints ----
    rect_outline(panel_width, panel_c_length);
    label("PANEL C footprint", panel_width/2, 0.9, 1.8);
    dash_x(0, panel_width, panel_c_length + panel_b_length > 62 ? 60 : panel_c_length + panel_b_length); // Panel B far edge (clipped)
    dash_y(0, panel_c_length, 60); dash_y(panel_width - 0.2, panel_c_length, 60);
    label("PANEL B above (bare cube frame)", panel_width/2, 57.5, 1.8);
    // MOVED TO THE DOCUMENT: label("tongues + straps pass UNDER its rear bottom rail (shallow notches)", panel_width/2, 37.1, 1.0);
    label("TAILGATE (open) — Y = 0", panel_width/2, -2.2, 1.8);
    label("DRIVER side (X=0)", 8, -4.8, 1.6);
    label("PASSENGER side", panel_width - 8, -4.8, 1.6);

    // ---- ghost appliances ----
    color("Gainsboro") translate([fridge_x0, 4.5]) rect_outline(fridge_ext_length, fridge_ext_width - 4.5, 0.12);
    label("Fridge", fridge_x0 + fridge_ext_length/2, 14, 1.8);
    label("(on its slide)", fridge_x0 + fridge_ext_length/2, 11.8, 1.6);
    color("Gainsboro") translate([kitchen_x0, 4.5]) rect_outline(kitchen_box_width, kitchen_box_length - 4.5, 0.12);
    label("Kitchen unit", kitchen_x0 + kitchen_box_width/2, 14, 1.8);
    label("(straps into L-track)", kitchen_x0 + kitchen_box_width/2, 11.8, 1.6);

    // ---- the anchor board: ONE comb-shaped piece of 3/4" ply ----
    // full-width bridge (Y 29-35) with three strips running back to
    // Y 2 — all continuous, cut from a single 46"x33" blank (no wood
    // joints; assembly sheet V1/V5)
    t2_x0 = rail_cx[1] - 1.25;                                     // 19.35 — center strip (rail + utility-bay gap)
    t2_x1 = kitchen_x0 - 0.5;                                      // 24.0
    t3_x0 = kitchen_x0 + kitchen_box_width;                        // 44.5 — kitchen-right strip
    board_poly([[0, 2], [2.5, 2], [2.5, 29],                       // driver rail-line strip
                [t2_x0, 29], [t2_x0, 2], [t2_x1, 2], [t2_x1, 29],
                [t3_x0, 29], [t3_x0, 2], [panel_width, 2],
                [panel_width, 29 + aboard_bridge_d], [0, 29 + aboard_bridge_d]]);
    // kitchen tie-down D-rings (stud fittings in the strips' L-track)
    for (kx = [kitchen_x0 - 1, kitchen_x0 + kitchen_box_width + 0.75])
        for (ky = [4, 25]) dring_icon(kx, ky);

    // ---- forward hardpoint 1: the 2nd-row floor rails ----
    for (tx = tongue_x) {
        // tongue: bridge -> rail end (outline flat bar)
        color("DimGray") difference() {
            translate([tx - aboard_tongue_w/2, 33]) square([aboard_tongue_w, railend_y - 33 + 1.5]);
            translate([tx - aboard_tongue_w/2 + 0.15, 33.15]) square([aboard_tongue_w - 0.3, railend_y - 33 + 1.2]);
        }
        // rail: solid channel at its rear end, dashed continuing forward
        color("Black") {
            translate([tx - 1.2, railend_y]) square([0.25, 8]);
            translate([tx + 0.95, railend_y]) square([0.25, 8]);
            translate([tx - 1.2, railend_y - 0.25]) square([2.4, 0.25]); // rear end cap
        }
        dash_y(tx - 1.2, railend_y + 8, 60, 0.25);
        dash_y(tx + 0.95, railend_y + 8, 60, 0.25);
        color("Black") translate([tx, railend_y + 1.2]) circle(r = 0.4, $fn = 20);  // tongue-to-rail bolt/clamp point
        color("black") translate([tx + 1.9, 34.2]) rotate(90) text("STEEL TONGUE", size = 1.62, halign = "left", valign = "center");
    }
    // name the strips right on them (rotated to fit)
    color("black") translate([1.25, 9]) rotate(90) text("ply strip — fridge rail riser", size = 1.6, halign = "left", valign = "center");
    color("black") translate([21.6, 5]) rotate(90) text("ply strip — riser + L-track", size = 1.6, halign = "left", valign = "center");
    // right-margin component callouts (the "what is what" labels) —
    // short wrapped lines so the drawing stays the dominant element
    cx = panel_width + 2;
    // One short tag per hardpoint. These were six wrapped paragraphs at 1.05,
    // and the longest of them set this sheet at 102 units wide, which is what
    // held them (and every other label here) to about 5pt on paper. What each
    // hardpoint IS, and which survey row is still assumed, is in the document
    // under this figure.
    label_left("← 2nd-row FLOOR RAIL (x2)", cx, 52.4, 1.7);
    label_left("← STRIKER LOOP (x3)", cx, 46.6, 1.7);
    label_left("← rail REAR END (F8)", cx, 41.4, 1.7);
    color("Firebrick") translate([cx, 36.2]) text("← RATCHET STRAP (x3)", size = 1.7);
    label_left("← stud D-RING (x3)", cx, 32, 1.7);
    label_left("← 3/4\" PLY BRIDGE", cx, 29.4, 1.7);
    label_left("← ply STRIP (L-track)", cx, 19.6, 1.7);

    // ---- forward hardpoint 2: the 3rd-row strikers ----
    // striker row / floor step, dashed across
    dash_x(-2, panel_width + 2, striker_y - 1.9, 0.18);
    for (sx = striker_x) {
        striker_icon(sx, striker_y);
        dring_icon(sx, 32);
        color("Firebrick") {
            hull() { translate([sx, 32.6]) circle(r = 0.22, $fn = 16); translate([sx, striker_y - 1.1]) circle(r = 0.22, $fn = 16); }
            translate([sx, striker_y - 2.6]) polygon([[0, 1.4], [-0.8, 0], [0.8, 0]]);
        }
    }
    // (strap + striker explanations live in the right-margin
    // callout stack above and the READ ME block below)

    // A 20-line READ ME block used to print below the drawing, explaining the
    // whole platform in prose at 1.0-1.25. It is what made this sheet 101 units
    // tall, and sheet height sets printed text size, so it was holding its own
    // lines (and every label on the drawing) to about 5pt. It is in the
    // document under this figure now, where it reads at body-text size.

    label("NO-DRILL ANCHOR PLATFORM — overhead", panel_width/2, 62, 2.4);
}

// no outer color() wrapper — helpers self-color (see
// fridge_install_detail.scad for why)
drawing();
