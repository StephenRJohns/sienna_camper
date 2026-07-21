// ============================================================
// Per-component HEADER TRIO (IKEA-manual style) — one banner per
// Section-6 component: a finished-component "hero" iso drawing, an
// ACCESSORY LIST (lettered hardware icons + counts), and a numbered
// PART LIST (isolated iso geometry of every cut part). Guarantees
// every part/hardware item appears at least once (per-component
// coverage). Driven by:
//    openscad -D comp=N component_headers.scad   (N = 1..10)
// renders to renders/steps/comp-N-header.{svg,png}
// ============================================================

include <hardware_icons.scad>

comp = 2;

// ---- shared geometry shorthands (match panel_ab_lego.scad) ------
RS = frame_rail_sz;
LH = leg_height;
PT = panel_thickness;
DT = drawer_divider_t;
PW = panel_width;      // 46

// a cut part drawn as an iso box centered on the origin
module piso(sz) { wbox([-sz[0]/2, -sz[1]/2, -sz[2]/2], sz); }

// ---- section layout --------------------------------------------
HH = 74;               // section height

// numbered PART-LIST cell: border, number tab, scaled iso geometry, name+count
module part_cell(num, name, count, s = 0.4, cw = 17.5, ch = 17.5) {
    color("Black") difference() { square([cw, ch]); translate([0.28, 0.28]) square([cw - 0.56, ch - 0.56]); }
    color("Black") translate([0, ch - 3.0]) square([3.8, 3.0]);
    color("White") translate([1.9, ch - 1.5]) text(num, size = 1.7, halign = "center", valign = "center");
    translate([cw / 2, ch * 0.56]) scale([s, s]) children();
    color("Black") translate([cw / 2, 2.5]) text(name, size = 1.02, halign = "center", valign = "center");
    color("Black") translate([cw / 2, 0.95]) text(count, size = 1.3, halign = "center", valign = "center");
}

// grid placement helper: cell i at (col,row), top-left origin inside a section
function gx(i, cols, cw) = (i % cols) * cw;
function gy(i, cols, ch, top) = top - (floor(i / cols) + 1) * ch;

// ============================================================
// COMPONENT 2 — Panel A & Bed Platform
// ============================================================
LA = panel_a_length;   // 29
drw_w = drawer_travel - drawer_side_clear;
drw_d = drawer_depth;
drw_h = drawer_height;

module hero_c2() {
    // assembled Panel A frame + legs + divider + right drawer + bed slats
    lib_frame_ring(LA, PW);
    lib_legs(LA, PW);
    // bottom rails (end faces) — shown for completeness
    wbox([-PW/2 + leg_inset, 0, bottom_rail_z], [PW - 2*leg_inset, RS, RS]);
    wbox([-PW/2 + leg_inset, LA - RS, bottom_rail_z], [PW - 2*leg_inset, RS, RS]);
    wbox([-DT/2, RS, 0], [DT, LA - 2*RS, LH]);                          // divider
    wbox([DT/2 + 0.6, RS + 0.6, 0.6], [drw_w, drw_d, drw_h]);           // right drawer (closed)
    // WAVE 3 glide strips, left bay floor
    ifill(INK) { translate([-DT/2 - PW*0.36, RS + 1, 0]) cube([PW*0.30, 1, 0.2]);
                 translate([-DT/2 - PW*0.36, LA - RS - 2, 0]) cube([PW*0.30, 1, 0.2]); }
    // bed platform, lightly exploded UP so the frame beneath reads
    zb = LH + RS + 13;
    for (x = [-PW/2 + 2, PW/2 - 2 - 0.75]) wbox([x, 0, zb], [0.75, LA, 3.5]);      // side rails
    for (y = [1.5 : 5.4 : LA - 2]) wbox([-PW/2 + 3.5, y, zb], [PW - 7, 3.0, 0.75]); // slats
    iarrow([PW*0.28, LA/2, zb - 1.5], [PW*0.28, LA/2, LH + RS + 1], 0.6);
    // numbered callouts -> PART LIST
    part_badge("01", [PW*0.18, RS/2, LH + RS], [2, 9], 2.7);            // end rail (top)
    part_badge("02", [PW/2 - RS/2, LA*0.42, LH + RS], [10, 3], 2.7);   // side rail
    part_badge("03", [-PW/2 + leg_inset + RS/2, 0, LH*0.5], [-11, -3], 2.7); // leg
    part_badge("04", [-PW*0.12, RS/2, bottom_rail_z + RS], [-9, -7], 2.7);   // bottom rail
    part_badge("05", [0, LA*0.5, LH*0.62], [-11, 3], 2.7);            // divider
    part_badge("06", [DT/2 + 0.6 + drw_w/2, RS + drw_d/2, drw_h*0.6], [9, -6], 2.7); // drawer box
    part_badge("07", [-DT/2 - PW*0.22, RS + 1.5, 0.2], [-11, -7], 2.7);      // glide strip
    part_badge("08", [PW/2 - 2, LA*0.5, zb + 2], [11, 5], 2.7);       // bed rail
    part_badge("09", [-PW*0.15, 1.5, zb + 0.75], [-3, 9], 2.7);       // bed slat
}

