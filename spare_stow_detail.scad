// ============================================================
// Spare-tire stowage detail (2D) — Modern Spare kit (27.7" dia x
// 5.7" wide, T145/85R18) stowed FLAT inside Panel B's deep-storage
// bay, raised on cleats above the bottom-rail curb, with 2 of the
// Sterilite totes restacked on top. Two views: top-down of Panel B
// + a side elevation of the height stack.
//
// Why Panel B: the 27.7" disc clears the bay's interior (29" x 43"
// between rails, corner legs missed by >4"), sits at the AXLE (the
// best place in the van for 35 lb), and the spare is emergency-only
// gear — the lift-the-platform access cost is paid ~never.
//
// Render with: openscad -o renders/spare-stow-detail.svg spare_stow_detail.scad
// ============================================================

include <params.scad>
include <colors.scad>
stroke = 0.3;

spare_d  = 27.7;   // Modern Spare rolling diameter (T145/85R18)
spare_t  = 5.7;    // section width = stack height lying flat
cleat_h  = 3;      // raises the spare above the bottom-rail curb (top at 2.5")

module rect_outline(w, h, s = stroke) {
    color("black") difference() { square([w, h]); translate([s, s]) square([w - 2*s, h - 2*s]); }
}
module label(txt, x, y, size = 1.4, ha = "center") {
    color("black") translate([x, y]) text(txt, size = size, halign = ha, valign = "center");
}
module marker(n, x, y) {
    translate([x, y]) { color(marker_col(n)) circle(r = 1.3); color("white") text(str(n), size = 1.4, halign = "center", valign = "center"); }
}

// ------------------------------------------------------------
// VIEW 1 — top-down of Panel B's bay (29 fore-aft x 43 between rails)
// ------------------------------------------------------------
module topdown() {
    L = panel_b_length;                    // 29
    W = panel_width - 2*frame_rail_sz;     // 43 between side rails
    rect_outline(L, W);                    // bay interior, x = fore-aft
    // corner legs
    color("Gray") for (x = [0, L - 1.5]) for (y = [0, W - 1.5])
        translate([x, y]) rect_outline(1.5, 1.5, 0.2);
    // spare: 27.7 disc, driver side (drawn at low y)
    cx = L/2; cy = spare_d/2 + 0.5;
    color("DimGray") translate([cx, cy]) difference() { circle(r = spare_d/2, $fn = 90); circle(r = spare_d/2 - 0.35, $fn = 90); }
    color("DimGray") translate([cx, cy]) difference() { circle(r = 5.2, $fn = 40); circle(r = 4.9, $fn = 40); } // alloy wheel
    color("DimGray") for (a = [0:72:288]) translate([cx, cy]) rotate(a) translate([7.5, 0]) circle(r = 0.5, $fn = 12);
    label("Modern Spare", cx, cy + 2.2, 1.5);
    label(str(spare_d, "\" dia x ", spare_t, "\" — flat, valve UP"), cx, cy - 0.2, 1.1);
    label("on 3 cleats + strap", cx, cy - 2.4, 1.1);
    // 3 cleats under it (radial pads)
    color("SaddleBrown") for (a = [90, 210, 330]) translate([cx, cy]) rotate(a) translate([9.5, 0]) square([4, 2], center = true);
    // clearance callouts
    label(str("bay 29\" x 43\" — disc clears the corner legs by >4\""), L/2, W + 2, 1.2);
    // jack + scissor kit beside it (passenger side)
    color("BurlyWood") translate([L/2 - 6, W - 11]) rect_outline(12, 8, 0.25);
    label("jack + wrench kit", L/2, W - 7, 1.05);
    label("(in its case)", L/2, W - 8.8, 0.9);
    label("DRIVER side", 5, -2, 1.2, "left");
    label("PASSENGER side", L - 5, W + 0.7, 1.2);
    label("<- Panel A   |   Panel C ->", L/2, -4.2, 1.1);
    marker(1, cx - 10, cy + 8);
    marker(2, cx, cy - 9.8);
    marker(3, L/2 + 7.5, W - 7);
    label("TOP-DOWN — Panel B bay (platform + mattress lifted off)", L/2, W + 4.5, 1.5);
}

