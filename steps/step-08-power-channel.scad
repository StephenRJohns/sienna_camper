// Step 8 (power channel): two cords share this channel now, running
// opposite directions along the same right-side rail —
//   1. The induction cooktop's cord: kitchen unit (bottom) forward
//      through Panels C, B, A to the front console AC outlet.
//   2. The fridge's DC line: the DELTA 3 (Panel A's right drawer,
//      top) back through Panels A, B to the fridge (Panel C, bottom)
//      — the fridge now runs off the DELTA 3, not the van's rear
//      outlet (Section 1), so unlike the old design it DOES need a
//      cord run of its own.
// Because every panel is still an independent module, BOTH cords
// cross a seam at each panel boundary — those crossings need a
// quick-disconnect connector or a coiled service loop (marked with a
// circle + label here) so a panel can still be lifted out without
// cutting or re-threading either cord.
//
// Orientation matches top_view.scad: front of the vehicle (Panel A,
// now the frontmost sleeping panel) at the TOP, tailgate (Panel C,
// with the headboard/pantry mounted on its deck) at the BOTTOM.
include <../params.scad>

stroke = 0.3;
grommet_r = 0.9;
qd_r = 1.2;
tick_len = 2;
tick_gap = 2;

module rect_outline(w, l, s = stroke) {
    difference() {
        square([w, l]);
        translate([s, s]) square([w - 2*s, l - 2*s]);
    }
}

// front (Panel A) at the top, tailgate (Panel C) at the bottom
y_panel_c = 0;
y_panel_b = y_panel_c + panel_c_length;
y_panel_a = y_panel_b + panel_b_length;
top_y     = y_panel_a + panel_a_length;

module drawing() {
    // context outlines for panels A/B/C (each an independent module)
    translate([-panel_width/2, y_panel_a]) rect_outline(panel_width, panel_a_length);
    translate([-panel_width/2, y_panel_b]) rect_outline(panel_width, panel_b_length);
    translate([-panel_width/2, y_panel_c]) rect_outline(panel_width, panel_c_length);
    translate([x_kitchen - kitchen_box_width/2, y_panel_c + panel_c_length - kitchen_box_length]) rect_outline(kitchen_box_width, kitchen_box_length);
    translate([x_fridge_module - fridge_module_width/2, y_panel_c + panel_c_length - fridge_ext_width]) rect_outline(fridge_module_width, fridge_ext_width);
    translate([x_kitchen, y_panel_c + 4.8])
        text("Fridge: DC line", size = 1.0, halign = "center", valign = "center");
    translate([x_kitchen, y_panel_c + 3.5])
        text("from DELTA 3", size = 1.0, halign = "center", valign = "center");
    translate([x_kitchen, y_panel_c + 2.2])
        text("(2nd channel, left rail)", size = 0.9, halign = "center", valign = "center");

    // cooktop channel: along the +X side, from the kitchen unit
    // (bottom) forward to Panel A's front edge (top)
    rail_x = panel_width/2 - stroke * 3;
    for (y = [0 : (tick_len + tick_gap) : top_y])
        translate([rail_x, y])
            square([stroke * 2, min(tick_len, top_y - y)]);

    // short jog from the kitchen unit (offset to one side) out to
    // the side rail
    kitchen_y0 = y_panel_c + panel_c_length - kitchen_box_length;
    translate([x_kitchen, kitchen_y0 + kitchen_box_length/2])
        square([rail_x - x_kitchen, stroke * 2]);

    // grommet at the kitchen unit (rear/bottom)
    translate([rail_x + stroke, kitchen_y0])
        circle(r = grommet_r);

    // grommet near Panel A's front edge (top)
    translate([rail_x + stroke, top_y - 1])
        circle(r = grommet_r);

    // quick-disconnect / service-loop markers at each module seam the
    // cooktop's cord crosses
    for (y = [y_panel_b, y_panel_a])
        translate([rail_x + stroke, y])
            circle(r = qd_r);

    // fridge DC line channel: a 2nd rail, offset to the -X side of
    // the cooktop's, running from the DELTA 3 (Panel A, near the
    // top) back to the fridge (Panel C, bottom) — opposite direction,
    // same 2 seams, its own quick-disconnects
    rail2_x = rail_x - 4;
    fridge_y0 = y_panel_c + panel_c_length - fridge_ext_width;
    for (y = [fridge_y0 : (tick_len + tick_gap) : top_y - 4])
        translate([rail2_x, y])
            square([stroke * 2, min(tick_len, top_y - 4 - y)]);

    // short jog from the DELTA 3 drawer (Panel A, offset to one side) to the rail
    delta3_y = top_y - 4;
    translate([rail2_x, delta3_y])
        square([panel_width/2 - 3 - rail2_x, stroke * 2]);

    // grommet at the DELTA 3 drawer (top)
    translate([rail2_x + stroke, delta3_y])
        circle(r = grommet_r);

    // grommet near the fridge (bottom)
    translate([rail2_x + stroke, fridge_y0 + 1])
        circle(r = grommet_r);

    // quick-disconnects at the 2 seams the fridge DC line crosses
    for (y = [y_panel_b, y_panel_a])
        translate([rail2_x + stroke, y])
            circle(r = qd_r);

    // captions below the whole drawing — safely inside the
    // horizontal extent already established by the module outlines
    translate([0, -6])
        text("Power channels: cooktop (right rail) + fridge DC line (left rail)", size = 1.8, halign = "center", valign = "center");
    translate([0, -10])
        text("cooktop: kitchen unit -> Panel C -> B -> A -> console outlet", size = 1.5, halign = "center", valign = "center");
    translate([0, -13.5])
        text("fridge: DELTA 3 (Panel A) -> B -> C -> fridge DC input", size = 1.5, halign = "center", valign = "center");
    translate([0, -17])
        text("(large circles = quick-disconnect at each panel seam)", size = 1.4, halign = "center", valign = "center");
}

color("black") drawing();
