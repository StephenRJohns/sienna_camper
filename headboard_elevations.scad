// ============================================================
// Headboard/pantry — all 4 sides, flat dimensioned elevations,
// every piece labeled with its material type and cut size.
// ============================================================
// Companion to headboard_storage_detail.scad (the exploded isometric)
// and Section 6 Component 1. Owner's July-18 layout: NO full-height
// divider and NO top. Two FULL-DEPTH shelves; the BED SHELF is the
// lower of the two, and a nook divider spans the MIDDLE tier to make
// an ENCLOSED personal cubby. The tall bottom bay gets one ADJUSTABLE
// shelf on pins (run it as one 13in bay or two ~6in tiers per trip).
// RETENTION is the marine-galley system now — a front FIDDLE LIP on
// each food shelf (primary) + an elastic lash strap across each
// opening + bins + non-slip liner (not plain bungee nets).
//
// Render with: openscad -o renders/headboard-elevations.svg headboard_elevations.scad
// ============================================================

include <params.scad>
include <colors.scad>

stroke = 0.22;
W  = headboard_width;   // 46
L  = headboard_length;  // 14
H  = headboard_height;  // 22
PT = panel_thickness;   // 0.75
Yf = headboard_food_depth;   // 10.5 — middle tier's kitchen side, behind the nook divider
Yp = headboard_shelf_depth;  // 2.75 — bed cubby depth
psz = headboard_personal_shelf_z; // 13.0 — BED shelf (lower); surface 13.75 = 9" above the mattress
zu  = headboard_upper_shelf_z;    // 18.0 — UPPER food shelf, the cubby ceiling
za  = headboard_adj_shelf_z;      // 6.5 — ADJUSTABLE shelf, default position in the bottom bay
ndh = headboard_nook_divider_h;   // 4.25 — nook divider fills the enclosed middle tier
lip = headboard_fiddle_lip_h;     // 1.5 — front fiddle-lip height

module rect_outline(w, l, s = stroke) {
    color("black") difference() {
        square([w, l]);
        translate([s, s]) square([w - 2*s, l - 2*s]);
    }
}
module label(txt, x, y, size = 1.25, halign = "center") {
    color("black") translate([x, y]) text(txt, size = size, halign = halign, valign = "center");
}
module dash_h(x0, x1, z, seg = 1.2, gap = 0.8) {
    n = floor((x1 - x0) / (seg + gap));
    for (i = [0 : n]) translate([x0 + i * (seg + gap), z]) square([min(seg, x1 - (x0 + i*(seg+gap))), 0.16]);
}

module face_frame() {
    color("BurlyWood") {
        translate([0, 0]) square([PT, H]);
        translate([W - PT, 0]) square([PT, H]);
    }
    rect_outline(W, H);
}
// the two fixed shelves solid + the adjustable one dashed
module shelf_edges() {
    for (sz = [psz, zu])
        color("BurlyWood") translate([PT, sz]) square([W - 2*PT, PT]);
    color("SaddleBrown") dash_h(PT, W - PT, za + PT/2);      // adjustable shelf (dashed)
}
// pin-hole columns up both side panels, bottom bay only
module pin_cols() {
    for (z = [headboard_pin_lo : headboard_pin_step : headboard_pin_hi])
        for (x = [PT + 0.7, W - PT - 0.7])
            color("DimGray") translate([x, z]) circle(r = 0.16, $fn = 12);
}
// fiddle lip seen face-on: a filled bar sitting on the shelf front
module lip_bar(z) { color("Peru") translate([PT, z]) square([W - 2*PT, lip * 0.55]); }
// elastic lash strap across a tier opening (horizontal, mid-height)
module strap(z0, z1) {
    zc = (z0 + z1)/2;
    color("DimGray") translate([PT + 0.5, zc - 0.13]) square([W - 2*PT - 1, 0.26]);
    for (x = [PT + 1, W - PT - 1]) color("DimGray") translate([x, zc]) circle(r = 0.35, $fn = 16); // anchors
}

module mattress_facing() {
    face_frame();
    shelf_edges();
    pin_cols();
    // bed cubby fit-out on the bed shelf
    color("SaddleBrown") translate([PT, psz + PT]) square([W - 2*PT, 0.4]); // half-round lip
    color("Black") translate([W * 0.62, psz + PT + 0.5]) square([5, 2]);    // Power strip 1
    color("DimGray") translate([W * 0.22, psz + PT + 0.5]) square([2.5, 0.75]); // roll bubble level
    // fiddle lips + straps on the bed-facing food tiers (bottom pair + top)
    lip_bar(0.2); lip_bar(za + PT + 0.05); lip_bar(zu + PT + 0.05);
    strap(0.2, za - 0.3); strap(za + PT, psz - 0.3); strap(zu + PT, H - 0.3);
    label("MATTRESS-FACING (looking from the bed toward the tailgate)", W/2, H + 5, 1.5);
    label(str("BED CUBBY (enclosed) in the middle band: floor 9\" above the mattress, ", Yp, "\" deep"), W/2, H + 2.6, 1.15);
    label("half-round lip + Power strip 1 + ROLL bubble level, all on the bed shelf", W/2, psz + PT + ndh/2, 1.05);
    label("open food tiers above AND below the cubby — fiddle lip + lash strap on each", W/2, psz - 2, 1.05);
    label(str("side panels: 3/4\" ply, ", L, "\" x ", H, "\" (x2) — NO top panel"), W/2, 1.6, 1.1);
}

