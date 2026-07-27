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
// The control panel lives in the OPEN utility bay between the
// fridge and kitchen (no door — the old hinged, louvered door was
// cut as pointless), on a backer board hung from the deck underside
// (the 3/4" sheet's offcut) — reach it by hand. Also here: the
// NO-DRILL ANCHOR BOARD for both the fridge's slide and the kitchen
// unit — mat + 3/4in ply strips + a full-width bridge, its steel
// tongues bolted to the rear ends of the 2nd-row long-slide floor
// rails (fallback: butting the striker-row step) and strapped to
// the 3 3rd-row striker loops — see "Securing heavy components"
// (Section 8) for why the factory cargo hooks aren't used for
// either, and why nothing bolts to the van (owner: no holes).
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

// anchor-board strip (mat + 3/4in ply) — drawn as an outline with
// diagonal section-hatching so it stays LINE ART (filled shapes
// union into solid blobs in OpenSCAD's monochrome SVG export) —
// the no-drill securing chassis, Section 8
module board_strip(x0, y0, w, l) {
    color("Peru") difference() {
        translate([x0, y0]) square([w, l]);
        translate([x0 + 0.15, y0 + 0.15]) square([w - 0.3, l - 0.3]);
    }
    color("Tan") intersection() {
        translate([x0 + 0.3, y0 + 0.3]) square([w - 0.6, l - 0.6]);
        union() {
            for (d = [2 : 4 : w + l])
                translate([x0, y0 + d]) rotate(-45) square([(w + l) * 1.5, 0.1]);
        }
    }
}

// L-track segment on a strip (double-line channel with slot dots)
module ltrack(x0, y0, l) {
    color("DimGray") difference() {
        translate([x0, y0]) square([1, l]);
        translate([x0 + 0.12, y0 + 0.12]) square([0.76, l - 0.24]);
    }
    color("Black") for (dy = [1.5 : 2.5 : l - 1]) translate([x0 + 0.5, y0 + dy]) circle(r = 0.18);
}

// stud-fitting D-ring anchor point
module dring_icon(x, y) {
    color("Black") translate([x, y]) difference() { circle(r = 0.55); circle(r = 0.3); }
}

module drawing() {
    z_deck = leg_height + frame_rail_sz;
    kitchen_x0 = x_kitchen - kitchen_box_width/2 + panel_width/2; // 24.5 — against the passenger rear corner leg (1.5in in from the edge)
    fridge_x0  = x_fridge_module - fridge_ext_length/2 + panel_width/2;

    // ---- NO-DRILL ANCHOR BOARD (Section 8) — drawn FIRST so every
    // component sits on top of it. Mat + 3/4in ply: a full-width
    // bridge across the appliance zone's front + strips along the
    // rail lines and the kitchen's sides. Outline is cut only after
    // the Section 0 F1-F7 floor survey. ----
    rail_cx = [fridge_x0 - fridge_slide_margin - fridge_rail_t/2,
               fridge_x0 + fridge_ext_length + fridge_slide_margin + fridge_rail_t/2];
    board_strip(0, 2, 2.5, 30);                                   // driver rail-line strip
    board_strip(rail_cx[1] - 1.25, 2, kitchen_x0 - 0.5 - (rail_cx[1] - 1.25), 30); // center strip: passenger rail + kitchen-left L-track
    board_strip(kitchen_x0 + kitchen_box_width, 2, panel_width - (kitchen_x0 + kitchen_box_width), 30); // kitchen-right strip (1.5in band at the panel edge)
    board_strip(0, 29, panel_width, aboard_bridge_d);             // full-width bridge, Y 29-35
    ltrack(kitchen_x0 - 1.5, 3, 24);                              // L-track, kitchen-left (cabinet-gap) side
    ltrack(kitchen_x0 + kitchen_box_width + 0.25, 3, 24);         // L-track, kitchen-right side
    // kitchen tie-down D-rings (4, stud fittings in the L-track)
    for (kx = [kitchen_x0 - 1, kitchen_x0 + kitchen_box_width + 0.75])
        for (ky = [4, 25]) dring_icon(kx, ky);
    // striker-strap D-rings (3) on the bridge + straps running
    // forward (off the top of the drawing) to the 3rd-row loops
    for (sx = [8, 23, 38]) {
        dring_icon(sx, 32);
        color("Firebrick") {
            hull() { translate([sx, 32.6]) circle(r = 0.22); translate([sx, 40]) circle(r = 0.22); }
            translate([sx, 40]) polygon([[0, 1.6], [-0.9, 0], [0.9, 0]]);
        }
    }
    color("Firebrick") translate([2, 47.4]) text("3 ratchet straps -> 3rd-row STRIKER LOOPS (crash-rated, ~10-14\" fwd of Panel C — position UNVERIFIED, F4)", size = 1.0);
    // 2 steel rail tongues, bridge -> the rear ends of the 2nd-row
    // long-slide floor rails (bolted/clamped there — the PRIMARY
    // forward connection, F8; fallback: butt the striker-row step).
    // They cross under Panel B's rear bottom rail.
    color("DimGray") for (tx = [15, 30]) {
        difference() {
            translate([tx - aboard_tongue_w/2, 33]) square([aboard_tongue_w, 8.5]);
            translate([tx - aboard_tongue_w/2 + 0.15, 33.15]) square([aboard_tongue_w - 0.3, 8.2]);
        }
        // the floor rail's rear end (channel section, drawn dashed-ish
        // as two side lines + end cap) + the tongue's bolt/clamp point
        translate([tx - 1.1, 41]) square([0.22, 5]);
        translate([tx + 0.88, 41]) square([0.22, 5]);
        translate([tx - 1.1, 45.8]) square([2.2, 0.22]);
    }
    color("Black") for (tx = [15, 30]) translate([tx, 42]) circle(r = 0.35); // tongue-to-rail bolt/clamp
    label_left("2 steel rail tongues (2\"x3/16\") BOLT to the rear ends of the 2nd-row FLOOR RAILS (seat anchorage — no new holes; F8;", 2, 50.7, 1.0);
    label_left("fallback: butt the striker-row step, F7) — forward restraint is steel-to-steel to the van's own rails (Sec. 8)", 2, 49.1, 1.0);
    marker(9, 15, 34.8, "DimGray");
    marker(10, 8, 33.8, "Firebrick");

