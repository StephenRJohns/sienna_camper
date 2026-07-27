// ============================================================
// No-drill anchor platform — OVERHEAD detail (2D, plan view)
// ============================================================
// Companion to the Overhead Floorplan: the whole securing system
// for the fridge + kitchen (Section 8) seen from above, INCLUDING
// the factory hardpoints forward of Panel C that the whole design
// hangs off — the rear ends of the 2nd-row long-slide floor rails
// (the tongues bolt to them) and the 3 crash-rated 3rd-row striker
// loops (the straps drop into them). fridge_install_detail.scad
// zooms into Panel C's footprint for per-component coordinates;
// THIS drawing exists to show the load paths leaving Panel C.
//
// NOTHING here bolts to the van: mat + 3/4in ply board, tongues to
// the rails' existing end hardware, straps into the loops.
//
// COORDINATE SYSTEM: same as fridge_install_detail.scad — origin
// at Panel C's tailgate-facing DRIVER-side corner, X 0-46 toward
// the passenger side, Y forward from the tailgate (Panel C is
// Y 0-36; everything above Y=36 sits under Panel B).
//
// UNVERIFIED geometry (drawn at the plan's assumptions): striker
// row ~46-50in fwd of the hatch (F4), rail rear ends reaching that
// same zone (F8), rail lateral spacing (F8). Re-render after the
// Section 0 survey pins the real numbers.
//
// Render with: openscad -o renders/anchor-platform-overhead.svg anchor_platform_overhead.scad
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

module label(txt, x, y, size = 1.3) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "center", valign = "center");
}

module label_left(txt, x, y, size = 1.1) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "left", valign = "center");
}

// anchor-board piece: outline + diagonal section hatch (line art —
// same technique as fridge_install_detail.scad)
module board_piece(x0, y0, w, l) {
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

module dring_icon(x, y) {
    color("Black") translate([x, y]) difference() { circle(r = 0.55); circle(r = 0.3); }
}

// a 3rd-row striker: the crash-rated wire latch loop, drawn as a
// stubby U seen from above
module striker_icon(x, y) {
    color("Black") translate([x, y]) {
        difference() { circle(r = 0.9); circle(r = 0.55); }
        translate([-1.45, -0.35]) square([0.55, 0.7]);
        translate([0.9, -0.35]) square([0.55, 0.7]);
    }
}

module dash_y(x, y0, y1, w = 0.2) {
    for (dy = [0 : 1.8 : y1 - y0 - 0.9]) color("Gray") translate([x, y0 + dy]) square([w, 0.9]);
}

module dash_x(x0, x1, y, h = 0.2) {
    for (dx = [0 : 1.8 : x1 - x0 - 0.9]) color("Gray") translate([x0 + dx, y]) square([0.9, h]);
}

module drawing() {
    kitchen_x0 = x_kitchen - kitchen_box_width/2 + panel_width/2;   // 24.5
    fridge_x0  = x_fridge_module - fridge_ext_length/2 + panel_width/2; // 2
    rail_cx = [fridge_x0 - fridge_slide_margin - fridge_rail_t/2,
               fridge_x0 + fridge_ext_length + fridge_slide_margin + fridge_rail_t/2];
    striker_y = 48;        // ASSUMED striker row / floor step (F4/F7)
    railend_y = 44;        // ASSUMED rail rear ends (F8)
    tongue_x  = [15, 30];  // follows the rails' ASSUMED lateral spacing (F8)
    striker_x = [8, 23, 38];

    // ---- context: Panel C + Panel B footprints ----
    rect_outline(panel_width, panel_c_length);
    label("PANEL C footprint (fridge + kitchen live under its deck)", panel_width/2, 2.2, 1.15);
    dash_x(0, panel_width, panel_c_length + panel_b_length > 62 ? 60 : panel_c_length + panel_b_length); // Panel B far edge (clipped)
    dash_y(0, panel_c_length, 60); dash_y(panel_width - 0.2, panel_c_length, 60);
    label("PANEL B above (bare cube frame) — tongues + straps pass UNDER its rear bottom rail through shallow relief notches", panel_width/2, 37.6, 1.0);
    label("TAILGATE (open) — Y = 0", panel_width/2, -2, 1.3);
    label("DRIVER side (X=0)", 6.5, -4, 1.0);
    label("PASSENGER side", panel_width - 7, -4, 1.0);

    // ---- ghost appliances ----
    color("Gainsboro") translate([fridge_x0, 4.5]) rect_outline(fridge_ext_length, fridge_ext_width - 4.5, 0.12);
    label("Fridge", fridge_x0 + fridge_ext_length/2, 14, 1.1);
    label("(on its slide)", fridge_x0 + fridge_ext_length/2, 12.4, 0.9);
    color("Gainsboro") translate([kitchen_x0, 4.5]) rect_outline(kitchen_box_width, kitchen_box_length - 4.5, 0.12);
    label("Kitchen unit", kitchen_x0 + kitchen_box_width/2, 14, 1.1);
    label("(straps criss-cross", kitchen_x0 + kitchen_box_width/2, 12.4, 0.9);
    label("into the L-track)", kitchen_x0 + kitchen_box_width/2, 11.1, 0.9);

