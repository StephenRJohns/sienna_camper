// ============================================================
// Kitchen drawer detail — the shallow slide-out drawer hung under
// Panel C's deck in the dead air above the kitchen unit. Two
// dimensioned 2D sections, woodworking-plan style.
// ============================================================
// The kitchen unit is 11.8in tall; Panel C's void is 17in clear
// under the tailgate-face rail. This drawer lives in that gap:
// hung from the deck by two 3/4in ply cheeks, riding a 24in
// full-extension side-mount slide pair, pulling straight out the
// open TAILGATE directly above the kitchen unit. Utensils, cutting
// board, flat dry goods, the cooktop's griddle plate.
//
// Render with: openscad -o renders/kitchen-drawer-detail.svg kitchen_drawer_detail.scad
// ============================================================

include <params.scad>

stroke = 0.2;

z_rail0 = leg_height;                    // 17
z_rail1 = leg_height + frame_rail_sz;    // 18.5
z_deck  = z_rail1 + panel_thickness;     // 19.25
z_d0    = kdrawer_z0;                    // 12.3 — drawer underside
z_d1    = kdrawer_z0 + kdrawer_box_h;    // 16.8 — drawer top

module rect_outline(w, h, s = stroke) {
    difference() {
        square([w, h]);
        translate([s, s]) square([w - 2*s, h - 2*s]);
    }
}
module label(txt, x, y, size = 1.2, halign = "center") {
    color("black") translate([x, y]) text(txt, size = size, halign = halign, valign = "center");
}
module dim_v(x, z0, z1, txt, size = 1.1) {
    color("black") {
        translate([x, z0]) square([stroke, z1 - z0]);
        translate([x - 0.8, z0]) square([1.6, stroke]);
        translate([x - 0.8, z1 - stroke]) square([1.6, stroke]);
        label(txt, x + 1.6, (z0 + z1)/2, size, "left");
    }
}
module dim_h(x0, x1, y, txt, size = 1.1) {
    color("black") {
        translate([x0, y]) square([stroke, 1.4], center = true);
        translate([x1, y]) square([stroke, 1.4], center = true);
        translate([x0, y - stroke/2]) square([x1 - x0, stroke]);
        label(txt, (x0 + x1)/2, y - 1.8, size);
    }
}

// ---- view 1: side section (Y-Z), tailgate at right ----
module side_section() {
    ky0 = panel_c_length - kitchen_box_length; // 10 — kitchen flush to the tailgate edge
    pull = 5;                                  // drawer drawn part-open

    color("black") {
        translate([-4, -stroke]) square([panel_c_length + 12, stroke]); // floor
        // Panel C legs + rail + deck
        translate([0, 0]) rect_outline(frame_rail_sz, leg_height);
        translate([panel_c_length - frame_rail_sz, 0]) rect_outline(frame_rail_sz, leg_height);
        translate([0, z_rail0]) rect_outline(panel_c_length, frame_rail_sz);
        translate([0, z_rail1]) rect_outline(panel_c_length, panel_thickness);
    }
    // kitchen unit
    color("DimGray") translate([ky0, 0]) rect_outline(kitchen_box_length, kitchen_box_height);
    label("kitchen unit (JAGAHAHA)", ky0 + kitchen_box_length/2, kitchen_box_height/2 + 1, 1.2);
    label(str(kitchen_box_height, "\" tall — slides out on its own rails"), ky0 + kitchen_box_length/2, kitchen_box_height/2 - 1.2, 1.0);

    // hanging cheek (edge-on, behind the drawer) — dashed top edge zone
    color("Gray") translate([ky0, z_d0]) rect_outline(kdrawer_box_len, z_rail1 - z_d0);
    // the drawer itself, part-open toward the tailgate
    color("black") translate([ky0 + pull, z_d0]) rect_outline(kdrawer_box_len, kdrawer_box_h);
    label("KITCHEN DRAWER — pulls out the tailgate", ky0 + pull + kdrawer_box_len/2, (z_d0 + z_d1)/2 + 0.9, 1.15);
    label(str(kdrawer_box_len, "\" deep on a ", kdrawer_slide_len, "\" full-extension slide pair"), ky0 + pull + kdrawer_box_len/2, (z_d0 + z_d1)/2 - 1.1, 1.0);

