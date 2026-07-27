// ============================================================
// Anchor board — ASSEMBLY & CONNECTION details (2D, 4 views)
// ============================================================
// The buildable-part companion to anchor_platform_overhead.scad
// (which shows WHERE the platform sits in the van). This sheet
// shows HOW it goes together (Section 8):
//
//   V1  TOP — the bare plywood assembly, dimensioned: bridge +
//       4 strips, tongue lap joints, L-track, D-rings, riser
//       bolt patterns. This is the piece you cut and bench-build.
//   V2  SIDE — appliances -> board, fridge side: section through
//       a rail-line strip (mat / ply / T-nut / riser / rail /
//       apron / hanging tray), drawn at 4x scale.
//   V3  SIDE — appliances -> board, kitchen side: the criss-cross
//       ratchet straps into the stud D-rings, rear elevation.
//   V4  SIDE — board -> van: the steel tongue let into the
//       bridge's underside dado, bolted, running forward to the
//       floor rail's rear end; the striker strap; the step
//       fallback; Panel B's notched bottom rail.
//
// Rail-end/striker geometry is ASSUMED until the Section 0 F1-F8
// survey (tongue length is cut to what F8 measures).
//
// Render with: openscad -o renders/anchor-board-assembly.svg anchor_board_assembly.scad
// ============================================================

include <params.scad>
include <colors.scad>

stroke = 0.22;

module rect_outline(w, l, s = stroke) {
    color("black")
    difference() {
        square([w, l]);
        translate([s, s]) square([w - 2*s, l - 2*s]);
    }
}

module label(txt, x, y, size = 1.2) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "center", valign = "center");
}

module label_left(txt, x, y, size = 1.05) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "left", valign = "center");
}

module board_piece(x0, y0, w, l) {
    color("Peru") difference() {
        translate([x0, y0]) square([w, l]);
        translate([x0 + 0.15, y0 + 0.15]) square([w - 0.3, l - 0.3]);
    }
    color("Tan") intersection() {
        translate([x0 + 0.3, y0 + 0.3]) square([w - 0.6, l - 0.6]);
        union() {
            for (d = [2 : 4 : w + l])
                translate([x0, y0 + d]) rotate(-45) square([(w + l) * 1.5, 0.08]);
        }
    }
}

module dring_icon(x, y) {
    color("Black") translate([x, y]) difference() { circle(r = 0.55, $fn = 28); circle(r = 0.3, $fn = 20); }
}

module bolt_dot(x, y, r = 0.28) {
    color("Black") translate([x, y]) circle(r = r, $fn = 18);
}

// horizontal dimension: two ticks + a line + centered text above
module dim_h(x0, x1, y, txt, ts = 1.0) {
    color("black") {
        translate([x0, y - 0.7]) square([0.1, 1.4]);
        translate([x1 - 0.1, y - 0.7]) square([0.1, 1.4]);
        translate([x0, y - 0.05]) square([x1 - x0, 0.1]);
    }
    label(txt, (x0 + x1)/2, y + 1.3, ts);
}

module dim_v(x, y0, y1, txt, ts = 1.0) {
    color("black") {
        translate([x - 0.7, y0]) square([1.4, 0.1]);
        translate([x - 0.7, y1 - 0.1]) square([1.4, 0.1]);
        translate([x - 0.05, y0]) square([0.1, y1 - y0]);
    }
    label(txt, x + 2.6, (y0 + y1)/2, ts);
}

module dash_v(x, y0, y1, w = 0.15) {
    for (dy = [0 : 1.6 : y1 - y0 - 0.8]) color("Gray") translate([x, y0 + dy]) square([w, 0.8]);
}

// ============================================================
// V1 — TOP: the bare plywood assembly, dimensioned
// ============================================================
module v1_top() {
    // board geometry (same numbers as the overhead diagram)
    ds_w = 2.5;   cs_x0 = 19.35; cs_w = 4.65; rs_x0 = 44.5; rs_w = 1.5;
    strip_l = 30; strip_y0 = 2;  br_y0 = 29;  br_d = aboard_bridge_d;