module accessory_c2() {
    cols = 4; cw = 14.5; ch = 17.0; top = HH - 5.5;
    // [letter, spec, count]
    labels = [
        ["A", "corner bkt 4\"", "x4"], ["B", "diag brace", "x2"], ["C", "wood screw 2\"", "x16"],
        ["D", "leveling foot", "x4"], ["E", "3/8-16 insert", "x4"], ["F", "slide 20\" pr", "x1"],
        ["G", "drawer catch", "x1"], ["H", "D-ring", "x2"], ["I", "cam strap 1\"", "x1"],
        ["J", "grommet 1\"", "x1"], ["K", "pocket scr 1¼", "x16"], ["L", "biscuit R1", "x8"],
        ["M", "pine cleat", "x1"], ["N", "bubble level", "x2"],
    ];
    for (i = [0 : len(labels) - 1])
        translate([gx(i, cols, cw), gy(i, cols, ch, top)])
            accessory_cell(labels[i][0], labels[i][1], labels[i][2], cw - 0.6, ch - 0.7) {
                if (i==0) ic_bracket(); else if (i==1) ic_brace(); else if (i==2) ic_screw();
                else if (i==3) ic_foot(); else if (i==4) ic_insert(); else if (i==5) ic_slide();
                else if (i==6) ic_catch(); else if (i==7) ic_dring(); else if (i==8) ic_cam_strap();
                else if (i==9) ic_grommet(); else if (i==10) ic_pocket_screw(); else if (i==11) ic_biscuit();
                else if (i==12) ic_cleat(); else ic_box("LVL");
            }
}

module partlist_c2() {
    cols = 4; cw = 17.5; ch = 17.5; top = HH - 5.5;
    names = [
        ["01", "end rail 46\"", "2x"], ["02", "side rail 29\"", "2x"], ["03", "leg 16\"", "4x"],
        ["04", "btm rail 46\"", "2x"], ["05", "divider 26\"", "1x"], ["06", "drawer box", "1x"],
        ["07", "glide strip", "2x"], ["08", "bed rail 58\"", "2x"], ["09", "bed slat 45\"", "8x"],
    ];
    for (i = [0 : len(names) - 1])
        translate([gx(i, cols, cw), gy(i, cols, ch, top)])
            part_cell(names[i][0], names[i][1], names[i][2],
                      [0.30, 0.42, 0.75, 0.30, 0.44, 0.34, 0.40, 0.26, 0.32][i], cw, ch) {
                if (i==0) piso([46, RS, RS]); else if (i==1) piso([RS, LA, RS]); else if (i==2) piso([RS, RS, 16]);
                else if (i==3) piso([46, RS, RS]); else if (i==4) piso([RS, 26, RS]); else if (i==5) piso([drw_w, drw_d, drw_h]);
                else if (i==6) piso([PW*0.30, 1, 0.4]); else if (i==7) piso([58, 3.5, 0.75]); else piso([45, 3.5, 0.75]);
            }
}