    // ---- the anchor board: 4 strips + full-width bridge ----
    board_piece(0, 2, 2.5, 30);                                                  // driver rail-line strip
    board_piece(rail_cx[1] - 1.25, 2, kitchen_x0 - 0.5 - (rail_cx[1] - 1.25), 30); // center strip (rail + utility-bay gap)
    board_piece(kitchen_x0 + kitchen_box_width, 2, panel_width - (kitchen_x0 + kitchen_box_width), 30); // kitchen-right strip
    board_piece(0, 29, panel_width, aboard_bridge_d);                            // full-width bridge, Y 29-35
    // kitchen tie-down D-rings (stud fittings in the strips' L-track)
    for (kx = [kitchen_x0 - 1, kitchen_x0 + kitchen_box_width + 0.75])
        for (ky = [4, 25]) dring_icon(kx, ky);

    // ---- forward hardpoint 1: the 2nd-row floor rails ----
    for (tx = tongue_x) {
        // tongue: bridge -> rail end (outline flat bar)
        color("DimGray") difference() {
            translate([tx - aboard_tongue_w/2, 33]) square([aboard_tongue_w, railend_y - 33 + 1.5]);
            translate([tx - aboard_tongue_w/2 + 0.15, 33.15]) square([aboard_tongue_w - 0.3, railend_y - 33 + 1.2]);
        }
        // rail: solid channel at its rear end, dashed continuing forward
        color("Black") {
            translate([tx - 1.2, railend_y]) square([0.25, 8]);
            translate([tx + 0.95, railend_y]) square([0.25, 8]);
            translate([tx - 1.2, railend_y - 0.25]) square([2.4, 0.25]); // rear end cap
        }
        dash_y(tx - 1.2, railend_y + 8, 60, 0.25);
        dash_y(tx + 0.95, railend_y + 8, 60, 0.25);
        color("Black") translate([tx, railend_y + 1.2]) circle(r = 0.4);  // tongue-to-rail bolt/clamp point
    }
    label_left("2nd-row FLOOR RAILS (dashed fwd) —", -26, railend_y + 10.5, 1.05);
    label_left("seat anchorage, carriages parked fwd;", -26, railend_y + 9, 1.05);
    label_left("each TONGUE bolts to a rail's rear", -26, railend_y + 7.5, 1.05);
    label_left("end hardware — NO new holes (F8)", -26, railend_y + 6, 1.05);

    // ---- forward hardpoint 2: the 3rd-row strikers ----
    // striker row / floor step, dashed across
    dash_x(-2, panel_width + 2, striker_y - 1.9, 0.18);
    for (sx = striker_x) {
        striker_icon(sx, striker_y);
        dring_icon(sx, 32);
        color("Firebrick") {
            hull() { translate([sx, 32.6]) circle(r = 0.22); translate([sx, striker_y - 1.1]) circle(r = 0.22); }
            translate([sx, striker_y - 2.6]) polygon([[0, 1.4], [-0.8, 0], [0.8, 0]]);
        }
    }
    color("Firebrick") {
        translate([-26, 42.5]) text("3 ratchet straps (400lb WLL each):", size = 1.05);
        translate([-26, 41]) text("bridge D-rings -> the 3 crash-rated", size = 1.05);
        translate([-26, 39.5]) text("3rd-row STRIKER LOOPS (rear + lift)", size = 1.05);
    }
    label_left("striker row + floor step — ASSUMED", -26, striker_y - 1, 0.95);
    label_left("~46-50\" fwd of hatch (F4/F7); the", -26, striker_y - 2.4, 0.95);
    label_left("step = the tongues' bearing FALLBACK", -26, striker_y - 3.8, 0.95);

    // ---- notes column ----
    nx = panel_width + 6;
    label_left("NO-DRILL ANCHOR PLATFORM — Section 8", nx, 58, 1.5);
    notes = [
        "Mat + 3/4\" ply board (hatched): a full-width bridge +",
        "4 strips under the fridge slide risers and along the",
        "kitchen's sides. Riser angles + L-track bolt to the",
        "BOARD (1/4-20 T-nuts) — never to the vehicle.",
        "",
        "FORWARD load path: the 2 steel tongues, bolted to the",
        "2nd-row floor rails' rear ends — steel to the van's own",
        "seat-rail anchorage (fallback: butt the striker-row step).",
        "",
        "REARWARD + LIFT: the 3 striker straps, tensioned.",
        "LATERAL: strap splay + the well/van walls + the mat.",
        "",
        "Kitchen unit: 4 straps criss-crossed over the top into",
        "stud-fitting D-rings (WLL 1,333lb) in the strips' L-track.",
        "Fridge: risers hold its slide; a cam strap over its end",
        "handles pins it to its tray (fridge-slide-detail).",
        "",
        "Margin: 3 straps = 1,200lb WLL vs ~80lb required by the",
        "49 CFR 393 yardstick (~155lb cargo + board) — before",
        "counting the bolted rail link.",
        "",
        "Board outline, tongue length & bracket detail are cut",
        "only AFTER the Section 0 F1-F8 floor survey.",
    ];
    for (i = [0 : len(notes) - 1])
        label_left(notes[i], nx, 55 - i * 2.1, 1.05);

    label("NO-DRILL ANCHOR PLATFORM — overhead: Panel C + the factory hardpoints forward of it (Section 8)", panel_width/2 + 14, 63, 1.6);
}

// no outer color() wrapper — helpers self-color (see
// fridge_install_detail.scad for why)
drawing();
