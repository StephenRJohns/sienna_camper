// ============================================================
// Floor panel detail — exploded isometric reference, woodworking-
// plan style (see steps/lego_lib.scad for the shared primitives).
// ============================================================
// One combined "everything, exploded, in one picture" reference per
// floor panel — the numbered sequential build steps live in
// steps/panel_ab_lego.scad / steps/panel_c_lego.scad. Set
// -D 'panel="A"|"B"|"C"' to pick which.
//
// Panel A: frame + divider + right drawer (DELTA 3) + WAVE 3 left
// bay. Panel B: BARE frame — no divider, no drawers (the side doors
// don't reach it; deep storage from above), with zoom insets
// dimensioning every hole (leg leveling inserts + alignment pins).
// Panel C: frame + fixed top + its ONE wall (front/B-facing, fan +
// grommet holes — own flat pattern: panel_c_wall_detail.scad), void
// reserved for the bought fridge/kitchen units.
//
// Render with: openscad -o renders/panel-a-detail.svg -D 'panel="A"' panel_detail.scad
// ============================================================
// LEGIBILITY (Aug 2026): 6 prose line(s) moved out of this
// sheet into the document, and every text size scaled x1.8. Those
// sentences were setting the sheet's width, and a figure's printed
// text height is size x (page_width / sheet_width) — so they were
// holding every other label on the sheet down to 3-6pt on paper.
// Keep prose in the markdown; this sheet carries geometry and short
// labels only.

include <steps/lego_lib.scad>
include <colors.scad>

panel = "B"; // "A", "B", or "C"
is_c = (panel == "C");
is_a = (panel == "A");

W  = panel_width;
RS = frame_rail_sz;
LH = is_c ? leg_height : leg_height_ab; // A/B legs 0.75in shorter (deck recess, params.scad)
LC = is_c ? leg_cut_length : leg_cut_length_ab; // saw cut: 17.5in (C's lapped front pair) / 16.75in (A/B) — the foot makes up the last 1in. Panel C's REAR corner pair is butt-under at leg_cut_length_corner (16in); the parts table below spells that out.
PT = panel_thickness;
DT = drawer_divider_t;
L  = is_c ? panel_c_length : panel_b_length; // panel_a_length == panel_b_length, asserted in params.scad

drw_w = drawer_travel - drawer_side_clear;
drw_d = drawer_depth;
drw_h = drawer_height;
pull  = 14; // how far a drawer pulls out for the exploded view

module marker3d(n, anchor3, off = [6, 4]) {
    q = p2(anchor3);
    t = q + off;
    color(marker_col(n)) translate(t) circle(r = 0.9);
    color(marker_col(n)) translate(t + [1.6, 0])
        text(str(n), size = 2.34, halign = "left", valign = "center");
    color(INK) line2d(q, t - off * (2.2 / max(2.2, norm(off))));
}

module side_list(list_x, top_y, items) {
    color(INK) {
        translate([list_x, top_y - 1]) text("Component", size = 2.52, halign = "left", valign = "center");
        translate([list_x, top_y - 4.4]) text("Position / fastener / material", size = 1.98, halign = "left", valign = "center");
    }
    for (i = [0 : len(items) - 1]) {
        y = top_y - 12 - i * 11;
        // numeral BESIDE the swatch — a white numeral centred in a filled
        // circle merges with it (OpenSCAD unions touching 2D shapes and paints
        // them one colour) and the marker reads as an anonymous blob
        color(marker_col(i + 1)) translate([list_x, y + 4.6]) circle(r = 1.1);
        color(marker_col(i + 1)) translate([list_x + 1.9, y + 4.6])
            text(items[i][0], size = 2.16, halign = "left", valign = "center");
        color(INK) {
            translate([list_x + 5.2, y + 4.6]) text(items[i][1], size = 2.07, halign = "left", valign = "center");
            translate([list_x + 5.2, y + 2.1]) text(items[i][2], size = 1.8, halign = "left", valign = "center");
            translate([list_x + 5.2, y - 0.3]) text(items[i][3], size = 1.8, halign = "left", valign = "center");
        }
    }
}