// ============================================================
// COMPONENT 1 — Rear Pantry (prefab drawer cluster + pot bay)
// ============================================================
module hero_c1() {
    wbox([-24, 0, 0], [48, 16, PT], [0, 0], true);                   // slice of Panel C deck
    for (ix = [0, 1]) for (iz = [0, 1])
        wbox([-22 + ix*12.5, 1, PT + iz*8.2], [12, 14, 8]);          // 2x2 IRIS cluster
    wbox([4, 1.5, PT], [13, 13, 11]);                                // pot crate
    ifill("SaddleBrown") translate([-22.5, 15, PT]) cube([24, 0.9, 5]); // cab-side pine cleat
    // numbered callouts -> PART LIST
    part_badge("01", [-16, 8, PT + 8.2 + 8], [-2, 9], 2.7);          // IRIS drawer unit
    part_badge("02", [10.5, 8, PT + 11], [9, 6], 2.7);              // pot crate
    part_badge("03", [-10, 15.4, PT + 3], [-2, 9], 2.7);           // pine cleat
}
module accessory_c1() {
    cols = 4; cw = 14.5; ch = 17.0; top = HH - 5.5;
    labels = [["A","IRIS drawer","x4"],["B","pot crate","x1"],["C","pine cleat","x3"],
              ["D","cam strap","x1"],["E","flush D-ring","x2"],["F","felt tape","x1"],
              ["G","velcro tie","x8"],["H","bubble level","x1"],["I","power strip","x1"]];
    for (i = [0:len(labels)-1]) translate([gx(i,cols,cw), gy(i,cols,ch,top)])
        accessory_cell(labels[i][0],labels[i][1],labels[i][2],cw-0.6,ch-0.7) {
            if (i==0) ic_box("IRIS"); else if (i==1) ic_box("crate"); else if (i==2) ic_cleat();
            else if (i==3) ic_cam_strap(); else if (i==4) ic_dring(); else if (i==5) ic_bumper();
            else if (i==6) ic_velcro(); else if (i==7) ic_box("LVL"); else ic_box("strip");
        }
}
module partlist_c1() {
    cols = 4; cw = 17.5; ch = 17.5; top = HH - 5.5;
    names = [["01","IRIS unit","4x"],["02","pot crate","1x"],["03","pine cleat","3x"]];
    sc = [0.5, 0.5, 0.9];
    for (i = [0:len(names)-1]) translate([gx(i,cols,cw), gy(i,cols,ch,top)])
        part_cell(names[i][0],names[i][1],names[i][2],sc[i],cw,ch) {
            if (i==0) piso([12,14,8]); else if (i==1) piso([13,13,11]); else piso([12,1,1]);
        }
}

// ============================================================
// COMPONENT 3 — Panel B (bare cube + spare + totes)
// ============================================================
LB = panel_b_length;   // 29
module hero_c3() {
    lib_frame_ring(LB, PW); lib_legs(LB, PW);
    // full-cube bottom rails (all 4 faces)
    wbox([-PW/2 + leg_inset, 0, bottom_rail_z], [PW - 2*leg_inset, RS, RS]);
    wbox([-PW/2 + leg_inset, LB - RS, bottom_rail_z], [PW - 2*leg_inset, RS, RS]);
    wbox([-PW/2 + leg_inset, RS, bottom_rail_z], [RS, LB - 2*RS, RS]);
    wbox([PW/2 - leg_inset - RS, RS, bottom_rail_z], [RS, LB - 2*RS, RS]);
    ifill("SaddleBrown") for (y = [3, LB/2 - 1, LB - 7]) translate([-15, y, 0.5]) cube([30, 3, 2.5]); // cradle skid
    wbox([-14, 2, 3.2], [28, 25, 6]);                                // spare tire (flat slab on skid)
    // 2 totes, lightly exploded UP so the spare + frame read
    zt = LH + RS + 9;
    wbox([-22, 4, zt], [20, 10, 6]); wbox([-22, 4, zt + 6.4], [20, 10, 6]);
    iarrow([-12, 9, zt - 1.5], [-12, 9, LH + RS + 1], 0.6);
    // numbered callouts -> PART LIST
    part_badge("01", [PW*0.15, RS/2, LH + RS], [2, 9], 2.7);         // end rail
    part_badge("02", [PW/2 - RS/2, LB*0.42, LH + RS], [10, 3], 2.7); // side rail
    part_badge("03", [-PW/2 + leg_inset + RS/2, 0, LH*0.5], [-11, -3], 2.7); // leg
    part_badge("04", [-PW*0.12, RS/2, bottom_rail_z + RS], [-9, -7], 2.7);   // btm rail 46
    part_badge("05", [PW/2 - leg_inset - RS/2, LB*0.5, bottom_rail_z + RS], [11, -3], 2.7); // btm rail 26
    part_badge("06", [8, LB/2, 1.5], [10, -5], 2.7);               // cradle skid
    part_badge("07", [-12, 9, zt + 9], [-3, 8], 2.7);             // Sterilite tote
    part_badge("08", [0, 14, 5], [3, -8], 2.7);                  // spare tire
}
module accessory_c3() {
    cols = 4; cw = 14.5; ch = 17.0; top = HH - 5.5;
    labels = [["A","corner bkt 4\"","x4"],["B","diag brace","x2"],["C","wood screw 2\"","x24"],
              ["D","leveling foot","x4"],["E","3/8-16 insert","x4"],["F","footman loop","x2"],
              ["G","cam strap 1\"","x1"],["H","#10 screw","x8"]];
    for (i = [0:len(labels)-1]) translate([gx(i,cols,cw), gy(i,cols,ch,top)])
        accessory_cell(labels[i][0],labels[i][1],labels[i][2],cw-0.6,ch-0.7) {
            if (i==0) ic_bracket(); else if (i==1) ic_brace(); else if (i==2) ic_screw();
            else if (i==3) ic_foot(); else if (i==4) ic_insert(); else if (i==5) ic_footman();
            else if (i==6) ic_cam_strap(); else ic_screw(7);
        }
}
module partlist_c3() {
    cols = 4; cw = 17.5; ch = 17.5; top = HH - 5.5;
    names = [["01","end rail 46\"","2x"],["02","side rail 29\"","2x"],["03","leg 16\"","4x"],
             ["04","btm rail 46\"","2x"],["05","btm rail 26\"","2x"],["06","cradle skid","1x"],
             ["07","Sterilite tote","2x"],["08","spare tire","1x"]];
    sc = [0.30,0.42,0.7,0.30,0.44,0.55,0.36,0.30];
    for (i = [0:len(names)-1]) translate([gx(i,cols,cw), gy(i,cols,ch,top)])
        part_cell(names[i][0],names[i][1],names[i][2],sc[i],cw,ch) {
            if (i==0) piso([46,RS,RS]); else if (i==1) piso([RS,LB,RS]); else if (i==2) piso([RS,RS,16]);
            else if (i==3) piso([46,RS,RS]); else if (i==4) piso([26,RS,RS]); else if (i==5) piso([16,3,2]);
            else if (i==6) piso([23,16,6]); else piso([28,28,6]);
        }
}

