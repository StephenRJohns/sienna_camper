// ============================================================
// Fridge installation detail — zoomed top-down view of Panel C
// ============================================================
// The whole-vehicle top_view.scad is too small-scale to label the
// fridge's 2 fans, temperature sensor, cabinet door, and floor
// anchors clearly (they're packed into Panel C's 46in x 36in
// footprint). This file draws JUST Panel C, at a scale where every
// component gets its own numbered marker — pairs with rear_view.scad
// (elevation), fridge_slide_detail.scad (the slide mechanism, side
// profile), and fridge_wiring.scad (the electrical side).
//
// Numbered markers + a side list (not inline labels scattered across
// the drawing) — an early draft tried inline labels and every one of
// them collided with something else in this tight a footprint.
//
// AIRFLOW (owner question, July 2026): the intake fan on Panel C's
// FRONT wall blows cabin air IN, it crosses the fridge's compressor
// end, and the exhaust fan on the fridge bay's RIGHT (kitchen-
// facing) side blows it INTO the utility cabinet — the door isn't
// airtight, so it leaks back out around the edges. Arrows drawn.
// The control panel lives INSIDE that cabinet, just behind the
// door, on a backer board hung from the deck underside (the 3/4"
// sheet's offcut) — reach it by opening the door. Also here: the
// cabinet door (hinges + catch) and the E-track floor anchors for
// both the fridge's slide and the kitchen unit — see "Securing
// heavy components" (Section 8) for why the factory cargo hooks
// aren't used for either.
//
// COORDINATE SYSTEM (also used in the build-plan coordinate table):
// origin (0,0) is Panel C's TAILGATE-FACING, LEFT corner, at floor
// level (as you'd stand at the open tailgate facing forward into the
// van). X increases to the RIGHT, 0 to 46in (panel_width). Y
// increases FORWARD (toward the Panel B seam), 0 to 36in
// (panel_c_length). This is the reverse of top_view.scad's own
// internal Y convention (increases toward the FRONT of the whole
// vehicle) and platform.scad's true 3D model convention (increases
// toward the TAILGATE) — both exist for other reasons already
// explained in their own files. This one reads most naturally for
// "how far in from the tailgate, how far over from the left" — the
// two questions you actually ask while installing something back
// here.
//
// Render with: openscad -o renders/fridge-install-detail.svg fridge_install_detail.scad
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

// Numbered marker: a filled circle with a white number, used in the
// drawing; the matching number in the side list gives the real
// coordinates, description, and fastener spec.
module marker(n, x, y, col) {
    // numbered AND hue-coded (marker_col, colors.scad) — number
    // pairs to the list row, color separates markers at a glance
    translate([x, y]) {
        color(marker_col(n)) circle(r = 1.3);
        color("white") text(str(n), size = 1.4, halign = "center", valign = "center");
    }
}

// small square anchor icon (E-track floor anchor footprint)
module anchor_icon(x, y) {
    color("DimGray") translate([x - 0.75, y - 0.75]) square([1.5, 1.5]);
    color("black") translate([x - 0.3, y - 0.3]) square([0.6, 0.6]);
}

module drawing() {
    z_deck = leg_height + frame_rail_sz;
    kitchen_x0 = x_kitchen - kitchen_box_width/2 + panel_width/2; // 26 — kitchen flush RIGHT (passenger side)
    fridge_x0  = x_fridge_module - fridge_ext_length/2 + panel_width/2;

    // Panel C outline (the full 46in x 36in deck footprint)
    rect_outline(panel_width, panel_c_length);
    label(str("PANEL C — ", panel_width, "\" wide x ", panel_c_length, "\" deep, looking down from above"),
          panel_width/2, panel_c_length + 3, 1.6);
    label("TAILGATE (open) — Y = 0 here", panel_width/2, -2, 1.4);
    label("DRIVER side (X=0)", 8, panel_c_length + 1.2, 1.1);
    label("PASSENGER side", panel_width - 8, panel_c_length + 1.2, 1.1);
    label_left("Y, in.", -6, panel_c_length/2, 1.2);
    label_left("(toward Panel B)", -9, panel_c_length/2 - 1.8, 0.9);
    label("X, in. (left to right) ->", panel_width/2, -3.8, 1.1);

