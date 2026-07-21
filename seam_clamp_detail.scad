// ============================================================
// Seam draw-latch positioning — EXPLODED ISOMETRIC (woodworking-plan
// line-art, see steps/lego_lib.scad). The three lift-out modules as
// one iso beam (front seats at upper-left, tailgate at lower-right),
// with the 4 over-center draw latches shown at their real positions:
// low on the bottom-rail band, one each side of BOTH seams. A detail
// vignette shows one latch clamping two adjacent legs across a bumper.
//
// Render with: openscad -o renders/seam-clamp-detail.svg seam_clamp_detail.scad
// ============================================================

include <steps/hardware_icons.scad>
include <colors.scad>

PT   = panel_thickness;
W    = panel_width;                       // 46
y_ab = panel_a_length;                    // 29 — A/B seam
y_bc = panel_a_length + panel_b_length;   // 58 — B/C seam
zr   = leg_height + frame_rail_sz;

module marker3d(n, anchor3, off = [6, 4]) {
    q = p2(anchor3); t = q + off;
    color(INK) line2d(q, t - off * (2.2 / max(2.2, norm(off))));
    color(marker_col(n)) translate(t) circle(r = 1.4);
    color("white") translate(t) text(str(n), size = 1.4, halign = "center", valign = "center");
}

// hollow iso wireframe box (edges only), spanning Y = y0..y0+len
module box_wire(y0, len, ctx = false) {
    ifill(ctx ? EDGE_CTX : INK) translate([-W/2, y0, 0]) edge_box(W, len, leg_height, ctx ? 0.11 : 0.16);
    // a few leg posts so it reads as a frame, not just a box
    for (x = [-W/2 + leg_inset, W/2 - frame_rail_sz - leg_inset])
        wbox([x, y0 + 0.2, 0], [frame_rail_sz, frame_rail_sz, leg_height], [0, 0], true);
}

module drawing() {
    // three modules as one beam
    box_wire(0, panel_a_length);
    box_wire(y_ab, panel_b_length);
    box_wire(y_bc, panel_c_length, true);
    // bed platform ties the A/B tops; Panel C keeps its own deck
    wbox([-W/2, 0, zr], [W, y_bc, 0.75], [0, 0], true);
    wbox([-W/2, y_bc, zr], [W, panel_c_length, PT], [0, 0], true);

    // 4 draw latches — low on the bottom-rail band, both sides of each seam
    n = 1;
    for (sy = [y_ab, y_bc]) for (sx = [seam_latch_x, -seam_latch_x])
        translate(p2([sx, sy, seam_latch_z + 1.5])) scale([0.95, 0.95]) ic_latch();
    marker3d(1, [ seam_latch_x, y_ab, seam_latch_z + 3], [4, 8]);
    marker3d(2, [-seam_latch_x, y_ab, seam_latch_z + 3], [-10, 6]);
    marker3d(3, [ seam_latch_x, y_bc, seam_latch_z + 3], [8, 6]);
    marker3d(4, [-seam_latch_x, y_bc, seam_latch_z + 3], [-10, 4]);

    // dashed seam lines across the deck for clarity
    color(INK) {
        dash2d(p2([-W/2, y_ab, zr]), p2([W/2, y_ab, zr]), 0.16, 1.4);
        dash2d(p2([-W/2, y_bc, zr]), p2([W/2, y_bc, zr]), 0.16, 1.4);
    }

    cap("SEAM DRAW-LATCHES — clamp the 3 lift-out modules into one rigid beam (Component 5)", 0, -10, 1.9);
    cap("4 latches total: one each side of BOTH the A/B and B/C seams, low on the bottom-rail band (~1.75\" up, hand-reach).", 0, -12.5, 1.3);
    cap("Alignment pins LOCATE the modules; the latches PULL them tight against the bumper strip. Hand-released — panels still lift out in seconds.", 0, -14.7, 1.3);
    cap("(front seats upper-left, tailgate lower-right; the bed platform already ties the Panel A + B tops)", 0, -16.9, 1.2);
}

// ---- detail vignette: one latch across two adjacent legs ----
module vignette() {
    g = frame_rail_sz + bumper_thickness;
    wbox([0, 0, 0], [frame_rail_sz, frame_rail_sz, 12]);                 // module 1 leg
    wbox([g, 0, 0], [frame_rail_sz, frame_rail_sz, 12]);                 // module 2 leg
    ifill("Peru") translate([frame_rail_sz, 0, 0]) cube([bumper_thickness, frame_rail_sz, 12]); // bumper
    translate(p2([g/2 + frame_rail_sz/2, frame_rail_sz/2, seam_latch_z + 3])) scale([1.2, 1.2]) ic_latch();
    cap("DETAIL — one latch, two legs, bumper between", frame_rail_sz/2 + g/2, 15, 1.4);
    cap("base plate on one leg, hooked bail + lever on the other;", frame_rail_sz/2 + g/2, 12.8, 1.05);
    cap("flip to clamp, flip to release (no tools)", frame_rail_sz/2 + g/2, 11.3, 1.05);
}

drawing();
translate([104, 18]) vignette();
