// ============================================================
// Shared dimension-arrow / blueprint style
// ============================================================
// Style reference: user-supplied AI-generated concept renders of a
// generic "2026 minivan" interior with orange double-headed
// dimension arrows on a light-grey backdrop, and small orange
// square + lightning-bolt icons for power outlets.
//
// IMPORTANT — style only, not data: those reference images (and a
// follow-up batch claiming to "correct" them) carry numbers that
// contradict each other and contradict figures already marked
// "already verified" elsewhere in this project (e.g. a claimed 61"
// max floor width vs. this project's own verified 48.5"; a claimed
// 37.5-38.5" ceiling height vs. this project's own verified 44").
// None of those numbers are used here. Every dimension drawn with
// these helpers still comes from params.scad, exactly as before —
// this file only changes how a dimension LOOKS, never what it says.
//
// include <dim_style.scad> from any 2D direct-drawing file (like
// measurement_van.scad) — it doesn't include params.scad itself.
// ============================================================

DIM_ORANGE = [0.88, 0.44, 0.06];
BG_GREY    = [0.91, 0.91, 0.91];

// light grey backdrop card behind a diagram's bounding box
module bg_panel(x0, y0, x1, y1, pad = 4) {
    color(BG_GREY) translate([x0 - pad, y0 - pad]) square([(x1 - x0) + 2 * pad, (y1 - y0) + 2 * pad]);
}

// hollow rectangle outline built from 4 plain strips, NOT
// difference(square, square) — OpenSCAD's fast preview renderer
// (used for every PNG export in this pipeline) doesn't always
// composite a 2D difference() correctly against coplanar fills
// behind it; the subtracted interior can render as a solid block
// instead of a hollow frame (same bug hit earlier on the LMioEtool
// enclosure icon). Four strips sidestep it entirely.
module frame_rect(w, h, t = 0.3, col = "black") {
    color(col) {
        square([w, t]);
        translate([0, h - t]) square([w, t]);
        square([t, h]);
        translate([w - t, 0]) square([t, h]);
    }
}

module tri_h(x, y, dir, size) { // dir: -1 points left, 1 points right
    color(DIM_ORANGE) translate([x, y]) polygon([[0, size * 1.3], [0, -size * 1.3], [dir * size * 2.1, 0]]);
}
module tri_v(x, y, dir, size) { // dir: -1 points down, 1 points up
    color(DIM_ORANGE) translate([x, y]) polygon([[size * 1.3, 0], [-size * 1.3, 0], [0, dir * size * 2.1]]);
}

// double-headed orange dimension arrow, horizontal / vertical
module dim_h(x0, x1, y, lw = 0.22, head = 1.1) {
    xa = min(x0, x1); xb = max(x0, x1);
    color(DIM_ORANGE) translate([xa, y - lw/2]) square([xb - xa, lw]);
    tri_h(xa, y, -1, head);
    tri_h(xb, y, 1, head);
}
module dim_v(y0, y1, x, lw = 0.22, head = 1.1) {
    ya = min(y0, y1); yb = max(y0, y1);
    color(DIM_ORANGE) translate([x - lw/2, ya]) square([lw, yb - ya]);
    tri_v(x, ya, -1, head);
    tri_v(x, yb, 1, head);
}
// orange dimension LABEL — matches the reference's on-arrow captions
module dim_label(txt, x, y, size = 1.0) {
    color(DIM_ORANGE) translate([x, y]) text(txt, size = size, halign = "center", valign = "center");
}

// small square + lightning-bolt outlet icon (schematic position only —
// none of this project's outlet positions are precisely measured yet,
// see Section 0)
module bolt_icon(x, y, s = 1.6) {
    translate([x, y]) {
        color(DIM_ORANGE) square([s * 1.7, s * 2.1], center = true);
        color("white") polygon([
            [0.12*s, 0.95*s], [-0.32*s, 0.05*s], [0.02*s, 0.05*s],
            [-0.12*s, -0.95*s], [0.32*s, -0.05*s], [-0.02*s, -0.05*s]
        ]);
    }
}
