// ============================================================
// Measurement guide — THE VAN (once 2nd row seats are removed)
// ============================================================
// Every dimension shown here is either UNVERIFIED (an estimate that
// drives real cut dimensions) or worth reconfirming before cutting
// anything. Matching numbered checklist + params.scad variable names
// are in the build plan's "Measurements to Take" section.
//
// Three simple sub-views, not to scale relative to each other and
// spaced well apart vertically (each block gets ~55 units of Y
// before the next starts) so titles, dimension lines, and long
// multi-line captions never fight each other — an earlier draft
// packed them tightly and nearly everything overlapped.
//
// TOP (looking down into the cargo floor), REAR (standing at the
// open tailgate looking at the opening), SIDE (standing outside the
// sliding door looking at its opening).
//
// Render with: openscad -o renders/measurement-van.svg measurement_van.scad
// ============================================================

include <params.scad>
include <dim_style.scad>

module label(txt, x, y, size = 1.4) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "center", valign = "center");
}

module label_left(txt, x, y, size = 1.2) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "left", valign = "center");
}

module num(n, x, y, col = "Black") {
    translate([x, y]) {
        color(col) circle(r = 1.6);
        color("white") text(str(n), size = 1.6, halign = "center", valign = "center");
    }
}

// dim_h/dim_v (orange double-headed arrows) and bolt_icon come from
// dim_style.scad — see that file for why these are STYLE only, not
// a source of new dimension values.

module drawing() {
    // light-grey backdrop, one card per sub-view — matches the
    // reference style's separate panels rather than one huge canvas
    bg_panel(-40, -4, 55, 58);
    bg_panel(-40, -101, 55, -52, 3);
    bg_panel(-40, -160, 55, -106, 3);

    // ================= TOP VIEW (Y = 0 to 55) =================
    label("TOP VIEW — cargo floor, looking down (2nd row removed, 3rd row folded)", 24, 54, 1.6);

    translate([0, 5]) frame_rect(48.5, 40, 0.3);

    // interior width — dimension line ABOVE the box, well clear of title
    dim_h(0, 48.5, 49);
    num(2, 24, 49, "Black");
    label(str("Interior width (", van_interior_width, "\" — already verified, double-check anyway)"), 24, 47, 1.0);

    // interior length — dimension line to the LEFT, text further left again
    dim_v(5, 45, -6);
    num(1, -6, 25, "Black");
    label_left("Interior length", -34, 25, 1.1);
    label_left(str("(", van_interior_length, "\" UNVERIFIED — closed"), -34, 23.5, 0.9);
    label_left("hatch to front seatbacks)", -34, 22.2, 0.9);

    // vent intrusion zones (both rear corners of the box, near Y=5)
    color("LightGray") { translate([0,5]) square([vent_intrusion_width, 8]); translate([48.5-vent_intrusion_width,5]) square([vent_intrusion_width, 8]); }
    num(3, vent_intrusion_width/2, 16, "DimGray");
    label_left("Vent intrusion width, both sides", 10, 16, 1.0);
    label_left(str("(", vent_intrusion_width, "\" — floor level only, already verified)"), 10, 14.6, 0.9);

    // hatch curvature clearance (bottom edge of the box, near Y=5)
    color("LightBlue") translate([0,5]) square([48.5, hatch_curvature_clearance]);
    num(4, 24, 2, "DarkGray");
    label("Hatch curvature clearance (already verified)", 24, -1.5, 1.0);

    // ================= REAR VIEW (Y = -55 to -100) =================
    label("REAR VIEW — standing at the open tailgate, looking at the liftgate opening", 24, -54, 1.6);
    translate([4, -95]) frame_rect(40.5, 32, 0.3);

    dim_h(4, 44.5, -58);
    num(5, 24, -58, "Black");
    label("Gate opening WIDTH — narrowest point", 24, -60.5, 1.0);
    label(str("(", gate_opening_width, "\" UNVERIFIED — measure the tightest spot side to side, not the widest)"), 24, -68, 0.95);

    dim_v(-95, -63, -2);
    num(6, -2, -79, "Black");
    label_left("Gate opening HEIGHT", -34, -74, 1.1);
    label_left(str("(", gate_opening_height, "\" UNVERIFIED —"), -34, -75.5, 0.9);
    label_left("corners are rounded, measure", -34, -76.8, 0.9);
    label_left("where they start cutting in)", -34, -78.1, 0.9);

    // rear 12V accessory outlet — schematic position only (Section 0
    // asks you to confirm both its exact position and whether it
    // stays powered with the ignition off)
    bolt_icon(40, -80, 1.5);
    label_left("REAR 12V ACCESSORY", 42.5, -79, 0.9);
    label_left("OUTLET — confirm position +", 42.5, -80.4, 0.85);
    label_left("stays hot with ignition OFF", 42.5, -81.6, 0.85);

    // ================= SIDE VIEW (Y = -110 to -155) =================
    label("SIDE VIEW — standing outside the sliding door, looking at its opening", 24, -109, 1.6);
    translate([4, -150]) frame_rect(40, 34, 0.3);

    dim_h(4, 44, -112);
    num(7, 24, -112, "Black");
    label(str("Side door opening WIDTH (", side_door_opening_width, "\" UNVERIFIED, fore-aft span)"), 24, -114, 1.0);

    dim_v(-150, -118, -2);
    num(8, -2, -134, "Black");
    label_left(str("Side door opening HEIGHT"), -34, -132, 1.1);
    label_left(str("(", side_door_opening_height, "\" UNVERIFIED)"), -34, -133.5, 0.95);

    label("Also record (no diagram needed): rear 12V outlet exact position, front console AC outlet wattage rating,", 24, -157, 1.0);
    label("folded 3rd-row well depth, and whether there's a factory sunroof (+ its opening size, if adding a roof vent later).", 24, -158.5, 1.0);
}

// NOTE: no outer color("black") wrapper — every helper above already
// self-colors (see top_view.scad/rear_view.scad for why a nested
// color() can't override an outer one in this pipeline).
drawing();