    // Panel C outline (the full 46in x 36in deck footprint)
    rect_outline(panel_width, panel_c_length);
    label(str("PANEL C — ", panel_width, "\" wide x ", panel_c_length, "\" deep, looking down from above"),
          panel_width/2, panel_c_length + 17, 1.6);
    label("TAILGATE (open) — Y = 0 here", panel_width/2, -2, 1.4);
    label("DRIVER side (X=0)", 8, -5.4, 1.1);
    label("PASSENGER side", panel_width - 8, -5.4, 1.1);
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
    marker(6, kitchen_x0 - 1, 14.5, "DimGray"); // kitchen tie-down: L-track + stud D-rings on the board strips

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
    color("SteelBlue") translate([fridge_x0 + 2, 7.2]) text("airflow: cool air in at the front wall (fan + a low passive louver), across the fridge, OUT through the OPEN utility bay toward the tailgate (no door)", size = 0.95);
    // the 2 slide rails stand VERTICALLY flanking the tray (side-mount
    // — see fridge-slide-detail): drawn as the 2 narrow bands beside
    // the fridge, set back ~2.5in from the tailgate face so the
    // driver-side one clears the rear corner leg. Each rail's steel
    // riser bolts to the anchor-board strip drawn under these rail
    // lines (T-nuts from below — no floor holes), never under the tray.
    rail_xs = [fridge_x0 - fridge_slide_margin - fridge_rail_t,
               fridge_x0 + fridge_ext_length + fridge_slide_margin];
    for (rx = rail_xs)
        color("DimGray") translate([rx, 2.5]) rect_outline(fridge_rail_t, fridge_slide_length, 0.12);
    marker(5, rail_xs[1] + fridge_rail_t/2, 27.5, "DimGray");

    // Fridge hold-down strap D-rings (x2, tray side apron — separate
    // from the E-track floor anchors above: these secure the FRIDGE to
    // its TRAY, not the tray to the van floor) — side profile + strap
    // geometry is in fridge-slide-detail.svg
    color("Firebrick") translate([fridge_x0 + fridge_ext_length/2 - 0.3, 1.3]) circle(r = 0.3);
    marker(8, fridge_x0 + fridge_ext_length/2, 3.2, "Firebrick");

    // OPEN utility bay — the gap between the fridge module (left/
    // driver) and the kitchen unit (right/passenger). NO door: the
    // old hinged, louvered door was cut as pointless — the open bay
    // vents the exhaust air straight out the tailgate face and the
    // switches are reached by hand.
    bay_x0 = fridge_x0 + fridge_ext_length + fridge_slide_margin + fridge_rail_stack; // past the passenger-side rail + riser
    bay_w  = kitchen_x0 - bay_x0;
    color("black") translate([bay_x0 + 0.7, 6.8]) rotate(90) text("OPEN BAY (no door)", size = 0.75, halign = "left", valign = "center");
    flow_arrow(bay_x0 + bay_w/2 + 0.6, 6.2, bay_x0 + bay_w/2 + 0.6, -0.9); // exhaust air exits the open bay toward the tailgate