    // Kitchen unit footprint + floor anchors
    translate([kitchen_x0, 0]) {
        color("Gainsboro") rect_outline(kitchen_box_width, kitchen_box_length);
        label("Kitchen unit", kitchen_box_width/2, kitchen_box_length - 3, 1.3);
        label("(JAGAHAHA)", kitchen_box_width/2, kitchen_box_length - 5, 1.1);
        label(str(kitchen_box_width, "\" x ", kitchen_box_length, "\""), kitchen_box_width/2, kitchen_box_length - 7, 1.1);
        label("slides out tailgate (-Y)", kitchen_box_width/2, 2.5, 1.0);
    }
    kx_anchors = [kitchen_x0 + 1, kitchen_x0 + kitchen_box_width - 1];
    ky_anchors = [1.5, kitchen_box_length - 1.5];
    for (ax = kx_anchors) for (ay = ky_anchors) anchor_icon(ax, ay);
    marker(9, kitchen_x0 + kitchen_box_width/2, kitchen_box_length - 1.5, "DimGray");

    // Fridge footprint — name/description text kept in the UPPER
    // third of the box (Y=15-22), well clear of the intake fan
    // marker at the very top (Y=22.68) and leaving the lower 2/3 of
    // the box free for markers.
    translate([fridge_x0, 0]) {
        color("DimGray") rect_outline(fridge_ext_length, fridge_ext_width);
        label("Fridge", fridge_ext_length/2, 19, 1.2);
        label("(BougeRV)", fridge_ext_length/2, 17, 1.0);
        label("out tailgate (-Y)", fridge_ext_length/2, 15, 0.9);

        // exhaust fan + NTC sensor: on the RIGHT (kitchen-facing,
        // high-X) side of the fridge bay — blows INTO the utility
        // cabinet (the door isn't airtight; air leaks back out)
        marker(2, fridge_ext_length, fridge_ext_width/2, "Silver");
        marker(3, fridge_ext_length - 1.5, fridge_ext_width/2 - 2.2, "GreenYellow");
    }
    // intake fan: on Panel C's FRONT wall (the panel's one wall),
    // over its pre-cut fan hole — Panel C Front Wall render
    marker(1, fridge_x0 + fridge_ext_length/2, panel_c_length, "DarkGray");

    // ---- airflow arrows: in through the front wall, across the
    // fridge, out into the cabinet ----
    module flow_arrow(x0, y0, x1, y1) {
        color("SteelBlue") {
            hull() { translate([x0, y0]) circle(r = 0.25, $fn = 12); translate([x1, y1]) circle(r = 0.25, $fn = 12); }
            dx = x1 - x0; dy = y1 - y0; n = norm([dx, dy]);
            translate([x1, y1]) rotate(atan2(dy, dx))
                polygon([[0, 0], [-1.6, 0.9], [-1.6, -0.9]]);
        }
    }
    flow_arrow(fridge_x0 + fridge_ext_length/2, panel_c_length + 1.5, fridge_x0 + fridge_ext_length/2, panel_c_length - 3.5);
    flow_arrow(fridge_x0 + 3, 10, fridge_x0 + fridge_ext_length - 2, 10);
    flow_arrow(fridge_x0 + fridge_ext_length - 2, fridge_ext_width/2, fridge_x0 + fridge_ext_length + 3.5, fridge_ext_width/2);
    color("SteelBlue") translate([fridge_x0 + 2, 7.2]) text("airflow: cool air in at the front wall (fan + a low passive louver), across the fridge, OUT into the cabinet + through its low door louver", size = 0.95);
    // the 2 slide rails stand VERTICALLY flanking the tray (side-mount
    // — see fridge-slide-detail): drawn as the 2 narrow bands beside
    // the fridge, set back ~2.5in from the tailgate face so the
    // driver-side one clears the rear corner leg. The E-track anchors
    // sit ON these rail lines (under each rail's steel riser), never
    // under the tray.
    rail_xs = [fridge_x0 - fridge_slide_margin - fridge_rail_t,
               fridge_x0 + fridge_ext_length + fridge_slide_margin];
    for (rx = rail_xs)
        color("DimGray") translate([rx, 2.5]) rect_outline(fridge_rail_t, fridge_slide_length, 0.12);
    fx_anchors = [rail_xs[0] + fridge_rail_t/2, rail_xs[1] + fridge_rail_t/2];
    fy_anchors = [4.5, 24];
    for (ax = fx_anchors) for (ay = fy_anchors) anchor_icon(ax, ay);
    marker(8, rail_xs[1] + fridge_rail_t/2, 27.5, "DimGray");

