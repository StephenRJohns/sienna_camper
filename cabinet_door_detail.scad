// ============================================================
// Utility cabinet door detail — exploded isometric reference,
// woodworking-plan style (see steps/lego_lib.scad).
// ============================================================
// The door that closes off the gap between the kitchen unit and the
// fridge (where the exhaust fan vents and the control panel lives) —
// platform.scad's cabinet_door_module(), shown here at a scale where
// the 2 hinges and magnetic catch each get their own numbered marker.
// Companion to fridge_install_detail.scad (item 8 there — this is
// that same door, zoomed in).
//
// Render with: openscad -o renders/cabinet-door-detail.svg cabinet_door_detail.scad
// ============================================================

include <steps/lego_lib.scad>
include <colors.scad>

// same formulas as platform.scad's cabinet_door_module() — kept in
// sync by construction, not by reference, since that module draws in
// context of the full 3D assembly and this file draws it alone
door_x0 = x_fridge_module + fridge_ext_length / 2 + fridge_slide_margin + fridge_rail_stack; // past the fridge module's right edge + its side-mount rail/riser
door_w  = x_kitchen - kitchen_box_width / 2 - door_x0;                         // gap to the kitchen unit's left edge
door_h  = leg_height;                                                          // floor to deck underside
door_t  = 0.4;

pull = 5; // how far hinges/catch pull away from the door's own edge for the exploded view

module marker3d(n, anchor3, off = [6, 4]) {
    q = p2(anchor3);
    t = q + off;
    color(marker_col(n)) translate(t) circle(r = 1.3);
    color("white") translate(t) text(str(n), size = 1.3, halign = "center", valign = "center");
    color(INK) line2d(q, t - off * (2.2 / max(2.2, norm(off))));
}

module side_list(list_x, top_y, items) {
    color(INK) {
        translate([list_x, top_y - 1]) text("Component", size = 1.4, halign = "left", valign = "center");
        translate([list_x, top_y - 3.6]) text("Position / fastener / material", size = 1.1, halign = "left", valign = "center");
    }
    for (i = [0 : len(items) - 1]) {
        y = top_y - 10 - i * 9;
        color(marker_col(i + 1)) translate([list_x, y + 3.8]) circle(r = 1.2);
        color("white") translate([list_x, y + 3.8]) text(items[i][0], size = 1.2, halign = "center", valign = "center");
        color(INK) {
            translate([list_x + 3.2, y + 3.8]) text(items[i][1], size = 1.15, halign = "left", valign = "center");
            translate([list_x + 3.2, y + 1.9]) text(items[i][2], size = 1.0, halign = "left", valign = "center");
            translate([list_x + 3.2, y]) text(items[i][3], size = 1.0, halign = "left", valign = "center");
        }
    }
}

module drawing() {
    // context: kitchen unit's right edge + fridge module's left edge,
    // muted, so the door's actual fit is obvious
    ifill(EDGE_CTX) {
        translate([door_x0 + door_w, 0, 0]) cube([kitchen_box_width, kitchen_box_length, kitchen_box_height]);
        translate([door_x0 - fridge_rail_stack - fridge_slide_margin - fridge_ext_length, 0, fridge_tray_gap + fridge_tray_t]) cube([fridge_ext_length, fridge_ext_width, fridge_ext_height]);
    }

    // door panel, in place
    wbox([door_x0, -door_t, 0], [door_w, door_t, door_h]);

    // low exhaust louver — gives the exhaust fan's warm air a direct
    // path OUT low toward the tailgate (not just door-edge leakage)
    vx0 = door_x0 + door_w/2 - cabinet_vent_w/2;
    ifill(INK) translate([vx0, -door_t - 0.05, cabinet_vent_z - cabinet_vent_h/2])
        cube([cabinet_vent_w, 0.1, cabinet_vent_h]);
    ifill("Gainsboro") for (i = [1 : 3])
        translate([vx0 + 0.3, -door_t - 0.1, cabinet_vent_z - cabinet_vent_h/2 + i * cabinet_vent_h/4])
            cube([cabinet_vent_w - 0.6, 0.12, 0.1]); // louver slats

    // hinges — kitchen-side edge, pulled out along -Y to separate
    // them visually from the door + kitchen unit they bridge
    for (hz = [door_h * 0.2, door_h * 0.8])
        wbox([door_x0 + door_w - 0.2, -door_t - pull, hz - 0.75], [0.4, 0.8, 1.5]);
    for (hz = [door_h * 0.2, door_h * 0.8])
        fastener_light([door_x0 + door_w, -door_t - pull + 0.4, hz], 0.35, 0);
    iarrow([door_x0, -door_t - pull + 1.5, door_h * 0.5], [door_x0, -door_t - 0.3, door_h * 0.5]);

    // magnetic catch — free (fridge-side) edge, pulled out the same way
    wbox([door_x0 + 0.1, -door_t - pull, door_h/2 - 0.5], [0.5, 0.8, 1]);
    iarrow([door_x0 + door_w - 0.25, -door_t - pull + 1.5, door_h/2], [door_x0 + door_w - 0.25, -door_t - 0.3, door_h/2]);

    marker3d(1, [door_x0 + door_w/2, -door_t/2, door_h * 0.6], [10, 6]);
    marker3d(2, [door_x0 + door_w, -door_t - pull + 0.4, door_h * 0.2], [11, -4]);
    marker3d(3, [door_x0 + 0.25, -door_t - pull + 0.4, door_h/2], [-10, -8]);
    marker3d(4, [door_x0 + door_w/2, -door_t, cabinet_vent_z], [-11, -5]);

    cap(str("UTILITY CABINET DOOR — exploded detail (", door_w, "\" wide x ", door_h, "\" tall x ", door_t, "\" thick)"), 13, -16, 2.0);
    cap("Hinged on the kitchen-side edge, swinging open toward the fridge — magnetic catch holds it shut on the free edge.", 13, -19, 1.4);
    cap("A low louver (4) gives the exhaust fan's warm air a direct path OUT toward the tailgate — the rest stays dust/draft control.", 13, -21.5, 1.4);

    side_list(door_x0 + door_w + 20, door_h + 10, [
        ["1", "Door panel", str(door_w, "\" x ", door_h, "\" x ", door_t, "\", 3/4\" ply offcut"), "BurlyWood — matches the utility cabinet's own scrap"],
        ["2", "Hinges (x2)", "small butt hinges, kitchen-side edge", "4x #6 x 5/8\" screws each"],
        ["3", "Magnetic catch", "free (fridge-side) edge", "holds the door shut in transit"],
        ["4", "Low exhaust louver", str(cabinet_vent_w, "\" x ", cabinet_vent_h, "\", centered, ", cabinet_vent_z, "\" up"), "vents the fridge's warm exhaust out low toward the tailgate"],
    ]);
}

drawing();