// ------------------------------------------------------------
// VIEW 2 — side elevation: the height stack
// ------------------------------------------------------------
module elevation() {
    L = panel_b_length;
    // legs + rails
    rect_outline(1.5, leg_height);
    translate([L - 1.5, 0]) rect_outline(1.5, leg_height);
    translate([0, leg_height]) rect_outline(L, frame_rail_sz);          // top rail
    translate([0, bottom_rail_z]) rect_outline(L, frame_rail_sz);       // bottom rail band
    // platform on the rails
    color("SteelBlue") translate([-3, leg_height + frame_rail_sz]) rect_outline(L + 6, 0.75);
    label("bed platform + mattress above (lift off for access)", L/2, leg_height + frame_rail_sz + 2.4, 1.1);
    // cleats
    color("SaddleBrown") for (x = [3, L/2 - 2, L - 7]) translate([x, 0]) square([4, cleat_h]);
    // spare lying flat
    color("DimGray") translate([(L - spare_d)/2 + 0.65, cleat_h]) rect_outline(spare_d, spare_t, 0.35);
    label(str("spare, flat — top at ", cleat_h + spare_t, "\""), L/2, cleat_h + spare_t/2, 1.1);
    // 2 totes restacked on top
    color("Gainsboro") for (x = [2.2, 2.2]) translate([2.6, cleat_h + spare_t]) rect_outline(panelb_tote_l, panelb_tote_h, 0.3);
    label(str("2 totes on top (", cleat_h + spare_t + panelb_tote_h, "\") — ", leg_height + frame_rail_sz - (cleat_h + spare_t + panelb_tote_h), "\" spare headroom"), L/2, cleat_h + spare_t + panelb_tote_h + 1.4, 1.0);
    // strap over the stack to the bottom rails
    color("Crimson") {
        translate([L/2 - 0.4, cleat_h + spare_t]) square([0.8, 0.5]);
        translate([1.2, 1]) square([0.6, cleat_h + spare_t]);
        translate([L - 1.8, 1]) square([0.6, cleat_h + spare_t]);
        translate([1.2, cleat_h + spare_t + 0.1]) square([L - 2.4, 0.5]);
    }
    marker(4, L/2 + 9, cleat_h + spare_t + 0.4);
    label("SIDE ELEVATION — the height stack (van floor at 0)", L/2, leg_height + 6.5, 1.5);
    label(str("cleats ", cleat_h, "\" (clear the ", bottom_rail_z + frame_rail_sz, "\" bottom-rail curb) + spare ", spare_t, "\" + tote ", panelb_tote_h, "\" = ", cleat_h + spare_t + panelb_tote_h, "\" of the ", leg_height + frame_rail_sz, "\" available"), L/2, -2.6, 1.05);
}

// ------------------------------------------------------------
// layout + legend
// ------------------------------------------------------------
topdown();
translate([panel_b_length + 14, 4]) elevation();

leg_x = 0; leg_y = -9;
items = ["Modern Spare kit (T145/85R18, ~30-35 lb w/ jack) — flat, valve up",
         "3x wood cleats, ~3\" tall (from offcut) — lift it above the bottom-rail curb",
         "Jack + wrench kit in its case, strapped beside the totes",
         "Cam strap over the stack, anchored to Panel B's bottom rails"];
label("Legend", leg_x, leg_y, 1.5, "left");
for (i = [0 : len(items) - 1]) {
    marker(i + 1, leg_x + 1, leg_y - 3 - i * 2.8);
    label(items[i], leg_x + 3.2, leg_y - 3 - i * 2.8, 1.1, "left");
}
label("SPARE TIRE — INSIDE, in Panel B's bay at the AXLE (best weight placement in the van; no hitch basket needed)",
      panel_b_length + 11, -27, 1.5);
label("Trade-offs: 2 of Panel B's 4 totes restack ON the spare (2 come out); access = lift the platform + mattress — acceptable for emergency-only gear.",
      panel_b_length + 11, -29.6, 1.1);
label("NOTE: the kitchen-drawer slot does NOT fit the spare (27.7\" disc vs ~24\" before the fridge blocks it) — the drawer stays.",
      panel_b_length + 11, -31.8, 1.1);
