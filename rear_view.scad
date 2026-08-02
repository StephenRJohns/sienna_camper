// ============================================================
// Rear-view line drawing (2D) — looking into the Sienna from the
// open tailgate, at Panel C, with the fridge and kitchen unit
// both stowed underneath the deck.
// ============================================================
// Drawn directly in the X-Z (width-height) plane, the same
// direct-drawing technique as side_view.scad/top_view.scad — not a
// projection() of the 3D model, so every internal line stays a
// clean, labeled outline instead of an ambiguous overlapping
// silhouette.
//
// Render with: openscad -o renders/rear-view.svg rear_view.scad
// ============================================================
// LEGIBILITY (Aug 2026): 6 prose line(s) moved out of this
// sheet into the document, and every text size scaled x1.6. Those
// sentences were setting the sheet's width, and a figure's printed
// text height is size x (page_width / sheet_width) — so they were
// holding every other label on the sheet down to 3-6pt on paper.
// Keep prose in the markdown; this sheet carries geometry and short
// labels only.

include <params.scad>
include <colors.scad>

stroke = 0.3;

// Every helper below self-colors black: the camera-preview PNG
// render (renders/*.png — unlike the SVG export, which drops color
// entirely) does NOT let a nested color() override an OUTER color()
// wrapping it; the outermost color() in scope always wins. Self-
// coloring black here means a caller that wraps a call in e.g.
// color("Gray") correctly gets that color (its wrapper is now
// outermost), while an unwrapped call gets black from here instead
// of needing a top-level wrapper that would otherwise blot out every
// nested color in the whole drawing.
module rect_outline(w, l, s = stroke) {
    color("black")
    difference() {
        square([w, l]);
        translate([s, s]) square([w - 2*s, l - 2*s]);
    }
}

module label(txt, x, y, size = 2.56) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "center", valign = "center");
}

module label_left(txt, x, y, size = 2.08) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "left", valign = "center");
}

// numbered, hue-coded marker (marker_col, colors.scad) — same
// convention as the detail views: the number pairs the marker to
// its legend row, the distinct color separates markers at a glance
// A white numeral centred in a filled circle disappears: OpenSCAD merges
// touching 2D shapes into one polygon set and paints them one colour. The
// numeral goes beside the icon.
module marker(n, x, y, nx = 1.3) {
    translate([x, y]) {
        color(marker_col(n)) circle(r = 0.75);
        color(marker_col(n)) translate([nx, 0])
            text(str(n), size = 1.5, halign = nx > 0 ? "left" : "right",
                 valign = "center");
    }
}

module rear_view() {
    z_deck = leg_height + frame_rail_sz;

    // van interior envelope (width x height), for context
    translate([-van_interior_width/2, 0]) rect_outline(van_interior_width, van_interior_height);
    label("Sienna interior envelope (width x height) — hard max", 0, van_interior_height + 3, 1.7);

    // floor-level vent intrusion zones
    color("LightGray") {
        translate([-van_interior_width/2, 0]) rect_outline(vent_intrusion_width, 6);
        translate([van_interior_width/2 - vent_intrusion_width, 0]) rect_outline(vent_intrusion_width, 6);
    }

    // Panel C's own frame + deck, spanning the full 46in width —
    // label sits well above everything else (z_deck+18), clear of
    // both the kitchen/fridge titles below and the control panel
    // stack beside it
    color("Gray") {
        translate([-panel_width/2, 0]) rect_outline(frame_rail_sz, leg_height); // left leg
        translate([panel_width/2 - frame_rail_sz, 0]) rect_outline(frame_rail_sz, leg_height); // right leg
        translate([-panel_width/2, leg_height]) rect_outline(panel_width, frame_rail_sz); // tailgate end rail — the deck is recessed flush BEHIND it
    }
    label(str("end rail — deck flush at ", z_deck, "\""), 0, leg_height + 0.75, 1.1);