// ============================================================
// COMPONENT 4 — Panel C (frame + fixed top + front wall)
// ============================================================
LC = panel_c_length;   // 36
module hero_c4() {
    lib_frame_ring(LC, PW); lib_legs(LC, PW);
    wbox([-PW/2 + leg_inset, 0, bottom_rail_z], [PW - 2*leg_inset, RS, RS]); // front bottom rail
    wbox([-PW/2, 0, 0], [PW, 0.375, 17]);                            // front wall (B-facing face)
    // fixed top, lightly exploded UP
    zt = LH + RS + 11;
    wbox([-PW/2, 0, zt], [PW, LC, PT]);
    iarrow([PW*0.28, LC/2, zt - 1.5], [PW*0.28, LC/2, LH + RS + 1], 0.6);
    // numbered callouts -> PART LIST
    part_badge("01", [PW*0.15, RS/2, LH + RS], [2, 9], 2.7);         // end rail
    part_badge("02", [PW/2 - RS/2, LC*0.45, LH + RS], [10, 3], 2.7); // side rail
    part_badge("03", [-PW/2 + leg_inset + RS/2, 0, LH*0.5], [-11, -3], 2.7); // leg
    part_badge("04", [-PW*0.1, RS/2, bottom_rail_z + RS], [-9, -6], 2.7); // front bottom rail
    part_badge("05", [-PW*0.1, LC*0.5, zt + PT], [-4, 9], 2.7);      // fixed top
    part_badge("06", [-PW/2, LC*0.06, 9], [-11, 3], 2.7);          // front wall
}
module accessory_c4() {
    cols = 4; cw = 14.5; ch = 17.0; top = HH - 5.5;
    labels = [["A","corner bkt 4\"","x4"],["B","wood screw 2\"","x12"],["C","#8 x1¼","x8"],
              ["D","leveling foot","x4"],["E","3/8-16 insert","x4"],["F","louver vent","x1"],
              ["G","grommet 1\"","x1"]];
    for (i = [0:len(labels)-1]) translate([gx(i,cols,cw), gy(i,cols,ch,top)])
        accessory_cell(labels[i][0],labels[i][1],labels[i][2],cw-0.6,ch-0.7) {
            if (i==0) ic_bracket(); else if (i==1) ic_screw(); else if (i==2) ic_screw(7);
            else if (i==3) ic_foot(); else if (i==4) ic_insert(); else if (i==5) ic_louver();
            else ic_grommet();
        }
}
module partlist_c4() {
    cols = 4; cw = 17.5; ch = 17.5; top = HH - 5.5;
    names = [["01","end rail 46\"","2x"],["02","side rail 36\"","2x"],["03","leg 16\"","4x"],
             ["04","front btm rail","1x"],["05","fixed top","1x"],["06","front wall","1x"]];
    sc = [0.30,0.34,0.7,0.30,0.28,0.30];
    for (i = [0:len(names)-1]) translate([gx(i,cols,cw), gy(i,cols,ch,top)])
        part_cell(names[i][0],names[i][1],names[i][2],sc[i],cw,ch) {
            if (i==0) piso([46,RS,RS]); else if (i==1) piso([RS,LC,RS]); else if (i==2) piso([RS,RS,16]);
            else if (i==3) piso([46,RS,RS]); else if (i==4) piso([46,LC,PT]); else piso([46,17,0.375]);
        }
}

