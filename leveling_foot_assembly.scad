// ============================================================
// Leg leveling foot — ENGINEERING DRAWING (2D orthographic)
// Cross-section + exploded assembly + knob top view, dimensioned,
// drawn to the ACTUAL purchased parts (July 2026):
//   - Anwenk "Heavy Duty Furniture Levelers" 4-pack: 3/8-16 T-nut
//     + glide stud w/ 1.375" nylon pad (1,320 lb/ft rating)
//   - Peachtree PW6103 star thru-hole knob, 3/8-16, ~2" dia
//   - 3/8-16 jam nut (12x, hardware store)
// 12 feet total: 4 per panel x 3 panels. Legs cut to 16";
// the foot's 1" nominal exposure restores the effective 17".
//
// Render with: openscad -o renders/leveling-foot-assembly.png \
//   --imgsize=3200,2200 $FLAT_CAM leveling_foot_assembly.scad
// ============================================================

include <params.scad>
include <colors.scad>
include <dim_style.scad>

SC = 6;                    // drawing scale: 6x actual size (labels give real inches)

// real part dims (inches)
leg_w    = frame_rail_sz;  // 1.5
bore_d   = 0.5;
bore_dp  = 0.75;
stud_d   = 0.375;
pad_d    = leveling_foot_pad_dia;   // 1.375 (Anwenk)
pad_h    = 0.25;
knob_d   = 2.0;
knob_t   = 0.4;
nut_w    = 0.5625;         // 9/16 hex across flats
nut_t    = 0.21;
tn_flange = 0.85;          // T-nut flange dia
tn_barrel = 0.49;          // T-nut barrel OD (fills the 1/2" bore)
expose   = leveling_foot_nominal_h; // 1.0 floor -> leg bottom
leg_show = 2.4;            // portion of leg drawn before the break

module label(txt, x, y, size = 1.35, ha = "center") {
    color("black") translate([x, y]) text(txt, size = size, halign = ha, valign = "center");
}
module leader(x0, y0, x1, y1) { color("black") hull() { translate([x0, y0]) circle(0.09); translate([x1, y1]) circle(0.09); } }

// sparse 45-degree section hatching clipped to a rect (drawing units)
module hatch(x, y, w, h, pitch = 2.4) {
    color([0.55, 0.42, 0.26]) intersection() {
        translate([x, y]) square([w, h]);
        translate([x, y]) for (i = [-h : pitch : w + h])
            translate([i, 0]) rotate(45) square([0.07, h * 1.6]);
    }
}
module frame_rect_at(x, y, w, h) { translate([x, y]) frame_rect(w, h, 0.22); }

// shared part profiles (drawing units, origin at part's bottom center)
module p_pad() { color("dimgray") polygon([[-pad_d/2*SC, 0], [pad_d/2*SC, 0], [pad_d/2*SC*0.75, pad_h*SC], [-pad_d/2*SC*0.75, pad_h*SC]]); }
module p_stud(len_in) {
    color("gray") translate([-stud_d/2*SC, 0]) square([stud_d*SC, len_in*SC]);
    color("black") for (yy = [0.06 : 0.09 : len_in - 0.05]) translate([-stud_d/2*SC, yy*SC]) square([stud_d*SC, 0.06]);
}
module p_knob() {
    color([0.12, 0.12, 0.12]) {
        translate([-knob_d/2*SC, 0]) square([knob_d*SC, knob_t*SC]);
        for (sx = [-1, 1]) translate([sx*knob_d/2*SC, knob_t/2*SC]) circle(knob_t/2*SC*0.8, $fn = 20);
    }
}
module p_nut() { color("goldenrod") translate([-nut_w/2*SC, 0]) square([nut_w*SC, nut_t*SC]); }
module p_tnut() {  // origin = underside of the flange
    color("goldenrod") {
        translate([-tn_flange/2*SC, 0]) square([tn_flange*SC, 0.06*SC]);
        translate([-tn_barrel/2*SC, 0.06*SC]) square([tn_barrel*SC, 0.5*SC]);
        for (sx = [-1, 1]) translate([sx*(tn_flange/2 - 0.07)*SC - 0.035*SC, 0.06*SC]) square([0.07*SC, 0.3*SC]);
    }
}

