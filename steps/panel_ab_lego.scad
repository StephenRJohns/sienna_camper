// ============================================================
// Panels A & B — Lego-manual step diagrams, woodworking-plan
// line-art style (see lego_lib.scad for the style rules).
// ============================================================
// Panels A and B share the same frame + divider construction, no
// top of their own at all. The one-piece slatted bed frame
// (Component 2) is ~79.5-80in long, fully covering both panels'
// combined 58in, and caps them directly — it's what lifts off for
// drawer-bay access now, not a per-panel lid.
//
// Step 3 (drawers) is the one place A and B diverge: Panel A's left
// (driver-side) bay holds the WAVE 3 as open storage (no drawer box
// or slide — see params.scad wave3_bay_width), so it only builds ONE
// drawer box (right, DELTA 3 side); Panel B builds both drawers as
// before. Set -D 'panel="A"' or 'panel="B"' to pick which; step 3's
// renders are saved as pab-s3a-* / pab-s3b-* (see render.sh), not
// plain pab-s3-*.
//
//   openscad -D step=N -D 'view="parts"|"assembly"' -D 'panel="A"|"B"' panel_ab_lego.scad
//
//   1  frame: end rails + side rails + legs        (A and B, identical)
//   2  center divider                              (A and B, identical)
//   3  drawer box(es) on slides + catch(es)        (A: 1 drawer + WAVE 3 open bay; B: 2 drawers)
//
// Part letters: A end rail, B side rail, C leg, D divider,
// E drawer box, F slide, G catch, H WAVE 3 glide strip (Panel A only).
// ============================================================

include <lego_lib.scad>

step = 1;
view = "assembly";
panel = "B"; // "A" or "B" — only affects step 3

L  = panel_b_length;   // 29 — panel_a_length is identical; assert below
W  = panel_width;      // 46
RS = frame_rail_sz;
LH = leg_height_ab; // Panels A/B: legs 0.75in shorter since the deck recess (params.scad)
PT = panel_thickness;
DT = drawer_divider_t;

assert(panel_a_length == panel_b_length,
       "Panels A and B no longer share a length — split their step renders");

drw_w = drawer_travel - drawer_side_clear;
drw_d = drawer_depth;
drw_h = drawer_height;

module divider_geom(lift = 0, ctx = false) {
    wbox([-DT/2, RS, lift], [DT, L - 2 * RS, LH], [0, 0], ctx);
}
module drawer_geom(x0, ctx = false) {
    wbox([x0, RS + 0.5, 0.5], [drw_w, drw_d, drw_h], [0, 0], ctx);
}

// ---- step 2: divider --------------------------------------------
module s2_parts() {
    wbox([0, 0, 0], [DT, L - 2 * RS, LH]);
    cap(str("D  1x center divider 2x2 x ", L - 2 * RS, "\""), 22, -6, 2.6);
}
module s2_assembly() {
    lift = 10;
    lib_frame_ctx(L, W, leg_height_ab);
    divider_geom(lift);
    iarrow([0, L/2, lift - 1], [0, L/2, 2]);
    // divider screwed into the end rails at top and bottom
    fastener([0, RS + 1, lift + LH * 0.85], 0.45, 90);
    fastener([0, L - RS - 1, lift + LH * 0.85], 0.45, 90);
    callout("D", [0, L - 2 * RS, lift + LH], [6, 4]);
    color(INK) dash2d(p2([0, RS, lift]), p2([0, RS, 0]));
}

// ---- step 3: drawers ---------------------------------------------
// Panel B (default): both bays get a drawer box (n=2). Panel A: only
// the right (DELTA 3) bay gets a drawer box (n=1) — the left bay is
// WAVE 3 open storage instead, no box or slide, just 2 glide strips.
is_a = (panel == "A");
n_drawers = is_a ? 1 : 2;