// ============================================================
// COMPONENT 5 — Bumpers, alignment pins & seam draw-latches (no cut parts)
// ============================================================
module hero_c5() {
    lib_frame_ring(20, PW); lib_legs(20, PW);
    // bumper strip on the front seam face
    ifill("Peru") translate([-14, 0, LH*0.35]) cube([28, 0.5, 3]);
    // 2 alignment dowel pins on the seam face
    ifill(INK) for (x = [-12, 12]) translate([x, 0, LH*0.68]) rotate([-90, 0, 0]) cylinder(h = 1.3, r = 0.6, $fn = 16);
    // over-center draw latch icon at the near face
    pl = p2([0, 0, LH*0.15]) + [0, -3];
    translate(pl) scale([0.85, 0.85]) ic_latch();
    // callouts -> ACCESSORY LIST (letters A-D)
    badge2d("A", p2([-7, 0, LH*0.35 + 1.5]), [-11, 5], 2.7);   // bumper strip
    badge2d("B", p2([12, 0, LH*0.68]), [10, 5], 2.7);          // dowel pin
    badge2d("C", pl + [-2, 0], [-9, -3], 2.7);                 // draw latch
    badge2d("D", pl + [3, 1], [9, 2], 2.7);                    // mount screw
}
module accessory_c5() {
    cols = 4; cw = 14.5; ch = 17.0; top = HH - 5.5;
    labels = [["A","bumper strip","x2"],["B","dowel pin 3/8","x4"],["C","draw latch","x4"],["D","mount screw","x16"]];
    for (i = [0:len(labels)-1]) translate([gx(i,cols,cw), gy(i,cols,ch,top)])
        accessory_cell(labels[i][0],labels[i][1],labels[i][2],cw-0.6,ch-0.7) {
            if (i==0) ic_bumper(); else if (i==1) ic_dowel(); else if (i==2) ic_latch(); else ic_screw(7);
        }
}
module partlist_note(w, l1, l2) {
    color(INK) translate([w/2 - 1, HH*0.56]) text(l1, size = 2.6, halign = "center", valign = "center");
    color(INK) translate([w/2 - 1, HH*0.56 - 4.5]) text(l2, size = 1.7, halign = "center", valign = "center");
}

// ============================================================
// COMPONENT 6 — Cord runs (no cut parts)
// ============================================================
module hero_c6() {
    lib_frame_ring(58, PW); lib_legs(58, PW);                        // A+B+C run
    // raceway channel along the near rail (DC line)
    ifill("DimGray") translate([-22, 3, LH - 1]) cube([1.5, 48, 1]);
    // dashed cord line + grommets along the run (page space)
    color(INK) dash2d(p2([-18, 3, LH]), p2([-18, 54, LH]), 0.2, 1.6);
    for (y = [6, 28, 50]) translate(p2([-18, y, LH])) scale([0.5, 0.5]) ic_grommet();
    // SAE quick-disconnects at the 2 seams
    for (y = [29, 40]) translate(p2([-18, y, LH])) scale([0.4, 0.4]) ic_sae();
    // power strip + 2-way tap near the tailgate end
    ifill(INK) translate([11, 50, LH]) cube([5, 3, 2]);             // power strip
    ifill("DimGray") translate([2, 51, LH]) cube([3, 2, 1.5]);      // 2-way tap
    // callouts -> ACCESSORY LIST (letters A-E)
    badge2d("A", p2([-18, 6, LH]), [-11, 4], 2.7);                  // grommet
    badge2d("B", p2([-18, 34, LH]), [-11, 3], 2.7);                // SAE disconnect
    badge2d("C", p2([3, 52, LH]), [-3, -8], 2.7);                 // 2-way tap
    badge2d("D", p2([-21, 22, LH]), [-11, -4], 2.7);             // raceway
    badge2d("E", p2([13, 51, LH + 2]), [10, 4], 2.7);           // power strip
}
module accessory_c6() {
    cols = 4; cw = 14.5; ch = 17.0; top = HH - 5.5;
    labels = [["A","grommet 1\"","x7"],["B","SAE disconnect","x2"],["C","2-way tap","x1"],
              ["D","raceway kit","x1"],["E","power strip","x2"]];
    for (i = [0:len(labels)-1]) translate([gx(i,cols,cw), gy(i,cols,ch,top)])
        accessory_cell(labels[i][0],labels[i][1],labels[i][2],cw-0.6,ch-0.7) {
            if (i==0) ic_grommet(); else if (i==1) ic_sae(); else if (i==2) ic_box("tap");
            else if (i==3) ic_box("race"); else ic_box("strip");
        }
}

