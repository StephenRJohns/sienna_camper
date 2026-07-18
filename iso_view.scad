// ============================================================
// Isometric line drawing (vector, via projection())
// ============================================================
// Render with: openscad -o renders/isometric.svg iso_view.scad
//
// Every large flat surface (panel tops, fridge/kitchen, the van
// shell) is drawn in wireframe form (12-edge cage, not a solid
// face) before projecting. projection() always collapses solid
// faces into one filled silhouette that hides whatever's behind
// it — wireframe edges stay as thin bands, so the result reads as
// a proper technical line drawing instead of a single filled blob.
//
// COLOR: projection() discards per-object color information (it
// flattens 3D geometry to a plain 2D outline) — a single projection
// of the whole colored assembly would come out entirely black. To
// keep the color coding that makes each part identifiable, each
// module group is projected SEPARATELY and colored AFTER
// projection, then all the projected 2D outlines are layered
// together. A legend (plain 2D text, not part of the rotated scene)
// explains what each color is.
// ============================================================

use <platform.scad>
include <params.scad>

show_van_shell = true; // pass -D show_van_shell=false to hide the reference envelope

// module offsets — computed locally since `use` doesn't import
// platform.scad's own top-level variables, only its modules
y_panel_a   = 0;
y_panel_b   = panel_a_length;
y_panel_c   = panel_a_length + panel_b_length;

rot = [35.264, 0, 45];

module iso(col) {
    color(col) projection(cut = false) rotate(rot) children();
}

iso("Silver") if (show_van_shell) van_shell();
iso("Gray") panel_module(panel_a_length, panel_width, y_panel_a, true, false, true);
iso("Gray") panel_module(panel_b_length, panel_width, y_panel_b, true);
iso("DimGray") panel_module(panel_c_length, panel_width, y_panel_c, true, true);
iso("DarkGray") headboard_module(y_panel_c + panel_c_length - headboard_length); // mounted on Panel C's tailgate end

// legend — plain 2D text/swatches, positioned beside the drawing,
// NOT part of the rotated isometric scene
legend_items = [
    ["Silver", "Van interior envelope"],
    ["Gray", "Panel A / B (sleeping deck, side drawers)"],
    ["DimGray", "Panel C (fridge + kitchen unit inside, see rear-view diagram)"],
    ["DarkGray", "Headboard/pantry (mounted on Panel C's tailgate end)"],
];
legend_x = 60;
for (i = [0 : len(legend_items) - 1]) {
    y = 40 - i * 5;
    color(legend_items[i][0]) translate([legend_x, y - 1.5]) square([3, 3]);
    color("black") translate([legend_x + 5, y]) text(legend_items[i][1], size = 2.2, halign = "left", valign = "center");
}
