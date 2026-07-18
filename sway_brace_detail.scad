// ============================================================
// Headboard/pantry sway brace detail — side elevation (Y-Z), 2D
// line art, woodworking-plan style.
// ============================================================
// The headboard/pantry is a tall (22in) shelving unit bolted to
// Panel C's deck. Its 4 base bolts carry the vertical load; these
// 2 braces (one per side) triangulate the fore-aft rocking that
// braking/acceleration would otherwise work into the tall unit.
//
// ANCHOR CHANGE (owner question, July 2026): the braces used to
// reach forward to PANEL B's side rails — but the flush bed
// platform (52in wide, 3in overhang past the boxes) now caps Panel
// B's rails exactly where those arms landed. Re-anchored to PANEL
// C's OWN side rail instead: same ~45 degrees, same ~30in of steel,
// headboard + Panel C become one rigid triangulated unit, and Panel
// B now lifts out without touching the braces at all.
//
// The brace is L-PROFILE steel (slotted angle), not flat strap:
// under braking one brace loads in COMPRESSION, and a 30in run of
// 1/8in flat strap buckles — the angle's second leg is what resists
// that. Slotted angle comes pre-punched (holes every inch), so
// there's no steel drilling: pick the slots that line up.
//
// Render with: openscad -o renders/sway-brace-detail.svg sway_brace_detail.scad
// ============================================================

include <params.scad>

stroke = 0.25;

// local frame: Y=0 at Panel C's FRONT (B/C seam), Z=0 at the van floor
z_rail0 = leg_height;                      // 17
z_rail1 = leg_height + frame_rail_sz;      // 18.5
z_deck  = z_rail1 + panel_thickness;       // 19.25
z_matt  = z_deck + mattress_total_thickness; // 23.25
z_hb1   = z_deck + headboard_height;       // 41.25
y_hb0   = panel_c_length - headboard_length; // 22 — headboard front face

// brace endpoints (on the x = +/-23 outside plane, drawn edge-on here)
by1 = y_hb0 + 0.6;  bz1 = z_deck + 20;     // top: ~20in up the side panel's front edge
by0 = 1.75;         bz0 = z_rail0 + 0.75;  // bottom: Panel C's side rail, at the B/C-seam corner
brace_len = norm([by1 - by0, bz1 - bz0]);  // ~29.4 -> buy 30in

module rect_outline(w, h, s = stroke) {
    difference() {
        square([w, h]);
        translate([s, s]) square([w - 2*s, h - 2*s]);
    }
}
module label(txt, x, y, size = 1.4, halign = "center") {
    color("black") translate([x, y]) text(txt, size = size, halign = halign, valign = "center");
}
module thickline(p0, p1, w) {
    hull() { translate(p0) circle(r = w/2, $fn = 16); translate(p1) circle(r = w/2, $fn = 16); }
}
module bolt(p) { // bolt head, drawn as a small filled hex-ish dot
    color("black") translate(p) circle(r = 0.45, $fn = 6);
}

module drawing() {
    // ---- context: Panel C frame, deck, headboard, mattress ----
    color("black") {
        // legs (front + rear) and side rail, seen from the side
        translate([0, 0]) rect_outline(frame_rail_sz, leg_height);
        translate([panel_c_length - frame_rail_sz, 0]) rect_outline(frame_rail_sz, leg_height);
        translate([0, z_rail0]) rect_outline(panel_c_length, frame_rail_sz);
        // deck
        translate([0, z_rail1]) rect_outline(panel_c_length, panel_thickness);
        // headboard side panel above the deck
        translate([y_hb0, z_deck]) rect_outline(headboard_length, headboard_height);
        // floor line
        translate([-16, -stroke]) square([panel_c_length + 20, stroke]);
    }
    label("Panel C", panel_c_length/2, leg_height * 0.5, 1.6);
    label("headboard/pantry", y_hb0 + headboard_length/2, z_deck + headboard_height - 3, 1.2);
    label("side panel (3/4\" ply)", y_hb0 + headboard_length/2, z_deck + headboard_height - 5.2, 1.0);

