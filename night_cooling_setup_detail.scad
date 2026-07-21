// ============================================================
// Nighttime van + tent cooling setup (top-down / plan view)
// ============================================================
// How the WAVE 3 conditions the shared van+tent air volume overnight,
// per Section 1's "WAVE 3 sleeping configurations: tent vs. no tent"
// (tent case): the unit sits on Panel C's deck, a few inches forward
// of the rear-pantry cluster, blowing toward the open tailgate, hoses
// routed the short distance past the pantry and out the tailgate gap
// to true outside air. The tent attaches beyond the tailgate via its
// own elastic connection sleeve — NOT part of this build, drawn here
// as a dashed example footprint (tent_example_length/width,
// params.scad) so you can swap in your own tent's spec sheet.
//
// This is a night-only setup: the factory AC needs the van sealed up
// (doors/tailgate shut) to run efficiently, which is incompatible
// with the tent's sleeve needing the tailgate open — so this diagram
// deliberately shows ONLY the WAVE 3 + tent configuration, no AC.
//
// Orientation: matches top_view.scad — front of the vehicle at the
// TOP, tailgate at Y=0, everything outside the van (the tent) drawn
// BELOW it at negative Y, same as standing at the open tailgate
// looking out toward the tent.
//
// Simplified interior-envelope diagram, not a full vehicle-silhouette
// recreation (see top_view.scad / vehicle_overview.scad for that) —
// same focused-detail style as delta3_wave3_detail.scad / fridge_
// install_detail.scad: rectangles + numbered markers + a side list.
//
// Render with: openscad -o renders/night-cooling-setup-detail.svg night_cooling_setup_detail.scad
// ============================================================

include <params.scad>
include <colors.scad>

stroke = 0.3;

module rect_outline(w, l, s = stroke) {
    color("black")
    difference() {
        square([w, l]);
        translate([s, s]) square([w - 2*s, l - 2*s]);
    }
}

module label(txt, x, y, size = 1.6) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "center", valign = "center");
}

module label_left(txt, x, y, size = 1.3) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "left", valign = "center");
}

module marker(n, x, y) {
    translate([x, y]) {
        color(marker_col(n)) circle(r = 1.5);
        color("white") text(str(n), size = 1.5, halign = "center", valign = "center");
    }
}

// dashed lines/rect — used for the tent (an owner accessory, not part
// of the build's own structure) so it visually reads as "example",
// distinct from the solid-line built components
module dashed_line_h(x0, x1, y, dash = 2.5, gap = 1.5, s = stroke) {
    len = x1 - x0;
    n = floor(len / (dash + gap));
    for (i = [0 : n]) {
        sx = x0 + i * (dash + gap);
        ex = min(sx + dash, x1);
        if (ex > sx) translate([sx, y - s/2]) square([ex - sx, s]);
    }
}
module dashed_line_v(x, y0, y1, dash = 2.5, gap = 1.5, s = stroke) {
    len = y1 - y0;
    n = floor(len / (dash + gap));
    for (i = [0 : n]) {
        sy = y0 + i * (dash + gap);
        ey = min(sy + dash, y1);
        if (ey > sy) translate([x - s/2, sy]) square([s, ey - sy]);
    }
}
module dashed_rect_outline(x0, y0, w, l) {
    dashed_line_h(x0, x0 + w, y0);
    dashed_line_h(x0, x0 + w, y0 + l);
    dashed_line_v(x0, y0, y0 + l);
    dashed_line_v(x0 + w, y0, y0 + l);
}

// airflow arrow: from (x,y0) toward (x+spread, y0-len) — points "out
// the tailgate, into the tent" (-Y), fanning by `spread` over the run
module arrow_flow(x, y0, len, spread = 0) {
    x1 = x + spread;
    y1 = y0 - len;
    color(COL_ARROW) {
        hull() {
            translate([x, y0]) circle(r = 0.35);
            translate([x1, y1]) circle(r = 0.35);
        }
        translate([x1, y1]) polygon([[-1.1, 1.0], [1.1, 1.0], [0, -1.1]]);
    }
}

