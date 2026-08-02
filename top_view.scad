// ============================================================
// Top-down technical line drawing (2D) — Sienna camper platform
// ============================================================
// Exports as SVG: outline-only rectangles (no fill), so this
// reads as a clean technical drawing rather than a filled block
// diagram.
//
// Orientation: front of the vehicle (front seats) is at the TOP of
// the drawing, tailgate at the BOTTOM — matches how you'd actually
// stand at the open tailgate looking into the van.
//
// Layout: ONE continuous full-length deck (Panels A/B/C) on uniform
// legs. The fridge (on a tailgate-pull slide, flush to Panel C's
// right edge) and the kitchen unit (its own tailgate slide, flush
// to Panel C's left edge) both live INSIDE Panel C's footprint —
// see the rear-view diagram (renders/rear-view.svg) for the fridge
// cooling system / control panel detail this view doesn't show. The
// rear-pantry drawer cluster shares that SAME footprint too, at a different Z
// height — it's a shelving superstructure mounted on TOP of Panel
// C's deck, right above the fridge/kitchen void, at the tailgate end
// (drawn here as a labeled outline overlapping the fridge/kitchen
// boxes, since a top-down view can't show the height separation).
//
// Render with: openscad -o renders/top-down.svg top_view.scad
// ============================================================

include <params.scad>
include <van_plan.scad>

stroke = 0.3; // outline thickness, inches

// ------------------------------------------------------------
// Van body context — the SHARED plan geometry from van_plan.scad, so
// this floorplan and the Appendix A survey plans read as the same
// vehicle (they used to each draw their own silhouette).
//
// van_plan.scad's canonical frame is X = fore-aft from the REAR
// bumper, Y = lateral from the centreline. This drawing is the
// transpose of that: X lateral, Y = fore-aft from the CLOSED HATCH.
// So the geometry is rotated 90 and mirrored (a transpose, not a
// rotation), then shifted by the bumper-to-hatch offset. Mirroring
// keeps the driver side on -X, where this drawing labels it, and puts
// the steering wheel on the correct side.
// ------------------------------------------------------------
module van_context() {
    translate([0, -VP_HATCH]) mirror([1, 0]) rotate(90) vp_van_context();
}

// Every helper below self-colors black: OpenSCAD's camera-preview
// PNG render (used for renders/*.png, which — unlike the SVG export
// — actually preserves color) does NOT let a nested color() override
// an OUTER color() wrapping it; the outermost color() always wins,
// contrary to the usual "child overrides parent" expectation.
// Self-coloring each element black here means a caller that wraps a
// call in e.g. color("DimGray") correctly gets orange (that wrapper
// is now the outermost color in scope), while an unwrapped call gets
// black from here instead of relying on a top-level wrapper that
// would otherwise blot out every nested color in the whole drawing.
module rect_outline(w, l, s = stroke) {
    color("black")
    difference() {
        square([w, l]);
        translate([s, s]) square([w - 2*s, l - 2*s]);
    }
}

module label(txt, x, y, size = 2.4) {
    color("black")
    translate([x, y])
        text(txt, size = size, halign = "center", valign = "center");
}

module handle_marker(x, y) {
    // hand-hold holes were removed from the plan (July 2026) — bare
    // frames are gripped by their exposed top rails; kept as a no-op
    // so the call sites stay documented.
}

module bumper_marker(width, y) {
    color("black")
    translate([-width/2, y - bumper_thickness/2])
        square([width, bumper_thickness]);
}

module pin_marker(x, y, r = 0.4) {
    color("black")
    translate([x, y]) circle(r = r);
}

// Name on one line, dimensions on a shorter line below.
module module_block(length, width, name, y_offset, handle_count = 2, name_size = 2.6, dim_size = 2.1, x_offset = 0) {
    translate([x_offset - width/2, y_offset]) rect_outline(width, length);
    label(name, x_offset, y_offset + length/2 + name_size * 0.65, name_size);
    label(str(length, "\" x ", width, "\""), x_offset, y_offset + length/2 - dim_size * 0.75, dim_size);

    if (handle_count == 2) {
        handle_marker(x_offset, y_offset + frame_rail_sz/2);
        handle_marker(x_offset, y_offset + length - frame_rail_sz/2);
    } else if (handle_count == 1) {
        handle_marker(x_offset, y_offset + frame_rail_sz/2);
    }
}

module top_view() {
    // illustrative van body — background context so this reads as a
    // Sienna, not a generic box (see header note above)
    van_context();

    // van interior envelope (hard max — see params.scad)
    translate([-van_interior_width/2, 0])
        rect_outline(van_interior_width, van_interior_length);
    // Orientation labels go OUTSIDE the body: the front seats now sit
    // flush against the envelope's forward edge (van_interior_length is
    // measured to the seatbacks), so this row used to land on top of them.
    label("FRONT", 0, 196, 2.2);
    color("black") translate([-43, 60]) rotate(90) text("DRIVER side", size = 2.0, valign = "center");
    color("black") translate([43, 60]) rotate(-90) text("PASSENGER side", size = 2.0, valign = "center");
    color("black") translate([-43, 118]) rotate(90) text("interior envelope — hard max", size = 1.9, valign = "center");

    // floor-level vent intrusion zones (legs must stay clear of these,
    // deck itself can overhang — see leg_inset in params.scad)
    translate([-van_interior_width/2, 0]) rect_outline(vent_intrusion_width, van_interior_length);
    translate([van_interior_width/2 - vent_intrusion_width, 0]) rect_outline(vent_intrusion_width, van_interior_length);