    // bed platform stub, ending flush at the B/C seam, + mattress
    color("DimGray") {
        translate([-14, z_rail1]) rect_outline(14, bed_frame_thickness);
        translate([-14, z_deck]) rect_outline(14 + y_hb0, mattress_total_thickness);
    }
    label("bed platform ENDS at the B/C seam", -14, z_rail1 - 1.6, 1.0, "left");
    label("mattress (rear ~20\" rides Panel C's deck)", -13, z_deck + mattress_total_thickness/2, 1.0, "left");

    // ---- the brace itself ----
    color("black") thickline([by0, bz0], [by1, bz1], 0.7);
    // 2 bolts per end, spaced along the brace direction
    dir = [(by1 - by0)/brace_len, (bz1 - bz0)/brace_len];
    for (t = [1.2, 3.2]) bolt([by0 + dir[0]*t, bz0 + dir[1]*t]);
    for (t = [1.2, 3.2]) bolt([by1 - dir[0]*t, bz1 - dir[1]*t]);

    label(str("slotted steel angle 1-1/2\" x 1-1/2\" x 1/8\" — cut ", ceil(brace_len), "\""), 12.5, 35.5, 1.3, "right");
    label("~45 deg — one per side, on the OUTSIDE face", 12.5, 33.7, 1.1, "right");

    // end callouts
    label("2x 1/4-20 bolts + nyloc nuts (permanent end)", by1 + 1.6, bz1 + 2.2, 1.1, "left");
    label("through the side panel, ~20\" up", by1 + 1.6, bz1 + 0.6, 1.0, "left");
    label("2x 1/4-20 studs + Kipp CAM-LEVER nuts", by0 - 1.5, bz0 - 2.6, 1.1, "left");
    label("into Panel C's side rail (2x2) — flip the levers to release, NO tools (bike-QR style)", by0 - 1.5, bz0 - 4.2, 1.0, "left");

    // ---- L cross-section inset, 3x scale ----
    ix = panel_c_length + 12; iy = 26; s3 = 3;
    color("black") translate([ix, iy]) {
        square([1.5 * s3, 0.125 * s3]);              // leg flat against the ply
        square([0.125 * s3, 1.5 * s3]);              // free leg, pointing outboard
    }
    label("L cross-section (3x)", ix + 2.2, iy + 6.6, 1.2, "left");
    label("one leg flat on the wood,", ix + 2.2, iy - 2.2, 1.0, "left");
    label("free leg points outboard —", ix + 2.2, iy - 3.7, 1.0, "left");
    label("only brushes the mattress's", ix + 2.2, iy - 5.2, 1.0, "left");
    label("2\" foam side overhang (harmless)", ix + 2.2, iy - 6.7, 1.0, "left");

    // ---- title + notes ----
    label("HEADBOARD SWAY BRACE — L-angle to Panel C's OWN side rail (side elevation, one of 2)", panel_c_length/2 + 2, z_hb1 + 6, 1.9);
    label("Anchored WITHIN Panel C (not Panel B): the flush platform now caps Panel B's rails where the old arms landed,", panel_c_length/2 + 2, z_hb1 + 3.8, 1.2);
    label("and Panel B lifts out without touching the braces. Slotted angle is pre-punched — no steel drilling, pick the slots that line up.", panel_c_length/2 + 2, z_hb1 + 2.2, 1.2);
    label("Why an L-profile and not flat strap: under braking one brace loads in COMPRESSION — 30\" of 1/8\" flat strap buckles; the angle's second leg resists it.", panel_c_length/2 + 2, -4, 1.2);
    label("FRONT (B/C seam) at left — TAILGATE at right. Heights computed from params.scad.", panel_c_length/2 + 2, -6.4, 1.1);
}

color("black") drawing();
