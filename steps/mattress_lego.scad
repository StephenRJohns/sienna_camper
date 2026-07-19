// ============================================================
// Mattress (DIY 3-layer foam) — Lego-manual step diagrams,
// woodworking-plan line-art style (see lego_lib.scad).
// ============================================================
//   1  trim all 3 queen blanks from 60" to 46" wide (length already
//      matches mattress_length exactly — a full untrimmed queen)
//   2  laminate the 2 layers (exploded stack, glued together)
// Part letters: A base foam, B egg-crate mid, C memory-foam
// topper. Drawn at a foreshortened length — an 80" slab at true
// scale would render the 4" thicknesses as hairlines.
// ============================================================

include <lego_lib.scad>

step = 1;
view = "assembly";

// foreshortened display length (annotated as mattress_length — see header)
DL = 40;
BW = mattress_blank_width; // 60
MW = mattress_width;       // 50 finished width (DIY fallback matches the HEST footprint)

module s1_parts() {
    // slabs first, labels after — a later slab's white fill would
    // paint over any label drawn before it
    wbox([0, 0, 0], [BW, DL, foam_base_t]);
    wbox([0, 0, 0], [BW, DL, foam_topper_t], [14, -46]);
    cap(str("A  1x queen ", foam_base_t, "\" firm foam base"), -6, -6, 2.8, "right");
    cap(str("B  1x queen ", foam_topper_t, "\" memory topper"), 8, -52, 2.8, "right");
    cap(str("all 3 blanks 60\" x ", mattress_length, "\" before trimming"), 40, -94, 2.4);
}
module s1_assembly() {
    // one blank shown with the cut line at panel_width
    wbox([0, 0, 0], [BW, DL, foam_base_t]);
    // dashed cut line at x = MW, full length
    color(INK) dash2d(p2([MW, 0, foam_base_t]), p2([MW, DL, foam_base_t]), 0.18, 2);
    callout(str("cut at ", MW, "\" — long serrated or electric knife"), [MW, DL * 0.25, foam_base_t], [10, 8]);
    callout(str("offcut ", BW - MW, "\" strip: pillow topper / spare cushion"), [BW - (BW - MW)/2, DL * 0.8, foam_base_t], [8, -10]);
    cap(str("repeat for all 3 layers — length already matches at ", mattress_length, "\", no cut there"), BW * 0.4, -14, 2.0);
}

module s2_parts() {
    cap("the 2 trimmed layers from step 1", 0, 4, 2.2);
    cap("+ spray adhesive (or wide fabric strips)", 0, 0, 2.2);
    cap("+ waterproof cover, fitted after gluing", 0, -4, 2.2);
}
module s2_assembly() {
    g1 = 9; // exploded gap
    wbox([0, 0, 0], [MW, DL, foam_base_t]);
    wbox([0, 0, foam_base_t + g1], [MW, DL, foam_topper_t]);
    iarrow([MW/2, DL/2, foam_base_t + g1 - 0.5], [MW/2, DL/2, foam_base_t + 0.5]);
    callout("A  4\" firm base — bottom", [MW, 0, foam_base_t/2], [8, -6]);
    callout("B  memory-foam topper — top", [MW, 0, foam_base_t + g1 + foam_topper_t/2], [10, 3]);
    cap("glue face-to-face with spray adhesive, then fit the waterproof cover", MW * 0.5, -26, 2.0);
}

if (view == "parts") {
    if (step == 1) s1_parts();
    else if (step == 2) s2_parts();
} else {
    if (step == 1) s1_assembly();
    else if (step == 2) s2_assembly();
}
