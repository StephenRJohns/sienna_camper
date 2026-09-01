// ============================================================
// Platform leg — SHOP DRAWING (2D orthographic)
// ============================================================
// The one drawing the build plan never had: the leg itself, as a
// part. Everything else about the legs is drawn in context (inside
// an exploded panel) or from the foot's point of view (the leveling
// -foot assembly sheet), so the two cut lengths and the bottom bore
// only ever appeared as text in a parts list — which is exactly
// where they went stale.
//
// Four views:
//   1  Panel C leg, elevation — 16" cut + 1" foot = 17" effective
//   2  Panel A/B leg, elevation — 15.25" cut = 16.25" effective
//   3  Bottom end grain, plan — the 1/2" x 7/8" insert bore, centred
//   4  Leg in the frame, end elevation — the 3.5" inset and the
//      bottom rail's 1" underside
//
// Every number comes from params.scad (leg_cut_length,
// leg_cut_length_ab, leg_height, leg_height_ab, leg_inset,
// bottom_rail_z, frame_rail_sz, panel_width, leveling_foot_*) or,
// for the bore, from leveling_foot_assembly.scad's bore_d/bore_dp.
//
// Render with: openscad -o renders/leg-detail.png \
//   --imgsize=3250,2000 $FLAT_CAM leg_detail.scad
//
// LEGIBILITY: prose belongs in the markdown, not on the sheet — a
// figure's printed text height is size x (page_width / sheet_width),
// so a sentence here shrinks every label on the drawing. Short
// labels only.
// ============================================================

include <params.scad>
include <colors.scad>
include <dim_style.scad>

INK = "black";
WOOD = [0.62, 0.47, 0.31];
METAL = [0.45, 0.45, 0.48];

bore_d  = 0.5;    // 1/2" — maker's spec (insert core is 7/16")
bore_dp = 0.875;  // 7/8" deep: 3/4" of insert plus clearance
pad_d   = leveling_foot_pad_dia;  // 1.375
knob_d  = 2.0;
foot_h  = leveling_foot_nominal_h; // 1.0 nominal exposure

E  = 2.0;   // elevation views: drawing units per inch
P  = 7.0;   // end-grain plan view: units per inch
F  = 1.9;   // frame view: units per inch

module label(txt, x, y, size = 2.0, ha = "center") {
    color(INK) translate([x, y]) text(txt, size = size, halign = ha, valign = "center");
}
module leader(x0, y0, x1, y1) {
    color(INK) hull() { translate([x0, y0]) circle(0.08); translate([x1, y1]) circle(0.08); }
}
// dashed outline, for the bore hidden inside the leg
module dashed_rect(x, y, w, h, dash = 0.55) {
    color(INK) {
        for (i = [0 : dash * 2 : h]) {
            translate([x, y + i]) square([0.16, min(dash, h - i)]);
            translate([x + w - 0.16, y + i]) square([0.16, min(dash, h - i)]);
        }
        for (i = [0 : dash * 2 : w])
            translate([x + i, y]) square([min(dash, w - i), 0.16]);
    }
}

// ------------------------------------------------------------
// VIEWS 1 & 2 — leg elevation. Origin at the leg's bottom-left.
// ------------------------------------------------------------
module leg_elevation(cut, eff, title, sub, foot_note = true) {
    w = frame_rail_sz * E;   // 3.0
    h = cut * E;

    // the leg
    color(WOOD) square([w, h]);
    color(INK) { square([w, 0.18]); translate([0, h - 0.18]) square([w, 0.18]);
                 square([0.18, h]); translate([w - 0.18, 0]) square([0.18, h]); }

    // the bore, hidden -> dashed
    dashed_rect(w/2 - bore_d/2 * E, 0, bore_d * E, bore_dp * E);

    // the foot, schematic: stud down to the floor, pad, knob
    color(METAL) translate([w/2 - 0.375/2 * E, -foot_h * E]) square([0.375 * E, foot_h * E]);
    color(METAL) translate([w/2 - pad_d/2 * E, -foot_h * E]) square([pad_d * E, 0.22 * E]);
    color(INK) translate([w/2 - knob_d/2 * E, -0.34 * E]) square([knob_d * E, 0.30 * E]);
    // floor line
    color(INK) translate([-5, -foot_h * E - 0.5]) square([w + 10, 0.28]);

