// ============================================================
// Panel C — Lego-manual step diagrams, woodworking-plan
// line-art style (see lego_lib.scad).
// ============================================================
//   1  frame: end rails + side rails + legs  (36" — its own
//      renders, not Panel A/B's 29" ones, so the labeled cut
//      lengths stay honest)
//   2  fixed top, screwed down — NO divider; the void stays
//      open for the fridge + kitchen unit
// (hand-holds reuse the dedicated routed-cut zoom detail)
// ============================================================

include <lego_lib.scad>

step = 1;
view = "assembly";

L = panel_c_length; // 36
W = panel_width;    // 46

if (view == "parts") {
    if (step == 1) lib_frame_parts(L, W);
    else if (step == 2) lib_top_parts(L, W);
} else {
    if (step == 1) lib_frame_assembly(L, W, "front");
    else if (step == 2) {
        lib_top_assembly(L, W);
        cap("no divider — void stays open for the fridge + kitchen unit", 0, -26, 2.0);
    }
}