module kitchen_facing() {
    face_frame();
    shelf_edges();
    pin_cols();
    // fiddle lips + straps on every food tier, kitchen face
    lip_bar(0.2); lip_bar(za + PT + 0.05); lip_bar(psz + PT + 0.05); lip_bar(zu + PT + 0.05);
    strap(0.2, za - 0.3); strap(za + PT, psz - 0.3); strap(psz + PT, zu - 0.3); strap(zu + PT, H - 0.3);
    label("KITCHEN-FACING (looking forward from the open tailgate)", W/2, H + 5, 1.5);
    label("2 fixed shelves + 1 ADJUSTABLE (dashed) -> 4 food tiers, no top", W/2, H + 2.6, 1.15);
    label(str("bottom bay ", psz, "\" tall — 1 adjustable shelf on pins (", headboard_pin_lo, "-", headboard_pin_hi, "\"): one tall bay OR two ~6\" tiers"), W/2, za - 1.6, 1.02);
    label("fiddle lip + lash strap every tier (bins for utensils, non-slip liner under all)", W/2, psz + PT + ndh/2, 1.0);
    label(str("shelves: 3/4\" ply, ", W - 2*PT, "\" x ", L, "\" FULL depth (x2 fixed + x1 adjustable)"), W/2, 1.6, 1.1);
}

// side elevation: Y (depth) x Z. mattress side at local Y=0 (left).
module side_elev(mirror_it = false) {
    sx = mirror_it ? -1 : 1;
    translate([mirror_it ? L : 0, 0]) scale([sx, 1]) {
        rect_outline(L, H);
        for (sz = [psz, zu])
            color("BurlyWood") translate([stroke, sz]) square([L - 2*stroke, PT]);
        color("SaddleBrown") translate([stroke, za]) square([L - 2*stroke, PT * 0.7]); // adjustable shelf
        color("SeaGreen") translate([Yp, psz + PT]) square([PT, ndh]);                 // nook divider
        label("bed", Yp/2 + 0.3, psz + PT + ndh/2 + 0.6, 1.0);
        label("shelf", Yp/2 + 0.3, psz + PT + ndh/2 - 0.7, 0.9);
        // fiddle lips at the front edges (front = kitchen at Y=L; also
        // mattress at Y=0 for the full-depth tiers)
        color("Peru") for (fz = [0, za + PT, zu + PT]) {
            translate([L - PT - 0.35, fz]) square([0.35, lip]);   // kitchen edge
            translate([PT, fz]) square([0.35, lip]);              // mattress edge
        }
        color("Peru") translate([L - PT - 0.35, psz + PT]) square([0.35, lip]); // middle food tier, kitchen edge only
        // pin holes up the side panel, bottom bay
        for (z = [headboard_pin_lo : headboard_pin_step : headboard_pin_hi])
            color("DimGray") translate([PT + 0.5, z]) circle(r = 0.16, $fn = 12);
        // base cleat + brace stub
        color("DimGray") translate([L/2 - 1.5, -1.2]) square([3, 1.2]);
        color("DimGray") hull() { translate([0.4, 20]) circle(0.35); translate([-4.5, 13]) circle(0.35); }
    }
}

module drawing() {
    mattress_facing();
    translate([W + 14, 0]) kitchen_facing();

    translate([6, -H - 20]) {
        side_elev(false);
        label("LEFT SIDE (driver side)", L/2, H + 4.4, 1.4);
        label("mattress <- | -> kitchen", L/2, H + 2.2, 1.0);
        label("side panel 3/4\" ply", L/2, -3.2, 1.05);
    }
    translate([6 + L + 30, -H - 20]) {
        side_elev(true);
        color("Crimson") {
            translate([L - Yp * 0.6, 0.6]) square([0.22, psz + PT - 0.6]);
            translate([L - Yp * 0.6 + 0.11, 0.6]) difference() { circle(r = 0.7, $fn = 20); circle(r = 0.5, $fn = 20); }
        }
        label("RIGHT SIDE (passenger side)", L/2, H + 4.4, 1.4);
        label("kitchen <- | -> mattress", L/2, H + 2.2, 1.0);
        label("mirror image — same parts", L/2, -3.2, 1.05);
    }

    // shared full-width caption (no side-by-side label collisions)
    cx = W + 7;
    label("HEADBOARD/PANTRY — ALL 4 SIDES (14\" deep x 46\" wide x 22\" tall, on Panel C's deck — NO TOP)", cx, -H - 34, 1.8);
    label(str("Carcass: 2 side panels + 2 FIXED full-depth shelves (at ", psz, "\" bed + ", zu, "\" upper) + 1 ADJUSTABLE shelf on pins in the bottom bay, 3/4\" ply; nook divider 1/2\" ply, MIDDLE tier."), cx, -H - 36.6, 1.2);
    label("Legend: Peru bars = 1.5\" fiddle lips (front rails, both faces); grey = elastic lash straps; green = nook divider; dotted columns = shelf-pin holes (1\" o.c.); crimson = Power strip 1 cord.", cx, -H - 38.8, 1.2);
    label("Retention: a fiddle lip on EVERY food shelf + a lash strap across each opening + bins for utensils/small items + non-slip liner under all (a net only on the soft-goods tier).", cx, -H - 41, 1.2);
    label("Clamped to Panel C's deck (4x Kipp CAM LEVERS into T-nuts) + 2 L-angle braces (base: 2x 46\"x3\" ply cleats) — flips off in a minute, NO tools.", cx, -H - 43.2, 1.2);
}

drawing();
