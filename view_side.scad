// ============================================================
// Side elevation (2D) — the van seen from ONE side door, Y-Z plane.
// Parametric: -D side="driver" or -D side="passenger". Shows the
// full stack silhouette (identical both sides) PLUS the under-deck
// contents that actually face THAT side's door, drawn as dashed
// ghosts. Same direct-drawing technique as side_view.scad.
// ============================================================
//   Driver (-X) side:    WAVE 3 in Panel A | fridge in Panel C
//   Passenger (+X) side: DELTA 3 drawer in Panel A | kitchen in Panel C
//
// Render with: openscad -o renders/side-driver.svg -D side="driver" view_side.scad
// ============================================================

include <params.scad>

side = "driver"; // "driver" | "passenger"
stroke = 0.3;
is_driver = (side == "driver");

module rect_outline(w, l, s = stroke) {
    color("black") difference() { square([w, l]); translate([s, s]) square([w - 2*s, l - 2*s]); }
}
module label(txt, x, y, size = 1.5, ha = "center") {
    color("black") translate([x, y]) text(txt, size = size, halign = ha, valign = "center");
}
module dash_box(w, h, s = 0.18, seg = 1.0, gap = 0.7) {
    // dashed rectangle outline (ghost of an under-deck item)
    color("DimGray") {
        for (yy = [0, h - s]) for (i = [0 : floor(w/(seg+gap))])
            translate([i*(seg+gap), yy]) square([min(seg, w - i*(seg+gap)), s]);
        for (xx = [0, w - s]) for (i = [0 : floor(h/(seg+gap))])
            translate([xx, i*(seg+gap)]) square([s, min(seg, h - i*(seg+gap))]);
    }
}

module drawing() {
    z_rail_top = leg_height + frame_rail_sz;
    z_deck     = z_rail_top + panel_thickness;
    z_plat_top = z_rail_top + bed_frame_thickness;
    z_matt_top = z_plat_top + mattress_total_thickness;
    z_hb_top   = z_deck + headboard_height;

    // In THIS elevation Y increases left->right. Tailgate at RIGHT,
    // front seats at LEFT, matching side_view.scad.
    y_a = 0;
    y_b = y_a + panel_a_length;
    y_c = y_b + panel_b_length;
    y_hb = y_c + panel_c_length - headboard_length;

    // van envelope + floor/ceiling
    rect_outline(van_interior_length, van_interior_height);
    color("black") translate([0, -stroke]) square([van_interior_length, stroke]);
    label("VAN FLOOR", van_interior_length/2, -2.4, 1.5);
    label(str("CEILING — ", van_interior_height, "\" interior height"), van_interior_length/2, van_interior_height + 2.2, 1.5);

    // side door opening (dashed) — where you reach in from this side
    dcolor = is_driver ? "RoyalBlue" : "ForestGreen";
    color(dcolor) {
        translate([side_door_y0, 0]) square([stroke, side_door_opening_height]);
        translate([side_door_y0 + side_door_opening_width - stroke, 0]) square([stroke, side_door_opening_height]);
        translate([side_door_y0, side_door_opening_height - stroke]) square([side_door_opening_width, stroke]);
    }
    label(str(side_door_opening_width, "\" sliding-door opening (UNVERIFIED position)"),
          side_door_y0 + side_door_opening_width/2, side_door_opening_height + 1.6, 1.15);

    // the three panel boxes: legs + top rail
    plen = [panel_a_length, panel_b_length, panel_c_length];
    pnm  = ["Panel A", "Panel B", "Panel C"];
    pys  = [y_a, y_b, y_c];
    for (i = [0:2]) {
        translate([pys[i], 0]) rect_outline(frame_rail_sz, leg_height);
        translate([pys[i] + plen[i] - frame_rail_sz, 0]) rect_outline(frame_rail_sz, leg_height);
        translate([pys[i], leg_height]) rect_outline(plen[i], frame_rail_sz);
        label(pnm[i], pys[i] + frame_rail_sz + 2, leg_height - 2.2, 1.35, "left"); // corner tag, clear of the ghosts
    }
    // Panel B is a bare deep-storage cube (nothing exits it sideways)
    label("bare-frame deep storage", y_b + panel_b_length/2, leg_height/2, 1.1);
    translate([y_c, z_rail_top]) rect_outline(panel_c_length, panel_thickness); // Panel C deck

