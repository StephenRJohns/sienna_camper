// Step 6: Rout a hand-hold hole through each end rail (two per
// panel module — Panel A, Panel B, Panel C; none on the pantry/
// pantry, which has no frame of its own — it mounts directly on
// Panel C's deck — and none on the fridge/kitchen unit, which are
// bought products with no frame of their own either) — NOT
// purchased hardware. Drill a hole at each rounded end of the slot,
// then cut the straight run between them with a jigsaw (or rout it
// in one pass with a template). Shown here zoomed in on just the
// hole itself (not the full 46in rail) so the cut detail actually
// reads, with a small inset showing where this sits on the full
// rail.
include <../params.scad>

stroke = 0.3;

module rect_outline(w, l, s = stroke) {
    difference() {
        square([w, l]);
        translate([s, s]) square([w - 2*s, l - 2*s]);
    }
}

module label(txt, x, y, size = 1.8) {
    translate([x, y]) text(txt, size = size, halign = "center", valign = "center");
}

module routed_slot(x_center, y_center) {
    straight_run = handle_width - 2 * handle_radius;
    translate([x_center, y_center])
        hull() {
            translate([-straight_run/2, 0]) circle(r = handle_radius);
            translate([straight_run/2, 0]) circle(r = handle_radius);
        }
}

module drawing() {
    zoom_w = handle_width + 6; // just enough rail to frame the hole with margin
    straight_run = handle_width - 2 * handle_radius;

    // zoomed-in rail segment, face-on, with the hole cut out of it
    difference() {
        translate([-zoom_w/2, 0]) rect_outline(zoom_w, frame_rail_sz);
        routed_slot(0, frame_rail_sz/2);
    }
    // construction guide: the two drilled end-circles, dashed since
    // the material between them is what gets removed in step 2
    translate([-straight_run/2, frame_rail_sz/2]) circle(r = handle_radius - stroke);
    translate([straight_run/2, frame_rail_sz/2]) circle(r = handle_radius - stroke);

    // dimension callouts — generous vertical gaps (~2x font size or
    // more) between every stacked line: OpenSCAD's SVG text export
    // has taller effective line metrics than its PNG preview, so
    // spacing that looks fine in a quick PNG check can still
    // overlap in the actual exported SVG used by the PDF.
    label(str(handle_radius * 2, "\" dia holes (x2)"), 0, frame_rail_sz + 4, 1.8);
    label(str(handle_width, "\" on center"), 0, -4, 1.8);

    label("Rail face, zoomed in on the hole (rail is 46\" wide overall)", 0, frame_rail_sz + 10, 1.9);
    label(str("1. Drill two ", handle_radius * 2, "\" holes, ", handle_width, "\" apart on center"),
          0, -9, 1.7);
    label("2. Jigsaw the straight run between them (or rout in one pass)",
          0, -13, 1.7);
    label("Hole passes all the way through the rail's 1.5\" depth — not a surface pull",
          0, -17, 1.6);

    label("Panel A outer edge shown — same hole at both ends of Panel A, B, and C", 0, -23, 1.5);
}

color("black") drawing();
