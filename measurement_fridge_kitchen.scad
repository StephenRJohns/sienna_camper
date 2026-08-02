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
// LEGIBILITY (Aug 2026): 5 prose line(s) moved out of this
// sheet into the document, and every text size scaled x1.5. Those
// sentences were setting the sheet's width, and a figure's printed
// text height is size x (page_width / sheet_width) — so they were
// holding every other label on the sheet down to 3-6pt on paper.
// Keep prose in the markdown; this sheet carries geometry and short
// labels only.

include <params.scad>
include <dim_style.scad>

module label(txt, x, y, size = 1.95) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "center", valign = "center");
}

module label_left(txt, x, y, size = 1.65) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "left", valign = "center");
}

// Numeral BESIDE the icon. A white numeral centred in a filled circle
// disappears: OpenSCAD merges touching 2D shapes into one polygon set and
// paints them a single colour.
module num(n, x, y, col = "Black", nx = 2.0) {
    translate([x, y]) {
        color(col) circle(r = 1.2);
        color(col) translate([nx, 0])
            text(str(n), size = 2.2, halign = nx > 0 ? "left" : "right",
                 valign = "center");
    }
}

// dim_h/dim_v (orange double-headed arrows) come from dim_style.scad
// — style only, every value drawn is still fridge_ext_*/kitchen_box_*
// straight out of params.scad, same as before.

module drawing() {
    // light-grey backdrop, one card per sub-view
    bg_panel(-26, -3, 46, 42);
    // KITCHEN_DY closes the 40-unit empty band that used to sit between the two
    // cards. Sheet height sets printed text size, so that gap was costing every
    // label on both cards about a third of its size.
    KITCHEN_DY = 32;
    translate([0, KITCHEN_DY]) bg_panel(-26, -102, 46, -43, 3);

    // ================= FRIDGE (Y = 0 to 45) =================
    label("BougeRV FRIDGE — top-down (lid up)", 20, 40, 2.2);
    translate([0, 5]) frame_rect(fridge_ext_length, fridge_ext_width, 0.25, "DimGray");

    dim_h(0, fridge_ext_length, 32);
    num(1, fridge_ext_length/2, 32, "Black");
    label(str("1  length, ", fridge_ext_length, "\" (rotated)"), fridge_ext_length/2 + 2, 36.8, 1.8);

    dim_v(5, 5+fridge_ext_width, -3);
    num(2, -3, 16.7, "Black");
    label_left(str("2  depth, ", fridge_ext_width, "\""), -24, 20.4, 1.8);

    num(3, fridge_ext_length/2, 16.7, "DarkGray");
    label_left(str("3  height, ", fridge_ext_height, "\" (confirm)"), fridge_ext_length + 3, 17.6, 1.8);

    num(4, fridge_ext_length/2, 8, "GreenYellow");
    label_left("4  which end vents?", fridge_ext_length + 3, 8, 1.8);

    // MOVED TO THE DOCUMENT: label("Also record: empty weight, cord length, and how far it must slide out", 20, -2, 1.0);
    // MOVED TO THE DOCUMENT: label("before the lid can open fully clear of the deck above (fridge_slide_length assumes 24\" is enough).", 20, -3.4, 1.0);

    translate([0, KITCHEN_DY]) {
        // ================= KITCHEN (Y = -50 to -95) =================
        label("JAGAHAHA KITCHEN — top-down, closed", 20, -46, 2.2);
        translate([0, -85]) frame_rect(kitchen_box_width, kitchen_box_length, 0.25, "Gray");

        dim_h(0, kitchen_box_width, -58);
        num(6, kitchen_box_width/2, -58, "Black");
        label(str("6  width, ", kitchen_box_width, "\" closed"), kitchen_box_width/2, -55.4, 1.8);

        dim_v(-85, -58, -3);
        num(7, -3, -71.5, "Black");
        label_left(str("7  length, ", kitchen_box_length, "\" closed"), -24, -68.4, 1.8);

        num(8, kitchen_box_width/2, -83, "DimGray");
        label_left(str("8  height, ", kitchen_box_height, "\" closed"), kitchen_box_width + 3, -79.2, 1.8);

        // stove tray sub-box, called out separately
        translate([2, -80]) frame_rect(16, 14, 0.2, "Black");
        num(9, 10, -73, "Black");
        label("9  stove tray L x W x clearance", 10, -95.5, 1.8);
    }
    // MOVED TO THE DOCUMENT: label("(this plan estimated 23\" x 15.7\" x 5.7\" from listing PHOTOS,", 10, -97, 0.9);
    // MOVED TO THE DOCUMENT: label("not a spec sheet — the COOKTRON cooktop's fit depends on this)", 10, -98.4, 0.9);

    // MOVED TO THE DOCUMENT: label("Also record: empty weight, and the cord pass-through location for the cooktop's power cord.", 10, -101.5, 1.0);
}

// NOTE: no outer color("black") wrapper — every helper above already
// self-colors (see top_view.scad/rear_view.scad for why a nested
// color() can't override an outer one in this pipeline).
drawing();