    // ---- rear pantry, ON the deck — from the open tailgate you're
    // looking straight at the 2x2 prefab drawer cluster's drawer
    // faces (driver side) + the open pot-bin bay (passenger side).
    // The full dimensioned story lives in rear_pantry_detail.scad. ----
    px0 = -panel_width/2;  // cluster sits against the driver edge
    color("DarkGray") {
        translate([px0, z_deck])
            rect_outline(pantry_cluster_w, pantry_cluster_h, 0.25);
        // the 4 drawer faces
        for (c = [0, 1]) for (r = [0, 1])
            translate([px0 + c*pantry_unit_w + 0.6, z_deck + r*pantry_unit_h + 0.6])
                rect_outline(pantry_unit_w - 1.2, pantry_unit_h - 1.2, 0.18);
        // pot bin in the open bay
        translate([px0 + pantry_cluster_w + 1.5, z_deck])
            rect_outline(pantry_pot_bin, pantry_pot_bin, 0.2);
    }
    // ran outside the van outline on the left and into the legend on the right
    label(str("Rear pantry: 2x2 cluster + pot bin (", pantry_cluster_w, "\" x ",
              pantry_cluster_h, "\")"),
          0, z_deck + pantry_cluster_h + 2.4, 1.3);

    // ---- kitchen unit — RIGHT/passenger side (x_kitchen > 0) ----
    color("Gainsboro")
        translate([x_kitchen - kitchen_box_width/2, 0]) rect_outline(kitchen_box_width, kitchen_box_height);
    kx = x_kitchen; // 1.5in inboard now — flush against Panel C's rear corner leg
    label("Kitchen unit", kx, kitchen_box_height/2 + 2.4, 1.5);
    label(str("(JAGAHAHA, ", kitchen_box_width, "\" x ", kitchen_box_height, "\")"), kx, kitchen_box_height/2 - 0.2, 1.1);
    label("slides out the tailgate", kx, kitchen_box_height/2 - 2.0, 1.1);

    // kitchen drawer, hung from the deck in the gap above the unit
    ddx0 = panel_width/2 - frame_rail_sz - kdrawer_cheek_t - kdrawer_span + 0.5;
    color("DimGray") translate([ddx0, kdrawer_z0]) rect_outline(kdrawer_box_w, kdrawer_box_h);
    label("kitchen drawer", ddx0 + kdrawer_box_w/2, kdrawer_z0 + kdrawer_box_h/2 + 0.8, 1.1);
    label("(hung from the deck)", ddx0 + kdrawer_box_w/2, kdrawer_z0 + kdrawer_box_h/2 - 0.8, 1.0);


    // Power strip 2 — mounted at the kitchen unit, powers the
    // induction cooktop and other small kitchen appliances (Section 7)
    color("DimGray") translate([kx - 1.5, 1.5]) square([3, 2]);
    label("Power strip 2 (cooktop)", kx, -2.0, 1.1);

    // ---- fridge zone — LEFT/driver side (x_fridge_module < 0) ----
    // Only 3in of headroom between the fridge top and the deck
    // underside, so its label is ONE short line, not a stack.
    // fridge_x0 is the fridge's CENTER X (matches x_fridge_module in
    // platform.scad/params.scad) — every use below subtracts or adds
    // fridge_ext_length/2 to get an edge, consistent with that.
    fridge_x0 = x_fridge_module; // 1.5in inboard now — flush against the rear corner leg
    color("DimGray")
        translate([fridge_x0 - fridge_ext_length/2, fridge_tray_gap + fridge_tray_t]) rect_outline(fridge_ext_length, fridge_ext_height);
    color("Gray")
        translate([fridge_x0 - fridge_ext_length/2, fridge_tray_gap]) rect_outline(fridge_ext_length, fridge_tray_t);
    label("Fridge", fridge_x0 + 2, fridge_ext_height/2 + fridge_tray_gap + fridge_tray_t + 1, 1.1);
    label("slides out back", fridge_x0 - 0.5, fridge_ext_height/2 + fridge_tray_gap + fridge_tray_t - 1, 1.0);

