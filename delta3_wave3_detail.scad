// ============================================================
// EcoFlow DELTA 3 Plus + Smart Extra Battery — Panel A right drawer
// (Panel B's drawers are only ~3in reachable from the side door per
// the placeholder side_door_y0 estimate in params.scad, functionally
// blocked by the van's own body structure; Panel A is confirmed
// reachable. See Section 1's side-door reachability note and Section
// 0's new door-position measurement.)
// EcoFlow WAVE 3 — Panel A LEFT (driver-side) bay, open storage
// ============================================================
// Two independent top-down views, stacked vertically (not to scale
// relative to each other). Both units are camp-time gear, not
// permanent fixtures like the fridge/kitchen — the DELTA3 stack rides
// in a normal drawer (no E-track needed, ~48lb total, well under what
// the drawer slides are rated for). The WAVE3 lives in Panel A's left
// bay — no drawer box, no slide, just resting directly on the bay
// floor (it's 20.4in wide, wider than a boxed drawer's 19in clear
// interior, but fits the raw 20.75in bay) — and gets carried to
// wherever it actually runs (Panel C's tailgate deck or the front
// seat) for camp use; see the "WAVE 3 sleeping configurations" note,
// Section 1.
//
// Numbered markers + a side list (not inline labels scattered across
// the drawing) — same convention as fridge_install_detail.scad, which
// found that inline labels collide badly in a footprint this tight.
//
// SECTION 1 COORDINATE SYSTEM: origin at the drawer's inner (divider-
// side) bottom-back corner. X = side-to-side (0 = divider/inner wall,
// drawer_clear_width = outer/pull wall, facing the side door). Y =
// fore-aft (0 = toward Panel C/the tailgate, where the power cord
// exits toward the WAVE3's charge cable; drawer_clear_depth = toward
// the front seats — Panel A is now the frontmost sleeping panel,
// there's nothing between it and the front seats anymore).
//
// SECTION 2 COORDINATE SYSTEM: origin at the left bay's inner
// (divider-side) bottom-back corner — same reference frame as
// Section 1's drawer, one bay over. X = side-to-side (0 = divider,
// wave3_bay_width = outer rail, facing the driver's side door). Y =
// fore-aft (0 = toward Panel C/tailgate, drawer_depth = toward the
// front seats).
//
// Render with: openscad -o renders/delta3-wave3-detail.svg delta3_wave3_detail.scad
// ============================================================

include <params.scad>
include <colors.scad>

stroke = 0.25;

module rect_outline(w, l, s = stroke) {
    color("black")
    difference() {
        square([w, l]);
        translate([s, s]) square([w - 2*s, l - 2*s]);
    }
}

module label(txt, x, y, size = 1.4) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "center", valign = "center");
}

module label_left(txt, x, y, size = 1.2) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "left", valign = "center");
}

module marker(n, x, y, col) {
    // markers are numbered AND hue-coded (marker_col, colors.scad):
    // the number pairs a marker to its side-list row, the distinct
    // color makes them easy to tell apart at a glance. col param
    // kept in the signature so call sites didn't churn.
    translate([x, y]) {
        color(marker_col(n)) circle(r = 1.3);
        color("white") text(str(n), size = 1.4, halign = "center", valign = "center");
    }
}

module side_list(list_x, top_y, items) {
    label_left("Component", list_x, top_y - 1, 1.3);
    label_left("Position / fastener", list_x, top_y - 3.2, 1.1);
    for (i = [0 : len(items) - 1]) {
        y = top_y - 8 - i * 8.5;
        color(marker_col_s(items[i][0])) translate([list_x, y + 3.4]) circle(r = 1.2); // hue matches the drawing marker
        color("white") translate([list_x, y + 3.4]) text(items[i][0], size = 1.2, halign = "center", valign = "center");
        label_left(items[i][2], list_x + 3, y + 3.4, 1.1);
        label_left(items[i][3], list_x + 3, y + 1.7, 1.0);
        label_left(items[i][4], list_x + 3, y, 1.0);
    }
}