    // ---- under-deck contents facing THIS side ----
    // Panel A item
    if (is_driver) {
        // WAVE 3 sitting in the open bay (no drawer box)
        wy = y_a + frame_rail_sz + 1;
        translate([wy, 0]) dash_box(wave3_depth, wave3_height);
        label("WAVE 3 A/C", wy + wave3_depth/2, wave3_height/2 + 1, 1.05);
        label("(open bay,", wy + wave3_depth/2, wave3_height/2 - 0.6, 0.9);
        label("hand-slid)", wy + wave3_depth/2, wave3_height/2 - 2, 0.9);
        // found-storage shelf above it (cleat-mounted)
        color("SaddleBrown") translate([y_a + frame_rail_sz, wave3_shelf_z]) square([drawer_depth, 0.3]);
    } else {
        // DELTA 3 drawer
        dy = y_a + frame_rail_sz + 1;
        translate([dy, 1]) dash_box(drawer_depth - 2, drawer_height - 1);
        label("DELTA 3 Plus +", dy + (drawer_depth-2)/2, drawer_height/2 + 1, 1.05);
        label("Extra Battery", dy + (drawer_depth-2)/2, drawer_height/2 - 0.5, 1.0);
        label("(slide-out drawer)", dy + (drawer_depth-2)/2, drawer_height/2 - 2, 0.9);
        color("SaddleBrown") translate([dy, drawer_height]) square([drawer_depth - 2, 0.3]);
    }

    // Panel C item (both slide out the tailgate = right end)
    if (is_driver) {
        // fridge (fridge_ext_width deep, fridge_ext_height tall) in Panel C
        fy = y_c + panel_c_length - fridge_ext_width - 0.5;
        translate([fy, fridge_tray_t]) dash_box(fridge_ext_width, fridge_ext_height);
        color("Gray") translate([fy, 0]) square([fridge_ext_width, fridge_tray_t]);
        label("Fridge (Rocky 40)", fy + fridge_ext_width/2, fridge_ext_height/2 + 1.5, 1.05);
        label("on a tray + slides", fy + fridge_ext_width/2, fridge_ext_height/2, 0.9);
        label("-> out the tailgate", fy + fridge_ext_width/2, fridge_ext_height/2 - 1.6, 0.9);
    } else {
        // kitchen unit
        ky = y_c + panel_c_length - kitchen_box_length - 0.5;
        translate([ky, 0]) dash_box(kitchen_box_length, kitchen_box_height);
        label("Kitchen unit (JAGAHAHA)", ky + kitchen_box_length/2, kitchen_box_height/2 + 1, 1.05);
        label("-> slides out the tailgate", ky + kitchen_box_length/2, kitchen_box_height/2 - 0.8, 0.9);
        // kitchen drawer hung above it
        color("Goldenrod") translate([ky + 1, kdrawer_z0]) dash_box(kdrawer_box_len - 2, kdrawer_box_h);
        label("kitchen drawer", ky + kitchen_box_length/2, kdrawer_z0 + kdrawer_box_h/2, 0.85);
    }

    // bed platform + mattress + headboard (shared stack, both sides)
    translate([y_a, z_rail_top]) rect_outline(bed_frame_length, bed_frame_thickness);
    translate([y_a, z_plat_top]) rect_outline(mattress_length, mattress_total_thickness);
    label(str("Mattress (top at ", z_matt_top, "\")"), mattress_length/2, z_plat_top + mattress_total_thickness/2, 1.4);
    translate([y_hb, z_deck]) rect_outline(headboard_length, headboard_height);
    label("Head-", y_hb + headboard_length/2, z_deck + headboard_height - 3, 1.15);
    label("board", y_hb + headboard_length/2, z_deck + headboard_height - 5, 1.15);

    label(str(is_driver ? "DRIVER" : "PASSENGER", " SIDE — looking in from this door.  FRONT SEATS at left, TAILGATE at right."),
          van_interior_length/2, -5.6, 1.5);
    label(is_driver ? "This side: WAVE 3 (Panel A) + fridge (Panel C).  Dashed = under-deck items reached from here."
                    : "This side: DELTA 3 power (Panel A) + kitchen unit (Panel C).  Dashed = under-deck items reached from here.",
          van_interior_length/2, -8, 1.25);
}

drawing();