    // OPEN utility bay between the kitchen unit and the fridge, at
    // the tailgate face (Section 6/8) — NO door (the old hinged,
    // louvered door was cut: the louver only existed because the
    // door trapped the exhaust air). Drawn as a dashed opening.
    // The fridge's vertical side-mount slide rails, seen end-on from
    // the tailgate: 2 narrow bands flanking the hanging tray (nothing
    // under the tray — see fridge-slide-detail); rails sit on the
    // anchor board's mat + ply strip (aboard_top).
    color("DimGray")
        for (rx = [fridge_x0 - fridge_ext_length/2 - fridge_slide_margin - fridge_rail_t,
                   fridge_x0 + fridge_ext_length/2 + fridge_slide_margin])
            translate([rx, aboard_top + fridge_riser_t]) rect_outline(fridge_rail_t, 3);
    // the no-drill anchor board's strips, end-on (mat + 3/4" ply,
    // Section 8): one under each fridge rail line, one in the
    // utility-bay gap (kitchen's strap L-track), one in the 1.5"
    // band at the panel's passenger edge
    for (bx = [[-panel_width/2, aboard_strip_w],
               [fridge_x0 + fridge_ext_length/2 + fridge_slide_margin + fridge_rail_t/2 - 1.25, 4.65],
               [x_kitchen + kitchen_box_width/2, panel_width/2 - (x_kitchen + kitchen_box_width/2)]]) {
        color([0.15, 0.15, 0.15]) translate([bx[0], 0]) square([bx[1], aboard_mat_t]);
        color("Peru") translate([bx[0], aboard_mat_t]) rect_outline(bx[1], aboard_t, 0.12);
    }
    marker(11, fridge_x0 + fridge_ext_length/2 + fridge_slide_margin + fridge_rail_t/2 + 1.1, -1.3);
    door_x0 = fridge_x0 + fridge_ext_length/2 + fridge_slide_margin + fridge_rail_stack;
    door_x1 = x_kitchen - kitchen_box_width/2;
    // dashed outline = an opening, not a panel
    module dash_h(x0, x1, z) { for (dx = [0 : 1.6 : x1 - x0 - 0.8]) color("Silver") translate([x0 + dx, z]) square([0.8, 0.18]); }
    module dash_v(x, z0, z1) { for (dz = [0 : 1.6 : z1 - z0 - 0.8]) color("Silver") translate([x, z0 + dz]) square([0.18, 0.8]); }
    dash_h(door_x0, door_x1, leg_height - 0.2);
    dash_v(door_x0, 0, leg_height); dash_v(door_x1 - 0.18, 0, leg_height);

    

    label("OPEN", (door_x0 + door_x1)/2, leg_height - 2.2, 1.0);
    label("bay", (door_x0 + door_x1)/2, leg_height - 3.5, 1.0);

    // Exhaust fan mounts on the fridge's RIGHT (kitchen-facing) wall,
    // blowing INTO the utility cabinet. The NTC sensor sits just
    // INSIDE the fridge bay at that same wall, right in the exhaust
    // airflow off the fridge's hot side — NOT out in the cabinet (the
    // cabinet air is downstream/diluted and would make the fans lag).
    // Both are at a real X position, shown here at true scale (unlike
    // the intake fan below, on a Y-axis face this X-Z view can't place
    // at its true position). Fan explanatory text lives in the caption
    // strip below Y=0, clear of the door label above.
    fan_z = fridge_ext_height/2 + fridge_tray_gap + fridge_tray_t;
    exhaust_x = fridge_x0 + fridge_ext_length/2;
    // fan icons drawn as actual fans (ring + hub + 4 blades), not
    // solid circles — the old filled low-poly circles read as
    // unexplained gray blobs
    module fan_icon(x, z, r) {
        color("DimGray") translate([x, z]) {
            difference() { circle(r = r, $fn = 40); circle(r = r - 0.25, $fn = 40); }
            circle(r = r * 0.18, $fn = 16);
            for (a = [0 : 90 : 270])
                rotate(a) translate([r * 0.52, 0]) scale([1, 0.45]) circle(r = r * 0.4, $fn = 20);
        }
    }
    fan_icon(exhaust_x, fan_z, exhaust_fan_dia/2);
    // NTC probe: just INSIDE the bay at the exhaust wall (negative X
    // offset keeps it within the fridge footprint, not the cabinet)
    color("GreenYellow") translate([exhaust_x - 1.8, fan_z + 2]) circle(r = sensor_dia/2, $fn = 20);