module drawing() {
    // ============================================================
    // SECTION 1: PANEL A, RIGHT DRAWER — DELTA 3 stack
    // ============================================================
    rect_outline(drawer_clear_width, drawer_clear_depth);
    label("PANEL A — RIGHT DRAWER (top-down)", drawer_clear_width/2, drawer_clear_depth + 3, 1.4);
    label("EcoFlow DELTA 3 Plus + Extra Battery, stowed", drawer_clear_width/2, drawer_clear_depth + 1.3, 1.1);
    label(str("clear interior ", drawer_clear_width, "\" x ", drawer_clear_depth, "\""), drawer_clear_width/2, -1.8, 0.95);
    label_left("Y: to Panel C/tailgate <-", 0.2, -3.6, 0.85);
    label_left("X: divider -> outer (pull)", 0.2, -5, 0.85);

    // Extra Battery INBOARD (near the divider, harder to reach), DELTA 3
    // Plus OUTBOARD (near the outer/pull wall) — the Plus unit is what
    // the WAVE 3 actually plugs into and gets pulled/reached more often
    // (used with or without the battery attached), so it gets the easy
    // reach; the battery is grabbed less often (extra runtime only).
    batt_x0 = 1.5; batt_y0 = 4;
    plus_x0 = batt_x0 + delta3_batt_width + 0.4; plus_y0 = 4;

    color("DarkGray") translate([plus_x0, plus_y0]) square([delta3_plus_width, delta3_length]);
    color("Silver") translate([batt_x0, batt_y0]) square([delta3_batt_width, delta3_length]);
    marker(1, plus_x0 + delta3_plus_width/2, plus_y0 + delta3_length/2, "DarkGray");
    marker(2, batt_x0 + delta3_batt_width/2, batt_y0 + delta3_length/2, "Silver");

    // combined-width dimension, below the drawer
    dim_x0 = batt_x0; dim_x1 = plus_x0 + delta3_plus_width;
    color("black") {
        translate([min(dim_x0,dim_x1), -7.05]) square([abs(dim_x1-dim_x0), 0.1]);
        translate([dim_x0, -7.6]) square([0.1, 1.2]);
        translate([dim_x1, -7.6]) square([0.1, 1.2]);
    }
    label(str("Combined ", delta3_plus_width + delta3_batt_width, "\" wide"), (dim_x0+dim_x1)/2, -9, 0.95);
    label(str("drawer clear width ", drawer_clear_width, "\""), (dim_x0+dim_x1)/2, -10.4, 0.95);

    // locating cleats — 4 small blocks bracketing the combined footprint's corners
    color("Gray") {
        translate([0.3, plus_y0 - 0.4]) square([0.8, 0.8]);
        translate([0.3, plus_y0 + delta3_length - 0.4]) square([0.8, 0.8]);
        translate([drawer_clear_width - 1.1, plus_y0 - 0.4]) square([0.8, 0.8]);
        translate([drawer_clear_width - 1.1, plus_y0 + delta3_length - 0.4]) square([0.8, 0.8]);
    }
    marker(3, 0.7, plus_y0 + delta3_length/2, "Gray");

    // vent slots — outer (pull) wall, short cluster
    for (i = [0:4])
        color("DimGray") translate([drawer_clear_width - 0.3, 9 + i*1.4]) square([0.3, 0.9]);
    marker(4, drawer_clear_width + 2, 12, "DimGray");

    // cam-strap anchors — divider wall + outer wall, above the units
    color("Black") {
        translate([0.3, 21.5]) circle(r = 0.4);
        translate([drawer_clear_width - 0.3, 21.5]) circle(r = 0.4);
    }
    marker(5, drawer_clear_width/2, 22.6, "Black");

    // cable pass-through grommet — Y=0 wall (toward Panel C/tailgate)
    color("LightGray") translate([drawer_clear_width - 3, 0.4]) circle(r = 0.6);
    marker(6, drawer_clear_width - 3, 0.4, "LightGray");

