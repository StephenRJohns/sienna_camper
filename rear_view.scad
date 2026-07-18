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

module label(txt, x, y, size = 1.6) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "center", valign = "center");
}

module label_left(txt, x, y, size = 1.3) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "left", valign = "center");
}

// numbered, hue-coded marker (marker_col, colors.scad) — same
// convention as the detail views: the number pairs the marker to
// its legend row, the distinct color separates markers at a glance
module marker(n, x, y) {
    translate([x, y]) {
        color(marker_col(n)) circle(r = 1.4);
        color("white") text(str(n), size = 1.5, halign = "center", valign = "center");
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
        translate([-panel_width/2, z_deck]) rect_outline(panel_width, panel_thickness); // deck top
    }
    label(str("Panel C deck (", panel_width, "\" x ", z_deck + panel_thickness, "\" high)"), -panel_width/2 + 10, z_deck - 1.4, 1.2);

    // ---- headboard/pantry, mounted ON the deck — from the open
    // tailgate you're looking straight at its FOOD side (the netted
    // tiers face the kitchen/tailgate). Thin outline + shelf lines so
    // the control-panel/CO labels behind it stay readable; the full
    // dimensioned story lives in headboard_elevations.scad. ----
    color("DarkGray") {
        translate([-headboard_width/2, z_deck + panel_thickness])
            rect_outline(headboard_width, headboard_height, 0.25);
        for (sz = [headboard_upper_shelf_z, headboard_personal_shelf_z])
            translate([-headboard_width/2 + 1, z_deck + panel_thickness + sz])
                square([headboard_width - 2, 0.18]);
        // adjustable shelf (dashed) in the bottom bay
        for (dx = [0 : 3 : headboard_width - 4])
            translate([-headboard_width/2 + 1 + dx, z_deck + panel_thickness + headboard_adj_shelf_z])
                square([1.8, 0.16]);
    }
    label(str("Headboard/pantry (", headboard_width, "\" x ", headboard_height, "\") — food tiers face you; see Headboard Elevations"),
          -3, z_deck + panel_thickness + headboard_height + 1.6, 1.3);

    // ---- kitchen unit (left), flush to Panel C's left edge ----
    color("Gainsboro")
        translate([x_kitchen - kitchen_box_width/2, 0]) rect_outline(kitchen_box_width, kitchen_box_height);
    kx = x_kitchen; // 1.5in inboard now — flush against Panel C's rear corner leg
    label("Kitchen unit", kx, kitchen_box_height/2 + 2.4, 1.5);
    label(str("(JAGAHAHA, ", kitchen_box_width, "\" x ", kitchen_box_height, "\")"), kx, kitchen_box_height/2 + 0.4, 1.1);
    label("slides out the tailgate", kx, kitchen_box_height/2 - 1.6, 1.1);

    // kitchen drawer, hung from the deck in the gap above the unit
    ddx0 = panel_width/2 - frame_rail_sz - kdrawer_cheek_t - kdrawer_span + 0.5;
    color("DimGray") translate([ddx0, kdrawer_z0]) rect_outline(kdrawer_box_w, kdrawer_box_h);
    label("kitchen drawer", ddx0 + kdrawer_box_w/2, kdrawer_z0 + kdrawer_box_h/2 + 0.9, 1.0);
    label("(hung from the deck)", ddx0 + kdrawer_box_w/2, kdrawer_z0 + kdrawer_box_h/2 - 0.9, 0.9);

    // Power strip 2 — mounted at the kitchen unit, powers the
    // induction cooktop and other small kitchen appliances (Section 7)
    color("DimGray") translate([kx - 1.5, 1.5]) square([3, 2]);
    label("Power strip 2 (cooktop)", kx, -1.5, 1.0);

    // ---- fridge zone (right), flush to Panel C's right edge ----
    // Only 3in of headroom between the fridge top and the deck
    // underside, so its label is ONE short line, not a stack.
    // fridge_x0 is the fridge's CENTER X (matches x_fridge_module in
    // platform.scad/params.scad) — every use below subtracts or adds
    // fridge_ext_length/2 to get an edge, consistent with that.
    fridge_x0 = x_fridge_module; // 1.5in inboard now — flush against the rear corner leg
    color("DimGray")
        translate([fridge_x0 - fridge_ext_length/2, fridge_tray_t]) rect_outline(fridge_ext_length, fridge_ext_height);
    color("Gray")
        translate([fridge_x0 - fridge_ext_length/2, 0]) rect_outline(fridge_ext_length, fridge_tray_t);
    label("Fridge", fridge_x0 + 2, fridge_ext_height/2 + fridge_tray_t + 1, 1.1);
    label("slides out back", fridge_x0 + 2, fridge_ext_height/2 + fridge_tray_t - 1, 1.0);

