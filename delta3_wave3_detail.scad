// ============================================================
// EcoFlow DELTA 3 Plus + Smart Extra Battery (Panel A right drawer)
// and EcoFlow WAVE 3 (Panel A left bay) — EXPLODED ISOMETRIC
// (woodworking-plan line-art, see steps/lego_lib.scad).
// The right drawer is drawn pulled out the side door with the DELTA 3
// stack inside (Plus outboard, Battery inboard); the WAVE 3 rests in
// the left bay on its glide strips. Found-storage (the reclaimed dead
// headroom: a lift-out tray over the DELTA stack, a shelf over the
// WAVE 3) is shown lifted above each. Clearances are in the side list.
//
// Render with: openscad -o renders/delta3-wave3-detail.svg delta3_wave3_detail.scad
// ============================================================

include <steps/lego_lib.scad>
include <colors.scad>

PT  = panel_thickness;
LA  = panel_a_length;    // 29
W   = panel_width;       // 46
RS  = frame_rail_sz;
LH  = leg_height_ab; // Panel A: legs 3/4" shorter since the deck recess
DT  = drawer_divider_t;
drw_w = drawer_travel - drawer_side_clear;
drw_d = drawer_depth;
drw_h = drawer_height;

module marker3d(n, anchor3, off = [6, 4]) {
    q = p2(anchor3); t = q + off;
    color(INK) line2d(q, t - off * (2.2 / max(2.2, norm(off))));
    color(marker_col(n)) translate(t) circle(r = 1.4);
    color("white") translate(t) text(str(n), size = 1.4, halign = "center", valign = "center");
}
module side_list(list_x, top_y, items) {
    color(INK) translate([list_x, top_y]) text("Component / position", size = 1.6, halign = "left", valign = "center");
    for (i = [0 : len(items) - 1]) {
        y = top_y - 4 - i * 4.2;
        color(marker_col(i + 1)) translate([list_x + 0.8, y]) circle(r = 1.2);
        color("white") translate([list_x + 0.8, y]) text(str(i + 1), size = 1.1, halign = "center", valign = "center");
        color(INK) translate([list_x + 3.4, y + 0.6]) text(items[i][0], size = 1.15, halign = "left", valign = "center");
        color(INK) translate([list_x + 3.4, y - 1.1]) text(items[i][1], size = 0.95, halign = "left", valign = "center");
    }
}

module drawing() {
    // Panel A frame (context)
    lib_frame_ring(LA, W); lib_legs(LA, W);
    wbox([-DT/2, RS, 0], [DT, LA - 2*RS, LH], [0, 0], true);              // divider

    // ---- right (passenger) drawer, pulled out the side door (+X) ----
    pull = 18;
    dx0 = DT/2 + drawer_side_clear;
    // drawer box, exploded outboard along +X
    wbox([dx0 + pull, RS + 0.5, 0.5], [drw_w, drw_d, drw_h]);
    // DELTA 3 Plus (outboard) + Smart Extra Battery (inboard) inside it
    wbox([dx0 + pull + drw_w - delta3_plus_width - 0.4, RS + 2, 1], [delta3_plus_width, delta3_length, delta3_plus_height]);
    wbox([dx0 + pull + 0.4, RS + 2, 1], [delta3_batt_width, delta3_length, delta3_batt_height]);
    // found-storage lift-out tray in the dead air on top of the stack
    wbox([dx0 + pull + 0.4, RS + 2, 1 + delta3_plus_height + 0.4], [drw_w - 0.8, delta3_length, delta3_tray_h]);
    // cam strap over both units + locating cleats
    ifill("Crimson") translate([dx0 + pull, RS + delta3_length*0.5, 1 + delta3_plus_height + delta3_tray_h + 0.6]) cube([drw_w, 0.8, 0.6]);
    iarrow([dx0 + pull - 1.5, RS + drw_d/2, drw_h/2], [dx0 + 2, RS + drw_d/2, drw_h/2], 0.6);
    color(INK) dash2d(p2([dx0 + pull, RS + drw_d/2, 0.5]), p2([dx0, RS + drw_d/2, 0.5]), 0.16, 1.4);