module side_list(list_x, top_y, items) {
    label_left("Component", list_x, top_y - 1, 1.3);
    label_left("Position / note", list_x, top_y - 3.2, 1.1);
    for (i = [0 : len(items) - 1]) {
        y = top_y - 8 - i * 9.5;
        color(marker_col(i + 1)) translate([list_x, y + 3.4]) circle(r = 1.3);
        color("white") translate([list_x, y + 3.4]) text(str(i + 1), size = 1.3, halign = "center", valign = "center");
        label_left(items[i][0], list_x + 3, y + 3.4, 1.15);
        label_left(items[i][1], list_x + 3, y + 1.6, 1.0);
        label_left(items[i][2], list_x + 3, y - 0.1, 1.0);
    }
}

module drawing() {
    // ---------- van interior envelope + panel layout (same math as
    // top_view.scad, reproduced here rather than shared since this is
    // a standalone focused-detail file) ----------
    y_panel_c = hatch_curvature_clearance; // ~2 — tailgate is at Y=0
    y_panel_b = y_panel_c + panel_c_length;
    y_panel_a = y_panel_b + panel_b_length;

    translate([-van_interior_width/2, 0]) rect_outline(van_interior_width, van_interior_length);
    label("Sienna interior envelope", 0, van_interior_length + 4.5, 1.8);
    label("FRONT", 0, van_interior_length + 1.8, 1.4);

    translate([-panel_width/2, y_panel_a]) rect_outline(panel_width, panel_a_length);
    label_left("Panel A", -panel_width/2 + 3, y_panel_a + panel_a_length - 3, 1.5);
    translate([-panel_width/2, y_panel_b]) rect_outline(panel_width, panel_b_length);
    label("Panel B", 0, y_panel_b + panel_b_length/2, 1.5);
    translate([-panel_width/2, y_panel_c]) rect_outline(panel_width, panel_c_length);
    label("Panel C", 0, y_panel_c + panel_c_length - 3, 1.5);

    // rear pantry (tailgate-most pantry_len of Panel C) — light context
    // only, same position convention as top_view.scad
    pantry_y0 = y_panel_c;
    color("Gainsboro") translate([-panel_width/2, pantry_y0]) rect_outline(pantry_cluster_w, pantry_len);
    color("Gainsboro") translate([-panel_width/2 + pantry_cluster_w + 1.5, pantry_y0]) rect_outline(pantry_pot_bin, pantry_pot_bin, 0.2);
    label("rear pantry", -panel_width/2 + pantry_cluster_w/2, pantry_y0 + pantry_len/2, 1.0);

    // ---------- 1: WAVE 3 unit + non-slip mat, on Panel C's deck a
    // few inches forward of the pantry, blowing toward the tailgate ----------
    wave_gap = 3; // "a few inches forward of" the pantry, Section 1
    wave_y0  = pantry_y0 + pantry_len + wave_gap;
    mat_pad  = 1.5;
    color("Tan") translate([-wave3_width/2 - mat_pad, wave_y0 - mat_pad])
        square([wave3_width + 2*mat_pad, wave3_depth + 2*mat_pad]);
    color("DarkGray") translate([-wave3_width/2, wave_y0]) square([wave3_width, wave3_depth]);
    marker(1, 0, wave_y0 + wave3_depth/2);

    // ---------- 2: hoses, past the pantry and out the tailgate gap ----------
    hose_x1 = wave3_width/4;
    hose_x2 = -wave3_width/4;
    color("SteelBlue") translate([hose_x1 - wave3_intake_hose_dia/4, -1]) square([wave3_intake_hose_dia/2, wave_y0 - (-1)]);
    color("DimGray")   translate([hose_x2 - wave3_exhaust_hose_dia/4, -1]) square([wave3_exhaust_hose_dia/2, wave_y0 - (-1)]);
    marker(2, (hose_x1 + hose_x2)/2, wave_y0 * 0.4);

