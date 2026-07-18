// ============================================================
// Seam draw-latch positioning — where the over-center clamps go to
// tie the three lift-out modules into one rigid beam. Three views:
//   TOP    side elevation — latches low on the bottom-rail band at
//          each seam; the bed platform already ties the A/B tops
//   MIDDLE top-down plan  — the 4 latch positions (2 per seam, one
//          per side), over the inset leg lines
//   RIGHT  detail vignette — one latch clamping two adjacent legs
//
// Render with: openscad -o renders/seam-clamp-detail.svg seam_clamp_detail.scad
// ============================================================

include <params.scad>
include <colors.scad>

stroke = 0.3;

module rect_outline(w, l, s = stroke) {
    color("black") difference() { square([w, l]); translate([s, s]) square([w - 2*s, l - 2*s]); }
}
module label(txt, x, y, size = 1.5, ha = "center") {
    color("black") translate([x, y]) text(txt, size = size, halign = ha, valign = "center");
}
module marker(n, x, y, r = 1.4) {
    translate([x, y]) { color(marker_col(n)) circle(r = r); color("white") text(str(n), size = r*1.05, halign = "center", valign = "center"); }
}

// schematic over-center draw latch, ~3 wide x 1.6 tall, centered at
// origin: a base plate on each module + a lever handle + a hooked bail
module latch_icon(s = 1) {
    scale(s) {
        color("DimGray") {
            translate([-1.6, -0.6]) square([0.7, 1.2]);   // base plate, module 1 (left)
            translate([0.9, -0.6]) square([0.7, 1.2]);     // keeper plate, module 2 (right)
        }
        color("DarkOrange") {
            translate([-0.9, 0]) circle(r = 0.24, $fn = 20);          // lever pivot
            translate([-0.9, -0.13]) rotate(8) square([1.55, 0.26]);  // over-center handle
            translate([0.55, 0]) difference() { circle(r = 0.55, $fn = 28); circle(r = 0.34, $fn = 28); } // hooked bail
        }
    }
}

// ---- geometry ----
y_ab = panel_a_length;                    // 29 — A/B seam (from the front)
y_bc = panel_a_length + panel_b_length;   // 58 — B/C seam
Ltot = panels_total_length;               // 94
zr   = leg_height + frame_rail_sz;         // 18.5 rail top

// ============================================================
// TOP — side elevation (van length horizontal; front at left)
// ============================================================
module elevation() {
    plen = [panel_a_length, panel_b_length, panel_c_length];
    pnm  = ["Panel A", "Panel B", "Panel C"];
    pys  = [0, y_ab, y_bc];
    for (i = [0:2]) {
        translate([pys[i], 0]) rect_outline(frame_rail_sz, leg_height);
        translate([pys[i] + plen[i] - frame_rail_sz, 0]) rect_outline(frame_rail_sz, leg_height);
        translate([pys[i], leg_height]) rect_outline(plen[i], frame_rail_sz);            // top rail
        translate([pys[i], bottom_rail_z]) rect_outline(plen[i], frame_rail_sz);         // bottom rail band
        label(pnm[i], pys[i] + plen[i]/2, leg_height*0.55, 1.5);
    }
    // bed platform tying the A/B tops (0..58)
    color("SteelBlue") translate([0, zr]) rect_outline(panel_a_length + panel_b_length, 0.75);
    label("bed platform ties the Panel A + B tops (one flush plane)", (panel_a_length+panel_b_length)/2, zr + 1.6, 1.15);
    // Panel C deck
    translate([y_bc, zr]) rect_outline(panel_c_length, panel_thickness);

    // latch icons low at each seam
    for (sx = [y_ab, y_bc]) translate([sx, seam_latch_z + 0.6]) latch_icon(1.1);
    marker(1, y_ab, seam_latch_z + 4);
    marker(2, y_bc, seam_latch_z + 4);
    label("draw latch, low on the bottom-rail band", y_ab, -2, 1.1);
    label("(one at EACH seam — with the platform above, this makes a rigid top-and-bottom couple)", (y_ab+y_bc)/2, -3.6, 1.1);

    label("SIDE ELEVATION — front seats at left, tailgate at right", Ltot/2, leg_height + 5, 1.7);
}

