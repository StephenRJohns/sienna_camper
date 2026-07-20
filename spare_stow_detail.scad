// ============================================================
// Spare-tire stowage detail (2D) — RJ-MODINI kit (28.5" dia, ~6.4"
// stored w/ case, T155/85R18 on a steel wheel) stowed FLAT inside Panel B's deep-storage
// bay, raised on cleats above the bottom-rail curb, with 2 of the
// Sterilite totes restacked on top. Two views: top-down of Panel B
// + a side elevation of the height stack.
//
// Why Panel B: the 28.5" disc clears the bay's interior (29" x 43"
// between rails, corner legs missed by >4"), sits at the AXLE (the
// best place in the van for ~40 lb), and the spare is emergency-only
// gear — the lift-the-platform access cost is paid ~never.
//
// Render with: openscad -o renders/spare-stow-detail.svg spare_stow_detail.scad
// ============================================================

include <params.scad>
include <colors.scad>
stroke = 0.3;

spare_d  = 28.5;   // RJ-MODINI rolling diameter (T155/85R18 — matches OE within 2%)
spare_t  = 6.4;    // stored width incl. case = stack height lying flat (T155 section 6.1)
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
    // spare: 28.5 disc, driver side (drawn at low y)
    cx = L/2; cy = spare_d/2 + 0.5;
    color("DimGray") translate([cx, cy]) difference() { circle(r = spare_d/2, $fn = 90); circle(r = spare_d/2 - 0.35, $fn = 90); }
    color("DimGray") translate([cx, cy]) difference() { circle(r = 5.2, $fn = 40); circle(r = 4.9, $fn = 40); } // steel wheel
    color("DimGray") for (a = [0:72:288]) translate([cx, cy]) rotate(a) translate([7.5, 0]) circle(r = 0.5, $fn = 12);
    label("RJ-MODINI kit", cx, cy + 2.2, 1.5);
    label(str(spare_d, "\" dia x ", spare_t, "\" — flat, valve UP"), cx, cy - 0.2, 1.1);
    label("on 3 cleats + strap", cx, cy - 2.4, 1.1);
    // 3 cleats under it (radial pads)
    color("SaddleBrown") for (a = [90, 210, 330]) translate([cx, cy]) rotate(a) translate([9.5, 0]) square([4, 2], center = true);
    // clearance callouts
    label(str("bay 29\" x 43\" — 28.5\" disc fits with 1/4\" per end, clears the corner legs by >4\""), L/2, W + 2, 1.2);
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
// VIEW 3 — INSTALLATION, exploded: what screws to what
// ------------------------------------------------------------
module lmarker(t, x, y) {
    translate([x, y]) { color("DarkSlateBlue") circle(r = 1.3); color("white") text(t, size = 1.4, halign = "center", valign = "center"); }
}
module install() {
    L = panel_b_length;
    label("INSTALLATION — exploded stack (assemble the skid once, from offcut)", L/2 + 2, 33, 1.5);
    // van floor
    color("black") translate([-3, -0.5]) square([L + 6, 0.5]);
    label("van floor — NOTHING screws into it; the skid just sits, liner grips", L/2, -2.2, 1.05);
    // A: non-slip liner
    color("DarkSlateGray") translate([2, 1.8]) square([L - 4, 0.35]);
    lmarker("A", -1.5, 2);
    // B: cradle skid — 2 battens + 3 cleats (side view shows 2 of the 3)
    color("SaddleBrown") {
        translate([3, 4.6]) square([L - 6, 0.75]);          // batten
        for (x = [4.5, L/2 - 2, L - 8.5]) translate([x, 5.35]) square([4, 2.25]);  // cleats
    }
    lmarker("B", -1.5, 5.6);
    label("glue + 1.25\" screws, cleats to battens", L/2, 8.6, 1.0);
    // C: spare, valve up, tool case nested (dashed = inside the barrel)
    color("DimGray") translate([0.65, 11]) rect_outline(spare_d, spare_t, 0.35);
    color("Gray") translate([L/2 - 5, 12.2]) rect_outline(10, 3.6, 0.2);
    label("tool case nests IN the wheel barrel", L/2, 10, 1.0);
    label("spare FLAT, valve stem UP", L/2, 14.2, 1.05);
    lmarker("C", -1.5, 14.2);
    // D: totes
    color("Gainsboro") translate([2.6, 19.5]) rect_outline(panelb_tote_l, panelb_tote_h, 0.3);
    label("2 totes restack on top", L/2, 22.5, 1.05);
    lmarker("D", -1.5, 22.4);
    // E: strap + footman loops on the bottom rails
    color("Crimson") {
        translate([0.4, 19.5 + panelb_tote_h + 0.6]) square([L - 0.8, 0.5]);
        translate([0.4, 2.6]) square([0.5, 17.5 + panelb_tote_h]);
        translate([L - 0.9, 2.6]) square([0.5, 17.5 + panelb_tote_h]);
    }
    color("DarkGoldenrod") for (x = [-0.6, L - 0.9]) translate([x, 1.6]) square([1.5, 1]);
    lmarker("E", L + 2.5, 26.5);
    label("cam strap OVER the stack", L/2, 27.6, 1.05);
    label("footman loops on the", L + 3.2, 1.9, 1.0, "left");
    label("bottom rails, 2x", L + 3.2, 0.3, 1.0, "left");
    // local legend
    ly = -16;
    lparts = ["A  non-slip liner offcut (grips the van floor — same roll as the drawer liner)",
              "B  cradle skid: 3x 3\" cleats screwed to 2x 1x3 battens — one piece, can't wander",
              "C  RJ-MODINI spare flat + tool case in the barrel (valve up = pressure checks in place)",
              "D  2x Sterilite totes restacked on top",
              "E  1\" cam-buckle strap -> 2x 1\" footman loops, #10 x 3/4\" screws into Panel B's bottom rails"];
    for (i = [0 : len(lparts) - 1]) label(lparts[i], -3, ly - i * 2.2, 1.0, "left");
}