// bottom: cube-frame bottom rails — "ends" (Panel A), "all" (Panel
// B, full cube), "front" (Panel C: tailgate face open, rear legs at
// the TRUE corners so the appliances slide past them)
// LH (this panel's rail underside) was never being passed down to the
// ring/legs, so Panels A and B drew at Panel C's 17in — fixed with the
// leg-lap revision (Sep 2026), which made the difference visible.
module frame_and_legs(drop = 9, bottom = "ends") {
    ri = bottom == "front" ? 0 : leg_inset;
    fy = leg_y_lap(leg_inset);   // lapped legs sit this far inboard
    ry = leg_y_lap(ri);          // 0 at Panel C's true rear corners
    lib_frame_ring(L, W, false, LH);
    lib_legs(L, W, drop, false, ri, LH);
    for (x = [-W/2 + leg_inset, W/2 - RS - leg_inset])
        iarrow([x + RS/2, fy + RS/2, LH - drop + 1.5],
               [x + RS/2, fy + RS/2, leg_len(LH, leg_inset) - 0.5]);
    for (x = [-W/2 + ri, W/2 - RS - ri])
        iarrow([x + RS/2, L - ry - RS/2, LH - drop + 1.5],
               [x + RS/2, L - ry - RS/2, leg_len(LH, ri) - 0.5]);
    // bottom rails, underside at bottom_rail_z (just above the feet).
    // They screw into the legs, so they moved inboard with them.
    wbox([-W/2 + leg_inset, fy, bottom_rail_z], [W - 2 * leg_inset, RS, RS]);
    if (bottom != "front")
        wbox([-W/2 + ri, L - ry - RS, bottom_rail_z], [W - 2 * ri, RS, RS]);
    if (bottom == "all")
        for (x = [-W/2 + leg_inset, W/2 - RS - leg_inset])
            wbox([x, RS + fy, bottom_rail_z], [RS, L - 2 * RS - fy - ry, RS]);
}

module drawing_ab() {
    frame_and_legs();

    // divider, small lift showing it drops into the bay
    div_lift = 6;
    wbox([-DT/2, RS, div_lift], [DT, L - 2 * RS, LH]);
    iarrow([0, L/2, div_lift - 1], [0, L/2, 2]);

    // right (DELTA 3 side) drawer — always a real box, pulled out on its slide
    wbox([DT/2 + drawer_side_clear + pull, RS + 0.5, 0.5], [drw_w, drw_d, drw_h]);
    ifill(INK) translate([W/2 - RS - 0.3, RS + 2, drw_h/2]) cube([0.3, drawer_slide_length, 1.8]);
    for (yf = [0.25, 0.75])
        fastener_light([W/2 - RS - 0.15, RS + 2 + drawer_slide_length * yf, drw_h/2], 0.4, 90);
    iarrow([DT/2 + drawer_side_clear + pull - 1, RS + 0.5 + drw_d/2, drw_h/2],
           [DT/2 + drawer_side_clear + 4, RS + 0.5 + drw_d/2, drw_h/2], 0.6);
    ifill(COL_LATCH) translate([DT/2 + drawer_side_clear + pull + drw_w * 0.5 - 0.5, RS + 0.5 + drw_d - 0.9, drw_h * 0.4]) cube([1, 0.9, 0.9]);

    if (is_a) {
        // left bay: WAVE 3 open storage, resting in place, + glide strips
        wv_y0 = RS + (L - 2 * RS - wave3_depth) / 2;
        wv_x0 = -DT/2 - wave3_width;
        wbox([wv_x0, wv_y0, 0], [wave3_width, wave3_depth, wave3_height]);
        ifill(INK) {
            translate([wv_x0 + 1, wv_y0, 0]) cube([wave3_width - 2, 1, 0.125]);
            translate([wv_x0 + 1, wv_y0 + wave3_depth - 1, 0]) cube([wave3_width - 2, 1, 0.125]);
        }
    } else {
        // left drawer — same construction as the right, pulled out too
        wbox([-DT/2 - drawer_side_clear - drw_w - pull, RS + 0.5, 0.5], [drw_w, drw_d, drw_h]);
        ifill(INK) translate([DT/2, RS + 2, drw_h/2]) cube([0.3, drawer_slide_length, 1.8]);
        for (yf = [0.25, 0.75])
            fastener_light([DT/2 + 0.15, RS + 2 + drawer_slide_length * yf, drw_h/2], 0.4, 90);
        iarrow([-DT/2 - drawer_side_clear - drw_w - pull + drw_w + 1, RS + 0.5 + drw_d/2, drw_h/2],
               [-DT/2 - drawer_side_clear - 4, RS + 0.5 + drw_d/2, drw_h/2], 0.6);
        ifill(COL_LATCH) translate([-DT/2 - drawer_side_clear - pull - drw_w * 0.5 - 0.5, RS + 0.5 + drw_d - 0.9, drw_h * 0.4]) cube([1, 0.9, 0.9]);
    }