    // dims on the left margin
    dim_v(ky0 - 2.5, 0, kitchen_box_height, str(kitchen_box_height, "\""));
    dim_v(ky0 - 2.5, kitchen_box_height, z_d0, "");
    label(str(kdrawer_gap_below, "\" clear"), ky0 - 4.2, (kitchen_box_height + z_d0)/2, 1.0, "right");
    dim_v(ky0 - 6.5, z_d0, z_d1, str(kdrawer_box_h, "\""));
    label(str("drawer top ", z_d1, "\" — clears under the ", z_rail0, "\" rail"), 6, z_d1 + 3.2, 1.0, "left");

    label("SIDE SECTION — front (B/C seam) at left, TAILGATE at right", panel_c_length/2 + 4, -3.4, 1.2);
}

// ---- view 2: rear section (X-Z), looking in from the tailgate ----
module rear_section() {
    kx0 = x_kitchen - kitchen_box_width/2;           // 1.5 — kitchen zone, passenger side (against the rear corner leg)
    ck_out_x1 = panel_width/2 - frame_rail_sz;        // 21.5 — outer cheek's outer face
    ck_out_x0 = ck_out_x1 - kdrawer_cheek_t;          // 20.75
    ck_in_x1  = ck_out_x1 - kdrawer_cheek_t - kdrawer_span; // 3.75 in face... inner cheek
    ck_in_x0  = ck_in_x1 - kdrawer_cheek_t;           // 3.0
    dx0 = ck_in_x1 + 0.5;                             // drawer box left face (slide clearance)

    color("black") {
        translate([-panel_width/2 - 2, -stroke]) square([panel_width + 4, stroke]); // floor
        // side rail (passenger) + deck
        translate([panel_width/2 - frame_rail_sz, z_rail0]) rect_outline(frame_rail_sz, frame_rail_sz);
        translate([-panel_width/2, z_rail1]) rect_outline(panel_width, panel_thickness);
    }
    // kitchen unit
    color("DimGray") translate([kx0, 0]) rect_outline(kitchen_box_width, kitchen_box_height);
    label("kitchen unit", kx0 + kitchen_box_width/2, kitchen_box_height/2, 1.2);

    // hanging cheeks, deck underside down to the drawer's underside
    color("black") {
        translate([ck_in_x0, z_d0]) rect_outline(kdrawer_cheek_t, z_rail1 - z_d0);
        translate([ck_out_x0, z_d0]) rect_outline(kdrawer_cheek_t, z_rail1 - z_d0);
    }
    // slides (one each side of the drawer, at mid-height)
    color("Gray") {
        translate([ck_in_x1, (z_d0 + z_d1)/2 - 0.75]) square([0.5, 1.5]);
        translate([ck_out_x0 - 0.5, (z_d0 + z_d1)/2 - 0.75]) square([0.5, 1.5]);
    }
    // drawer box
    color("black") translate([dx0, z_d0]) rect_outline(kdrawer_box_w, kdrawer_box_h);
    label("drawer", dx0 + kdrawer_box_w/2, (z_d0 + z_d1)/2, 1.2);

    dim_h(dx0, dx0 + kdrawer_box_w, z_d0 - 1.2, str(kdrawer_box_w, "\" box (~", kdrawer_box_w - 1, "\" clear inside)"));
    dim_h(ck_in_x1, ck_out_x0, z_rail1 + 3.4, str(kdrawer_span, "\" between cheek faces"));
    label("2x 1/2\" ply cheeks, screwed UP into the deck (2\" screws every 6\")", 0, z_rail1 + 6.2, 1.05);
    label("outer cheek also screws into the side rail's inner face", 0, z_rail1 + 4.8, 1.0);
    label("24\" side-mount slides, 100lb pair — one per cheek", dx0 + kdrawer_box_w/2, z_d0 - 4.9, 1.05);

    label("REAR SECTION — looking in from the open tailgate (passenger side at right)", 0, -3.4, 1.2);
}

module drawing() {
    side_section();
    translate([panel_c_length + 24, 0]) translate([panel_width/2, 0]) rear_section();

    label("KITCHEN DRAWER — hung under Panel C's deck, above the kitchen unit (Component 7)", panel_c_length + 12, z_deck + 12, 1.9);
    label("Box: 1/2\" ply, glue + 1-1/4\" screws, ~3.5\" clear inside — utensils / cutting board / flat dry goods / griddle plate.", panel_c_length + 12, z_deck + 9.8, 1.15);
    label("Face matches the utility-cabinet door look, with the same magnetic catch so nothing rattles in transit.", panel_c_length + 12, z_deck + 8.4, 1.15);
}

color("black") drawing();
