// ============================================================
// Tongue -> 2nd-row rail connection detail (Section 8)
// ============================================================
// The anchor board's forward load path, fully measured Aug 1 2026.
//
// THE JOINT: the tongue runs forward off the board's bridge, steps UP
// 0.15in, rides ON the steel saddle cap that closes the rail's end, and a
// VERTICAL 1/4in pin drops through the tongue into the cap's 1/4in hole.
// Forward load is pure SHEAR on that pin. Nothing is drilled into the van.
//
// LEGIBILITY IS A LAYOUT PROBLEM, NOT A FONT SIZE. A rendered figure is
// scaled to the page, so the text height you get on paper is
// text_size x (page_width / sheet_width). This sheet is deliberately kept
// near 125 x 170 units with SHORT labels, which lands ~9pt. The previous
// revision carried the full reasoning as prose in three note columns, went
// to 200 units wide, and printed at ~5pt. All of that reasoning lives in
// Section 8's own text, where it renders at the document's font size and
// is searchable. DO NOT put paragraphs back on this sheet.
//
// CONVENTION: line-art. RED is the subject (tongue, pin, fasteners), GRY
// is context (van, rail, board). Each band declares its own scale.
//
// Render with: openscad -o renders/rail-tongue-detail.svg rail_tongue_detail.scad
// ============================================================

include <params.scad>
include <van_plan.scad>   // also pulls in sheet2d.scad

// Vertical budget, bottom to top:
//   band 3 (boxes) 4..36   band 2 (section) 42..88
//   band 1 (plan) 96..150  header 156..166
SW = 140;   // widened from 125: several note lines were crossing the border
SH = 170;

module bolt_plan(r = 1.2) {
    color(RED) {
        difference() { circle(r = r, $fn = 28); circle(r = r - 0.36, $fn = 28); }
        translate([-r, -0.18]) square([2 * r, 0.36]);
        translate([-0.18, -r]) square([0.36, 2 * r]);
    }
}

// ============================================================
// BAND 1 — PLAN
// ============================================================
S1 = 1.6;
function p1x(mx) = 26 + mx * S1;
function p1y(my) = 100 + (my - 20) * S1;

module plan_band() {
    txt("1  PLAN — looking down, forward is up", 6, 152, 3.2, "left", "Black");

    // the board: full-width bridge + comb strips broken off
    color(GRY) {
        rect_ol(p1x(0), p1y(aboard_depth - aboard_bridge_d), 46 * S1, aboard_bridge_d * S1, MED);
        for (sx = [1.5, 23 - aboard_strip_w / 2, 46 - 1.5 - aboard_strip_w])
            rect_ol(p1x(sx), p1y(20), aboard_strip_w * S1, (aboard_depth - aboard_bridge_d - 20) * S1, THIN);
    }
    txt("bridge", p1x(1.2), p1y(30.2), 2.3, "left", GRY);

    for (s = [-1, 1]) {
        cx = 23 + s * rail_spacing / 2;
        // rail, running forward off the crop
        color(GRY) {
            rect_ol(p1x(cx - 0.8), p1y(rail_end_y), 1.6 * S1, (48 - rail_end_y) * S1, MED);
            rect_ol(p1x(cx - 0.4), p1y(rail_end_y), 0.8 * S1, (48 - rail_end_y) * S1, THIN);
        }
        // the steel saddle cap over its end
        color(GRY) rect_ol(p1x(cx - 1), p1y(rail_end_y - 2), 2 * S1, 2 * S1, MED);
        // the tongue
        color(RED) rect_ol(p1x(cx - aboard_tongue_w / 2), p1y(aboard_depth - tongue_lap),
                           aboard_tongue_w * S1, tongue_len * S1, HEAVY);
        // 2 bolts through the bridge, then the vertical pin
        translate([p1x(cx), p1y(aboard_depth - tongue_lap + 1)]) bolt_plan(1.1);
        translate([p1x(cx), p1y(aboard_depth - 1)]) bolt_plan(1.1);
        translate([p1x(cx), p1y(rail_end_y - 1)]) bolt_plan(1.5);
    }
    txt("steel cap + PIN", p1x(46) + 2, p1y(rail_end_y - 1), 2.3, "left", RED);
    txt("tongue", p1x(46) + 2, p1y(aboard_depth + 2), 2.3, "left", RED);

    dim_y(p1y(aboard_depth), p1y(rail_end_y), p1x(0) - 4, str(tongue_span, "\" span"), 2.3, RED, "left");
    dim_x(p1x(23 - rail_spacing / 2), p1x(23 + rail_spacing / 2), p1y(47.4),
          str(rail_spacing, "\" apart (F8b)"), 2.3, RED, 3);
    txt(str("Rail ends ", rail_end_y, "\" from the closed hatch (F8a)."), 6, 96, 2.3, "left", "Black");
    txt(str("Tongues ", tongue_len, "\" long: ", tongue_lap, "\" on the bridge + ",
            tongue_span, "\" span + 3\" on the cap."), 6, 93, 2.3, "left", "Black");
}

// ============================================================
// BAND 2 — SIDE SECTION
// ============================================================
SX = 3.6;
SZ = 11;
function s2x(mx) = 12 + (mx + 8) * SX;
function s2z(mz) = 56 + mz * SZ;

module side_band() {
    txt("2  SIDE SECTION — vertical scale exaggerated", 6, 86, 3.2, "left", "Black");

    color(GRY) translate([s2x(-8), s2z(0) - 1.1]) square([s2x(20) - s2x(-8), 1.1]);
    color(GRY) rect_ol(s2x(0), s2z(0), s2x(7) - s2x(0), 0.3 * SZ, THIN);
    txt("carpet", s2x(2.4), s2z(0.15), 2.1, "left", GRY);