// ------------------------------------------------------------
// VIEW 1 — SECTION A-A through the leg centerline (installed, mid-travel)
// ------------------------------------------------------------
module cross_section() {
    lw2 = leg_w/2*SC;  b2 = bore_d/2*SC;
    y_leg = expose*SC;                 // 6 — leg bottom face
    y_bore = y_leg + bore_dp*SC;       // 10.5 — top of the bore
    y_top = y_leg + leg_show*SC;       // 20.4 — break line

    // floor
    color("black") translate([-11, -0.8]) square([25, 0.8]);
    label("van floor", -13, -0.4, 1.2, "right");

    // foot stack: pad, stud, knob, jam nut
    p_pad();
    translate([0, pad_h*SC]) p_stud(expose + bore_dp - 0.15 - pad_h);
    translate([0, 0.30*SC]) p_knob();
    translate([0, (0.30 + knob_t + 0.03)*SC]) p_nut();

    // leg in section: two cheeks + block above the bore, hatched
    color("BurlyWood") {
        translate([-lw2, y_leg]) square([lw2 - b2, leg_show*SC]);
        translate([b2, y_leg]) square([lw2 - b2, leg_show*SC]);
        translate([-lw2, y_bore]) square([leg_w*SC, y_top - y_bore]);
    }
    hatch(-lw2, y_leg, lw2 - b2, leg_show*SC);
    hatch(b2, y_leg, lw2 - b2, leg_show*SC);
    hatch(-lw2, y_bore, leg_w*SC, y_top - y_bore);
    frame_rect_at(-lw2, y_leg, leg_w*SC, leg_show*SC);

    // T-nut seated against the end grain
    translate([0, y_leg - 0.06*SC]) p_tnut();

    // break marks at the top
    color("black") for (sx = [-1, 1]) scale([sx, 1]) translate([0, y_top])
        polygon([[0, 0], [lw2, 0], [lw2, 0.5], [lw2*0.55, 1.4], [lw2*0.45, -0.3], [0, 0.6]]);
    label("leg continues (16\" cut length)", 0, y_top + 2.6, 1.15);

    // ---- dimensions ----
    dim_v(0, y_leg, -8.5);                                   // 1" exposure
    label("1\" exposed", -9.4, y_leg/2 + 1, 1.15, "right");
    label("(travel +/- 1/2\")", -9.4, y_leg/2 - 1, 1.0, "right");

    dim_v(y_leg, y_bore, -6.2);                              // bore depth
    label("3/4\" deep", -7.0, (y_leg + y_bore)/2, 1.1, "right");

    dim_h(-lw2, lw2, y_top + 5.2);                           // leg width
    label("1-1/2\" (2x2 leg)", 0, y_top + 6.8, 1.15);

    dim_h(-pad_d/2*SC, pad_d/2*SC, -3.6);                    // pad dia
    label("1-3/8\" pad", 0, -5.2, 1.1);
    dim_h(-knob_d/2*SC, knob_d/2*SC, -7.4);                  // knob dia
    label("2\" knob", 0, -9.0, 1.1);

    // ---- leaders, staggered on the right ----
    leader(b2, y_bore - 0.5, 9, 16);   label("1/2\" dia bore", 9.6, 16, 1.15, "left");
    leader(tn_flange/2*SC, y_leg + 0.8, 9, 12);  label("3/8-16 T-nut (Anwenk)", 9.6, 12, 1.15, "left");
    leader(nut_w/2*SC, (0.30 + knob_t + 0.13)*SC, 9, 8);  label("3/8-16 jam nut — locks the knob", 9.6, 8, 1.15, "left");
    leader(knob_d/2*SC + 0.9, (0.30 + knob_t/2)*SC, 9, 4);  label("PW6103 star knob (hand wheel)", 9.6, 4, 1.15, "left");
    leader(pad_d/2*SC*0.85, pad_h*SC*0.5, 9, 0.5);  label("nylon glide pad (Anwenk stud)", 9.6, 0.5, 1.15, "left");

    label("SECTION A-A — installed, mid-travel (6x actual size)", 0, -12.6, 1.5);
    label(str("effective leg: 16\" cut + 1\" foot = ", leg_height, "\" — deck height unchanged"), 0, -15, 1.15);
}