// ------------------------------------------------------------
// VIEW 4 — ACCESS sequence (4 steps, emergency-only)
// ------------------------------------------------------------
module bay_side() {
    L = panel_b_length;
    rect_outline(1.5, leg_height);
    translate([L - 1.5, 0]) rect_outline(1.5, leg_height);
    translate([0, leg_height]) rect_outline(L, frame_rail_sz);
    translate([0, bottom_rail_z]) rect_outline(L, frame_rail_sz);
}
module arrow_up(x, y, len = 4) {
    color("ForestGreen") translate([x, y]) { square([0.6, len]); translate([0.3, len]) polygon([[-1.1, 0], [1.1, 0], [0, 1.8]]); }
}
module stack_in_bay(with_totes = true, with_case = true, strapped = true) {
    L = panel_b_length;
    color("SaddleBrown") translate([3, 0]) square([L - 6, cleat_h]);
    color("DimGray") translate([0.65, cleat_h]) rect_outline(spare_d, spare_t, 0.35);
    if (with_case) color("Gray") translate([L/2 - 5, cleat_h + 1.2]) rect_outline(10, 3.6, 0.2);
    if (with_totes) color("Gainsboro") translate([2.6, cleat_h + spare_t]) rect_outline(panelb_tote_l, panelb_tote_h, 0.3);
    if (strapped) color("Crimson") translate([0.9, (with_totes ? cleat_h + spare_t + panelb_tote_h : cleat_h + spare_t) + 0.15]) square([L - 1.8, 0.5]);
}
module access() {
    L = panel_b_length;
    pitch = L + 9;
    label("ACCESS — 4 steps, no tools (emergency-only: you pay this ~never)", 2 * pitch - 4, 36, 1.6);
    // step 1: platform + mattress off
    translate([0 * pitch, 0]) {
        bay_side(); stack_in_bay();
        color("SteelBlue") translate([-2, leg_height + 6]) rect_outline(L + 4, 0.75);
        color("MediumPurple") translate([-2, leg_height + 7]) rect_outline(L + 4, 2.5);
        arrow_up(L/2 - 0.3, leg_height + 10.5);
        label("1. lift the mattress +", L/2, -3, 1.15);
        label("platform slats off", L/2, -4.9, 1.15);
    }
    // step 2: totes out
    translate([1 * pitch, 0]) {
        bay_side(); stack_in_bay(with_totes = false, strapped = false);
        color("Gainsboro") translate([2.6, leg_height + 5]) rect_outline(panelb_tote_l, panelb_tote_h, 0.3);
        arrow_up(L/2 - 0.3, leg_height + 12);
        label("2. lift out the 2 totes", L/2, -3, 1.15);
        label("(they stay packed)", L/2, -4.9, 1.15);
    }
    // step 3: strap + tool case
    translate([2 * pitch, 0]) {
        bay_side(); stack_in_bay(with_totes = false, with_case = false, strapped = false);
        color("Crimson") { translate([0.9, cleat_h + spare_t + 0.3]) square([8, 0.5]); translate([8.9, cleat_h + spare_t - 1]) square([0.5, 2]); }
        color("Gray") translate([L/2 - 5, leg_height + 5]) rect_outline(10, 3.6, 0.2);
        arrow_up(L/2 - 0.3, leg_height + 9.8);
        label("3. pop the cam buckle,", L/2, -3, 1.15);
        label("lift out the tool case", L/2, -4.9, 1.15);
    }
    // step 4: tilt + roll out
    translate([3 * pitch, 0]) {
        bay_side();
        color("SaddleBrown") translate([3, 0]) square([L - 6, cleat_h]);
        color("DimGray") translate([L/2, spare_d/2]) difference() { circle(r = spare_d/2, $fn = 90); circle(r = spare_d/2 - 0.5, $fn = 90); }
        color("ForestGreen") { translate([L - 2, spare_d/2]) square([7, 0.6]); translate([L + 5, spare_d/2 - 0.8]) polygon([[0, 0], [0, 2.2], [1.8, 1.1]]); }
        label("4. tilt it upright, roll it", L/2, -3, 1.15);
        label("over Panel C, out the gate", L/2, -4.9, 1.15);
    }
}

