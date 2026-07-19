// ============================================================
// Side-profile line drawing (2D) — Sienna camper platform
// ============================================================
// Drawn directly in the Y-Z (length-height) plane as outline
// rectangles, the same reliable technique as top_view.scad —
// NOT a projection() of the 3D model, which only yields an outer
// silhouette and loses every internal seam/leg line.
//
// This is the VERTICAL-FIT view: van floor to ceiling, with the
// true stack drawn at real heights — panel boxes on the floor (on
// their leveling feet), the bed platform directly on Panel A/B's
// top rails (ending flush at the B/C seam), the mattress on the
// platform + Panel C's deck, the headboard/pantry on Panel C's
// deck — and the remaining clearances called out on the right.
//
// Render with: openscad -o renders/side-profile.svg side_view.scad
// ============================================================

include <params.scad>

stroke = 0.3;

module rect_outline(w, l, s = stroke) {
    difference() {
        square([w, l]);
        translate([s, s]) square([w - 2*s, l - 2*s]);
    }
}

module label(txt, x, y, size = 2.2, halign = "center") {
    translate([x, y]) text(txt, size = size, halign = halign, valign = "center");
}

module dashed_line(x1, x2, y, dash = 1, gap = 0.8) {
    span = x2 - x1;
    n = max(1, floor(span / (dash + gap)));
    for (i = [0 : n])
        translate([x1 + i * (dash + gap), y])
            square([min(dash, x2 - (x1 + i * (dash + gap))), stroke]);
}

// vertical dimension bracket with ticks at both ends, label to the right
module dim_v(x, z0, z1, txt, size = 1.4) {
    translate([x, z0]) square([stroke, z1 - z0]);
    translate([x - 1, z0]) square([2, stroke]);
    translate([x - 1, z1 - stroke]) square([2, stroke]);
    label(txt, x + 2, (z0 + z1)/2, size, "left");
}

module side_view() {
    // ---- real stack heights, straight from params ----
    z_rail_top = leg_height + frame_rail_sz;                    // 18.5 — top of the panel frame rails
    z_deck     = z_rail_top + panel_thickness;                  // 19.25 — Panel C's deck surface (A/B have no deck)
    z_pads     = z_rail_top;                                    // platform sits DIRECTLY on the box rails now
    z_plat_top = z_pads + bed_frame_thickness;                  // 20.5 — bed platform's sleeping surface
    z_matt_top = z_plat_top + mattress_total_thickness;         // 27.5 — mattress top
    z_pan_top  = z_deck + pantry_cluster_h;                     // 37.85 — rear-pantry cluster top

    y_panel_a = 0;
    y_panel_b = y_panel_a + panel_a_length;
    y_panel_c = y_panel_b + panel_b_length;
    y_pantry = y_panel_c + panel_c_length - pantry_len;

    // ---- van envelope: floor + ceiling, hard max ----
    rect_outline(van_interior_length, van_interior_height);
    translate([0, -stroke]) square([van_interior_length, stroke]); // ground line
    label("VAN FLOOR", van_interior_length/2, -2.4, 1.6);
    label(str("CEILING — ", van_interior_height, "\" interior height (hard max; curves down toward the walls)"),
          van_interior_length/2, van_interior_height + 2.4, 1.6);

    // ---- panel boxes: legs at both ends + rail line; Panel C also
    // gets its fixed deck plank ----
    panel_lengths = [panel_a_length, panel_b_length, panel_c_length];
    panel_names = ["Panel A", "Panel B", "Panel C"];
    panel_ys = [y_panel_a, y_panel_b, y_panel_c];
    for (i = [0:2]) {
        translate([panel_ys[i], 0]) rect_outline(frame_rail_sz, leg_height);
        translate([panel_ys[i] + panel_lengths[i] - frame_rail_sz, 0]) rect_outline(frame_rail_sz, leg_height);
        translate([panel_ys[i], leg_height]) rect_outline(panel_lengths[i], frame_rail_sz); // top rail
        label(panel_names[i], panel_ys[i] + panel_lengths[i]/2, leg_height * 0.8, 1.7);
        label(str(panel_lengths[i], "\" x ", leg_height + frame_rail_sz, "\" box"), panel_ys[i] + panel_lengths[i]/2, leg_height * 0.62, 1.3);
        label("on the floor", panel_ys[i] + panel_lengths[i]/2, leg_height * 0.47, 1.2);
    }
    // Panel C's fixed deck
    translate([y_panel_c, z_rail_top]) rect_outline(panel_c_length, panel_thickness);