// ============================================================
// MIDDLE — top-down plan (van length horizontal; width vertical)
// ============================================================
module plan() {
    // deck outline (94 long x 46 wide), centered on X=0 in width
    translate([0, -panel_width/2]) rect_outline(Ltot, panel_width);
    // seam lines
    for (sx = [y_ab, y_bc]) color("black") translate([sx - stroke/2, -panel_width/2]) square([stroke, panel_width]);
    // panel name tags
    label("Panel A", panel_a_length/2, 0, 1.4);
    label("Panel B", y_ab + panel_b_length/2, 0, 1.4);
    label("Panel C", y_bc + panel_c_length/2, 0, 1.4);
    // 4 latch positions: over the inset leg lines (+/- seam_latch_x), at each seam
    for (sx = [y_ab, y_bc]) for (sy = [seam_latch_x, -seam_latch_x])
        translate([sx, sy]) latch_icon(0.9);
    marker(1, y_ab,  seam_latch_x + 2.4);
    marker(2, y_bc,  seam_latch_x + 2.4);
    marker(3, y_ab, -seam_latch_x - 2.4);
    marker(4, y_bc, -seam_latch_x - 2.4);
    label("PASSENGER SIDE", Ltot/2,  panel_width/2 + 2, 1.3);
    label("DRIVER SIDE",    Ltot/2, -panel_width/2 - 2.4, 1.3);
    label("TOP-DOWN — 4 latches total: one each side of BOTH seams, over the leg lines", Ltot/2, panel_width/2 + 5, 1.6);
}

// ============================================================
// RIGHT — detail: one latch clamping two adjacent legs
// ============================================================
module detail() {
    gap = 2 * frame_rail_sz + bumper_thickness;  // two rails + bumper between the seam faces
    // two adjacent legs (2x2) with the bumper strip between
    color("SteelBlue") { translate([0, 0]) rect_outline(frame_rail_sz, 12); translate([frame_rail_sz + bumper_thickness, 0]) rect_outline(frame_rail_sz, 12); }
    color("Peru") translate([frame_rail_sz, 0]) square([bumper_thickness, 12]);  // bumper strip
    label("module 1 leg", -0.5, 12.6, 1.0, "right");
    label("module 2 leg", frame_rail_sz*2 + bumper_thickness + 0.5, 12.6, 1.0, "left");
    label("bumper", frame_rail_sz + bumper_thickness/2, -1.4, 0.85);

    // latch mounted across the two legs at the bottom-rail band height
    translate([frame_rail_sz + bumper_thickness/2, seam_latch_z + 0.4]) rotate(90) latch_icon(1.5);
    // dimension line for mounting height
    color("Crimson") { translate([-3, 0]) square([stroke, seam_latch_z + 0.4]); translate([-3.6, seam_latch_z + 0.4 - stroke]) square([1.2, stroke]); translate([-3.6, 0]) square([1.2, stroke]); }
    label(str("mount at ~", seam_latch_z, "\" (bottom-rail band, low, hand-reach)"), -4, (seam_latch_z)/2 + 2, 0.95, "right");

    label("DETAIL — over-center draw latch", frame_rail_sz + bumper_thickness/2, 19.5, 1.4);
    label("base plate on one leg, hooked bail + lever on the other;", frame_rail_sz + bumper_thickness/2, 17.9, 0.95);
    label("flip the handle to clamp tight, flip to release (no tools)", frame_rail_sz + bumper_thickness/2, 16.9, 0.95);
}

// ============================================================
// layout
// ============================================================
elevation();
translate([0, -leg_height - 30]) plan();
translate([Ltot + 22, -leg_height - 26]) detail();

// overall caption
label("SEAM DRAW-LATCHES — clamp the 3 lift-out modules into one rigid beam (4 latches: both sides of the A/B and B/C seams)",
      Ltot/2, -leg_height - 30 - panel_width/2 - 6, 1.7);
label("Alignment pins LOCATE the modules; the draw latches PULL them tight against the bumper. Hand-released — modules still lift out in seconds.",
      Ltot/2, -leg_height - 30 - panel_width/2 - 8.4, 1.3);