    // Utility cabinet door, between the kitchen unit and the fridge,
    // at the tailgate face (Section 6/8) — label sits near the TOP of
    // the door, well clear of the exhaust fan/sensor at mid-height
    door_x0 = fridge_x0 + fridge_ext_length/2;
    door_x1 = x_kitchen - kitchen_box_width/2;
    color("Gainsboro") translate([door_x0, 0]) rect_outline(door_x1 - door_x0, leg_height);
    label("Cabinet", (door_x0 + door_x1)/2, leg_height - 2, 0.9);
    label("door", (door_x0 + door_x1)/2, leg_height - 3.6, 0.9);
    // low exhaust louver in the door
    color("DimGray") translate([(door_x0 + door_x1)/2 - cabinet_vent_w/2, cabinet_vent_z - cabinet_vent_h/2])
        rect_outline(cabinet_vent_w, cabinet_vent_h, 0.15);
    for (i = [1:3]) color("DimGray")
        translate([(door_x0 + door_x1)/2 - cabinet_vent_w/2 + 0.3, cabinet_vent_z - cabinet_vent_h/2 + i*cabinet_vent_h/4])
            square([cabinet_vent_w - 0.6, 0.1]);

    // Exhaust fan mounts on the fridge's RIGHT (kitchen-facing) wall,
    // blowing INTO the utility cabinet. The NTC sensor sits just
    // INSIDE the fridge bay at that same wall, right in the exhaust
    // airflow off the fridge's hot side — NOT out in the cabinet (the
    // cabinet air is downstream/diluted and would make the fans lag).
    // Both are at a real X position, shown here at true scale (unlike
    // the intake fan below, on a Y-axis face this X-Z view can't place
    // at its true position). Fan explanatory text lives in the caption
    // strip below Y=0, clear of the door label above.
    fan_z = fridge_ext_height/2 + fridge_tray_t;
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

    label("Exhaust fan: fridge's right wall, blows INTO the cabinet | NTC probe: just inside the bay at that wall (in the hot exhaust, NOT the cabinet)", exhaust_x - 2, -3.4, 0.85);
    label("Intake fan + a passive LOW cool-air louver: both on Panel C's FRONT wall (see its render) | cabinet door has a LOW exhaust louver", fan_in_x + 6, -4.8, 0.85);

    // control panel: switches, surge protector, fan speed
    // controller — INSIDE the utility cabinet, behind its door
    // (mounted on the backer board hung from the deck underside),
    // so everything electrical hides behind one latched face.
    cab_cx = (door_x0 + door_x1)/2;
    color("Black")
        translate([cab_cx - control_panel_width/2, 6.5]) rect_outline(control_panel_width, 6);
    label("Control panel: switches + surge protector — INSIDE the cabinet, behind the door", cab_cx - 2, -6.2, 0.85);

    // numbered markers on the drawing itself — every legend item
    // gets one (color-swatch-only pairing stopped working once the
    // part fills went grayscale; number + distinct marker hue works
    // in any palette)
    marker(1, -18, z_deck + 3.5);                                   // frame/deck
    marker(2, -panel_width/2 + 3, kitchen_box_height - 2.5);        // kitchen unit
    marker(3, fridge_x0 - fridge_ext_length/2 + 2.5, fridge_tray_t + 2.5); // fridge
    marker(4, fan_in_x, fan_z + 3.2);                               // intake fan icon
    marker(5, exhaust_x - 4.2, fan_z);                              // exhaust fan
    marker(6, exhaust_x - 1.8, fan_z + 3);                          // NTC sensor — inside the bay at the exhaust wall
    marker(7, cab_cx - 3.2, 9.5);                                   // control panel (inside the cabinet)
    marker(8, kx + 5, 2.5);                                         // power strip 2
    marker(9, -van_interior_width/2 + 1.25, 8.5);                  // vent intrusion (left zone shown)
    marker(10, (door_x0 + door_x1)/2 + 2.4, leg_height - 2);        // cabinet door

    // legend — numbered markers (matching the drawing), LEFT-aligned
    // text after each
    leg_x = van_interior_width/2 + 5;
    leg_items = [
        "Frame / deck / fridge tray",
        "Kitchen unit (standalone)",
        "Fridge (standalone)",
        "Intake fan (120mm)",
        "Exhaust fan (120mm)",
        "NTC temp sensor",
        "Control panel",
        "Power strip 2 (cooktop)",
        "Floor vent intrusion (both sides)",
        "Utility cabinet door",
    ];
    label_left("Legend", leg_x, van_interior_height - 2, 1.7);
    for (i = [0 : len(leg_items) - 1]) {
        y = van_interior_height - 5.5 - i * 3.2;
        marker(i + 1, leg_x + 0.8, y);
        label_left(leg_items[i], leg_x + 3.4, y, 1.2);
    }

    label("Looking forward from the open tailgate at Panel C — both units shown stowed for driving", 0, -7.5, 1.4);
}

rear_view(); // no outer color() wrapper — see the note above rect_outline()