    marker3d(1, [W/2 - RS/2, L * 0.15, LH], [10, 6]);
    marker3d(2, [W/2 - RS - leg_inset + RS/2, 0, LH * 0.3], [9, -4]);
    marker3d(3, [0, L - 2 * RS, div_lift + LH], [-12, 5]);
    marker3d(4, [DT/2 + drawer_side_clear + pull + drw_w, RS + 0.5, drw_h], [10, 4]);
    marker3d(5, [W/2 - RS, RS + 2 + drawer_slide_length/2, drw_h/2], [11, -6]);
    marker3d(6, [DT/2 + drawer_side_clear + pull + drw_w * 0.5, RS + 0.5 + drw_d, drw_h * 0.4], [8, -8]);
    if (is_a) marker3d(7, [-DT/2 - wave3_width/2, RS + (L - 2*RS)/2, wave3_height], [-11, 6]);
    marker3d(8, [0, RS/2, bottom_rail_z + RS], [-10, -7]);
}

module drawing_c() {
    frame_and_legs(9, "front"); // front bottom rail only; rear legs at the TRUE corners
    lib_top_drop(L, W);

    // the ONE wall any panel gets: Panel C's front (B-facing) face,
    // exploded forward of its installed position (y = RS, against
    // the front legs' inner faces) — holes dimensioned in
    // panel_c_wall_detail.scad
    wbox([-W/2, -7, 0], [W, pcwall_t, pcwall_h]);
    iarrow([0, -7 + pcwall_t/2 + 1.5, pcwall_h/2], [0, RS - 0.3, pcwall_h/2], 0.5);

    // fridge + kitchen reserved footprint — context only (own full
    // detail: fridge_install_detail.scad), flush to the tailgate-
    // facing (far, high-Y) end. Flat outlines at floor level (not a
    // filled solid — a dark box there reads as a 3rd object floating
    // near the lifted top instead of "empty space below the deck").
    fr_y0 = L - fridge_ext_width;
    kt_y0 = L - kitchen_box_length;
    ifill("Gainsboro") {
        translate([x_fridge_module - fridge_ext_length/2, fr_y0, 0]) cube([fridge_ext_length, fridge_ext_width, 0.05]);
        translate([x_kitchen - kitchen_box_width/2, kt_y0, 0]) cube([kitchen_box_width, kitchen_box_length, 0.05]);
    }

    marker3d(1, [W/2 - RS/2, L * 0.15, LH], [10, 6]);
    marker3d(2, [W/2 - RS - leg_inset + RS/2, 0, LH * 0.3], [9, -4]);
    marker3d(3, [0, L/2, LH + RS + 9 + PT], [10, 6]);
    marker3d(4, [x_fridge_module, (fr_y0 + L) / 2, 0], [11, -4]);
    marker3d(5, [x_kitchen, (kt_y0 + L) / 2, 0], [-11, -6]);
    marker3d(6, [0, -7 + pcwall_t/2, pcwall_h * 0.75], [-12, 5]);
    marker3d(7, [0, RS/2, bottom_rail_z + RS], [-10, -7]);
}