// ============================================================
// COMPONENT 7 — Fridge & kitchen install
// ============================================================
module hero_c7() {
    wbox([-PW/2, 0, LH+RS], [PW, LC, PT], [0, 0], true);            // deck (context)
    lib_legs(LC, PW, 0, true);
    wbox([-21, -8, 1], [26, 18, 16]);                               // fridge pulled out (-Y = tailgate)
    wbox([-21, -8, 0], [26, 18, 1]);                                // fridge tray under it
    wbox([2, -8, 0], [18, 18, 20]);                                 // kitchen unit pulled out
    wbox([4, -6, 20], [14, 12, 3]);                                 // cooktop on the kitchen
    wbox([-4, -9, 1], [1, 12, 14]);                                 // utility cabinet door (in the gap)
    wbox([3, 12, LH - 3.5], [16, 6, 4.5]);                          // kitchen drawer, hung under deck
    wbox([-3, 12, LH - 4], [10, 6, 0.75]);                          // control backer board
    // numbered callouts -> PART LIST
    part_badge("01", [-8, -8, 0.5], [-4, -8], 2.7);                 // fridge tray
    part_badge("02", [11, 15, LH - 1.5], [9, 4], 2.7);            // kitchen drawer box
    part_badge("03", [3, 15, LH - 1.5], [-10, 3], 2.7);          // drawer cheek
    part_badge("04", [-3.5, -9, 9], [-10, 6], 2.7);              // cabinet door
    part_badge("05", [2, 15, LH - 4], [3, -8], 2.7);            // control backer
    part_badge("06", [-8, -8, 12], [-11, 5], 2.7);              // Rocky 40 fridge
    part_badge("07", [11, 0, 16], [11, 5], 2.7);               // kitchen unit
    part_badge("08", [11, 0, 23], [4, 9], 2.7);               // cooktop
}
module accessory_c7() {
    cols = 4; cw = 14.5; ch = 17.0; top = HH - 5.5;
    labels = [["A","E-track anchor","x8"],["B","carriage bolt","x16"],["C","ratchet strap","x4"],
              ["D","120mm fan","x2"],["E","PWM controller","x1"],["F","toggle switch","x3"],
              ["G","fuse block","x1"],["H","hinge","x2"],["I","magnetic catch","x2"],
              ["J","louver vent","x1"],["K","slide 24\" pr","x2"],["L","wood screw","x16"]];
    for (i = [0:len(labels)-1]) translate([gx(i,cols,cw), gy(i,cols,ch,top)])
        accessory_cell(labels[i][0],labels[i][1],labels[i][2],cw-0.6,ch-0.7) {
            if (i==0) ic_etrack(); else if (i==1) ic_carriage_bolt(); else if (i==2) ic_ratchet_strap();
            else if (i==3) ic_fan(); else if (i==4) ic_controller(); else if (i==5) ic_toggle();
            else if (i==6) ic_fuseblock(); else if (i==7) ic_hinge(); else if (i==8) ic_mag_catch();
            else if (i==9) ic_louver(); else if (i==10) ic_slide(); else ic_screw();
        }
}
module partlist_c7() {
    cols = 4; cw = 17.5; ch = 17.5; top = HH - 5.5;
    names = [["01","fridge tray","1x"],["02","kitchen drawer","1x"],["03","drawer cheek","2x"],
             ["04","cabinet door","1x"],["05","control backer","1x"],["06","Rocky 40 fridge","1x"],
             ["07","kitchen unit","1x"],["08","cooktop","1x"]];
    sc = [0.32,0.34,0.34,0.5,0.55,0.32,0.34,0.5];
    for (i = [0:len(names)-1]) translate([gx(i,cols,cw), gy(i,cols,ch,top)])
        part_cell(names[i][0],names[i][1],names[i][2],sc[i],cw,ch) {
            if (i==0) piso([28,18,1]); else if (i==1) piso([26,16,4.5]); else if (i==2) piso([26,6,0.5]);
            else if (i==3) piso([12,17,0.5]); else if (i==4) piso([14,10,0.75]); else if (i==5) piso([28,18,16]);
            else if (i==6) piso([20,18,20]); else piso([14,12,3]);
        }
}