    // ---------- 3: DELTA 3 Plus + Smart Extra Battery stack, Panel A
    // right (passenger) drawer — power source, illustrative position
    // (see delta3_wave3_detail.scad for the drawer-scale layout) ----------
    delta_w = 11; delta_x0 = panel_width/2 - delta_w - 3; delta_y0 = y_panel_a + 6;
    delta_cx = delta_x0 + delta_w/2;
    color("Silver") translate([delta_x0, delta_y0]) square([delta_w, delta3_length]);
    marker(3, delta_cx, delta_y0 + delta3_length/2);
    // power cord run, the length of the van, back to the WAVE 3 — routed
    // along the passenger-side edge (clear of the centered panel labels):
    // right from the WAVE 3 marker, up the side, then in to the DELTA 3 box
    cord_x = panel_width/2 - 5;
    wave_cy = wave_y0 + wave3_depth/2;
    color("Black") {
        translate([0, wave_cy - 0.15]) square([cord_x, 0.3]);
        translate([cord_x - 0.15, wave_cy]) square([0.3, delta_y0 - wave_cy]);
        translate([min(cord_x, delta_cx) - 0.15, delta_y0 - 0.15]) square([abs(delta_cx - cord_x) + 0.3, 0.3]);
    }

    // ---------- 4: tent connection sleeve, wrapping the open tailgate ----------
    sleeve_half = min(gate_opening_width, tent_example_width) / 2;
    color("SlateGray") translate([-sleeve_half, -2]) square([2 * sleeve_half, 4]);
    marker(4, sleeve_half + 3, 0);

    // ---------- 5: tent footprint (example — VEVOR SUV tent) ----------
    tent_y1 = -2; // just beyond the sleeve
    tent_y0 = tent_y1 - tent_example_length;
    color("Gainsboro") dashed_rect_outline(-tent_example_width/2, tent_y0, tent_example_width, tent_example_length);

    // ---------- 6: conditioned airflow, fanning from the open tailgate
    // into the shared tent volume — kept short so it clears the caption
    // text placed below it ----------
    arrow_flow(0, -1.5, 20, 0);
    arrow_flow(0, -1.5, 18, -14);
    arrow_flow(0, -1.5, 18, 14);

    // captions placed well below the arrows, safely inside the tent's
    // own footprint, clear of the tailgate/hose/sleeve clutter above
    label("TENT — EXAMPLE FOOTPRINT (swap for your tent's spec)", 0, -33, 1.3);
    label(str(tent_example_length, "\" x ", tent_example_width, "\" — VEVOR SUV tailgate tent"), 0, -35.4, 1.1);
    marker(5, -tent_example_width/2 + 5, -33);
    marker(6, tent_example_width/2 - 5, -33);

    // ---------- side list ----------
    side_list(panel_width/2 + 10, y_panel_a + panel_a_length, [
        ["WAVE 3 + non-slip mat", "Panel C's deck, a few in. forward of the pantry", "blows toward the open tailgate"],
        ["Intake/exhaust hoses", str(wave3_intake_hose_dia, "\"/", wave3_exhaust_hose_dia, "\" dia, past the pantry"), "out the open tailgate gap to true outside air"],
        ["DELTA 3 Plus + Extra Battery", "Panel A right (passenger) drawer", "power source — cord runs the length of the van"],
        ["Tent connection sleeve", "elastic, wraps the open tailgate/liftgate", "not part of this build — the tent's own accessory"],
        ["Tent footprint (example)", str(tent_example_length, "\" x ", tent_example_width, "\""), "VEVOR SUV tent or similar — swap in your own spec"],
        ["Conditioned airflow", "fans from the tailgate into the tent", "shares one open van+tent air volume — NIGHT ONLY"],
    ]);

    label_left("Night-only setup: skip the factory AC here — it needs the van sealed", -van_interior_width/2, -tent_example_length - 8, 1.1);
    label_left("(doors/tailgate shut) to run efficiently, which conflicts with the", -van_interior_width/2, -tent_example_length - 9.4, 1.1);
    label_left("tent sleeve needing the tailgate open. Seal the tent's own mesh/", -van_interior_width/2, -tent_example_length - 10.8, 1.1);
    label_left("vents shut and add a small circulation fan inside the tent to push", -van_interior_width/2, -tent_example_length - 12.2, 1.1);
    label_left("the WAVE 3's output to the tent's far end — see Section 1.", -van_interior_width/2, -tent_example_length - 13.6, 1.1);
}

// NOTE: no outer color("black") wrapper — every helper above
// self-colors (see top_view.scad / delta3_wave3_detail.scad for why:
// OpenSCAD's camera-preview PNG render does not let a nested color()
// override an OUTER color() wrapping it).
drawing();