// Panel B: bare frame + legs — NO divider, NO drawers. The side
// doors don't reach this panel, so its whole void is deep storage
// loaded from above (lift the platform + mattress). What it DOES
// have is holes: the leg-bottom leveling-insert holes and the
// alignment-pin holes at both seam faces — dimensioned in the two
// zoom insets.
module drawing_b() {
    frame_and_legs(9, "all"); // the full cube — bottom rails on all 4 faces

    marker3d(1, [W/2 - RS/2, L * 0.15, LH], [10, 6]);
    marker3d(2, [W/2 - RS - leg_inset + RS/2, 0, LH * 0.3], [9, -4]);
    marker3d(3, [0, RS/2, bottom_rail_z + RS], [-10, -6]);

    // ---- zoom inset 1: leg bottom (3x scale), the leveling-foot
    // insert hole — same hole on EVERY leg of every panel ----
    ix = -58; iy = 30; s3 = 3;
    color(INK) translate([ix, iy]) difference() {
        square([RS * s3, RS * s3]);
        translate([0.25, 0.25]) square([RS * s3 - 0.5, RS * s3 - 0.5]);
    }
    color(INK) translate([ix + RS * s3/2, iy + RS * s3/2]) difference() {
        circle(r = 0.25 * s3, $fn = 32); circle(r = 0.25 * s3 - 0.25, $fn = 32);
    }
    color(INK) {
        translate([ix, iy + RS * s3 + 8.4]) text("LEG BOTTOM — all 12 legs", size = 2.34);
        translate([ix, iy + RS * s3 + 5.4]) text("1/2\" dia x 7/8\" deep, dead", size = 1.98);
        translate([ix, iy + RS * s3 + 2.8]) text("center of the end grain", size = 1.98);
        translate([ix, iy - 3.2]) text("drill BEFORE assembly", size = 1.89);
    }

    // ---- zoom inset 2: end-rail seam face, alignment-pin holes ----
    jx = -58; jy = 10; sw = 0.55; // rail face drawn at 0.55x so 46in fits
    color(INK) translate([jx, jy]) difference() {
        square([W * sw, RS * 2.2]);
        translate([0.2, 0.2]) square([W * sw - 0.4, RS * 2.2 - 0.4]);
    }
    for (hx = [3 * sw, (W - 3) * sw])
        color(INK) translate([jx + hx, jy + RS * 1.1]) difference() {
            circle(r = 0.7, $fn = 24); circle(r = 0.5, $fn = 24);
        }
    color(INK) {
        translate([jx, jy + RS * 2.2 + 6.2]) text("END-RAIL SEAM FACE", size = 2.34);
        translate([jx, jy + RS * 2.2 + 3.2]) text("2x 3/8\" pin holes, 3\" in", size = 1.89);
        translate([jx, jy - 3.2]) text("drill as a matched pair", size = 1.8);
    }
}

module drawing() {
    if (is_c) drawing_c(); else if (is_a) drawing_ab(); else drawing_b();

    panel_name = is_c ? "Panel C" : is_a ? "Panel A" : "Panel B";
    cap(str(panel_name, " — exploded detail (", L, "\" x ", W, "\")"), 13, -16, 2.0);