// ============================================================
// COMPONENT 8 — EcoFlow stowage (DELTA 3 + WAVE 3)
// ============================================================
module hero_c8() {
    lib_frame_ring(29, PW); lib_legs(29, PW);
    wbox([3, 4, 1], [14, 8, 11]);                                   // DELTA 3 Plus
    wbox([3, 13, 1], [11, 8, 11]);                                  // Extra battery
    wbox([3, 4, 12.5], [14, 8, 3]);                                 // found-storage drawer tray (over DELTA)
    wbox([-20, 5, 1], [18, 13, 13]);                                // WAVE 3 left bay
    wbox([-20, 5, LH - 3.5], [18, 13, PT]);                         // found-storage shelf (over WAVE 3)
    // numbered callouts -> PART LIST
    part_badge("01", [10, 8, 6], [9, -5], 2.7);                     // DELTA 3 Plus
    part_badge("02", [8.5, 17, 6], [10, 4], 2.7);                  // Extra Battery
    part_badge("03", [-11, 11, 6], [-11, -4], 2.7);              // WAVE 3
    part_badge("04", [-11, 11, LH - 3.5], [-11, 5], 2.7);        // overhead shelf
    part_badge("05", [10, 8, 14], [3, 9], 2.7);                 // drawer tray
}
module accessory_c8() {
    cols = 4; cw = 14.5; ch = 17.0; top = HH - 5.5;
    labels = [["A","hose/cord hook","x1"],["B","non-slip mat","x1"],["C","Car Vent Kit","x1"],
              ["D","1x1 cleat","x2"],["E","utility bin","x2"]];
    for (i = [0:len(labels)-1]) translate([gx(i,cols,cw), gy(i,cols,ch,top)])
        accessory_cell(labels[i][0],labels[i][1],labels[i][2],cw-0.6,ch-0.7) {
            if (i==0) ic_box("hook"); else if (i==1) ic_box("mat"); else if (i==2) ic_box("vent");
            else if (i==3) ic_cleat(); else ic_box("bin");
        }
}
module partlist_c8() {
    cols = 4; cw = 17.5; ch = 17.5; top = HH - 5.5;
    names = [["01","DELTA 3 Plus","1x"],["02","Extra Battery","1x"],["03","WAVE 3","1x"],
             ["04","overhead shelf","1x"],["05","drawer tray","1x"]];
    sc = [0.5,0.55,0.42,0.45,0.55];
    for (i = [0:len(names)-1]) translate([gx(i,cols,cw), gy(i,cols,ch,top)])
        part_cell(names[i][0],names[i][1],names[i][2],sc[i],cw,ch) {
            if (i==0) piso([15,8,11]); else if (i==1) piso([12,8,11]); else if (i==2) piso([20,13,13]);
            else if (i==3) piso([20,10,0.5]); else piso([15,8,3]);
        }
}

// ============================================================
// COMPONENT 9 — Mattress
// ============================================================
module hero_c9() {
    for (y = [0 : 6 : 24]) wbox([-25, y, 0], [50, 3, 0.75]);        // platform slats
    wbox([-25, 0, 1.0], [50, 29, 3]);                              // firm foam base (DIY) / HEST body
    wbox([-25, 0, 4.0], [50, 29, 1.5]);                            // memory-foam topper (DIY)
    // numbered callouts -> PART LIST
    part_badge("01", [25, 14, 4], [10, 5], 2.7);                    // HEST (whole, primary path)
    part_badge("02", [-25, 3, 2.4], [-11, -3], 2.7);              // firm base (DIY)
    part_badge("03", [-25, 3, 4.75], [-11, 5], 2.7);             // memory topper (DIY)
}
module accessory_c9() {
    cols = 4; cw = 14.5; ch = 17.0; top = HH - 5.5;
    labels = [["A","spray adhesive","x1"],["B","waterproof cover","x1"]];
    for (i = [0:len(labels)-1]) translate([gx(i,cols,cw), gy(i,cols,ch,top)])
        accessory_cell(labels[i][0],labels[i][1],labels[i][2],cw-0.6,ch-0.7) {
            if (i==0) ic_box("glue"); else ic_box("cover");
        }
}
module partlist_c9() {
    cols = 4; cw = 17.5; ch = 17.5; top = HH - 5.5;
    names = [["01","HEST (buy)","1x"],["02","firm base (DIY)","1x"],["03","memory top (DIY)","1x"]];
    sc = [0.26,0.26,0.26];
    for (i = [0:len(names)-1]) translate([gx(i,cols,cw), gy(i,cols,ch,top)])
        part_cell(names[i][0],names[i][1],names[i][2],sc[i],cw,ch) {
            if (i==0) piso([50,50,4]); else if (i==1) piso([50,50,4]); else piso([50,50,2]);
        }
}

