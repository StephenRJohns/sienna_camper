// ============================================================
// Router jig detail — flat template pattern, dimensioned top-down,
// woodworking-plan style.
// ============================================================
// A template guide for cutting the hand-hold holes with a plunge
// router instead of drill + jigsaw (Section 3/6) — the Porter
// Cable's own 5-7/8in base rides directly against the template's
// cutout edge (no separate guide bushing collar), so the cutout has
// to be bigger than the finished hole by exactly
// (router_base_dia/2 - router_bit_dia/2) all the way around: that gap
// is how far the spinning bit sits in from the base's own edge, and
// it's the base's edge — not the bit — that actually follows the
// template.
//
// The cutout is a PLAIN RECTANGLE — nothing fancy. The finished
// hole's corners come out rounded automatically at the bit's own
// radius (the bit can't cut a sharper inside corner than itself),
// which is exactly what a hand-hold wants.
//
// Render with: openscad -o renders/jig-detail.svg jig_detail.scad
// ============================================================

include <params.scad>
include <colors.scad>

stroke = 0.15;

offset_d = router_base_dia/2 - router_bit_dia/2; // 2.6875 with the default bit
hole_len = handle_width + 2 * handle_radius;      // 5.5 — finished hand-hold hole, overall length
hole_ht  = 2 * handle_radius;                     // 1.5 — finished hole height
jig_len  = hole_len + 2 * offset_d;               // rectangle cutout, overall length
jig_ht   = hole_ht + 2 * offset_d;                // rectangle cutout, overall height
board_margin = router_base_dia/2 + 1.5;           // solid material needed around the cutout so the base is always fully supported
board_w = jig_len + 2 * board_margin;
board_h = jig_ht + 2 * board_margin;
bit_r   = router_bit_dia/2;                       // finished hole's corner radius, set by the bit itself

module label(txt, x, y, size = 1.4, halign = "center") {
    color("black") translate([x, y]) text(txt, size = size, halign = halign, valign = "center");
}

// rectangle with rounded corners, centered on the origin
module rrect(l, h, r) {
    offset(r = r) square([l - 2*r, h - 2*r], center = true);
}

module dim_h(x0, x1, y, txt) {
    color("black") {
        translate([x0, y]) square([stroke, 1.2], center = true);
        translate([x1, y]) square([stroke, 1.2], center = true);
        translate([x0, y]) square([x1 - x0, stroke], center = false);
        label(txt, (x0 + x1)/2, y + 1.4, 1.3);
    }
}
module dim_v(y0, y1, x, txt) {
    color("black") {
        translate([x, y0]) square([1.2, stroke], center = true);
        translate([x, y1]) square([1.2, stroke], center = true);
        translate([x, y0]) square([stroke, y1 - y0], center = false);
        label(txt, x + 3.2, (y0 + y1)/2, 1.3, "left");
    }
}

module drawing() {
    // jig board (context, muted) — solid material with the plain
    // rectangular cutout removed
    color("BurlyWood") difference() {
        translate([-board_w/2, -board_h/2]) square([board_w, board_h]);
        square([jig_len, jig_ht], center = true);
    }

    // jig cutout edge (what the router base actually rides against)
    color("black") difference() {
        offset(r = stroke) square([jig_len, jig_ht], center = true);
        square([jig_len, jig_ht], center = true);
    }

    // finished hole (red) — what the bit actually cuts: the same
    // rectangle shrunk back in by the base/bit offset, corners
    // rounded at the bit's own radius
    color("Crimson")
        difference() {
            rrect(hole_len, hole_ht, bit_r);
            offset(r = -0.15) rrect(hole_len, hole_ht, bit_r);
        }

    // centerlines
    color("DimGray") {
        translate([-board_w/2 - 2, 0]) square([board_w + 4, stroke]);
        translate([0, -board_h/2 - 2]) square([stroke, board_h + 4]);
    }

    // dimensions
    dim_h(-jig_len/2, jig_len/2, -board_h/2 - 5, str(jig_len, "\" jig cutout length"));
    dim_v(-jig_ht/2, jig_ht/2, jig_len/2 + 3, str(jig_ht, "\" jig cutout height"));
    dim_h(-hole_len/2, hole_len/2, board_h/2 + 5, str(hole_len, "\" x ", hole_ht, "\" finished hole (red) — corners self-round at the bit's ", bit_r, "\" radius"));
    label(str("cutout = hole + ", offset_d, "\" all around (base radius ", router_base_dia/2, "\" - bit radius ", bit_r, "\")"), 0, board_h/2 + 8, 1.3);

    label("ROUTER JIG — hand-hold template (flat pattern, dimensioned)", 0, board_h/2 + 13, 2.0);
    label(str("Porter Cable plunge router, ", router_base_dia, "\" dia base, riding directly on the cutout edge (no guide bushing)"), 0, board_h/2 + 11, 1.3);
    label(str("Assumes a ", router_bit_dia, "\" straight/spiral bit — swap router_bit_dia in params.scad and every dimension above recomputes"), 0, board_h/2 + 9.5, 1.2);

    label("Cut the jig opening square with a jigsaw/circular saw — the HOLE takes its shape from what the bit cuts, not the jig's corners.", 0, -board_h/2 - 9, 1.2);
    label(str("board: ", board_w, "\" x ", board_h, "\" min (1/2\" MDF or ply) — clamp centered over the rail's hand-hold centerline before plunging"), 0, -board_h/2 - 11, 1.2);
    label("Plunge in the middle, then sweep the router's base around the cutout's full inside edge — the base edge follows the template.", 0, -board_h/2 - 13, 1.2);
}

drawing();