    // Module layout, front (Panel A, closest to the front seats) at
    // the top working down to the tailgate (Panel C). Panel A now
    // sits flush with the front seatbacks (see panel_a_y0 in
    // params.scad) — no open floor left between them, now that the 3
    // panels fill usable_length exactly. hatch_curvature_clearance
    // (2") is left empty at the very bottom, matching the reserve at
    // the tailgate.
    y_panel_c    = hatch_curvature_clearance;
    y_panel_b    = y_panel_c + panel_c_length;
    y_panel_a    = y_panel_b + panel_b_length;

    // usable boundary line — nothing built below this line (toward
    // the tailgate)
    translate([-van_interior_width/2, y_panel_c]) square([van_interior_width, stroke]);

    module_block(panel_a_length, panel_width, "Panel A", y_panel_a);
    module_block(panel_b_length, panel_width, "Panel B", y_panel_b);
    // spare tire ghost: thin ring + nested tool case, flat under the platform
    color("Gray") translate([0, y_panel_b + panel_b_length/2]) difference() {
        circle(r = spare_dia/2, $fn = 90); circle(r = spare_dia/2 - 0.3, $fn = 90);
    }
    color("Gray") translate([-5, y_panel_b + panel_b_length/2 + 3]) difference() {
        square([10, 7]); translate([0.3, 0.3]) square([9.4, 6.4]);
    }
    label("RJ-MODINI spare + jack case (in the wheel), 2 totes on top", 0, y_panel_b + 4.2, 1.05);

    // Panel C: outline + hand-holds like the others, but its own
    // name/dims label sits near the TOP of the box (close to the
    // Panel B seam) instead of centered — the bottom half is where
    // the fridge/kitchen sub-labels live, and centering would
    // collide with them
    translate([-panel_width/2, y_panel_c]) rect_outline(panel_width, panel_c_length);
    handle_marker(0, y_panel_c + frame_rail_sz/2);
    handle_marker(0, y_panel_c + panel_c_length - frame_rail_sz/2);
    label("Panel C", 0, y_panel_c + panel_c_length - 3, 2.2);
    label(str(panel_c_length, "\" x ", panel_width, "\""), 0, y_panel_c + panel_c_length - 5.5, 1.8);

    // fridge + kitchen unit, flush to Panel C's tailgate-facing
    // (bottom) edge, inside Panel C's own outline
    fridge_y0 = y_panel_c; // flush to the bottom (tailgate) edge
    kitchen_y0 = y_panel_c; // also flush to the bottom edge
    translate([x_fridge_module - fridge_module_width/2, fridge_y0]) rect_outline(fridge_module_width, fridge_ext_width);
    label("Fridge", x_fridge_module, fridge_y0 + 4.5, 1.6);
    label(str(fridge_ext_width, "\" x ", fridge_ext_length, "\""), x_fridge_module, fridge_y0 + 2.6, 1.2);
    label("slides out tailgate", x_fridge_module, fridge_y0 + 1, 1.0);

    translate([x_kitchen - kitchen_box_width/2, kitchen_y0]) rect_outline(kitchen_box_width, kitchen_box_length);
    label("Kitchen unit", x_kitchen, fridge_y0 + 4.5, 1.6);
    label("(JAGAHAHA)", x_kitchen, fridge_y0 + 2.6, 1.2);
    label("slides out tailgate", x_kitchen, fridge_y0 + 1, 1.0);

    // Rear pantry (prefab drawer cluster): shares the SAME X-Y footprint as the tailgate
    // end of the fridge/kitchen zone above, just at a different Z
    // height (mounted on Panel C's deck, above the void) — drawn as a
    // full-width outline overlapping both. Its own explanation lives
    // in the caption strip below (Panel C's own box is too crowded
    // with fridge/kitchen labels for more text here without colliding).
    pantry_y0 = y_panel_c; // flush to the tailgate edge, same as fridge/kitchen
    // 2x2 drawer cluster against the driver edge + pot bin in the open bay
    color("DarkGray") translate([-panel_width/2, pantry_y0]) rect_outline(pantry_cluster_w, pantry_len);
    color("DarkGray") translate([-panel_width/2 + pantry_cluster_w + 1.5, pantry_y0]) rect_outline(pantry_pot_bin, pantry_pot_bin, 0.2);

    // Power strip 1 — relocated to the deck edge in the pantry's open
    // bay (marker only here — full caption in the strip below)
    color("DimGray") translate([panel_width/2 - 5, pantry_y0 + pantry_len + 1]) square([3, 2], center = true);

    // front-to-back seams: bumper strip + 2 alignment pins between
    // lift-out panels (not at the pantry, which just sits on the deck)
    seam_ys = [y_panel_a, y_panel_b];
    for (i = [0:1]) {
        y = seam_ys[i];
        bumper_marker(panel_width, y);
        pin_marker(-panel_width/2 + 3, y);
        pin_marker(panel_width/2 - 3, y);
    }

    // captions below the drawing — safely inside the horizontal
    // extent already established by the van outline
    label("REAR / TAILGATE", 0, -3.5, 1.8);
    label(str("Vent intrusion (", vent_intrusion_width, "\" per side, floor level only) shown along both edges — legs must stay clear"),
          0, -13, 1.4);
    label(str("Usable boundary line = ", hatch_curvature_clearance, "\" hatch-curvature reserve, nothing built below it toward the tailgate"),
          0, -15.5, 1.4);
    label("Fridge + kitchen unit live inside Panel C (not a separate row) — see rear-view diagram for cooling/control detail",
          0, -18, 1.3);
    label("Rear pantry (dark gray, tailgate end of Panel C): prefab 2x2 drawer cluster + pot bin ON the deck above the fridge/kitchen void,",
          0, -20.5, 1.3);
    label("not a separate footprint — food side faces the kitchen, personal shelf (Power strip 1) faces the mattress",
          0, -23, 1.3);
}

top_view(); // no outer color() wrapper — see the note above rect_outline()