    // fridge + kitchen hidden below deck inside Panel C
    dashed_line(y_panel_c, y_panel_c + panel_c_length, leg_height * 0.4);
    label("fridge + kitchen below deck (see rear view)", y_panel_c + panel_c_length/2, leg_height * 0.4 - 2, 1.2);

    // ---- bed platform: spans Panel A + B only, ends flush at the
    // B/C seam (Panel C's own deck is at the same surface height) ----
    translate([y_panel_a, z_pads]) rect_outline(bed_frame_length, bed_frame_thickness);
    label(str("bed platform (", bed_frame_length, "\" x ", bed_frame_thickness, "\" — ends at the B/C seam, flush with Panel C's deck)"), bed_frame_length * 0.3, z_pads + bed_frame_thickness + 1.3, 1.3);

    // ---- mattress, true thickness ----
    translate([y_panel_a, z_plat_top]) rect_outline(mattress_length, mattress_total_thickness);
    label(str("Mattress ", mattress_length, "\" x ", mattress_total_thickness, "\" thick — top at ", z_matt_top, "\""),
          mattress_length/2, z_plat_top + mattress_total_thickness/2, 1.8);

    // ---- rear pantry (prefab 2x2 drawer cluster) on Panel C's deck ----
    translate([y_pantry, z_deck]) rect_outline(pantry_unit_d, pantry_cluster_h);
    // seam between the two stacked drawer rows
    translate([y_pantry, z_deck + pantry_unit_h]) square([pantry_unit_d, stroke]);
    label("Rear", y_pantry + pantry_unit_d/2, z_deck + pantry_cluster_h - 3, 1.4);
    label("pantry", y_pantry + pantry_unit_d/2, z_deck + pantry_cluster_h - 5.3, 1.4);
    label("(prefab)", y_pantry + pantry_unit_d/2, z_deck + pantry_cluster_h - 7.6, 1.1);

    // ---- right-margin vertical dimension callouts ----
    dx = van_interior_length + 3;
    dim_v(dx, 0, z_rail_top, str("box: ", z_rail_top, "\" (16\" legs + 1\" leveling feet + 1.5\" rail)"), 1.3);
    dim_v(dx, z_rail_top, z_matt_top, str("+3/4\" platform +", mattress_total_thickness, "\" mattress = ", z_matt_top, "\""), 1.3);
    dim_v(dx, z_matt_top, van_interior_height, str("sitting headroom: ", van_interior_height - z_matt_top, "\""), 1.3);
    dim_v(dx + 34, z_deck, z_pan_top, str("pantry cluster: ", pantry_cluster_h, "\" (top at ", z_pan_top, "\")"), 1.3);
    dim_v(dx + 34, z_pan_top, van_interior_height, str("to ceiling: ", van_interior_height - z_pan_top, "\""), 1.3);

    // pantry note, under the drawing
    label(str("rear-pantry cluster top at ", z_pan_top, "\" -> ", van_interior_height - z_pan_top,
              "\" of roof clearance | Power strip 1 + ROLL level on the deck edge beside it"),
          van_interior_length/2, -5.5, 1.5);
    label("FRONT SEATS at left — TAILGATE at right. Every height above is computed from params.scad, not sketched.",
          van_interior_length/2, -8.5, 1.4);
}

color("black") side_view();