// ============================================================
// COMPONENT 10 — Final assembly, curtain & test fit (no cut parts)
// ============================================================
module hero_c10() {
    color(INK) line2d([-24, 8], [24, 8], 0.3);                      // tension rod
    color(INK) for (x = [-22 : 4 : 22]) dash2d([x, 8], [x, -14], 0.14, 1.4); // curtain fabric
    wbox([-20, 0, 0], [40, 6, 0.75], [-0, -22]);                    // platform edge below (sanded/sealed)
    // callouts -> ACCESSORY LIST (letters; sandpaper D is a consumable, not shown)
    badge2d("A", [20, 8], [8, 4], 2.7);                            // tension rod
    badge2d("B", [-2, -4], [-10, 3], 2.7);                        // blackout curtain
    badge2d("C", [8, -20], [9, -3], 2.7);                        // wood sealant (on the platform)
}
module accessory_c10() {
    cols = 4; cw = 14.5; ch = 17.0; top = HH - 5.5;
    labels = [["A","tension rod","x1"],["B","blackout curtain","x1"],["C","wood sealant","x1"],["D","sandpaper","x1"]];
    for (i = [0:len(labels)-1]) translate([gx(i,cols,cw), gy(i,cols,ch,top)])
        accessory_cell(labels[i][0],labels[i][1],labels[i][2],cw-0.6,ch-0.7) {
            if (i==0) ic_rod(); else if (i==1) ic_box("curtain"); else if (i==2) ic_box("varnish"); else ic_box("sand");
        }
}

// ============================================================
// dispatch + banner layout
// ============================================================
titles = [ "", // 1-indexed padding
    "COMPONENT 1 — REAR PANTRY (PREFAB DRAWER CLUSTER + POT BAY)",
    "COMPONENT 2 — PANEL A & BED PLATFORM",
    "COMPONENT 3 — PANEL B",
    "COMPONENT 4 — PANEL C",
    "COMPONENT 5 — BUMPERS, ALIGNMENT PINS & SEAM DRAW-LATCHES",
    "COMPONENT 6 — CORD RUNS (COOKTOP / STRIP 1 / FRIDGE DC / DELTA 3)",
    "COMPONENT 7 — FRIDGE & KITCHEN INSTALL",
    "COMPONENT 8 — ECOFLOW STOWAGE (DELTA 3 + WAVE 3)",
    "COMPONENT 9 — MATTRESS",
    "COMPONENT 10 — FINAL ASSEMBLY, CURTAIN & TEST FIT",
];

module banner(hero_w, acc_w, part_w, hero_dx, hero_dy, hero_s) {
    gap = 4;
    ax = hero_w + gap;
    px = ax + acc_w + gap;
    total = px + part_w;
    // overall title strip
    color(INK) translate([0, HH + 1]) square([total, 0.3]);
    color(INK) translate([total/2, HH + 4]) text(titles[comp], size = 3.0, halign = "center", valign = "center");
    // three sections
    hdr_frame(0, 0, hero_w, HH, "FINISHED COMPONENT");
    hdr_frame(ax, 0, acc_w, HH, "ACCESSORY LIST");
    hdr_frame(px, 0, part_w, HH, "PART LIST");
    // content
    translate([hero_dx, hero_dy]) scale([hero_s, hero_s]) children(0);
    translate([ax + 2, 0]) children(1);
    translate([px + 2, 0]) children(2);
}

if (comp == 1) {
    banner(58, 60, 56, 28, 20, 0.80) { hero_c1(); accessory_c1();
        translate([2, 0]) partlist_c1(); }
} else if (comp == 2) {
    banner(62, 60, 74, 30, 24, 0.85) { hero_c2(); accessory_c2(); partlist_c2(); }
} else if (comp == 3) {
    banner(60, 60, 74, 30, 22, 0.82) { hero_c3(); accessory_c3(); partlist_c3(); }
} else if (comp == 4) {
    banner(60, 60, 74, 30, 20, 0.82) { hero_c4(); accessory_c4(); partlist_c4(); }
} else if (comp == 5) {
    banner(58, 60, 52, 28, 24, 0.85) { hero_c5(); accessory_c5(); partlist_note(52, "(no cut parts)", "hardware mounts to existing panels"); }
} else if (comp == 6) {
    banner(60, 74, 52, 30, 22, 0.80) { hero_c6(); accessory_c6(); partlist_note(52, "(no cut parts)", "cords, grommets & connectors only"); }
} else if (comp == 7) {
    banner(60, 60, 74, 30, 22, 0.82) { hero_c7(); accessory_c7(); partlist_c7(); }
} else if (comp == 8) {
    banner(60, 74, 74, 30, 22, 0.82) { hero_c8(); accessory_c8(); partlist_c8(); }
} else if (comp == 9) {
    banner(58, 60, 56, 28, 22, 0.80) { hero_c9(); accessory_c9(); translate([2, 0]) partlist_c9(); }
} else if (comp == 10) {
    banner(58, 60, 52, 28, 24, 0.85) { hero_c10(); accessory_c10(); partlist_note(52, "(no cut parts)", "finishing + test-fit only"); }
}