    side_list(drawer_clear_width + 6, drawer_clear_depth, [
        ["1", "DarkGray", "DELTA 3 Plus (main unit)", str(delta3_plus_width, "\" x ", delta3_length, "\" x ", delta3_plus_height, "\", ~28 lb"), "outboard (pull wall) — WAVE 3 plugs into this always"],
        ["2", "Silver", "Smart Extra Battery", str(delta3_batt_width, "\" x ", delta3_length, "\" x ", delta3_batt_height, "\", ~20 lb"), "inboard — grabbed less often, extra runtime only"],
        ["3", "Gray", "Locating cleats (x4)", "1x1 pine blocking, drawer floor", "glued + screwed — #6 x 1\" screws"],
        ["4", "DimGray", "Vent slots (x5)", "1\" x 0.5\" slots, outer wall", "lets cooling fans breathe if run while closed"],
        ["5", "Black", "Cam-strap anchors (x2)", "screw-eye D-rings, divider + outer wall", "#8 x 1\" screws, strap over both units"],
        ["6", "LightGray", "Cable pass-through", "1\" grommet, Y=0 tailgate-facing wall", "WAVE 3 cord exits here toward the tray below"],
    ]);

    // ============================================================
    // SECTION 2: PANEL A, LEFT (DRIVER-SIDE) BAY — WAVE 3 open storage
    // ============================================================
    translate([0, -62]) {
        bay_w = wave3_bay_width;
        bay_d = drawer_depth;
        clear = bay_w - wave3_width;

        label("PANEL A — LEFT (DRIVER-SIDE) BAY (top-down)", bay_w/2, bay_d + 10, 1.4);
        label("EcoFlow WAVE 3 — open storage, no box or slide", bay_w/2, bay_d + 8, 1.1);
        label(str("raw bay ", bay_w, "\" x ", bay_d, "\" (no box walls to eat into it)"), bay_w/2, -1.8, 0.95);
        label_left("Y: Panel B/tailgate <-", 0, -3.6, 0.85);
        label_left("X: divider -> outer (driver door)", 0, -5, 0.85);

        // bay outline (raw void — no drawer box)
        color("Gray") rect_outline(bay_w, bay_d);
        marker(8, bay_w - 0.6, bay_d - 0.6, "Gray");

        // WAVE3 unit footprint, centered fore-aft, flush to the divider
        unit_x0 = 0; unit_y0 = (bay_d - wave3_depth) / 2;
        color("DarkGray") translate([unit_x0, unit_y0]) square([wave3_width, wave3_depth]);
        marker(7, unit_x0 + wave3_width/2, unit_y0 + wave3_depth/2, "DarkGray");

        // 2 glide strips along the bay floor, full depth, at the front
        // and back edges of the unit's footprint
        color("Silver") translate([0.2, unit_y0]) square([bay_w - 0.4, 0.8]);
        color("Silver") translate([0.2, unit_y0 + wave3_depth - 0.8]) square([bay_w - 0.4, 0.8]);
        marker(9, bay_w/2, unit_y0 - 1.6, "Silver");

        // clearance callout — the tight 0.35in margin, called out explicitly
        color("black") {
            translate([wave3_width, bay_d * 0.15]) square([clear, 0.1]);
            translate([wave3_width, bay_d * 0.15 - 0.5]) square([0.1, 1.2]);
            translate([bay_w - 0.1, bay_d * 0.15 - 0.5]) square([0.1, 1.2]);
        }
        label(str(clear, "\" clear"), wave3_width + clear/2, bay_d * 0.15 - 2, 0.9);

        side_list(bay_w + 6, bay_d, [
            ["7", "DarkGray", "WAVE 3 unit", str(wave3_width, "\" x ", wave3_depth, "\" x ", wave3_height, "\", ", wave3_weight, " lb"), "rests directly on the bay floor — no box, no slide"],
            ["8", "Gray", "Bay opening", str(bay_w, "\" x ", bay_d, "\" raw void"), "reached through the driver's side door"],
            ["9", "Silver", "Glide strips (x2)", "UHMW or laminate scrap, full bay depth", "cuts friction sliding the unit in/out by hand"],
        ]);

        label_left(str("Clearance is tight: ", clear, "in on the pull side — a"), 0, -7, 0.9);
        label_left("boxed drawer (19in clear) would NOT fit; this raw", 0, -8.4, 0.9);
        label_left("bay does, which is why this is open storage, not a", 0, -9.8, 0.9);
        label_left("normal drawer like Panel A's right side.", 0, -11.2, 0.9);
        label_left("Storage-only: for camp use, carry the unit to Panel", 0, -12.6, 0.9);
        label_left("C's tailgate deck (tent) or the front seat (no tent)", 0, -14, 0.9);
        label_left("— see the sleeping-configurations note, Section 1.", 0, -15.4, 0.9);
        label_left("Hoses + cord stow on a hook inside the utility", 0, -16.8, 0.9);
        label_left("cabinet (between fridge + kitchen) when not in use.", 0, -18.2, 0.9);
    }

