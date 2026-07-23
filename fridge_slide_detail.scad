// ============================================================
// Fridge slide mechanism detail — side view (Y-Z), closed + open
// ============================================================
// Explicitly shows the fridge's heavy-duty slide, SIDE-MOUNTED (the
// VADANIA's 3in rail stands vertically beside the tray — fixed member
// on a steel riser angle bolted to the E-track floor anchors, moving
// member on the tray's 1x3 side apron; NOTHING under the hanging
// tray), the tray + fridge in their CLOSED (solid) and fully OPEN
// (dashed) positions, and the 24in of travel between them. Pairs with fridge_install_detail.scad
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

    // ---- deck structure above, for context — including the tailgate
    // end rail at Y=0, the ONE thing the mounted fridge must clear as
    // it slides out (its underside is at leg_height) ----
    color("Gray") translate([frame_rail_sz, z_deck - panel_thickness]) rect_outline(fridge_ext_width - frame_rail_sz, panel_thickness);
    label("deck (Panel C top — recessed flush)", fridge_ext_width/2, z_deck + 1.5, 1.0);
    color("Gray") translate([0, leg_height]) rect_outline(frame_rail_sz, frame_rail_sz);
    label("end rail", 0.9, 19.9, 0.8);
    color("Gray") translate([fridge_ext_width - frame_rail_sz, leg_height]) rect_outline(frame_rail_sz, frame_rail_sz);
    label("frame rail", fridge_ext_width - frame_rail_sz/2 - 2.3, leg_height - 0.75, 0.8);

    // ---- SIDE-MOUNT slide (fixes the old undermount drawing): the
    // VADANIA's 3in rail stands VERTICALLY beside the tray — fixed
    // member screwed to a steel riser angle through-bolted to the
    // E-track anchors, moving member screwed to the tray's 1x3 side
    // apron. NOTHING under the tray: it hangs between the rails,
    // fridge_tray_gap off the floor. The fixed rail is set back ~2.5in
    // from the tailgate face (the driver-side one clears Panel C's
    // rear corner leg that way). ----
    rail_y0 = 2.5;                       // set-back from the tailgate face
    rail_zb = fridge_riser_t;            // rail bottom, on the riser's bolt flange
    color("DimGray") translate([rail_y0, rail_zb]) rect_outline(fridge_slide_length, 3);
    label_left("FIXED rail (VADANIA VD2576, 3\" tall, stands VERTICALLY beside the tray —", fridge_ext_width + 1.5, 5.0, 1.0);
    label_left("screwed to a steel riser angle bolted to the E-track anchors; it adds", fridge_ext_width + 1.5, 3.7, 1.0);
    label_left("WIDTH beside the tray, ZERO height under it — never mount it undermount:", fridge_ext_width + 1.5, 2.4, 1.0);
    label_left("flat under the tray it would add ~1.2\" and hit the end rail above.", fridge_ext_width + 1.5, 1.1, 1.0);
    label_left("DC line slack clips to THIS fixed rail (3 screw-mount", fridge_ext_width + 1.5, 9.2, 0.9);
    label_left("clips, Sec. 5/6) — never to the moving tray, so it can't", fridge_ext_width + 1.5, 7.9, 0.9);
    label_left("get pinched between apron and rail when the slide comes home.", fridge_ext_width + 1.5, 6.6, 0.9);

    // E-track anchors on the floor along this rail line, front and back
    color("Black")
        for (ay = [rail_y0 + 2, rail_y0 + fridge_slide_length - 2])
            translate([ay - 0.75, 0]) square([1.5, 0.4]);
    label_left("E-track anchor (x2 this rail line, x4 total both slides — Sec. 8),", fridge_ext_width + 1.5, -0.5, 0.95);
    label_left("BESIDE the tray on the rail lines, never under it", fridge_ext_width + 1.5, -1.8, 0.95);

    // ---- CLOSED position: hanging tray + apron + fridge, flush to
    // Y=0 (tailgate) ----
    color("Gray") translate([0, fridge_tray_gap]) rect_outline(fridge_ext_width, fridge_tray_t);
    color("SaddleBrown") translate([0, fridge_tray_gap]) rect_outline(fridge_ext_width, 2.5, 0.12);
    label("1x3 side apron on the tray edge —", fridge_ext_width/2, 6.6, 0.8);
    label("moving member screws to it; top edge is the", fridge_ext_width/2, 5.5, 0.8);
    label(str("anti-shift lip; tray hangs ", fridge_tray_gap, "\" off the floor"), fridge_ext_width/2, 4.4, 0.8);
    color("DimGray", 0.3) translate([0, fridge_tray_gap + fridge_tray_t]) rect_outline(fridge_ext_width, fridge_ext_height);
    label("Fridge — CLOSED", fridge_ext_width/2, fridge_tray_gap + fridge_tray_t + fridge_ext_height/2 + 2, 1.1);
    label("(driving position)", fridge_ext_width/2, fridge_tray_gap + fridge_tray_t + fridge_ext_height/2 + 0.6, 0.95);

    // running clearance callout: mounted stack top vs the end rail
    color("Firebrick") translate([1.2, fridge_stack_top]) square([0.06, leg_height - fridge_stack_top]);
    label("the fridge slides under the TAILGATE END RAIL above", fridge_ext_width/2, 13.9, 0.85);
    label(str("(underside 17\") with ", leg_height - fridge_stack_top, "\" clearance (assert, params.scad)"), fridge_ext_width/2, 12.8, 0.8);

    // ---- hold-down strap: hooks to the fridge's end handles, down to
    // 2 D-rings screwed into the tray's side apron — the riser/anchor
    // bolting above secures the TRAY to the van; this strap is what
    // stops the fridge lifting/shifting off the TRAY itself ----
    fridge_top_z = fridge_stack_top;
    dring_z = fridge_tray_gap + 2.5; // apron's top edge
    for (sy = [2.5, fridge_ext_width - 2.5]) {
        color("Firebrick") {
            translate([sy - 1.4, dring_z]) circle(r = 0.35); // D-ring, tray side apron
            hull() { translate([sy - 1.4, dring_z]) circle(r = 0.15); translate([sy, fridge_top_z]) circle(r = 0.15); }
            translate([sy + 1.4, dring_z]) circle(r = 0.35); // D-ring, tray side apron, other side
            hull() { translate([sy + 1.4, dring_z]) circle(r = 0.15); translate([sy, fridge_top_z]) circle(r = 0.15); }
            translate([sy, fridge_top_z]) circle(r = 0.3); // fridge's end handle
        }
    }
    label_left("Hold-down strap (x1, cam-buckle): fridge's end handle ->", fridge_ext_width + 1.5, 20.6, 1.0);
    label_left("2 D-rings on the tray's side apron — stops the fridge lifting", fridge_ext_width + 1.5, 19.3, 1.0);
    label_left("off the TRAY (the riser/E-track bolting only pins the TRAY", fridge_ext_width + 1.5, 18.0, 1.0);
    label_left("to the van). Snug, not tight — must clear the lid at OPEN.", fridge_ext_width + 1.5, 16.7, 1.0);

    // ---- OPEN position: shifted -fridge_slide_length in Y, dashed ----
    open_y = -fridge_slide_length;
    color("DimGray") translate([open_y, fridge_tray_gap]) rect_dashed(fridge_ext_width, fridge_tray_t + fridge_ext_height, "DimGray");
    label("Fridge — fully OPEN", open_y + fridge_ext_width/2, fridge_tray_gap + fridge_ext_height + fridge_tray_t + 2, 1.1);
    label("(top-lid access)", open_y + fridge_ext_width/2, fridge_tray_gap + fridge_ext_height + fridge_tray_t + 0.6, 0.95);

    // moving (inner) rail, attached to the tray's apron, shown extended
    color("Black") translate([open_y + 2.5, rail_zb + 0.3]) rect_dashed(fridge_slide_length, 2.4, "Black");

    // 24in travel dimension
    dim_y = -4;
    dim_arrow(open_y, dim_y, 0);
    label(str(fridge_slide_length, "\" full-extension travel"), open_y/2, dim_y - 1.3, 1.05);

    label_left("VADANIA VD2576 industrial pair, 24\", 379lb, LOCKS closed (transit) and", fridge_ext_width + 1.5, 15.0, 1.0);
    label_left("extended (loading) — loaded fridge can hit 60-90lb, well within rating.", fridge_ext_width + 1.5, 13.7, 1.0);
    label_left("Tray (3/8\" ply + two 1x3 side aprons) hangs BETWEEN the rails on the", fridge_ext_width + 1.5, 12.1, 1.0);
    label_left("moving members; the aprons' top edges are the fridge's anti-shift lip.", fridge_ext_width + 1.5, 10.8, 1.0);

    label("Y (in., toward Panel B) ->", fridge_ext_width/2 - 12, -8.5, 1.1);
}

// NOTE: no outer color("black") wrapper — every helper above already
// self-colors (see top_view.scad/rear_view.scad for why a nested
// color() can't override an outer one in this pipeline).
drawing();