// ------------------------------------------------------------
// layout + legend
// ------------------------------------------------------------
topdown();
translate([panel_b_length + 14, 4]) elevation();
translate([2 * panel_b_length + 32, 12]) install();
translate([0, -80]) access();

leg_x = 0; leg_y = -9;
items = ["RJ-MODINI kit (T155/85R18, steel wheel, ~40 lb w/ 2-ton jack) — flat, valve up",
         "Cradle skid: 3x ~3\" cleats on 2 battens (offcut) — clears the bottom-rail curb, one piece",
         "Jack + wrench kit in its case, nested in the wheel barrel",
         "Cam strap over the stack -> 2 footman loops on Panel B's bottom rails"];
label("Legend", leg_x, leg_y, 1.5, "left");
for (i = [0 : len(items) - 1]) {
    marker(i + 1, leg_x + 1, leg_y - 3 - i * 2.8);
    label(items[i], leg_x + 3.2, leg_y - 3 - i * 2.8, 1.1, "left");
}
label("SPARE TIRE — INSIDE, in Panel B's bay at the AXLE (best weight placement in the van; no hitch basket needed)",
      panel_b_length + 11, -27, 1.5);
label("Trade-offs: 2 of Panel B's 4 totes restack ON the spare (2 come out); access = lift the platform + mattress — acceptable for emergency-only gear.",
      panel_b_length + 11, -29.6, 1.1);
label("NOTE: the kitchen-drawer slot does NOT fit the spare (28.5\" disc vs ~24\" before the fridge blocks it) — the drawer stays.",
      panel_b_length + 11, -31.8, 1.1);