    // dimensions: cut length (near), effective height (far)
    dim_v(0, h, -3.2);
    label(str(cut, "\" CUT"), -4.2, h/2, 2.2, "right");
    dim_v(-foot_h * E, h, -9.0);
    label(str(eff, "\" effective"), -10.0, h/2 - 4.5, 1.9, "right");
    dim_v(-foot_h * E, 0, w + 4.2);
    if (foot_note) {
        label("1\" foot", w + 5.4, -foot_h * E / 2 + 0.9, 1.7, "left");
        label("(travel +/- 1/2\")", w + 5.4, -foot_h * E / 2 - 1.5, 1.5, "left");
    }

    // bore call-out
    leader(w/2 + bore_d/2 * E, bore_dp * E * 0.6, w + 4.2, 7.5);
    label("1/2\" dia x 7/8\" deep bore", w + 5.4, 7.5, 1.7, "left");

    // width
    dim_h(0, w, h + 3.0);
    label("1-1/2\" (2x2 pine)", w/2, h + 5.2, 1.8);

    label(title, w/2, -foot_h * E - 5.0, 2.6);
    label(sub, w/2, -foot_h * E - 8.0, 1.8);
}

// ------------------------------------------------------------
// VIEW 3 — bottom end grain, plan. The same hole on all 12 legs.
// ------------------------------------------------------------
module end_grain_plan() {
    s = frame_rail_sz * P;   // 10.5

    color(WOOD) square([s, s]);
    color(INK) { square([s, 0.2]); translate([0, s - 0.2]) square([s, 0.2]);
                 square([0.2, s]); translate([s - 0.2, 0]) square([0.2, s]); }

    // centre-finding diagonals
    color([0.3, 0.3, 0.3]) {
        hull() { circle(0.07); translate([s, s]) circle(0.07); }
        hull() { translate([s, 0]) circle(0.07); translate([0, s]) circle(0.07); }
    }

    // the bore
    color("white") translate([s/2, s/2]) circle(bore_d * P / 2, $fn = 64);
    color(INK) translate([s/2, s/2]) difference() {
        circle(bore_d * P / 2, $fn = 64);
        circle(bore_d * P / 2 - 0.22, $fn = 64);
    }
    // centre mark
    color(INK) {
        translate([s/2 - 1.2, s/2 - 0.09]) square([2.4, 0.18]);
        translate([s/2 - 0.09, s/2 - 1.2]) square([0.18, 2.4]);
    }

    dim_h(0, s, -3.0);
    label("1-1/2\"", s/2, -5.0, 2.0);
    dim_v(0, s, -3.0);
    label("1-1/2\"", -4.2, s/2, 2.0, "right");
    dim_h(0, s/2, s + 3.0);
    label("3/4\" — dead centre", s/2, s + 5.2, 1.9);

    leader(s/2 + bore_d * P / 2, s/2, s + 3.0, s * 0.30);
    label("1/2\" dia bore", s + 3.6, s * 0.30, 2.0, "left");
    label("7/8\" deep", s + 3.6, s * 0.30 - 2.6, 2.0, "left");
    label("bore BEFORE assembly", s + 3.6, s * 0.30 - 5.6, 1.7, "left");

    label("BOTTOM END GRAIN — all 12 legs", s/2, -9.0, 2.4);
}

// ------------------------------------------------------------
// VIEW 4 — leg in the frame, end elevation: the inset and the
// bottom rail. Drawn at the panel's 46" end face.
// ------------------------------------------------------------
module frame_position() {
    W  = panel_width * F;         // 46" of deck
    RS = frame_rail_sz * F;
    LH = leg_height_ab * F;       // A/B shown; C is 0.75" taller
    IN = leg_inset * F;

    // top rail spanning the full deck width
    color(WOOD) translate([0, LH]) square([W, RS]);
    color(INK) frame_rect_outline(0, LH, W, RS);

