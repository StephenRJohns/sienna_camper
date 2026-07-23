// ============================================================
// Spare-tire stowage — EXPLODED ISOMETRIC (woodworking-plan line-art,
// see steps/lego_lib.scad). RJ-MODINI kit (28.5" dia, T155/85R18 on a
// steel wheel, ~40 lb w/ 2-ton jack) stowed FLAT in Panel B's bay at
// the AXLE, on a cradle skid over a non-slip liner, 2 Sterilite totes
// restacked on top, one cam strap to 2 footman loops. Assemble the
// skid once from offcut; access is emergency-only (steps at right).
//
// Render with: openscad -o renders/spare-stow-detail.svg spare_stow_detail.scad
// ============================================================

include <steps/lego_lib.scad>
include <colors.scad>

PT = panel_thickness;
LB = panel_b_length;     // 29
W  = panel_width;        // 46
RS = frame_rail_sz;
LH = leg_height_ab; // Panel B: legs 3/4" shorter since the deck recess
spare_d = 28.5; spare_t = 6.4;

module marker3d(n, anchor3, off = [6, 4]) {
    q = p2(anchor3); t = q + off;
    color(INK) line2d(q, t - off * (2.2 / max(2.2, norm(off))));
    color(marker_col(n)) translate(t) circle(r = 1.4);
    color("white") translate(t) text(str(n), size = 1.4, halign = "center", valign = "center");
}
module side_list(list_x, top_y, title, items) {
    color(INK) translate([list_x, top_y]) text(title, size = 1.6, halign = "left", valign = "center");
    for (i = [0 : len(items) - 1]) {
        y = top_y - 4 - i * 4.0;
        color(marker_col(i + 1)) translate([list_x + 0.8, y]) circle(r = 1.2);
        color("white") translate([list_x + 0.8, y]) text(str(i + 1), size = 1.1, halign = "center", valign = "center");
        color(INK) translate([list_x + 3.4, y]) text(items[i], size = 1.1, halign = "left", valign = "center");
    }
}
// white iso disc (tire lying flat) with black rim
module iso_disc(pos, r, h) {
    ifill("White") translate(pos) cylinder(h = h, r = r, $fn = 54);
    ifill(INK) translate(pos) difference() { cylinder(h = h, r = r, $fn = 54); translate([0, 0, -0.5]) cylinder(h = h + 1, r = r - 0.16, $fn = 54); }
    ifill(INK) translate(pos + [0, 0, h]) difference() { cylinder(h = 0.16, r = 5.4, $fn = 40); translate([0, 0, -0.5]) cylinder(h = 1, r = 5.0, $fn = 40); } // hub ring (small, centered)
}

module drawing() {
    // Panel B bare cube (context)
    lib_frame_ring(LB, W); lib_legs(LB, W);
    // full-cube bottom rails (all 4 faces) — Panel B's defining feature
    wbox([-W/2 + leg_inset, 0, bottom_rail_z], [W - 2*leg_inset, RS, RS], [0, 0], true);
    wbox([-W/2 + leg_inset, LB - RS, bottom_rail_z], [W - 2*leg_inset, RS, RS], [0, 0], true);
    // footman loops on the bottom rails (strap anchors)
    ifill("DarkGoldenrod") for (x = [-W/4, W/4]) translate([x, 0.2, bottom_rail_z + RS]) cube([1.5, 1, 1]);

    // exploded stack, lifted above the bay
    z0 = LH + 6;
    dz = 8;
    // A liner
    wbox([-19, 3, z0], [38, LB - 6, 0.3]);
    // B cradle skid: 2 battens (along Y) + 3 cleats (along X)
    ifill("SaddleBrown") {
        for (x = [-12, 10]) translate([x, 3, z0 + dz]) cube([3, LB - 6, 1]);
        for (y = [3, LB/2 - 1, LB - 7]) translate([-15, y, z0 + dz + 1]) cube([30, 3, 2.5]);
    }
    // C spare, flat, valve up, tool case nested in the barrel
    iso_disc([0, LB/2, z0 + 2*dz], spare_d/2, spare_t);
    wbox([-5, LB/2 - 2, z0 + 2*dz + 1], [10, 4, 3.6]);   // tool case
    // D 2 totes restacked
    wbox([-11, 3, z0 + 3*dz], [22, panelb_tote_l*0.5, panelb_tote_h]);
    wbox([-11, 3, z0 + 3*dz + panelb_tote_h + 0.3], [22, panelb_tote_l*0.5, panelb_tote_h]);
    // E cam strap over the top + down the sides to the footman loops
    ifill("Crimson") {
        translate([-W/4, LB/2 - 0.4, z0 + 3*dz + 2*panelb_tote_h + 0.3]) cube([W/2, 0.8, 0.6]);
        translate([-W/4 - 0.4, LB/2 - 0.4, bottom_rail_z + RS]) cube([0.7, 0.8, z0 + 3*dz + 2*panelb_tote_h - bottom_rail_z]);
        translate([W/4, LB/2 - 0.4, bottom_rail_z + RS]) cube([0.7, 0.8, z0 + 3*dz + 2*panelb_tote_h - bottom_rail_z]);
    }
    // down-assembly arrows
    for (z = [z0 + dz*0.5, z0 + dz*1.5, z0 + dz*2.5])
        iarrow([16, LB/2, z + 3], [16, LB/2, z - 1], 0.5);

    // markers
    marker3d(1, [0, LB/2, z0 + 2*dz + spare_t], [8, 8]);              // spare
    marker3d(2, [-13, LB/2, z0 + dz + 2], [-12, 4]);                 // skid
    marker3d(3, [0, LB/2, z0 + 2*dz + 2], [10, -4]);               // tool case
    marker3d(4, [0, 4, z0 + 3*dz + panelb_tote_h], [-12, 8]);      // totes
    marker3d(5, [W/4, LB/2, z0 + 3*dz + 2*panelb_tote_h], [10, 4]); // strap
    marker3d(6, [-W/4, 0.7, bottom_rail_z + RS], [-12, -4]);       // footman

    cap("SPARE TIRE — flat in Panel B's bay at the AXLE (Component 3), exploded stack", 0, -24, 1.9);
    cap("Best weight placement in the van — no hitch basket needed. NOTHING screws to the van floor: the skid sits on the liner, the strap ties to footman loops on the bottom rails.", 0, -26.5, 1.2);
    cap(str("Height stack: cleats 3\" (clear the ", bottom_rail_z + RS, "\" curb) + spare ", spare_t, "\" + tote ", panelb_tote_h, "\" — fits under the ", LH + RS, "\" deck. Kitchen-drawer slot does NOT fit the 28.5\" disc; the drawer stays."), 0, -28.7, 1.2);

    side_list(W/2 + 20, LH + 10, "Exploded stack (top -> bottom)", [
        "Spare, FLAT, valve stem UP (pressure checks in place)",
        "Cradle skid: 3x 3\" cleats on 2 battens (offcut), one piece",
        "Tool case (2-ton jack + wrenches) nested in the wheel barrel",
        "2x Sterilite totes restacked on top",
        "1\" cam strap over the whole stack",
        "2x footman loops, #10x3/4\" into the bottom rails (strap anchors)",
    ]);
    side_list(W/2 + 20, -2, "Access (emergency-only, no tools)", [
        "Lift the mattress + platform slats off",
        "Lift out the 2 totes (they stay packed)",
        "Pop the cam buckle, lift out the tool case",
        "Tilt the spare upright, roll it over Panel C, out the gate",
    ]);
}

drawing();