// ------------------------------------------------------------
// VIEW 2 — EXPLODED, in assembly order (A..E, top = first)
// ------------------------------------------------------------
module lmark(t, x, y) {
    color("DarkSlateBlue") translate([x, y]) circle(1.5);
    color("white") translate([x, y]) text(t, size = 1.5, halign = "center", valign = "center");
}
module exploded() {
    lw2 = leg_w/2*SC;  b2 = bore_d/2*SC;

    // centerline
    color(DIM_ORANGE) translate([-0.05, -1]) square([0.1, 42.5]);

    // A: leg, bore shown dashed
    frame_rect_at(-lw2, 27, leg_w*SC, 13);
    color("BurlyWood") translate([-lw2 + 0.22, 27.22]) square([leg_w*SC - 0.44, 12.56]);
    color("black") for (sx = [-1, 1]) for (yy = [0 : 0.9 : bore_dp*SC - 0.5])
        translate([sx*b2 - 0.06, 27 + yy]) square([0.12, 0.55]);
    color("black") translate([-b2, 27 + bore_dp*SC - 0.08]) square([bore_d*SC, 0.16]);
    lmark("A", -lw2 - 3, 33.5);

    // B: T-nut
    translate([0, 21.5]) p_tnut();
    lmark("B", -lw2 - 3, 22.8);

    // C: jam nut
    translate([0, 17.8]) p_nut();
    lmark("C", -lw2 - 3, 18.4);

    // D: star knob
    translate([0, 13.4]) p_knob();
    lmark("D", -knob_d/2*SC - 3, 14.6);

    // E: stud + pad
    p_pad();
    translate([0, pad_h*SC]) p_stud(1.55);
    lmark("E", -pad_d/2*SC - 3, 2);

    label("EXPLODED — assembly order", 0, 44.5, 1.5);
}

// ------------------------------------------------------------
// VIEW 3 — star knob, top view
// ------------------------------------------------------------
module knob_top() {
    color([0.12, 0.12, 0.12]) {
        circle(0.68*SC, $fn = 48);
        for (a = [0 : 72 : 288]) rotate(a) translate([0.70*SC, 0]) circle(0.34*SC, $fn = 24);
    }
    color("white") circle(stud_d/2*SC, $fn = 24);
    color("black") for (a = [0, 60, 120]) rotate(a) translate([-stud_d/2*SC - 0.14, -0.06]) square([stud_d*SC + 0.28, 0.12]);
    dim_h(-knob_d/2*SC, knob_d/2*SC, -8.2);
    label("2\"", 0, -9.8, 1.15);
    label("3/8-16 thru-hole", 0, 8.2, 1.1);
    label("KNOB — top view", 0, 10.4, 1.4);
}

// ------------------------------------------------------------
// layout
// ------------------------------------------------------------
cross_section();
translate([44, -14]) exploded();
translate([78, 6]) knob_top();

// assembly steps, under the exploded view's x-range
steps = ["A  drill the leg's end grain: 1/2\" dia x 3/4\" deep, centered",
         "B  drive the T-nut up into the bore (dab of epoxy)",
         "C  spin a 3/8-16 jam nut ~1\" up the stud",
         "D  thread the knob up to it; wrench the nut DOWN to lock them",
         "E  screw the stud into the T-nut to 1\" exposure",
         "Locked together, knob + nut drive the stud: tip the corner, spin, done."];
label("ASSEMBLY", 36, -19.5, 1.4, "left");
for (i = [0 : len(steps) - 1]) label(steps[i], 36, -22 - i*2.3, 1.15, "left");

label("LEG LEVELING FOOT — engineering drawing (parts as purchased, July 2026)", 34, 39, 1.9);
label("12 feet total (4 per panel x 3 panels): 3x Anwenk leveler 4-packs + 3x Peachtree PW6103 knob 4-packs + 12x 3/8-16 jam nuts", 34, 36.4, 1.2);
label("Rating: 1,320 lb per foot (Anwenk) — 4 feet under the heaviest panel = ~5,280 lb capacity vs ~450 lb actual load.", 22, -37.5, 1.2, "left");
label("NOTE: skip the kit's stick-on felt pads — the bare nylon pad grips the van floor better and doesn't shed.", 22, -39.9, 1.2, "left");
