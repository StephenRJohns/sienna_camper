// ============================================================
// Panel C — LEFT side elevation (Y-Z), looking from the driver's
// side toward the passenger side
// ============================================================
// The two new pieces of mounting detail no other diagram shows in
// true elevation: the fire extinguisher's actual height/position on
// the left frame rail, and the kitchen unit's own side profile. The
// fridge's slide is already covered, at a comparable Y-Z slice, by
// fridge_slide_detail.scad — no need to duplicate it here.
//
// This is a schematic elevation, not a literal photographic
// cross-section: the fire extinguisher's real footprint spans a few
// inches of X (mounted on the rail, not paper-thin), so it's drawn
// at its full width here rather than as an edge-on sliver, the same
// simplification convention used throughout this project's line
// drawings (see rear_view.scad's own notes on schematic vs. true
// position).
//
// COORDINATE SYSTEM: Y=0 at Panel C's tailgate-facing edge,
// increasing toward Panel B (matches fridge_install_detail.scad /
// fridge_slide_detail.scad). Z=0 at the van floor.
//
// Render with: openscad -o renders/panel-c-left-side.svg panel_c_left_side_detail.scad
// ============================================================

include <params.scad>

stroke = 0.2;

module rect_outline(w, h, s = stroke) {
    color("black")
    difference() {
        square([w, h]);
        translate([s, s]) square([w - 2*s, h - 2*s]);
    }
}

module label(txt, x, y, size = 1.3) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "center", valign = "center");
}

module label_left(txt, x, y, size = 1.2) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "left", valign = "center");
}

module drawing() {
    z_deck = leg_height + frame_rail_sz;

    label("PANEL C — LEFT side elevation (Y-Z), looking from the driver's side", panel_c_length/2, z_deck + 22, 1.6);
    label("(kitchen-unit side of the platform — see fridge_slide_detail.scad for the right/fridge side)", panel_c_length/2, z_deck + 20, 1.05);

    // van floor
    color("black") translate([-2, -0.1]) square([panel_c_length + 4, 0.2]);
    label("VAN FLOOR", -6, -2, 1.0);
    color("black") translate([-0.1, -1.5]) square([0.2, 3]);
    label("TAILGATE (Y=0)", 4.5, -3.5, 1.0);
    label("(toward Panel B) Y ->", panel_c_length - 4, -2, 1.0);

    // left corner legs (front + back), same leg_height as every module —
    // drawn behind the kitchen unit's own box below; not individually
    // labeled here since any label placed near them would sit inside
    // the kitchen unit's footprint (both share this X slice) — see the
    // general note near the title instead.
    color("Gray") translate([0, 0]) rect_outline(frame_rail_sz, leg_height);
    color("Gray") translate([panel_c_length - frame_rail_sz, 0]) rect_outline(frame_rail_sz, leg_height);
    label_left(str("corner leg (", leg_height, "\" tall)"), 5, z_deck + 9, 0.9);

    // deck (frame rail + ply) spanning the full length
    color("Gray") translate([0, leg_height]) rect_outline(panel_c_length, frame_rail_sz);
    color("Gray") translate([frame_rail_sz, z_deck - panel_thickness]) rect_outline(panel_c_length - 2 * frame_rail_sz, panel_thickness);
    label("deck (Panel C top — recessed flush with the rail tops)", panel_c_length/2, z_deck + 1.5, 1.0);

    // Kitchen unit — closed profile, flush to the tailgate edge (Y=0)
    color("Gainsboro") translate([0, 0]) rect_outline(kitchen_box_length, kitchen_box_height);
    label("Kitchen unit (JAGAHAHA)", kitchen_box_length/2, kitchen_box_height + 2.3, 1.05);
    label(str(kitchen_box_length, "\" (closed) x ", kitchen_box_height, "\" tall"), kitchen_box_length/2, kitchen_box_height + 0.9, 0.95);
    label("extends to 70\" open, OUTSIDE the vehicle — not shown", kitchen_box_length/2, -5, 0.9);

    // Fire extinguisher — real elevation on the left frame rail, near
    // the Panel B seam (front-left corner). Shown at its real width
    // (5.75in) even though it's mounted ON the ~1.5in-thick rail —
    // schematic, not literal edge-on thickness (see file header).
    ext_y = 24; // matches fridge_install_detail.scad's real mounting position
    ext_w = 5.75; ext_h = 15.5;
    color("Black") translate([ext_y - ext_w/2, z_deck]) rect_outline(ext_w, ext_h);
    label("Fire extinguisher", ext_y, z_deck + ext_h + 2.3, 1.1);
    label("(Amerex B417T, bracket-mounted", ext_y, z_deck + ext_h + 0.9, 0.9);
    label("to the frame rail, 3x #10x1.5\" screws)", ext_y, z_deck + ext_h - 0.5, 0.9);

    label("Looking forward (Panel B is to the right in this view) — same left rail the fire extinguisher's bracket bolts to",
          panel_c_length/2, -7, 1.0);
}

// NOTE: no outer color("black") wrapper — every helper above already
// self-colors (see top_view.scad/rear_view.scad for why a nested
// color() can't override an outer one in this pipeline).
drawing();