    board_piece(0, strip_y0, ds_w, strip_l);
    board_piece(cs_x0, strip_y0, cs_w, strip_l);
    board_piece(rs_x0, strip_y0, rs_w, strip_l);
    board_piece(0, br_y0, panel_width, br_d);

    // riser-angle footprints on the rail-line strips (dashed) + T-nut bolts
    for (rx = [0.15, 19.85]) {
        dash_v(rx, 3, 27); dash_v(rx + 2, 3, 27);
        for (by = [5, 12, 19, 26]) bolt_dot(rx + 1, by);
    }
    label_left("riser-angle footprint (2\"x24\") — 4x 1/4-20 bolts into T-nuts", 3.6, 22, 0.95);
    label_left("(riser shown dashed; same on the center strip)", 3.6, 20.6, 0.95);

    // L-track on the kitchen-side strips
    for (lx = [23, 44.75]) {
        color("DimGray") difference() {
            translate([lx, 3.5]) square([1, 23]);
            translate([lx + 0.12, 3.62]) square([0.76, 22.76]);
        }
        for (dy = [5 : 3 : 25]) bolt_dot(lx + 0.5, dy, 0.16);
    }
    dring_icon(23.5, 6); dring_icon(23.5, 24); dring_icon(45.25, 6); dring_icon(45.25, 24);
    label_left("L-track (screwed to the strip)", 25.2, 26.8, 0.95);
    label_left("+ stud D-rings, kitchen straps", 25.2, 25.4, 0.95);

    // bridge D-rings + tongue lap joints (tongues shown dashed under
    // the bridge, solid where they emerge forward)
    for (sx = [8, 23, 38]) dring_icon(sx, 32);
    for (tx = [15, 30]) {
        dash_v(tx - 1, br_y0 + 0.3, br_y0 + br_d - 0.3); dash_v(tx + 0.85, br_y0 + 0.3, br_y0 + br_d - 0.3);
        color("DimGray") difference() {
            translate([tx - 1, br_y0 + br_d]) square([2, 6]);
            translate([tx - 0.85, br_y0 + br_d]) square([1.7, 5.85]);
        }
        bolt_dot(tx, br_y0 + 1.5); bolt_dot(tx, br_y0 + 4.5);
        color("black") translate([tx, br_y0 + br_d + 7.2]) text("...", size = 1.2, halign = "center");
    }
    label_left("steel tongue (2\"x3/16\"), let into a 3/16\" dado in the", 2, 44.2, 0.95);
    label_left("bridge's UNDERSIDE, 2x 1/4-20 T-nut bolts each — runs fwd,", 2, 42.8, 0.95);
    label_left("cut to the F8-measured length (~10-14\" past the bridge)", 2, 41.4, 0.95);
    label_left("striker-strap D-rings (x3)", 39.6, 32, 0.95);

    // dimensions
    dim_h(0, panel_width, 38.2, str(panel_width, "\""));
    dim_v(-2.5, br_y0, br_y0 + br_d, str(br_d, "\""));
    dim_v(-2.5, strip_y0, strip_y0 + strip_l, str(strip_l, "\""));
    dim_h(0, ds_w, 0, "2.5\"");
    dim_h(cs_x0, cs_x0 + cs_w, 0, "4.65\"");
    dim_h(rs_x0, rs_x0 + rs_w, 0, "1.5\"");
    label("cut everything from one 3/4\" ply sheet's spare + a rubber mat under every piece", panel_width/2, -3.4, 1.0);
    label("(gaps between strips = bare van floor: the fridge tray hangs there, the kitchen sits there)", panel_width/2, -5, 1.0);
    label("V1 — TOP: the plywood assembly (bench-built, then laid in as ONE piece)", panel_width/2, 47.5, 1.3);
    label("fwd ->", -4.5, 34, 1.0);
    label("tailgate ->", -4.5, 6, 1.0);
}