    // ---- left (driver) bay: WAVE 3 open storage on glide strips ----
    wv_x0 = -DT/2 - wave3_width;
    wv_y0 = RS + (LA - 2*RS - wave3_depth)/2;
    wbox([wv_x0, wv_y0, 0.4], [wave3_width, wave3_depth, wave3_height]);
    ifill(INK) { translate([wv_x0 + 1, wv_y0, 0]) cube([wave3_width - 2, 1, 0.2]);
                 translate([wv_x0 + 1, wv_y0 + wave3_depth - 1, 0]) cube([wave3_width - 2, 1, 0.2]); }
    // found-storage shelf on cleats above the WAVE 3 (unit still slides out beneath)
    wbox([wv_x0, wv_y0, wave3_shelf_z], [wave3_width, wave3_depth, PT]);

    // ---- markers ---------------------------------------------------
    // Anchors 5 and 6 share an x,y (the WAVE 3 bay) and differ only in
    // z, so their leaders MUST be thrown apart in page space or the two
    // badges land on top of each other. Same for 1 and 3, which are the
    // DELTA stack and the tray directly above it.
    marker3d(1, [dx0 + pull + drw_w - delta3_plus_width/2, RS + delta3_length/2, 1 + delta3_plus_height], [12, 5]);
    marker3d(2, [dx0 + pull + delta3_batt_width/2, RS + delta3_length/2, 1 + delta3_batt_height], [-11, 5]);
    marker3d(3, [dx0 + pull + drw_w/2, RS + delta3_length/2, 1 + delta3_plus_height + delta3_tray_h/2], [2, 13]);
    marker3d(4, [dx0 + pull + drw_w, RS + delta3_length*0.5, drw_h + 1], [12, -5]);
    marker3d(5, [wv_x0 + wave3_width/2, wv_y0 + wave3_depth/2, wave3_height], [-14, -3]);
    marker3d(6, [wv_x0 + wave3_width/2, wv_y0 + wave3_depth/2, wave3_shelf_z + PT], [-13, 10]);

    // ---- title block + parts list, STACKED BELOW the drawing -------
    // This sheet renders at 2500x4700 (portrait). The title lines used
    // to be centred on page x=0 and the parts list sat out at page
    // x=45, which made the content ~150 units wide and ~50 tall — a 3:1
    // landscape block in a 1:1.9 portrait frame. OpenSCAD's --viewall
    // could not frame that, and both the captions and the list got
    // clipped at the image edges. Everything is now left-aligned to one
    // margin and stacked vertically, so the content block is portrait
    // like the sheet, and every line is kept under ~60 units wide.
    TX = -17;   // one left margin for all page text
    cap("DELTA 3 STACK (right drawer) + WAVE 3 (left bay)", TX, -21, 1.9, "left");
    cap("Panel A, exploded — Components 2 & 8", TX, -24.2, 1.35, "left");
    cap("DELTA 3 Plus outboard (the WAVE 3 plugs into it), Extra Battery", TX, -27.4, 1.2, "left");
    cap("inboard; ~48 lb in a normal drawer — no E-track. The WAVE 3", TX, -29.6, 1.2, "left");
    cap("rests in the raw bay on 2 glide strips.", TX, -31.8, 1.2, "left");
    cap(str("Found storage: a ~", round((drawer_height - delta3_plus_height)*10)/10,
            "\" lift-out tray tops the DELTA stack,"), TX, -35, 1.2, "left");
    cap(str("and a shelf @ ", round(wave3_shelf_z*10)/10,
            "\" tops the WAVE 3 — it still slides out beneath."), TX, -37.2, 1.2, "left");

    side_list(TX, -42, [
        [str("DELTA 3 Plus — ", delta3_plus_width, "\"x", delta3_length, "\"x", delta3_plus_height, "\", ~28 lb"), "outboard (pull wall); cam-strapped over locating cleats"],
        [str("Smart Extra Battery — ", delta3_batt_width, "\"x", delta3_length, "\", ~20 lb"), "inboard — extra runtime only, grabbed less often"],
        [str("Lift-out tray — reclaims ~", round((drawer_height - delta3_plus_height)*10)/10, "\" dead air"), "cables, the DELTA's own cords, dongles"],
        ["Cam strap + D-rings + 1\" grommet", "strap over both units; WAVE 3 charge cable exits the grommet"],
        [str("WAVE 3 — ", wave3_width, "\"x", wave3_depth, "\"x", wave3_height, "\", ", wave3_weight, " lb"), str("raw bay, ", round((wave3_bay_width - wave3_width)*100)/100, "\" clear — a boxed drawer would NOT fit")],
        [str("Overhead shelf @ ", round(wave3_shelf_z*10)/10, "\" on 1x1 cleats"), "flat soft goods + the WAVE 3's own hoses ride up here"],
    ]);
}

drawing();