    if (is_c) {
        // MOVED TO THE DOCUMENT: cap("No divider, no drawers — the void stays open for the bought fridge + kitchen unit (Component 7). ONE wall: the front (B-facing) face.", 13, -19, 1.4);
        side_list(56, LH + RS + 9 + PT + 24, [
            ["1", "End rails (x2) + side rails (x2)", str("end rails ", W, "\" (full width, outboard); side rails ", L - 2 * RS, "\" BETWEEN them = ", L, "\" x ", W, "\" perimeter"), "corner brackets + 2\" screws + glue"],
            ["2", "Legs (x4, TWO lengths)", str("FRONT x2: ", LC, "\" cut, LAPPED, inset ", leg_inset, "\"  /  REAR x2: ", leg_cut_length_corner, "\" cut, BUTT-UNDER at the true corners"), "insert hole in each bottom — see the Panel B detail's inset; the 2 rear legs each need a steel angle bracket"],
            ["3", "Fixed top", str(W - 2 * RS, "\" x ", L - 2 * RS, "\", 3/4\" ply — RECESSED between the rails, flush with the rail tops"), "on 3/4x3/4 bearer cleats; NOTCH 1.5x1.5 at the 2 lapped front legs; screwed down — NOT a lift-off lid"],
            ["4", "Fridge zone (reserved)", str(fridge_ext_length, "\" x ", fridge_ext_width, "\", flush LEFT/driver"), "bought product — see fridge-install-detail"],
            ["5", "Kitchen zone (reserved)", str(kitchen_box_width, "\" x ", kitchen_box_length, "\", flush RIGHT/passenger"), "bought product — see fridge-install-detail"],
            ["6", "Front wall (the ONLY wall)", str(W, "\" x ", pcwall_h, "\", 3/8\" ply, on the B-facing face"), "fan hole + 2 grommets — Panel C Front Wall render"],
            ["7", "Bottom rail (x1, FRONT face only)", str("2x2 pine, underside at ", bottom_rail_z, "\", on the front legs' line"), "tailgate face stays open (appliances exit there); REAR legs at the TRUE corners"],
        ]);
    } else if (!is_a) {
        // MOVED TO THE DOCUMENT: cap("NO divider, NO drawers, no skirts — the side doors don't reach Panel B, so its whole bay is deep storage, loaded from above.", 13, -19, 1.4);
        // MOVED TO THE DOCUMENT: cap("THE FULL CUBE: bottom rails on all 4 faces (nothing exits Panel B sideways). Both hole types dimensioned in the insets at left.", 13, -21.5, 1.3);
        side_list(48, LH + 14, [
            ["1", "End rails (x2) + side rails (x2)", str("end rails ", W, "\" (full width, outboard); side rails ", L - 2 * RS, "\" BETWEEN them = ", L, "\" x ", W, "\" perimeter"), "corner brackets + 2\" screws + glue; grip these rails to lift the panel"],
            ["2", "Legs (x4)", str(LC, "\" cut + leveling foot, inset ", leg_inset, "\" from the edge"), "LAPPED to the end rails, tops flush with the rail tops; 1/2\" x 7/8\" insert hole in each bottom (inset at left)"],
            ["3", "Bottom rails (x4 — full cube)", str("2x2 pine, underside at ", bottom_rail_z, "\" (clears the feet/knobs)"), "2x 2\" screws + glue into each leg — the frame racks far less as a closed box"],
        ]);
    } else {
        // MOVED TO THE DOCUMENT: cap("Left (driver-side) bay: WAVE 3 open storage, no drawer box or slide — the unit is too wide for a boxed drawer.", 13, -19, 1.4);
        side_list(48, LH + 14, [
            ["1", "End rails (x2) + side rails (x2)", str("end rails ", W, "\" (full width, outboard); side rails ", L - 2 * RS, "\" BETWEEN them = ", L, "\" x ", W, "\" perimeter"), "corner brackets + 2\" screws + glue"],
            ["2", "Legs (x4)", str(LC, "\" cut + leveling foot, inset ", leg_inset, "\" from the edge"), "LAPPED to the end rails, tops flush with the rail tops; 1/2\" x 7/8\" insert hole in each bottom (Panel B detail's inset)"],
            ["3", "Center divider", str(L - 2*RS, "\" cut, 2x2 pine"), "splits the bay — drawer (right) / WAVE 3 (left)"],
            ["4", "Drawer box (right, DELTA 3 side)", str(drw_w, "\" x ", drw_d, "\" x ", drw_h, "\", 3/8\" ply, 1/2\" bottom"), "5 pieces, glued + biscuited"],
            ["5", "Drawer slide (right)", str(drawer_slide_length, "\" full-extension pair"), "box-to-rail + box-to-divider"],
            ["6", "Drawer catch (right)", "friction catch or small turn latch", "keeps the drawer shut in transit"],
            ["7", "WAVE 3 + glide strips (left)", "2x glide strip, UHMW/laminate scrap", "no box, no slide — rests directly on the bay floor"],
            ["8", "Bottom rails (x2, END faces only)", str("2x2 pine, underside at ", bottom_rail_z, "\""), "the SIDE faces stay open — the drawer + WAVE 3 exit there at floor level"],
        ]);
    }
}

drawing();
