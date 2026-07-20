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

stroke = 0.3; // outline thickness, inches

// ------------------------------------------------------------
// Van body silhouette (illustrative, top-down) — same overall
// proportions as vehicle_overview.scad's side profile (front bumper
// to rear bumper = 203in, wheels at the same longitudinal positions)
// so the two views read as the same vehicle. Drawn as background
// context BEHIND the real dimensioned interior/platform diagram
// below; the body outline itself is not to any verified spec, just
// close enough to read as a minivan (long hood, mirrors, sliding
// doors, wheels tucked under the fenders) rather than a plain box.
// ------------------------------------------------------------
body_length    = 203;
body_rear_oh   = 10;  // rear bumper face to tailgate inner face
body_front_oh  = body_length - body_rear_oh - van_interior_length;
front_ref      = van_interior_length + body_front_oh; // front bumper's Y here
body_wheel_r   = 13.5;
body_front_wheel_d = 48;  // distance from FRONT bumper, matches vehicle_overview.scad
body_rear_wheel_d  = 160; // distance from FRONT bumper, matches vehicle_overview.scad

// (distance-from-front-bumper, halfwidth) key points — mirrors the
// side view's longitudinal hood/greenhouse/liftgate proportions. The
// mirrors themselves are drawn as separate small bumps (below), not
// baked into this outline — a sharp spike here turns into an ugly
// notch once run through the offset()-based outline-stroke technique.
body_profile = [
    [0, 22], [3, 30], [8, 35], [18, 39],
    [66, 39.5],
    [176, 39], [188, 34], [196, 28], [203, 18],
];
body_mirror_d = 67; // distance from the front bumper

module van_top_outline() {
    right_pts = [for (p = body_profile) [p[1], front_ref - p[0]]];
    left_pts  = [for (i = [len(body_profile) - 1 : -1 : 0]) [-body_profile[i][1], front_ref - body_profile[i][0]]];
    color("Silver")
    difference() {
        offset(r = stroke) polygon(concat(right_pts, left_pts));
        polygon(concat(right_pts, left_pts));
    }
}

module van_top_mirrors() {
    for (side = [-1, 1])
        color("Silver") translate([side * 41.5, front_ref - body_mirror_d])
            scale([1.4, 1]) circle(r = 1.8);
}

module van_top_wheel(d) {
    for (side = [-1, 1])
        color("Silver") translate([side * 30, front_ref - d])
            square([body_wheel_r * 0.9, body_wheel_r * 2], center = true);
}

module van_top_seams() {
    // sliding door seams (front + rear edge of the door opening) as
    // short tick marks crossing the body edge, one pair per side
    color("Silver") for (d = [88, 148]) for (side = [-1, 1])
        translate([side * (39.5 - 1), front_ref - d])
            square([2, stroke], center = true);
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
    van_top_outline();
    van_top_mirrors();
    van_top_wheel(body_front_wheel_d);
    van_top_wheel(body_rear_wheel_d);
    van_top_seams();

    // van interior envelope (hard max — see params.scad)
    translate([-van_interior_width/2, 0])
        rect_outline(van_interior_width, van_interior_length);
    label("Sienna interior envelope — hard max", 0, van_interior_length + 6.5, 2.0);
    label("FRONT", 0, van_interior_length + 3.5, 1.6);
    label("DRIVER side", -van_interior_width/2 + 6, van_interior_length + 3.5, 1.5);
    label("PASSENGER side", van_interior_width/2 - 6, van_interior_length + 3.5, 1.5);

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