// ============================================================
// V2 — SIDE: appliances -> board, fridge side (4x scale section)
// ============================================================
module v2_fridge_stack() {
    SC = 4;
    // van floor
    color("black") translate([-2, -0.15*1]) square([9.5*SC, 0.25]);
    // mat + ply strip
    color([0.15, 0.15, 0.15]) square([2.5*SC, aboard_mat_t*SC]);
    color("Peru") translate([0, aboard_mat_t*SC]) rect_outline(2.5*SC, aboard_t*SC, 0.18);
    // T-nut (flange under the ply, barrel up) + bolt through the riser leg
    color("Black") {
        translate([1.1*SC, aboard_mat_t*SC]) square([0.3*SC, 0.12*SC]);          // flange (counterbored into the ply bottom)
        translate([1.19*SC, aboard_mat_t*SC]) square([0.12*SC, aboard_t*SC]);     // barrel
        translate([1.16*SC, (aboard_mat_t + aboard_t)*SC]) square([0.18*SC, 0.3*SC]); // bolt head above the riser leg
    }
    // riser angle: horizontal leg on the ply, vertical face inboard
    color("DimGray") {
        translate([0.25*SC, (aboard_mat_t + aboard_t)*SC]) square([2*SC, 0.19*SC]);
        translate([2.06*SC, (aboard_mat_t + aboard_t)*SC]) square([0.19*SC, 2*SC]);
    }
    // VADANIA rail against the riser face (fixed member; bottom at 1.1")
    color("Black") translate([2.25*SC, 1.1*SC]) rect_outline(0.75*SC, 3*SC, 0.2);
    // 1x3 apron + tray edge, hanging at 0.5" over BARE floor
    color("SaddleBrown") translate([3.0*SC, 0.5*SC]) rect_outline(0.75*SC, 2.5*SC, 0.2);
    color("Gray") translate([3.75*SC, 0.5*SC]) rect_outline(2.8*SC, fridge_tray_t*SC, 0.15);
    dash_v(3.9*SC, (0.5 + fridge_tray_t)*SC, (0.5 + fridge_tray_t)*SC + 2.2*SC, 0.2); // fridge above (dashed hint)
    dash_v(6.2*SC, (0.5 + fridge_tray_t)*SC, (0.5 + fridge_tray_t)*SC + 2.2*SC, 0.2);

    // labels
    label_left("<- fridge sits on the tray (dashed, continues up)", 6.8*SC, 2.55*SC, 1.0);
    label_left("<- 3/8\" ply TRAY — hangs 0.5\" over BARE van floor (no board here)", 6.8*SC, 0.7*SC, 1.0);
    label_left("<- 1x3 apron (the slide's moving member screws to it)", 4.0*SC, 2.4*SC + 4.2, 1.0);
    label_left("<- VADANIA fixed rail (3\") — bottom at 1.1\"", 3.15*SC, 4.0*SC, 1.0);
    label_left("<- steel riser angle 2\"x2\"x3/16\"", 2.4*SC, 2.75*SC, 1.0);
    label_left("<- 1/4-20 bolt -> T-nut (flange counterbored into the ply bottom)", 1.5*SC, 1.35*SC, 1.0);
    label_left("<- 3/4\" ply strip", 2.65*SC, 0.55*SC, 1.0);
    label_left("<- non-slip rubber mat (0.1\")", 2.65*SC, 0.1*SC, 1.0);
    label("V2 — SIDE section, fridge side (4x scale): riser + rail bolt to the BOARD, never the van", 4.7*SC, -1.6, 1.2);
    label("(the whole stack repeats at the other rail line, on the center strip)", 4.7*SC, -3.2, 1.0);
}