    // ============================================================
    // SECTION 3: FOUND STORAGE — side sections showing the reclaimed
    // headroom above each unit (both are Z features the top-down
    // views above can't show)
    // ============================================================
    translate([0, -112]) {
        label("FOUND STORAGE — dead headroom reclaimed (side sections)", 22, drawer_height + 7, 1.4);

        // --- left: DELTA 3 drawer, side section ---
        translate([0, 0]) {
            rect_outline(delta3_length + 2, drawer_height);           // drawer box (side)
            color("DarkGray") translate([1, 0.4]) square([delta3_length, delta3_plus_height]); // DELTA 3 stack
            label("DELTA 3", 1 + delta3_length/2, delta3_plus_height/2, 1.0);
            // tray in the ~3in headroom on top
            color("Peru") translate([1, delta3_plus_height + 0.4]) rect_outline(delta3_length, delta3_tray_h, 0.18);
            label("lift-out tray", 1 + delta3_length/2, delta3_plus_height + delta3_tray_h/2 + 0.4, 0.9);
            label(str("DELTA 3 drawer: ", drawer_height, "\" tall, unit ", delta3_plus_height, "\" ->"), (delta3_length+2)/2, -2, 0.95);
            label(str("~", round((drawer_height - delta3_plus_height)*10)/10, "\" of dead air on top = a cable/cord tray"), (delta3_length+2)/2, -3.6, 0.9);
        }
        // --- right: WAVE 3 bay, side section ---
        translate([delta3_length + 10, 0]) {
            rect_outline(wave3_depth + 2, leg_height);                // bay (side, to deck underside)
            color("DimGray") translate([1, 0]) square([wave3_depth, wave3_height]); // WAVE 3
            label("WAVE 3", 1 + wave3_depth/2, wave3_height/2, 1.0);
            // shelf on cleats above it
            color("BurlyWood") translate([0.6, wave3_shelf_z]) square([wave3_depth + 0.8, panel_thickness]);
            color("Gray") { translate([0.6, wave3_shelf_z - 0.8]) square([0.6, 0.8]); translate([wave3_depth + 0.6, wave3_shelf_z - 0.8]) square([0.6, 0.8]); } // cleats
            label(str("shelf @ ", round(wave3_shelf_z*10)/10, "\""), 1 + wave3_depth/2, wave3_shelf_z + 1.4, 0.85);
            label(str("WAVE 3 bay: ", leg_height, "\" tall, unit ", wave3_height, "\" ->"), (wave3_depth+2)/2, -2, 0.95);
            label(str("~", round(wave3_shelf_clear*10)/10, "\" clear above = a shelf on cleats (unit slides out under it)"), (wave3_depth+2)/2, -3.6, 0.9);
        }
    }
}

// NOTE: no outer color("black") wrapper here — every helper above
// (rect_outline, label, label_left, marker, side_list) already
// self-colors, and OpenSCAD's camera-preview PNG render does not let
// a nested color() override an OUTER color() wrapping it. See
// fridge_install_detail.scad/top_view.scad/rear_view.scad for the
// same fix applied after this bug was found mid-project.
drawing();
