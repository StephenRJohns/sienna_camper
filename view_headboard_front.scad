// ============================================================
// Headboard/pantry — the face you see LOOKING FROM THE FRONT SEATS
// back toward the tailgate (the mattress-facing / bed side). X-Z
// elevation. This is the personal side: the enclosed bed cubby in
// the middle band, the bed shelf with Power strip 1 + bubble level,
// and the open food tiers above and below it. Companion to the
// full 4-side headboard_elevations.scad.
//
// Render with: openscad -o renders/headboard-front.svg view_headboard_front.scad
// ============================================================

include <params.scad>
include <colors.scad>

stroke = 0.22;
W  = headboard_width;   L = headboard_length; H = headboard_height;
PT = panel_thickness;
Yp = headboard_shelf_depth;
psz = headboard_personal_shelf_z;   // bed shelf
zu  = headboard_upper_shelf_z;      // upper food shelf (cubby ceiling)
za  = headboard_adj_shelf_z;        // adjustable shelf
ndh = headboard_nook_divider_h;
lip = headboard_fiddle_lip_h;

module rect_outline(w, l, s = stroke) {
    color("black") difference() { square([w, l]); translate([s, s]) square([w - 2*s, l - 2*s]); }
}
module label(txt, x, y, size = 1.25, ha = "center") {
    color("black") translate([x, y]) text(txt, size = size, halign = ha, valign = "center");
}
module dash_h(x0, x1, z, seg = 1.2, gap = 0.8) {
    n = floor((x1 - x0) / (seg + gap));
    for (i = [0 : n]) translate([x0 + i * (seg + gap), z]) square([min(seg, x1 - (x0 + i*(seg+gap))), 0.16]);
}
module marker(n, x, y) {
    translate([x, y]) { color(marker_col(n)) circle(r = 1.1); color("white") text(str(n), size = 1.2, halign = "center", valign = "center"); }
}

module drawing() {
    // deck the headboard sits on (context)
    color("Gray") translate([0, -1.5]) rect_outline(W, 1.5);
    label("Panel C deck", W/2, -0.75, 0.9);

    // side panels + outer outline
    color("BurlyWood") { translate([0, 0]) square([PT, H]); translate([W - PT, 0]) square([PT, H]); }
    rect_outline(W, H);

    // the two fixed shelves (solid) + the adjustable one (dashed)
    for (sz = [psz, zu]) color("BurlyWood") translate([PT, sz]) square([W - 2*PT, PT]);
    color("SaddleBrown") dash_h(PT, W - PT, za + PT/2);

    // enclosed bed cubby: the band between the bed shelf and the upper
    // shelf reads as the open personal nook on this face. Objects sit
    // at the band edges; the label owns the center.
    color("SaddleBrown") translate([PT, psz + PT]) square([W - 2*PT, 0.4]);      // half-round lip on the bed shelf
    color("Black")   translate([W * 0.68, psz + PT + 0.35]) square([5, 1.6]);    // Power strip 1 (right)
    color("DimGray") translate([W * 0.14, psz + PT + 0.35]) square([2.5, 0.75]); // ROLL bubble level (left)
    label("BED CUBBY — open toward the mattress", W/2, zu - 0.9, 1.1);

    // pin-hole columns (bottom bay)
    for (z = [headboard_pin_lo : headboard_pin_step : headboard_pin_hi])
        for (x = [PT + 0.7, W - PT - 0.7]) color("DimGray") translate([x, z]) circle(r = 0.16, $fn = 12);

    // fiddle lips on the food tiers seen on this face (bottom + top)
    color("Peru") { translate([PT, 0.2]) square([W - 2*PT, lip*0.55]);
                    translate([PT, za + PT + 0.05]) square([W - 2*PT, lip*0.55]);
                    translate([PT, zu + PT + 0.05]) square([W - 2*PT, lip*0.55]); }

    // title
    label("LOOKING FROM THE FRONT SEATS BACK TOWARD THE HEADBOARD (bed side)", W/2, H + 5, 1.6);
    label(str(W, "\" wide x ", H, "\" tall, on Panel C's deck — NO top panel; food side faces the tailgate"), W/2, H + 2.6, 1.15);

    // in-figure tier labels (kept short; detail is in the caption below)
    label("open food tier above the cubby", W/2, zu + PT + 1.6, 0.95);
    label("tall open food bay below — 1 adjustable shelf (dashed)", W/2, 9, 0.95);

    // markers on the drawing
    marker(1, W * 0.68 - 1.4, psz + PT + 1.2);   // Power strip 1
    marker(2, W * 0.14 + 3.4, psz + PT + 0.7);   // ROLL bubble level
    marker(3, PT + 3, zu + PT + 0.3);            // fiddle lip (top tier)
    marker(4, PT + 2.2, 4);                      // pin columns

    // legend
    leg_x = W + 4;
    items = ["Power strip 1 (bed-cubby)", "ROLL bubble level (leveling)",
             "Fiddle lip on every food tier", "Shelf-pin columns (adjustable bay)"];
    label("Legend", leg_x, H - 1, 1.5, "left");
    for (i = [0 : len(items) - 1]) {
        y = H - 4 - i * 3;
        marker(i + 1, leg_x + 0.8, y);
        label(items[i], leg_x + 2.6, y, 1.05, "left");
    }

    // caption strip below the figure
    label(str("Bed-cubby floor sits 9\" above the mattress top, ", Yp, "\" deep, full width — open only toward the mattress."),
          W/2, -3.2, 1.1);
    label("Enclosed by a food tier above + a tall food bay below; the nook divider forms its ceiling. Every food tier: fiddle lip + lash strap.",
          W/2, -5.2, 1.1);
}

drawing();
