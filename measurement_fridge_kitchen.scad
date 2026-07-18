// ============================================================
// Measurement guide — THE FRIDGE (BougeRV) and KITCHEN (JAGAHAHA)
// ============================================================
// Take these once you actually have both units in hand — the specs
// used throughout this plan come from online listings/photos, not a
// hands-on measurement, and the kitchen unit's cooktop fit depends
// directly on getting its stove tray right.
//
// Render with: openscad -o renders/measurement-fridge-kitchen.svg measurement_fridge_kitchen.scad
// ============================================================

include <params.scad>
include <dim_style.scad>

module label(txt, x, y, size = 1.3) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "center", valign = "center");
}

module label_left(txt, x, y, size = 1.1) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "left", valign = "center");
}

module num(n, x, y, col = "Black") {
    translate([x, y]) {
        color(col) circle(r = 1.4);
        color("white") text(str(n), size = 1.4, halign = "center", valign = "center");
    }
}

// dim_h/dim_v (orange double-headed arrows) come from dim_style.scad
// — style only, every value drawn is still fridge_ext_*/kitchen_box_*
// straight out of params.scad, same as before.

module drawing() {
    // light-grey backdrop, one card per sub-view
    bg_panel(-26, -3, 46, 42);
    bg_panel(-26, -102, 46, -43, 3);

    // ================= FRIDGE (Y = 0 to 45) =================
    label("BougeRV FRIDGE — top-down view (lid up)", 20, 40, 1.6);
    translate([0, 5]) frame_rect(fridge_ext_length, fridge_ext_width, 0.25, "DimGray");

    dim_h(0, fridge_ext_length, 32);
    num(1, fridge_ext_length/2, 32, "Black");
    label(str("Length as installed, ", fridge_ext_length, "\" left-right (rotated)"), fridge_ext_length/2, 34.3, 1.0);

    dim_v(5, 5+fridge_ext_width, -3);
    num(2, -3, 16.7, "Black");
    label_left("Depth, front to back", -22, 18.3, 1.05);
    label_left(str("(", fridge_ext_width, "\")"), -22, 16.9, 1.0);

    num(3, fridge_ext_length/2, 16.7, "DarkGray");
    label_left("Height (unlisted here —", fridge_ext_length + 3, 18.5, 1.0);
    label_left(str("spec sheet says ", fridge_ext_height, "\", confirm"), fridge_ext_length + 3, 17.1, 1.0);
    label_left("with the real unit)", fridge_ext_length + 3, 15.7, 1.0);

    num(4, fridge_ext_length/2, 8, "GreenYellow");
    label_left("Which side is the compressor/vent on?", fridge_ext_length + 3, 9.5, 1.0);
    label_left("(confirm intake/exhaust fan placement", fridge_ext_length + 3, 8.1, 1.0);
    label_left("still make sense — Section 2 coordinates)", fridge_ext_length + 3, 6.7, 1.0);

    label("Also record: empty weight, cord length, and how far it must slide out", 20, -2, 1.0);
    label("before the lid can open fully clear of the deck above (fridge_slide_length assumes 24\" is enough).", 20, -3.4, 1.0);

    // ================= KITCHEN (Y = -50 to -95) =================
    label("JAGAHAHA KITCHEN UNIT — top-down view, closed", 20, -46, 1.6);
    translate([0, -85]) frame_rect(kitchen_box_width, kitchen_box_length, 0.25, "Gray");

    dim_h(0, kitchen_box_width, -58);
    num(6, kitchen_box_width/2, -58, "Black");
    label(str("Width, ", kitchen_box_width, "\" closed"), kitchen_box_width/2, -55.7, 1.0);

    dim_v(-85, -58, -3);
    num(7, -3, -71.5, "Black");
    label_left("Length (closed),", -24, -70, 1.05);
    label_left(str(kitchen_box_length, "\" — also confirm"), -24, -71.4, 1.0);
    label_left("it still extends to ~70\" open", -24, -72.8, 1.0);

    num(8, kitchen_box_width/2, -83, "DimGray");
    label_left("Height, closed", kitchen_box_width + 3, -78.5, 1.0);
    label_left(str("(", kitchen_box_height, "\")"), kitchen_box_width + 3, -80, 1.0);

    // stove tray sub-box, called out separately
    translate([2, -80]) frame_rect(16, 14, 0.2, "Black");
    num(9, 10, -73, "Black");
    label("Stove tray L x W x clearance-height", 10, -95.5, 1.0);
    label("(this plan estimated 23\" x 15.7\" x 5.7\" from listing PHOTOS,", 10, -97, 0.9);
    label("not a spec sheet — the COOKTRON cooktop's fit depends on this)", 10, -98.4, 0.9);

    label("Also record: empty weight, and the cord pass-through location for the cooktop's power cord.", 10, -101.5, 1.0);
}

// NOTE: no outer color("black") wrapper — every helper above already
// self-colors (see top_view.scad/rear_view.scad for why a nested
// color() can't override an outer one in this pipeline).
drawing();