    // board: mat + ply
    color(GRY) {
        rect_ol(s2x(-8), s2z(0), s2x(0) - s2x(-8), aboard_mat_t * SZ, THIN);
        rect_ol(s2x(-8), s2z(aboard_mat_t), s2x(0) - s2x(-8), aboard_t * SZ, MED);
    }
    txt("3/4\" ply bridge", s2x(-7.6), s2z(0.42), 2.1, "left", GRY);

    // rail + its plastic housing
    color(GRY) {
        rect_ol(s2x(11.5), s2z(0), s2x(20) - s2x(11.5), rail_top_z * SZ, MED);
        rect_ol(s2x(13), s2z(rail_top_z), s2x(20) - s2x(13), (rail_housing_z - rail_top_z) * SZ, THIN);
    }
    txt("2nd-row rail", s2x(16), s2z(0.14), 2.1, "left", "Black");

    // the STEEL SADDLE CAP: flat top face + rear skirt, open rear
    color(GRY) {
        rect_ol(s2x(7), s2z(rail_cap_hole_z - 0.1), s2x(12.5) - s2x(7), 0.1 * SZ, MED);
        rect_ol(s2x(7), s2z(0.25), 0.8, (rail_cap_hole_z - 0.35) * SZ, THIN);
    }
    txt("STEEL SADDLE CAP", s2x(7.2), s2z(rail_cap_hole_z) + 9, 2.2, "left", "Black");
    txt("(open rear)", s2x(7.2), s2z(rail_cap_hole_z) + 6.4, 2.1, "left", "Black");

    // the tongue: flat, step up, then on the cap
    tz = s2z(aboard_top);
    tzc = s2z(rail_cap_hole_z);
    color(RED) {
        rect_ol(s2x(-5), tz, s2x(6.2) - s2x(-5), tongue_t * SZ, HEAVY);
        rect_ol(s2x(6.2), tz, 0.8, (rail_cap_hole_z - aboard_top) * SZ + tongue_t * SZ, HEAVY);
        rect_ol(s2x(6.2), tzc, s2x(12) - s2x(6.2), tongue_t * SZ, HEAVY);
    }
    txt("tongue", s2x(0.4), tz + 3.4, 2.3, "left", RED);

    // the vertical pin
    color(RED) rect_ol(s2x(9.2), s2z(rail_cap_hole_z - 0.14), tongue_pin_d * SX, 0.4 * SZ, MED);
    txt(str(tongue_pin_d, "\" PIN"), s2x(12.7), tzc + 3.2, 2.2, "left", RED);

    // the 2 bridge bolts, drawn simply
    color(RED) for (bx = [-5.4, -1.6]) {
        translate([s2x(bx) - 0.4, s2z(0) - 1.8]) square([0.8, aboard_top * SZ + 3.2]);
        translate([s2x(bx) - 1.5, tz + tongue_t * SZ]) square([3, 1.4]);
    }
    txt("2x 1/4\"-20 into the bridge", s2x(-7.6), tz + 8, 2.2, "left", RED);

    dim_y(tz, tzc, s2x(5.4), str(tongue_step_up, "\" step"), 2.1, RED, "left");
    txt(str("The tongue rides ON the cap's top face (", rail_cap_hole_z,
            "\") and the pin drops into its ", rail_cap_hole_d, "\" hole."),
        6, 49, 2.3, "left", "Black");
    txt("The cap's rear is OPEN, so nothing butts: forward load is pure SHEAR on the pin.",
        6, 46, 2.3, "left", "Black");
    txt("Shim the step; a hold-down keeps the pin seated.", 6, 43, 2.3, "left", "Black");
}

// ============================================================
// BAND 3 — two boxes: the hold-down, and what was ruled out
// ============================================================
module box(i, title, lines) {
    x0 = 6 + i * 60.5;
    y0 = 4;
    inset(x0, y0, 57, 32, title) {
        for (j = [0 : len(lines) - 1])
            txt(lines[j], x0 + 3, y0 + 23 - j * 3.2, 2.15, "left", "Black");
    }
}

module boxes_band() {
    txt("3  THE ONE CHOICE LEFT, AND THE DEAD ENDS", 6, 39, 3.2, "left", "Black");
    box(0, "HOLD-DOWN (choose one)", [
        "ESSENTIAL, not optional: a vertical pin",
        "lifts straight out. Either",
        "  - a clip hooked over the cap's side",
        "    skirts (the open rear helps), or",
        "  - a saddle clamp on the rail just",
        "    forward of the cap."]);
    box(1, "RULED OUT — do not revisit", [
        "- fastener in the track slot: the slot runs",
        "  FORE-AFT, so friction only, ~430 lb",
        "- nut bar from the end: cap + pin block it",
        "- butting the rail's end face: no such face,",
        "  the cap's rear is open",
        "- bolt through the hole: no nut access"]);
}

// ============================================================
module sheet() {
    color("Black") rect_ol(0, 0, SW, SH, 0.5);
    txt("SECTION 8 — TONGUE TO 2ND-ROW RAIL CONNECTION", 6, 164, 3.6, "left", "Black");
    txt("All measured Aug 1 2026. Governing limit is hole-edge bearing in the", 6, 159, 2.3, "left", RED);
    txt(str("cap's top face, on an ASSUMED ", rail_cap_t_est,
            "\" thickness (~1,400 lb/tongue) — measure it."), 6, 156, 2.3, "left", RED);
    plan_band();
    side_band();
    boxes_band();
}

sheet();