// ============================================================
// V3 — SIDE: appliances -> board, kitchen side (rear elevation)
// ============================================================
module v3_kitchen_straps() {
    // floor + the 2 flanking strips (end-on) with L-track + D-rings
    color("black") translate([-4, -0.15]) square([30, 0.25]);
    for (bx = [[-2.4, 2], [20.5, 1.5]]) {
        color([0.15, 0.15, 0.15]) translate([bx[0], 0]) square([bx[1], aboard_mat_t]);
        color("Peru") translate([bx[0], aboard_mat_t]) rect_outline(bx[1], aboard_t, 0.12);
        color("DimGray") translate([bx[0] + bx[1]/2 - 0.5, aboard_mat_t + aboard_t]) square([1, 0.4]); // L-track profile
    }
    dring_icon(-1.4, 1.9); dring_icon(21.25, 1.9);
    // kitchen unit
    color("Gainsboro") rect_outline(kitchen_box_width, kitchen_box_height, 0.2);
    label("kitchen unit", kitchen_box_width/2, kitchen_box_height/2 + 1, 1.2);
    label(str(kitchen_box_width, "\" x ", kitchen_box_height, "\" — sits on BARE floor"), kitchen_box_width/2, kitchen_box_height/2 - 1, 0.95);
    // criss-cross straps: each D-ring -> over the top -> opposite top corner zone
    color("Firebrick") {
        hull() { translate([-1.4, 2.4]) circle(r = 0.22, $fn = 16); translate([6, kitchen_box_height + 0.3]) circle(r = 0.22, $fn = 16); }
        hull() { translate([6, kitchen_box_height + 0.3]) circle(r = 0.22, $fn = 16); translate([21.25, 2.4]) circle(r = 0.22, $fn = 16); }
        hull() { translate([21.25, 2.4]) circle(r = 0.22, $fn = 16); translate([14, kitchen_box_height + 0.3]) circle(r = 0.22, $fn = 16); }
        hull() { translate([14, kitchen_box_height + 0.3]) circle(r = 0.22, $fn = 16); translate([-1.4, 2.4]) circle(r = 0.22, $fn = 16); }
    }
    label_left("<- stud D-ring (WLL 1,333lb) dropped into the L-track", 22.6, 1.9, 1.0);
    label_left("ratchet straps (4x, 400lb WLL) criss-cross", 22.6, kitchen_box_height - 1, 1.0);
    label_left("over the top — this is the 2-of-4 view;", 22.6, kitchen_box_height - 2.4, 1.0);
    label_left("the other pair crosses fore-aft", 22.6, kitchen_box_height - 3.8, 1.0);
    label("V3 — REAR elevation, kitchen side: straps -> D-rings -> L-track -> BOARD", 13, -2.6, 1.2);
}

// ============================================================
// V4 — SIDE: board -> van (tongue -> rail end; strap -> striker)
// ============================================================
module v4_board_to_van() {
    // forward at LEFT, tailgate at right
    color("black") translate([-2, -0.15]) square([58, 0.25]);   // van floor
    // step at the striker row (dashed vertical, fallback bearing face)
    dash_v(0, 0, 4.5, 0.25);
    label_left("^ floor STEP at the striker row = the tongue's bearing FALLBACK (F7)", -1, 6.2, 0.95);
    // striker loop (side view: a low arch at the floor)
    color("Black") translate([3.5, 0]) difference() { circle(r = 1.1, $fn = 28); circle(r = 0.65, $fn = 24); translate([-1.6, -1.6]) square([3.2, 1.6]); }
    // floor rail rear end (low channel profile) + tongue bolted to it
    color("Black") {
        translate([7, 0]) square([4, 0.3]);
        translate([7, 0.3]) square([0.35, 0.9]);        // end upstand
        translate([10.65, 0.3]) square([0.35, 0.9]);
    }
    dash_v(6.2, 0.45, 1.1, 0.2);                        // rail continues fwd (schematic)
    // the steel tongue: floor level, from the rail end back under the bridge
    color("DimGray") translate([8, 1.2]) rect_outline(24, 0.6, 0.15); // drawn thick for legibility (real bar: 3/16")
    bolt_dot(9.5, 1.5); // tongue-to-rail bolt/clamp
    // Panel B rear bottom rail, notched over the tongue
    color("Gray") difference() {
        translate([17, 0]) rect_outline(2.25, 2.25, 0.2);
        translate([16.8, 0.9]) square([2.65, 1.1]);
    }
    label_left("Panel B rear bottom rail sits over the run — its shallow notch lets the tongue + strap pass", 2, 7.9, 0.95);
    // bridge: mat + ply, tongue let into its underside dado
    color([0.15, 0.15, 0.15]) translate([26, 0]) square([24, aboard_mat_t * 4]);
    color("Peru") translate([26, aboard_mat_t * 4]) rect_outline(24, aboard_t * 4, 0.2);
    bolt_dot(30, 1.5); bolt_dot(34, 1.5);               // tongue-to-bridge T-nut bolts
    dring_icon(31, aboard_mat_t * 4 + aboard_t * 4 + 0.8);
    label_left("<- 3/4\" PLY BRIDGE on its mat — strips continue right", 50.8, 2, 0.95);
    // strap: bridge D-ring -> striker loop
    color("Firebrick") {
        hull() { translate([31, aboard_mat_t * 4 + aboard_t * 4 + 1.4]) circle(r = 0.25, $fn = 16); translate([3.6, 1.3]) circle(r = 0.25, $fn = 16); }
        translate([2, 9.6]) text("RATCHET STRAP (x3): bridge D-ring -> striker loop, tensioned (rearward + lift restraint)", size = 1.0);
    }
    label_left("striker loop ^", 0.6, -1.5, 0.9);
    label_left("STEEL TONGUE (x2) at floor level: bolt/clamp to the rail's rear end (F8) ... 2x T-nut bolts up into the bridge's underside dado", 6, -2.9, 1.0);
    label("V4 — SIDE: how the board grabs the VAN — forward at left, tailgate at right (vertical scale exaggerated)", 26, -5.2, 1.2);
}

