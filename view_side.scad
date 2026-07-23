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
// Text emitter that stays readable under the passenger-view mirror:
// the whole drawing is mirrored for the passenger side (so the view
// matches what you SEE standing at that door — front seats on the
// RIGHT), and each label counter-mirrors itself in place, flipping
// its halign so left-anchored tags stay left-anchored visually.
module label(txt, x, y, size = 1.5, ha = "center") {
    real_ha = (is_driver || ha == "center") ? ha : (ha == "left" ? "right" : "left");
    color("black") translate([x, y])
        mirror(is_driver ? [0, 0, 0] : [1, 0, 0])
        text(txt, size = size, halign = real_ha, valign = "center");
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
    z_rail_top = deck_surface_z;                        // 18.5 — Panel C rail tops = the deck plane (deck recess)
    z_deck     = deck_surface_z;                        // Panel C's recessed deck surface, flush with its rails
    z_ab_rail  = leg_height_ab + frame_rail_sz;         // 17.75 — A/B rail tops (the platform's seat)
    z_plat_top = z_ab_rail + bed_frame_thickness;       // 18.5 — flush with Panel C
    z_matt_top = z_plat_top + mattress_total_thickness;

    // In THIS elevation Y increases left->right. Tailgate at RIGHT,
    // front seats at LEFT, matching side_view.scad.
    y_a = 0;
    y_b = y_a + panel_a_length;
    y_c = y_b + panel_b_length;
    y_pan = y_c + panel_c_length - pantry_len;

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
    plh  = [leg_height_ab, leg_height_ab, leg_height]; // A/B legs 3/4" shorter (deck recess)
    for (i = [0:2]) {
        translate([pys[i], 0]) rect_outline(frame_rail_sz, plh[i]);
        translate([pys[i] + plen[i] - frame_rail_sz, 0]) rect_outline(frame_rail_sz, plh[i]);
        translate([pys[i], plh[i]]) rect_outline(plen[i], frame_rail_sz);
        label(pnm[i], pys[i] + frame_rail_sz + 2, plh[i] - 1.1, 1.35, "left"); // corner tag, tucked under the top rail clear of the shelf lines
    }
    // Panel B is a bare deep-storage cube (nothing exits it sideways)
    label("bare-frame deep storage", y_b + panel_b_length/2, leg_height_ab/2, 1.1);
    // Panel C deck — recessed between its rails, flush with the rail tops
    translate([y_c + frame_rail_sz, z_rail_top - panel_thickness]) rect_outline(panel_c_length - 2 * frame_rail_sz, panel_thickness);

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
        translate([fy, fridge_tray_gap + fridge_tray_t]) dash_box(fridge_ext_width, fridge_ext_height);
        color("Gray") translate([fy, fridge_tray_gap]) square([fridge_ext_width, fridge_tray_t]);
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

    // bed platform + mattress + rear pantry (shared stack, both sides)
    translate([y_a, z_ab_rail]) rect_outline(bed_frame_length, bed_frame_thickness);
    translate([y_a, z_plat_top]) rect_outline(mattress_length, mattress_total_thickness);
    label(str("Mattress (top at ", z_matt_top, "\")"), mattress_length/2, z_plat_top + mattress_total_thickness/2, 1.4);
    translate([y_pan, z_deck]) rect_outline(pantry_unit_d, pantry_cluster_h);
    translate([y_pan, z_deck + pantry_unit_h]) square([pantry_unit_d, stroke]);
    label("Pan-", y_pan + pantry_unit_d/2, z_deck + pantry_cluster_h - 3, 1.15);
    label("try", y_pan + pantry_unit_d/2, z_deck + pantry_cluster_h - 5, 1.15);

    label(str(is_driver ? "DRIVER SIDE — looking in from this door.  FRONT SEATS at left, TAILGATE at right."
                        : "PASSENGER SIDE — looking in from this door.  TAILGATE at left, FRONT SEATS at right."),
          van_interior_length/2, -5.6, 1.5);
    label(is_driver ? "This side: WAVE 3 (Panel A) + fridge (Panel C).  Dashed = under-deck items reached from here."
                    : "This side: DELTA 3 power (Panel A) + kitchen unit (Panel C).  Dashed = under-deck items reached from here.",
          van_interior_length/2, -8, 1.25);
}

if (is_driver) drawing();
else translate([van_interior_length, 0]) mirror([1, 0, 0]) drawing();  // passenger view mirrored = what you see from that door