    // Fridge hold-down strap D-rings (x2, tray side apron — separate
    // from the E-track floor anchors above: these secure the FRIDGE to
    // its TRAY, not the tray to the van floor) — side profile + strap
    // geometry is in fridge-slide-detail.svg
    color("Firebrick") translate([fridge_x0 + fridge_ext_length/2 - 0.3, 1.3]) circle(r = 0.3);
    marker(11, fridge_x0 + fridge_ext_length/2, 3.2, "Firebrick");

    // Utility cabinet door — fills the gap between the fridge module
    // (left/driver) and the kitchen unit (right/passenger), right at
    // the tailgate face
    door_x0 = fridge_x0 + fridge_ext_length + fridge_slide_margin + fridge_rail_stack; // past the passenger-side rail + riser
    door_w  = kitchen_x0 - door_x0;
    color("Gainsboro") translate([door_x0, 0]) rect_outline(door_w, 1.5);
    marker(5, door_x0 + door_w/2, 0.75, "Gainsboro");
    marker(6, door_x0 + door_w + 2.6, 0.75, "DimGray"); // hinges, kitchen-side (high-X) edge — marker offset onto the kitchen corner for legibility in the narrow gap
    marker(7, door_x0 - 4.4, 0.75, "Black");            // catch, fridge-side (free) edge — marker offset onto the fridge corner for legibility

    // WAVE 3 hose/cord storage hook — inside the cabinet's own void
    // (open under the deck, same depth as the fridge/kitchen bays),
    // well clear of the door hardware at Y=0.75 above and the fridge/
    // kitchen footprints to either side
    marker(10, door_x0 + door_w/2, 10, "Silver");

    // Control panel — INSIDE the utility cabinet, just behind its
    // door, on a backer board hung from the deck underside (Z in the
    // side list; a top-down view only shows its footprint).
    ctrl_x0 = door_x0 + door_w/2 - control_panel_width/2;
    color("Black") translate([ctrl_x0, 1.8]) rect_outline(control_panel_width, 1.5);
    marker(4, ctrl_x0 + control_panel_width/2, 5.5, "Black");
    label("(4 is INSIDE the cabinet behind the door — Z in the list. CO monitor + fire extinguisher: owner-placed, not located here)",
          panel_width/2, panel_c_length + 5.5, 1.05);