    // WAVE 3 hose/cord storage hook — in the open bay's void (under
    // the deck, same depth as the fridge/kitchen bays), screwed up
    // into the deck underside at the bay's kitchen side
    marker(7, bay_x0 + bay_w/2, 10, "Silver");

    // Control panel — at the tailgate end of the OPEN utility bay,
    // on a backer board hung from the deck underside (Z in the
    // side list; a top-down view only shows its footprint).
    ctrl_x0 = bay_x0 + bay_w/2 - control_panel_width/2;
    color("Black") translate([ctrl_x0, 1.8]) rect_outline(control_panel_width, 1.5);
    marker(4, ctrl_x0 + control_panel_width/2, 5.5, "Black");
    label("(4 sits in the OPEN utility bay — Z in the list.", panel_width/2, -7.6, 1.05);
    label("CO monitor + fire extinguisher: owner-placed, not located here)", panel_width/2, -9.3, 1.05);

    // ---- side list: numbered components with coordinates + fastener spec ----
    list_x = panel_width + 6;
    items = [
        ["1", "DarkGray", "Intake fan (120mm) — blows IN", str("X=", round((fridge_x0+fridge_ext_length/2)*100)/100, " Y=", panel_c_length, " (Panel C's FRONT wall) Z=8.8"), "4x M4x20 machine screws over the wall's fan hole (Front Wall render)"],
        ["2", "Silver", "Exhaust fan (120mm) — blows INTO the open utility bay", str("X=", round((fridge_x0+fridge_ext_length)*100)/100, " Y=", round((fridge_ext_width/2)*10)/10, " Z=8.8"), "4x M4x20 machine screws, 105mm bolt circle, into a plywood fan ring"],
        ["3", "GreenYellow", "NTC temp sensor", str("X=", round((fridge_x0+fridge_ext_length-1.5)*100)/100, " Y=", round((fridge_ext_width/2-2.2)*10)/10, " Z=8.8"), "adhesive thermal pad or 1x #4 screw through its bracket tab"],
        ["4", "Black", "Control panel enclosure", str("X=", round(ctrl_x0*10)/10, "-", round((ctrl_x0+control_panel_width)*10)/10, " Y=~2 Z=6.5-12.5 — in the OPEN utility bay (no door: reach in)"), "backer board (3/4\" offcut) hung from the deck; 4x #8x1\" screws"],
        ["5", "DimGray", "Anchor-board rail strips (x2, under the slide rails)", "mat + 3/4\" ply band on each rail line BESIDE the tray (side-mount) — the fixed rails' risers bolt to them", "1/4-20 machine screws into T-nuts from below — NO holes in the van (Section 8)"],
        ["6", "DimGray", "Kitchen tie-down: L-track + 4 stud D-rings", "on the board's kitchen-side strips (utility-bay gap + the 1.5\" band at the panel edge)", "4 ratchet straps (400lb WLL) criss-crossed over the top into the D-rings"],
        ["7", "Silver", "WAVE 3 hose/cord hook", "in the open bay — screwed up into the deck underside, kitchen side; bundle the hoses so nothing swings out", "1x heavy-duty hook, #8x1.5\" screw — stows hoses+cord when not in use"],
        ["8", "Firebrick", "Fridge hold-down strap D-rings (x2)", "tray side apron, near the tailgate end — hooks to the fridge's 2 end handles", "cam strap, snug not tight — secures fridge TO its tray (the anchor board secures the tray to the van); side profile in fridge-slide-detail"],
        ["9", "DimGray", "Board bridge + 2 steel rail tongues", "full-width 3/4\" ply bridge at Y=29-35; 2\"x3/16\" flat bars run fwd and BOLT to the 2nd-row floor rails' rear ends (F8)", "forward restraint = steel-to-steel to the van's own seat rails, no new holes (fallback: butt the striker-row step, F7)"],
        ["10", "Firebrick", "Striker straps (x3)", "bridge D-rings -> the 3rd-row seat striker loops, fwd of Panel C (crash-rated; position UNVERIFIED, F4)", "400lb WLL ratchet straps — rearward + lift restraint; re-tension after the first drive"],
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
    label_left("NO-DRILL (Section 8): no new holes in the van. The board straps to the 3rd-row striker loops and its tongues",
               list_x, fn_y - 2, 0.95);
    label_left("bolt to the 2nd-row floor rails' rear ends. Cut the board's outline only AFTER the Section 0 F1-F8 survey.",
               list_x, fn_y - 3.5, 0.95);
}

// NOTE: no outer color("black") wrapper here — every helper above
// (rect_outline, label, label_left, marker, anchor_icon) already
// self-colors, and OpenSCAD's camera-preview PNG render does not let
// a nested color() override an OUTER color() wrapping it (the
// outermost color in scope always wins). See top_view.scad/
// rear_view.scad for the same fix applied after this exact bug was
// found mid-project.
drawing();
