// ============================================================
// Fridge slide mechanism detail — side view (Y-Z), closed + open
// ============================================================
// Explicitly shows the fridge's heavy-duty slide: the fixed (outer)
// rail bolted to the E-track floor anchors, the tray + fridge in
// their CLOSED (solid) and fully OPEN (dashed) positions, and the
// 24in of travel between them. Pairs with fridge_install_detail.scad
// (top-down, real X/Y position of everything) and rear_view.scad
// (X-Z, looking in from the tailgate).
//
// One of 2 parallel slides is shown (the other is a mirror image at
// the fridge's other edge, same Y positions, different X) — a side
// view can only show one slice through X at a time.
//
// COORDINATE SYSTEM: Y=0 at Panel C's tailgate-facing edge (where
// the fridge sits when closed), increasing toward Panel B (matches
// fridge_install_detail.scad's convention). NEGATIVE Y is past the
// tailgate, into open air — where the fridge ends up when pulled
// out. Z=0 at the van floor, increasing up.
//
// Render with: openscad -o renders/fridge-slide-detail.svg fridge_slide_detail.scad
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

// dashed outline, for the OPEN (extended) position
module rect_dashed(w, h, col = "DimGray") {
    n = max(4, round((2*w + 2*h) / 2));
    perim = [[0,0],[w,0],[w,h],[0,h],[0,0]];
    for (i = [0:3]) {
        p0 = perim[i]; p1 = perim[i+1];
        seg_len = sqrt(pow(p1[0]-p0[0],2) + pow(p1[1]-p0[1],2));
        steps = max(2, round(seg_len / 1.2));
        for (j = [0:steps-1])
            if (j % 2 == 0) {
                t0 = j/steps; t1 = min(1, (j+0.6)/steps);
                color(col)
                hull() {
                    translate([p0[0]+(p1[0]-p0[0])*t0, p0[1]+(p1[1]-p0[1])*t0]) circle(r=0.09);
                    translate([p0[0]+(p1[0]-p0[0])*t1, p0[1]+(p1[1]-p0[1])*t1]) circle(r=0.09);
                }
            }
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

module dim_arrow(x0, y, x1, size = 1) {
    color("black") {
        translate([x0, y]) circle(r = 0.08);
        translate([x1, y]) circle(r = 0.08);
        translate([(x0+x1)/2, y]) hull() { translate([x0,0]) circle(r=0.08); translate([x1,0]) circle(r=0.08); }
    }
    color("black") translate([x0, y]) square([abs(x1-x0), 0.06], center=false);
}

module drawing() {
    z_deck = leg_height + frame_rail_sz;

    label("Fridge Slide Mechanism — side view (one of 2 parallel slides shown)", fridge_ext_width/2 - 12, z_deck + 12, 1.6);
    label("CLOSED (solid) vs fully OPEN (dashed) — pulled out through the tailgate for top-lid access", fridge_ext_width/2 - 12, z_deck + 10, 1.1);

    // floor line, spanning both closed and open positions with margin
    color("black") translate([-fridge_slide_length - 4, -0.1]) square([fridge_ext_width + fridge_slide_length + 8, 0.2]);
    label("VAN FLOOR", -fridge_slide_length + 2, -2, 1.1);
    label("TAILGATE OPENING (Y=0)", 0, -2, 1.0);
    color("black") translate([-0.1, -1.5]) square([0.2, 3]);

    // ---- deck structure above, for context ----
    color("Gray") translate([0, z_deck]) rect_outline(fridge_ext_width, panel_thickness);
    label("deck (Panel C top)", fridge_ext_width/2, z_deck + panel_thickness + 1.5, 1.0);
    color("Gray") translate([fridge_ext_width - frame_rail_sz, leg_height]) rect_outline(frame_rail_sz, frame_rail_sz);
    label("frame rail", fridge_ext_width - frame_rail_sz/2, leg_height - 1.5, 0.9);

    // ---- outer (fixed) slide rail — bolted to the E-track floor
    // anchors, spans the tray's closed footprint, does NOT move ----
    rail_z = 0.6;
    color("DimGray") translate([0, rail_z]) rect_outline(fridge_ext_width, 0.6);
    label_left("Outer rail (FIXED — bolted to E-track anchors below)", fridge_ext_width + 1.5, rail_z + 3, 1.0);

    // E-track anchors under the outer rail, front and back
    color("Black")
        for (ay = [1.5, fridge_ext_width - 1.5])
            translate([ay - 0.75, -0.5]) square([1.5, 0.5]);
    label_left("E-track anchor (x2 this slide,", fridge_ext_width + 1.5, rail_z + 1.2, 0.95);
    label_left("x4 total both slides — Sec. 8)", fridge_ext_width + 1.5, rail_z - 0.2, 0.95);

    // ---- CLOSED position: tray + fridge, flush to Y=0 (tailgate) ----
    color("Gray") translate([0, rail_z + 0.6]) rect_outline(fridge_ext_width, fridge_tray_t);
    color("DimGray", 0.3) translate([0, rail_z + 0.6 + fridge_tray_t]) rect_outline(fridge_ext_width, fridge_ext_height);
    label("Fridge — CLOSED", fridge_ext_width/2, rail_z + 0.6 + fridge_ext_height/2 + 2, 1.1);
    label("(driving position)", fridge_ext_width/2, rail_z + 0.6 + fridge_ext_height/2 + 0.6, 0.95);

    // ---- OPEN position: shifted -fridge_slide_length in Y, dashed ----
    open_y = -fridge_slide_length;
    color("DimGray") translate([open_y, rail_z + 0.6]) rect_dashed(fridge_ext_width, fridge_tray_t + fridge_ext_height, "DimGray");
    label("Fridge — fully OPEN", open_y + fridge_ext_width/2, rail_z + 0.6 + fridge_ext_height + fridge_tray_t + 2, 1.1);
    label("(top-lid access)", open_y + fridge_ext_width/2, rail_z + 0.6 + fridge_ext_height + fridge_tray_t + 0.6, 0.95);

    // inner rail, attached to the tray, shown extended
    color("Black") translate([open_y, rail_z + 0.15]) rect_dashed(fridge_ext_width, 0.3, "Black");

    // 24in travel dimension
    dim_y = -4;
    dim_arrow(open_y, dim_y, 0);
    label(str(fridge_slide_length, "\" full-extension travel"), open_y/2, dim_y - 1.3, 1.05);

    label_left("Heavy-duty full-extension slide pair, 24\", 200lb-rated per pair —", fridge_ext_width + 1.5, rail_z + fridge_ext_height - 2, 1.0);
    label_left("loaded fridge can realistically hit 60-90lb, well within rating.", fridge_ext_width + 1.5, rail_z + fridge_ext_height - 3.4, 1.0);
    label_left("Tray (3/8\" ply + edge frame) screwed to the inner rail; fridge screwed", fridge_ext_width + 1.5, rail_z + fridge_ext_height - 5.4, 1.0);
    label_left("to the tray with a lip so it can't shift in transit.", fridge_ext_width + 1.5, rail_z + fridge_ext_height - 6.8, 1.0);

    label("Y (in., toward Panel B) ->", fridge_ext_width/2 - 12, -8.5, 1.1);
}

// NOTE: no outer color("black") wrapper — every helper above already
// self-colors (see top_view.scad/rear_view.scad for why a nested
// color() can't override an outer one in this pipeline).
drawing();
