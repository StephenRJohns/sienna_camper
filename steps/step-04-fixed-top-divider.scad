// Step 4: Screw the panel top down FIXED (no hinge — storage is
// reached from the side via drawers now, not by lifting the top),
// then install the center divider rail that splits the storage bay
// into a left and right drawer run. Shown as a cross-section
// through the middle of Panel A (looking toward the front of the
// module) so the divider and both drawer bays are visible at once —
// same construction on Panel B and C.
include <../params.scad>

stroke = 0.3;

module rect_outline(w, l, s = stroke) {
    difference() {
        square([w, l]);
        translate([s, s]) square([w - 2*s, l - 2*s]);
    }
}

module label(txt, x, y, size = 1.8) {
    translate([x, y]) text(txt, size = size, halign = "center", valign = "center");
}

module drawing() {
    z_rail = leg_height;
    z_deck = leg_height + frame_rail_sz;
    leg_x0 = -panel_width/2 + leg_inset;
    leg_x1 = panel_width/2 - frame_rail_sz - leg_inset;

    // legs (thin, de-emphasized — full detail is in Step 2)
    translate([leg_x0, 0]) rect_outline(frame_rail_sz, leg_height);
    translate([leg_x1, 0]) rect_outline(frame_rail_sz, leg_height);

    // long rail cross-sections (cut through, at the module's outer
    // edges, sitting atop the legs)
    translate([-panel_width/2, z_rail]) rect_outline(frame_rail_sz, frame_rail_sz);
    translate([panel_width/2 - frame_rail_sz, z_rail]) rect_outline(frame_rail_sz, frame_rail_sz);

    // fixed panel top — screwed straight down onto the rails, no hinge
    translate([-panel_width/2, z_deck]) rect_outline(panel_width, panel_thickness);
    for (sx = [-1, -0.5, 0, 0.5, 1])
        translate([sx * panel_width/2 * 0.85, z_deck + panel_thickness/2])
            circle(r = 0.18);
    label(str("Panel top ", panel_a_length, "\" x ", panel_width, "\" — FIXED, screwed to rails (no hinge)"),
          0, z_deck + panel_thickness + 5.5, 1.7);
    label("screws marked with dots", 0, z_deck + panel_thickness + 2, 1.3);

    // center divider rail — splits the bay into left/right drawer runs
    translate([-drawer_divider_t/2, 0]) rect_outline(drawer_divider_t, leg_height);
    label("Center divider", 0, drawer_height + 2.5, 1.4);

    // drawer bay footprints, left and right of the divider
    translate([drawer_divider_t/2, 0]) rect_outline(drawer_travel, drawer_height);
    translate([-drawer_divider_t/2 - drawer_travel, 0]) rect_outline(drawer_travel, drawer_height);
    label("Right drawer bay", drawer_divider_t/2 + drawer_travel/2, drawer_height/2 + 2.6, 1.4);
    label(str(drawer_travel, "\" x ", drawer_height, "\""), drawer_divider_t/2 + drawer_travel/2, drawer_height/2 - 0.6, 1.2);
    label("Left drawer bay", -drawer_divider_t/2 - drawer_travel/2, drawer_height/2 + 2.6, 1.4);
    label(str(drawer_travel, "\" x ", drawer_height, "\""), -drawer_divider_t/2 - drawer_travel/2, drawer_height/2 - 0.6, 1.2);

    label("Cross-section through Panel A's middle, looking toward the front — same on B, C", 0, -4.5, 1.5);
}

color("black") drawing();