module s3_parts() {
    wbox([0, 0, 0], [drw_w, drw_d, drw_h]);
    cap(str("E  ", n_drawers, "x drawer box (5 pieces each)"), 16, -12, 2.6);
    cap(str(drw_w, "\" x ", drw_d, "\" x ", drw_h, "\", 1/2\" ply"), 16, -17, 2.2);
    wbox([0, 0, 0], [0.3, drawer_slide_length, 1.8], [44, 6]);
    cap(str("F  ", n_drawers, n_drawers > 1 ? " pairs " : " pair ", drawer_slide_length, "\" slides"), 52, -2, 2.6);
    wbox([0, 0, 0], [1.6, 0.9, 0.9], [48, -14]);
    cap(str("G  ", n_drawers, "x catch"), 54, -16, 2.6);
    if (is_a) {
        wbox([0, 0, 0], [wave3_width, 1, 0.125], [16, -28]);
        cap("H  2x glide strip, UHMW/laminate scrap, left bay floor", 16, -34, 2.4);
    }
}
module s3_assembly() {
    pull = 14;
    lib_frame_ctx(L, W, leg_height_ab);
    divider_geom(0, true);

    if (is_a) {
        // left bay: WAVE 3 open storage, no drawer box — shown resting
        // in place, plus the 2 glide strips it slides on
        wv_y0 = RS + (L - 2 * RS - wave3_depth) / 2;
        wv_x0 = -DT/2 - wave3_width;
        wbox([wv_x0, wv_y0, 0], [wave3_width, wave3_depth, wave3_height], [0, 0], true);
        ifill(INK) {
            translate([wv_x0 + 1, wv_y0, 0]) cube([wave3_width - 2, 1, 0.125]);
            translate([wv_x0 + 1, wv_y0 + wave3_depth - 1, 0]) cube([wave3_width - 2, 1, 0.125]);
        }
        callout("H", [wv_x0 + 1, wv_y0, 0], [-6, 3]);
        cap("Left bay: WAVE 3 open storage (shown in place for reference) — no box, no slide", 0, -22, 1.8);
    } else {
        drawer_geom(-DT/2 - drawer_side_clear - drw_w);      // left drawer installed
        ifill(INK)
            translate([DT/2, RS + 2, drw_h/2]) cube([0.3, drawer_slide_length, 1.8]);
        for (yf = [0.25, 0.75])
            fastener_light([DT/2 + 0.15, RS + 2 + drawer_slide_length * yf, drw_h/2], 0.4, 90);
    }

    ifill(INK) // slide rail, right (DELTA 3) drawer's outer rail
        translate([W/2 - RS - 0.3, RS + 2, drw_h/2]) cube([0.3, drawer_slide_length, 1.8]);
    for (yf = [0.25, 0.75])
        fastener_light([W/2 - RS - 0.15, RS + 2 + drawer_slide_length * yf, drw_h/2], 0.4, 90);
    drawer_geom(DT/2 + drawer_side_clear + pull);        // right drawer exploded out
    iarrow([DT/2 + drawer_side_clear + pull - 1, RS + 0.5 + drw_d/2, drw_h/2],
           [DT/2 + drawer_side_clear + 4,        RS + 0.5 + drw_d/2, drw_h/2], 0.6);
    callout("E", [DT/2 + drawer_side_clear + pull + drw_w, RS + 0.5, drw_h], [6, 5]);
    callout("F  slide: box-to-rail + box-to-divider", [W/2 - RS, RS + 2 + drawer_slide_length/2, drw_h/2], [8, -8]);
    color(INK) dash2d(p2([DT/2 + drawer_side_clear + pull, RS + 0.5 + drw_d/2, drw_h/2]),
                      p2([DT/2 + drawer_side_clear, RS + 0.5 + drw_d/2, drw_h/2]));
}

// ---- dispatch ----------------------------------------------------
if (view == "parts") {
    if (step == 1) lib_frame_parts(L, W, leg_cut_length_ab, leg_height_ab);
    else if (step == 2) s2_parts();
    else if (step == 3) s3_parts();
} else {
    if (step == 1) lib_frame_assembly(L, W, panel == "A" ? "ends" : "all", leg_height_ab);
    else if (step == 2) s2_assembly();
    else if (step == 3) s3_assembly();
}