    // the two legs, inset
    for (x = [IN, W - IN - RS]) {
        color(WOOD) translate([x, 0]) square([RS, LH]);
        color(INK) frame_rect_outline(x, 0, RS, LH);
        // foot
        color(METAL) translate([x + RS/2 - 0.19 * F, -foot_h * F]) square([0.375 * F, foot_h * F]);
        color(METAL) translate([x + RS/2 - pad_d/2 * F, -foot_h * F]) square([pad_d * F, 0.2 * F]);
    }

    // bottom rail: underside at bottom_rail_z, i.e. level with the leg bottoms
    color(WOOD) translate([IN, bottom_rail_z * F - foot_h * F]) square([W - 2 * IN, RS]);
    color(INK) frame_rect_outline(IN, bottom_rail_z * F - foot_h * F, W - 2 * IN, RS);

    // floor
    color(INK) translate([-4, -foot_h * F - 0.5]) square([W + 4, 0.3]);
    label("van floor", W + 5.2, -foot_h * F - 0.2, 2.4, "left");

    dim_h(0, IN, LH + RS + 3.2);
    label(str(leg_inset, "\" inset"), IN/2, LH + RS + 5.4, 2.4);
    dim_h(W - IN, W, LH + RS + 3.2);
    label(str(leg_inset, "\" inset"), W - IN/2, LH + RS + 5.4, 2.4);
    dim_h(0, W, LH + RS + 9.0);
    label(str(panel_width, "\" deck width"), W/2, LH + RS + 11.4, 2.7);
    dim_h(IN, W - IN, LH - 4.0);
    label(str(panel_width - 2 * leg_inset, "\" leg to leg (outside faces)"), W/2, LH - 6.4, 2.4);

    // MOVED TO THE DOCUMENT: the bottom rail's screw spec, and the
    // Panel C rear-leg exception. Both were prose, and prose here sets
    // the sheet width — see the LEGIBILITY note at the top.
    dim_v(-foot_h * F, bottom_rail_z * F - foot_h * F, -5.0);
    label(str(bottom_rail_z, "\""), -6.2, (bottom_rail_z * F - foot_h * F)/2, 2.4, "right");
    leader(W - IN, bottom_rail_z * F - foot_h * F + RS, W - IN - 12, 14.0);
    label("bottom rail", W - IN - 12.6, 14.0, 2.4, "right");

    label("LEG POSITION — end elevation (Panel A/B)", W/2, -foot_h * F - 6.0, 3.0);
}

// a hollow rectangle from 4 strips — see dim_style.scad's frame_rect
// note on why difference() is avoided in the preview renderer
module frame_rect_outline(x, y, w, h, t = 0.2) {
    color(INK) translate([x, y]) {
        square([w, t]); translate([0, h - t]) square([w, t]);
        square([t, h]); translate([w - t, 0]) square([t, h]);
    }
}

// ------------------------------------------------------------
// SHEET
// ------------------------------------------------------------
// Two sheets, not one. All four views in a row made a ~280-unit-wide
// drawing, and a figure's printed text height is size x (page_width /
// sheet_width) — so at one page column every label on it printed at
// ~5pt. Split, each sheet gets the full column to itself.
sheet = "part";  // "part" or "position"

if (sheet == "part") {
    translate([16,  14]) leg_elevation(leg_cut_length,    leg_height,    "PANEL C LEG x4", "the tall pair of lengths");
    translate([56,  14]) leg_elevation(leg_cut_length_ab, leg_height_ab, "PANEL A + B LEG x8", "3/4\" shorter — deck recess", false);
    translate([100, 24]) end_grain_plan();

    color(INK) translate([2, 62]) text("PLATFORM LEG — shop drawing (12 legs: 4 per panel x 3 panels)", size = 3.2);
    color(INK) translate([2, 57]) text("Cut in TWO batches: 4 at 16\" (Panel C), 8 at 15.25\" (Panels A and B). Same bore in every one.", size = 2.3);
} else {
    translate([10, 16]) frame_position();
}
