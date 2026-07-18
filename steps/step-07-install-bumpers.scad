// Step 7: Install anti-rattle bumpers + alignment pins at every
// seam between modules — a felt/rubber strip across the seam
// plus two locating dowels near the edges, so modules register in
// the same spot every time and don't rub or squeak in transit.
// Shown here at the Panel A / Panel B seam as the representative
// example (same treatment at every other module boundary).
include <../params.scad>

stroke = 0.3;
viz_bumper_t = bumper_thickness * 2.5; // exaggerated for visibility, not to BOM scale
viz_pin_r = 0.6;

module rect_outline(w, l, s = stroke) {
    difference() {
        square([w, l]);
        translate([s, s]) square([w - 2*s, l - 2*s]);
    }
}

module drawing() {
    // two adjoining panel outlines
    rect_outline(panel_width, panel_a_length);
    translate([0, panel_a_length]) rect_outline(panel_width, panel_b_length);

    // bumper strip across the seam
    translate([0, panel_a_length - viz_bumper_t/2])
        square([panel_width, viz_bumper_t]);

    // alignment pins near both edges — offset above the strip and
    // outlined (not filled) so they read as distinct pins, not just
    // blend into the thick bumper line
    for (px = [5, panel_width - 5])
        translate([px, panel_a_length + viz_bumper_t/2 + viz_pin_r + 0.5])
            difference() {
                circle(r = viz_pin_r);
                circle(r = viz_pin_r - 0.35);
            }

    // captions below the whole assembly — genuinely empty space,
    // not inside either panel's own rectangle (Panel B extends up
    // to panel_a_length + panel_b_length, so anything placed just
    // above the seam actually lands inside Panel B's box)
    translate([panel_width/2, -6])
        text("Bumper strip + 2 alignment pins", size = 2.0, halign = "center", valign = "center");
    translate([panel_width/2, -16])
        text("at every module seam (A/B shown)", size = 1.6, halign = "center", valign = "center");
}

color("black") drawing();