    // ---- side list: numbered components with coordinates + fastener spec ----
    list_x = panel_width + 6;
    items = [
        ["1", "DarkGray", "Intake fan (120mm) — blows IN", str("X=", round((fridge_x0+fridge_ext_length/2)*100)/100, " Y=", panel_c_length, " (Panel C's FRONT wall) Z=8.8"), "4x M4x20 machine screws over the wall's fan hole (Front Wall render)"],
        ["2", "Silver", "Exhaust fan (120mm) — blows INTO the cabinet", str("X=", round((fridge_x0+fridge_ext_length)*100)/100, " Y=", round((fridge_ext_width/2)*10)/10, " Z=8.8"), "4x M4x20 machine screws, 105mm bolt circle, into a plywood fan ring"],
        ["3", "GreenYellow", "NTC temp sensor", str("X=", round((fridge_x0+fridge_ext_length-1.5)*100)/100, " Y=", round((fridge_ext_width/2-2.2)*10)/10, " Z=8.8"), "adhesive thermal pad or 1x #4 screw through its bracket tab"],
        ["4", "Black", "Control panel enclosure", str("X=", round(ctrl_x0*10)/10, "-", round((ctrl_x0+control_panel_width)*10)/10, " Y=~2 Z=6.5-12.5 — INSIDE the cabinet"), "backer board (3/4\" offcut) hung from the deck; 4x #8x1\" screws"],
        ["5", "Gainsboro", "Cabinet door", str("X=", round(door_x0*10)/10, "-", round((door_x0+door_w)*10)/10, " Y=0-1.5"), "1/2\" ply panel, closes the kitchen/fridge gap (not airtight — by design)"],
        ["6", "DimGray", "Door hinges (x2)", "on the kitchen-side (high-X) edge", "2x small butt hinges, 4x #6x5/8\" screws each"],
        ["7", "Black", "Door catch", "on the fridge-side (free) edge", "1x magnetic or roller catch, 2x #6x5/8\" screws"],
        ["8", "DimGray", "Fridge slide floor anchors (x4)", "E-track, 2 per slide rail, front+back of each rail line BESIDE the tray (side-mount)", "1000lb WLL each — 2x 5/16\" carriage bolts through the floor per anchor"],
        ["9", "DimGray", "Kitchen floor anchors (x4)", "E-track, one per corner", "1000lb WLL each — 2x 5/16\" carriage bolts through the floor per anchor"],
        ["10", "Silver", "WAVE 3 hose/cord hook", "inside the cabinet, kitchen-side wall", "1x heavy-duty wall hook, #8x1.5\" screw — stows hoses+cord when not in use"],
        ["11", "Firebrick", "Fridge hold-down strap D-rings (x2)", "tray side apron, near the tailgate end — hooks to the fridge's 2 end handles", "cam strap, snug not tight — secures fridge TO its tray (E-track anchors secure the tray to the van); side profile in fridge-slide-detail"],
    ];
    label_left("Component", list_x, panel_c_length - 1, 1.3);
    label_left("Position / fastener", list_x, panel_c_length - 3.2, 1.1);
    for (i = [0 : len(items) - 1]) {
        y = panel_c_length - 11 - i * 8.5;
        color(marker_col_s(items[i][0])) translate([list_x, y + 3.4]) circle(r = 1.2); // hue matches the drawing marker
        color("white") translate([list_x, y + 3.4]) text(items[i][0], size = 1.2, halign = "center", valign = "center");
        label_left(items[i][2], list_x + 3, y + 3.4, 1.1);
        label_left(items[i][3], list_x + 3, y + 1.7, 1.0);
        label_left(items[i][4], list_x + 3, y, 1.0);
    }

    fn_y = panel_c_length - 11 - len(items) * 8.5 - 2; // below the LAST row, same pitch the rows use
    label_left("All coordinates measured from Panel C's tailgate-facing left corner, floor level (see file header).",
               list_x, fn_y, 0.95);
    label_left("Floor-anchor bolts go THROUGH the van's floor pan — inspect underneath for fuel/brake lines and wiring",
               list_x, fn_y - 2, 0.95);
    label_left("before drilling any hole (Section 8).", list_x, fn_y - 3.5, 0.95);
}

// NOTE: no outer color("black") wrapper here — every helper above
// (rect_outline, label, label_left, marker, anchor_icon) already
// self-colors, and OpenSCAD's camera-preview PNG render does not let
// a nested color() override an OUTER color() wrapping it (the
// outermost color in scope always wins). See top_view.scad/
// rear_view.scad for the same fix applied after this exact bug was
// found mid-project.
drawing();