    // Intake fan — on a Y-axis face (Panel C's front wall), not
    // representable at its true position in this X-Z view; shown as
    // a small schematic icon instead, placed inside the fridge's own
    // footprint.
    fan_in_x = fridge_x0 - 3;
    fan_icon(fan_in_x, fan_z, 1.1);

    // MOVED TO THE DOCUMENT: label("Exhaust fan: fridge's right wall, blows INTO the open utility bay | NTC probe: just inside the bay at that wall (in the hot exhaust, NOT the bay)", exhaust_x - 2, -3.4, 0.85);
    // MOVED TO THE DOCUMENT: label("Intake fan + a passive LOW cool-air louver: both on Panel C's FRONT wall (see its render) | exhaust exits the OPEN bay toward the tailgate", fan_in_x + 6, -4.8, 0.85);

    // control panel: switches, surge protector, fan speed
    // controller — at the back of the OPEN utility bay (mounted on
    // the backer board hung from the deck underside); everything
    // electrical is reached by just reaching into the bay.
    cab_cx = (door_x0 + door_x1)/2;
    color("Black")
        translate([cab_cx - control_panel_width/2, 6.5]) rect_outline(control_panel_width, 6);
    // MOVED TO THE DOCUMENT: label("Control panel: switches + surge protector — at the back of the open bay, reach in", cab_cx - 2, -6.2, 0.85);

    // numbered markers on the drawing itself — every legend item
    // gets one (color-swatch-only pairing stopped working once the
    // part fills went grayscale; number + distinct marker hue works
    // in any palette)
    marker(1, 18, z_deck - 2.7);                                    // frame/deck (end rail band)
    marker(2, x_kitchen - kitchen_box_width/2 + 2.5, kitchen_box_height - 2.5); // kitchen unit
    marker(3, fridge_x0 - fridge_ext_length/2 + 2.5, fridge_tray_gap + fridge_tray_t + 2.5); // fridge
    marker(4, fan_in_x, fan_z + 3.2);                               // intake fan icon
    marker(5, exhaust_x - 6.5, fan_z + 4.2, -1.3);                  // exhaust fan
    marker(6, exhaust_x - 1.8, fan_z + 3);                          // NTC sensor — inside the bay at the exhaust wall
    marker(7, cab_cx - 3.4, 5.6, -1.3);                             // control panel (inside the cabinet)
    marker(8, kx + 5, 2.5);                                         // power strip 2
    marker(9, -van_interior_width/2 + 1.25, 8.5);                  // vent intrusion (left zone shown)
    marker(10, (door_x0 + door_x1)/2 + 2.4, leg_height - 2);        // open utility bay

    // The 11-row legend that used to print beside this view is now a table in
    // the document under the figure. Its longest row was 77 characters, which
    // set this sheet at 128 units wide against a 49in-wide van — and printed
    // text height is size x (page_width / sheet_width), so it was holding
    // every label here to about 4pt.
    label("Markers 1-11: see the key under this figure", 0, -6.5, 1.3);

    // MOVED TO THE DOCUMENT: label("Looking forward from the open tailgate at Panel C — both units shown stowed for driving", 0, -7.5, 1.4);
    label("DRIVER side", -van_interior_width/2 + 7, van_interior_height - 2, 1.3);
    label("PASSENGER side", van_interior_width/2 - 8, van_interior_height - 2, 1.3);
    // MOVED TO THE DOCUMENT: label("(standing at the tailgate looking in, the DRIVER side is on YOUR LEFT — exactly as drawn)", 0, -9.5, 1.1);
}

rear_view(); // no outer color() wrapper — see the note above rect_outline()
