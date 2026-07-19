// Step 2: Build each module's independent frame — 4-sided
// perimeter rail (2 long rails + 2 end rails) + 4 legs, sized to
// that module's own footprint. Same construction for Panels A/B/C
// (Panel C's frame just has fridge/kitchen living in its void
// instead of drawers — see Step 4/Section 1). The rear pantry
// is NOT its own module anymore — it mounts directly onto Panel C's
// already-built deck (Component 4/1), no separate frame of its own.
// The fridge and kitchen unit are bought products with no frame of
// their own either. Two views: the individual parts as a kit (top), then
// the assembled cross-section showing the one non-obvious detail —
// the legs sit inset (leg_inset, params.scad) from the side rails
// so they land clear of the floor-level vent intrusion, while the
// deck itself overhangs the vents harmlessly at height. A top-down
// view can't show the vent-clearance detail — the legs hide under
// the end rails.
//
// Spacing note: OpenSCAD's SVG text export has taller effective
// line metrics than its PNG preview, so every stacked-label gap
// here is generous (roughly 2x font size or more) — verified
// against the actual exported SVG through the same CSS the PDF
// uses, not just a quick PNG preview render.
include <../params.scad>

stroke = 0.3;

module rect_outline(w, l, s = stroke) {
    difference() {
        square([w, l]);
        translate([s, s]) square([w - 2*s, l - 2*s]);
    }
}

module label(txt, x, y, size = 2.0) {
    translate([x, y]) text(txt, size = size, halign = "center", valign = "center");
}

module part(w, l, name, dims, x, y, show_label = true) {
    translate([x - w/2, y]) rect_outline(w, l);
    if (show_label) {
        label(name, x, y + l + 5, 1.7);
        label(dims, x, y + l + 2, 1.5);
    }
}

module parts_kit() {
    label("Parts for one module's frame (Panel A shown)", 0, 30, 2.2);

    // 2 long rails, with a real gap between them
    part(panel_a_length, frame_rail_sz, "Long rail (x2)", str(panel_a_length, "\" x 1.5\""), -36, 16);
    part(panel_a_length, frame_rail_sz, "Long rail (x2)", str(panel_a_length, "\" x 1.5\""), -10, 16);

    // 2 end rails, stacked, off to the side
    part(panel_width * 0.4, frame_rail_sz, "End rail (x2, 46\" full length)", str(panel_width, "\" x 1.5\""), 28, 16);
    part(panel_width * 0.4, frame_rail_sz, "End rail (x2, 46\" full length)", str(panel_width, "\" x 1.5\""), 28, 8, false);

    // 4 legs, spaced well apart, single shared label (centered over
    // the middle of the row, not tied to any one leg's position)
    for (i = [0:3])
        part(frame_rail_sz, leg_height, "Leg", str(leg_height, "\" x 1.5\""), -36 + i * 8, -8, false);
    label("Leg (x4)", -36 + 1.5 * 8, -8 + leg_height + 5, 1.7);
    label(str(leg_height, "\" x 1.5\""), -36 + 1.5 * 8, -8 + leg_height + 2, 1.5);
}

module assembled_section() {
    y0 = -56; // vertical offset for this whole sub-drawing, well clear of the parts kit above
    z_rail = leg_height + y0;
    z_deck = leg_height + frame_rail_sz + y0;

    label("Assembled cross-section — vent clearance detail", 0, y0 + leg_height + frame_rail_sz + panel_thickness + 12, 2.1);
    label(str("deck ", panel_width, "\" wide — overhangs the vents"),
          0, y0 + leg_height + frame_rail_sz + panel_thickness + 7, 1.9);

    translate([-van_interior_width/2, y0 - stroke])
        square([van_interior_width, stroke]);

    for (sx = [-1, 1])
        translate([sx * van_interior_width/2 - (sx > 0 ? vent_intrusion_width : 0), y0])
            rect_outline(vent_intrusion_width, 3);
    label("vent", -van_interior_width/2 + vent_intrusion_width/2, y0 - 4, 1.6);
    label("vent",  van_interior_width/2 - vent_intrusion_width/2, y0 - 4, 1.6);

    for (sx = [-1, 1])
        translate([sx * (panel_width/2 - leg_inset) - (sx > 0 ? frame_rail_sz : 0), y0])
            rect_outline(frame_rail_sz, leg_height);

    translate([-panel_width/2, z_rail])
        rect_outline(panel_width, frame_rail_sz);

    translate([-panel_width/2, z_deck])
        rect_outline(panel_width, panel_thickness);

    label(str("legs inset ", leg_inset, "\" from each side rail"),
          0, y0 + leg_height/2 + 2.6, 1.8);
    label("(clear of the floor-level vents)",
          0, y0 + leg_height/2 - 2.6, 1.6);
}

module drawing() {
    parts_kit();
    assembled_section();
    label("Same frame on Panel A/B/C — fridge/kitchen unit are bought products, no frame; the rear-pantry drawer cluster just sits on Panel C's deck", 0, -108, 1.6);
}

color("black") drawing();
