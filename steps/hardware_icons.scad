// ============================================================
// Hardware icon library — small iso/elevation line-art icons for
// the per-component ACCESSORY LISTs (IKEA-manual style). Each ic_*
// module draws a recognizable 2D icon centered at the origin, sized
// to sit inside an accessory_cell (~fits a 9-wide x 10-tall area).
// Style matches lego_lib.scad: white "paper" fill, black edges.
// ============================================================
// include <hardware_icons.scad> from a header file (it pulls in
// lego_lib.scad, which pulls in params.scad). Draw an icon inside a
// cell like:
//    translate([x,y]) accessory_cell("A", "2\" wood screw", "x8") ic_screw();
// ============================================================

include <lego_lib.scad>

$fn = 32;
IB = 0.16; // icon line (border) weight

// white fill + black outline of whatever 2D shape the children draw
module linefill(b = IB) {
    color("Black") children();
    color("White") offset(delta = -b) children();
}
// a plain black stroke between two 2D points (reuses lego_lib line2d)
module stroke(a, b, w = IB) { color("Black") line2d(a, b, w); }

// ---- fasteners --------------------------------------------------
module ic_screw(l = 9, taper = true) {
    hw = 1.15;
    linefill() polygon([[-hw, l/2], [hw, l/2], [hw*0.72, l/2 - 1.0], [-hw*0.72, l/2 - 1.0]]); // head
    tip = taper ? 0 : 0.28;
    linefill() polygon([[-0.62, l/2 - 1.0], [0.62, l/2 - 1.0], [tip, -l/2], [-tip, -l/2]]);   // shank
    color("Black") for (t = [l/2 - 1.5 : -0.9 : -l/2 + 0.7]) // thread ticks
        line2d([-0.6, t + 0.35], [0.6, t - 0.35], 0.12);
    color("Black") line2d([-hw*0.55, l/2 - 0.5], [hw*0.55, l/2 - 0.5], 0.12); // drive slot
}
module ic_pocket_screw(l = 8) {
    linefill() union() { translate([0, l/2 - 0.5]) square([3.0, 1.0], center = true); // washer head
                         translate([0, l/2 - 1.1]) circle(1.05); }
    linefill() polygon([[-0.6, l/2 - 1.6], [0.6, l/2 - 1.6], [0, -l/2], [0, -l/2]]);
    color("Black") for (t = [l/2 - 2.2 : -0.9 : -l/2 + 0.7])
        line2d([-0.55, t + 0.3], [0.55, t - 0.3], 0.12);
}
module ic_carriage_bolt(l = 9) {
    linefill() translate([0, l/2 - 0.9]) intersection() { circle(1.35); translate([0, 0]) square([3, 3], center = true); } // dome
    linefill() square([1.0, l - 3], center = false, $fn = 4);
    translate([-0.5, -l/2 + 1]) linefill() square([1.0, l - 3.5]);
    color("Black") for (t = [l/2 - 2.6 : -0.9 : -l/2 + 3.2]) line2d([-0.5, t], [0.5, t], 0.1);
    linefill() translate([0, -l/2 + 1.6]) square([2.4, 1.1], center = true); // nut
}
module ic_bracket() { // L angle bracket with holes
    linefill() polygon([[-4, 4], [-4, -4], [4, -4], [4, -2.4], [-2.4, -2.4], [-2.4, 4]]);
    color("White") { translate([-3.2, 2.6]) circle(0.55); translate([2.4, -3.2]) circle(0.55); }
    color("Black") { translate([-3.2, 2.6]) difference() { circle(0.55); circle(0.4); }
                     translate([2.4, -3.2]) difference() { circle(0.55); circle(0.4); } }
}
module ic_brace() { // flat diagonal strap w/ 2 holes
    linefill() rotate(45) square([11, 2.4], center = true);
    for (s = [-1, 1]) color("Black") translate([s*2.6, s*2.6]) difference() { circle(0.5); circle(0.36); }
}
module ic_slide() { // telescoping drawer slide, 2 nested rails
    linefill() square([12, 1.6], center = true);
    linefill() translate([1.2, 1.1]) square([11, 1.3], center = true);
    color("Black") for (x = [-4.5 : 2.2 : 4.5]) translate([x, -0.1]) circle(0.28);
}
module ic_catch() { // roller/friction catch
    linefill() square([3.2, 4.2], center = true);
    linefill() translate([2.2, 0]) circle(1.2);
    color("Black") translate([-0.9, 1.3]) circle(0.3);
    color("Black") translate([-0.9, -1.3]) circle(0.3);
}
module ic_mag_catch() {
    linefill() square([4.6, 2.6], center = true);
    color("Black") text("N", size = 1.4, halign = "center", valign = "center");
    color("Black") translate([-1.15, 0]) line2d([0, -1], [0, 1], 0.12);
}
module ic_dowel() { // rounded-end pin
    linefill() hull() { translate([0, 3.4]) circle(0.9); translate([0, -3.4]) circle(0.9); }
    color("Black") for (t = [2.4, 0, -2.4]) line2d([-0.9, t], [0.9, t], 0.1);
}
module ic_bumper() { // adhesive bumper strip w/ bumps
    linefill() square([10, 1.4], center = true);
    color("Black") for (x = [-4 : 2 : 4]) translate([x, 1.0]) circle(0.55);
    color("White") for (x = [-4 : 2 : 4]) translate([x, 1.0]) circle(0.4);
}
module ic_latch() { // over-center draw latch
    linefill() translate([-3, -1]) square([3.2, 3.6]);      // base plate
    linefill() translate([-1.4, 1.6]) rotate(-18) square([5.2, 1.5]); // lever
    linefill() translate([3.6, -0.6]) square([1.4, 2.8]);   // keeper
    color("Black") translate([-1.5, 0.2]) circle(0.35);     // pivot
}
module ic_grommet() { color("Black") difference() { circle(3.2); circle(2.2); } color("Black") difference() { circle(2.2); circle(1.9); } }
module ic_sae() { // 2-pin quick disconnect
    linefill() translate([-2.6, 0]) square([2.6, 3.4], center = true);
    linefill() translate([2.6, 0]) square([2.6, 3.4], center = true);
    color("Black") { translate([-2.6, 0]) circle(0.55); translate([2.6, 0]) circle(0.55); }
    stroke([-3.9, 0], [-5, 0]); stroke([3.9, 0], [5, 0]);
}
module ic_dring() { // screw-eye D-ring
    color("Black") difference() { circle(1.3); circle(0.85); } // eye
    linefill() translate([0, -2.6]) polygon([[-0.5, 1.4], [0.5, 1.4], [0.25, -1.6], [-0.25, -1.6]]); // screw
    color("Black") difference() { translate([0, 2.6]) scale([1.5, 1]) circle(2.0); translate([0, 2.6]) scale([1.5, 1]) circle(1.4); } // D
}
module ic_cam_strap() { // cam buckle + webbing
    linefill() translate([-2.5, 0]) square([3.4, 3.4], center = true); // buckle
    color("Black") translate([-2.5, 0]) line2d([-1, 0], [1, 0], 0.35);
    linefill() translate([2.2, 0]) square([5, 2.0], center = true);   // strap
}
module ic_etrack() { // E-track anchor fitting
    linefill() square([9, 3.2], center = true);
    color("White") for (x = [-3 : 2 : 3]) translate([x, 0]) square([1.0, 2.0], center = true);
    color("Black") for (x = [-3 : 2 : 3]) translate([x, 0]) difference() { square([1.0, 2.0], center = true); square([0.7, 1.7], center = true); }
}
module ic_ratchet_strap() {
    linefill() translate([-2, 0]) square([4.6, 3.8], center = true); // ratchet body
    linefill() translate([-2, 2.6]) rotate(20) square([3.6, 1.2]);   // handle
    linefill() translate([3.2, 0]) square([4, 1.8], center = true);  // strap
    color("Black") translate([-2, 0]) circle(0.5);
}
module ic_fan() {
    color("Black") difference() { square([8, 8], center = true); square([7.2, 7.2], center = true); }
    color("Black") difference() { circle(3.4); circle(3.0); }
    color("Black") for (a = [0:90:270]) rotate(a) translate([1.5, 0]) scale([1, 0.5]) circle(1.5);
    color("Black") circle(0.6);
    color("Black") for (c = [[-3.4, 3.4], [3.4, 3.4], [-3.4, -3.4], [3.4, -3.4]]) translate(c) circle(0.4);
}
module ic_controller() { // PWM controller + NTC probe
    linefill() square([6, 5], center = true);
    color("Black") translate([-1.3, 0]) circle(1.1);          // knob
    color("Black") translate([-1.3, 0]) line2d([0, 0], [0.7, 0.7], 0.12);
    color("Black") translate([1.4, 1.2]) square([1.6, 0.9], center = true); // display
    stroke([3, -1.4], [5, -3]); linefill() translate([5.2, -3.2]) circle(0.7); // NTC probe
}
module ic_toggle() {
    linefill() square([3.2, 4.6], center = true);
    linefill() translate([0.8, 2.2]) rotate(-25) square([1.0, 3.0]);
    color("Black") circle(0.5);
}
module ic_fuseblock() {
    linefill() square([7, 4.5], center = true);
    color("Black") for (x = [-2, 0, 2]) { translate([x, 0]) difference() { square([1.2, 3], center = true); square([0.85, 2.6], center = true); } }
}
module ic_hinge() { // butt hinge, open
    linefill() translate([-2.2, 0]) square([4, 6], center = true);
    linefill() translate([2.2, 0]) square([4, 6], center = true);
    color("Black") for (y = [-2.2, 0, 2.2]) translate([0, y]) circle(0.7);
    color("White") for (c = [[-3, 2], [-3, -2], [3, 2], [3, -2]]) translate(c) circle(0.45);
}
module ic_louver() {
    linefill() square([9, 6], center = true);
    color("Black") for (y = [-1.8 : 1.5 : 2.2]) line2d([-3.6, y - 0.3], [3.6, y + 0.3], 0.18);
}
module ic_biscuit() { linefill() scale([1.6, 1]) circle(3); color("Black") scale([1.6, 1]) difference() { circle(3); circle(2.7); } }
module ic_cleat() { linefill() square([9, 2.4], center = true); color("Black") for (x = [-3, 0, 3]) translate([x, 0]) circle(0.3); }
module ic_footman() { // footman loop
    linefill() square([7, 1.6], center = true);
    color("Black") difference() { translate([0, 1.6]) scale([1.4, 1]) circle(2.2); translate([0, 1.6]) scale([1.4, 1]) circle(1.5); }
    color("White") { translate([-2.6, 0]) circle(0.4); translate([2.6, 0]) circle(0.4); }
}
module ic_foot() { // leveling foot: star knob + stud + pad (compact elevation)
    linefill() polygon([[-3.2, -4], [3.2, -4], [2.2, -2.8], [-2.2, -2.8]]); // pad
    linefill() square([0.9, 4.4], center = true);                            // stud
    color("Black") for (t = [-1.6 : 0.7 : 1.8]) line2d([-0.45, t], [0.45, t], 0.1);
    color("Black") difference() { translate([0, 2.6]) circle(2.2, $fn = 5); translate([0, 2.6]) circle(1.5, $fn = 5); } // star knob
}
module ic_insert() { // screw-in threaded insert
    linefill() polygon([[-2.4, 3], [2.4, 3], [2.4, 2.2], [1.4, 2.2], [1.4, -3], [-1.4, -3], [-1.4, 2.2], [-2.4, 2.2]]);
    color("Black") for (s = [-1, 1]) for (y = [-2.4 : 0.8 : 1.8]) translate([s*1.4, y]) line2d([0, 0], [s*0.6, -0.4], 0.1);
}
module ic_rod() { linefill() hull() { translate([-5, 0]) circle(0.9); translate([5, 0]) circle(0.9); } color("Black") { translate([-5, 0]) circle(0.9); translate([5, 0]) circle(0.9); } }
module ic_foam() { linefill() translate([0, -1.2]) square([10, 3.2], center = true); linefill() translate([0, 1.6]) square([10, 2.0], center = true); }
module ic_velcro() { linefill() square([8, 2.2], center = true); color("Black") for (x = [-3 : 1.5 : 3]) { translate([x, 0.4]) circle(0.28); } }

// generic labelled box for whole purchased units (appliances, totes,
// power gear) — icons for these would add nothing over the name.
module ic_box(txt, w = 9, h = 7) {
    linefill() square([w, h], center = true);
    color("Black") text(txt, size = 1.5, halign = "center", valign = "center");
}

// ---- accessory cell (bordered box: letter tab, icon, spec, count) ---
module accessory_cell(letter, spec, qty, cw = 14, ch = 16) {
    color("Black") difference() { square([cw, ch]); translate([0.28, 0.28]) square([cw - 0.56, ch - 0.56]); }
    color("Black") translate([0, ch - 3.0]) square([3.2, 3.0]);            // letter tab
    color("White") translate([1.6, ch - 1.5]) text(letter, size = 2.0, halign = "center", valign = "center");
    translate([cw / 2, ch * 0.55]) children();                            // icon
    color("Black") translate([cw / 2, 2.5]) text(spec, size = 1.15, halign = "center", valign = "center");
    color("Black") translate([cw / 2, 0.95]) text(qty, size = 1.7, halign = "center", valign = "center");
}