// ============================================================
// SYMBOLS legend — what every mark on this sheet means
// ============================================================
module legend() {
    label_left("SYMBOLS", 0, 1.5, 1.35);
    // 1: hatched piece = plywood
    board_piece(0, -2.4, 6, 2);
    label_left("3/4\" plywood (cut piece, section-hatched)", 7.5, -1.4, 1.0);
    // 2: dark band = rubber mat
    color([0.15, 0.15, 0.15]) translate([0, -4.6]) square([6, 0.6]);
    label_left("non-slip rubber mat (under every piece)", 7.5, -4.3, 1.0);
    // 3: gray outline bar = steel tongue
    color("DimGray") difference() { translate([0, -7.6]) square([6, 1.2]); translate([0.15, -7.45]) square([5.7, 0.9]); }
    label_left("steel tongue — 2\"x3/16\" flat bar", 7.5, -7, 1.0);
    // 4: dashed = hidden / overlaid part
    for (dx = [0 : 1.2 : 5]) color("Gray") translate([dx, -10.2]) square([0.7, 0.15]);
    for (dx = [0 : 1.2 : 5]) color("Gray") translate([dx, -9]) square([0.7, 0.15]);
    label_left("dashed = hidden or overlaid part (riser footprint,", 7.5, -9, 1.0);
    label_left("tongue under the bridge, fridge above the tray)", 7.5, -10.4, 1.0);
    // 5: donut = stud D-ring
    dring_icon(3, -12.6);
    label_left("stud-fitting D-ring (drops into an L-track slot)", 7.5, -12.6, 1.0);
    // 6: dot = bolt into T-nut
    bolt_dot(3, -14.8);
    label_left("1/4-20 bolt into a T-nut (through the ply)", 7.5, -14.8, 1.0);
    // 7: channel + dots = L-track
    color("DimGray") difference() { translate([0, -17.6]) square([6, 1]); translate([0.12, -17.48]) square([5.76, 0.76]); }
    bolt_dot(1.5, -17.1, 0.16); bolt_dot(3, -17.1, 0.16); bolt_dot(4.5, -17.1, 0.16);
    label_left("L-track, screwed to the strip (slot dots)", 7.5, -17.1, 1.0);
    // 8: red line = ratchet strap
    color("Firebrick") hull() { translate([0, -19.5]) circle(r = 0.22, $fn = 16); translate([6, -19.5]) circle(r = 0.22, $fn = 16); }
    label_left("ratchet strap (400lb WLL)", 7.5, -19.5, 1.0);
}

// ============================================================
// sheet layout
// ============================================================
v1_top();
translate([62, 26]) v2_fridge_stack();
translate([64, -2]) v3_kitchen_straps();
translate([2, -18]) v4_board_to_van();
translate([88, -9]) legend();
label("ANCHOR BOARD — assembly & connections (Section 8; companion to the overhead platform diagram)", 52, 51.5, 1.6);
