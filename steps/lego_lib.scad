// ============================================================
// Shared library for the Lego-manual-style step diagrams,
// drawn in STANDARD WOODWORKING-PLAN line-art style:
// white "paper" parts with black edges, letter labels with
// leader lines, fastener callouts, exploded parts offset along
// their real installation axis with insertion arrows.
// ============================================================
// include <lego_lib.scad> from a steps/*.scad file (it includes
// params.scad itself). Every consumer file is driven by
//   -D step=N -D 'view="parts"|"assembly"'
// exactly like panel_ab_lego.scad.
//
// STYLE RULES (matching a classic printed woodworking plan):
//  - Parts are opaque white with black edges (a part in front
//    genuinely hides what's behind it, like paper line art).
//  - Parts already installed in previous steps keep white fill
//    but drop to light-gray edges, so the step's NEW parts are
//    the only strong-black shapes on the page.
//  - Insertion arrows are black, like the plan's own arrows.
//  - Letter/qty labels sit at the end of a thin leader line —
//    NOT floating on top of the part (the projected drawings
//    are too dense for inline text; same lesson as
//    fridge_install_detail.scad's marker convention).
// ============================================================

include <../params.scad>

$fn = 24;

EDGE_CTX = [0.62, 0.62, 0.62]; // context parts from previous steps
INK      = "Black";

// ---- isometric camera -----------------------------------------
// Spin about Z FIRST, then tilt about X — a single combined
// rotate() applies its X component first and projects world-Z
// down-right (scene reads upside down). This keeps world-Z
// pointing straight up on the page; X recedes down-right, Y
// recedes up-right (camera in the +X/-Y/+Z octant).
module isoT() { rotate([-54.7356, 0, 0]) rotate([0, 0, -45]) children(); }

module ifill(col) { color(col) projection(cut = false) isoT() children(); }

// where a 3D point lands on the 2D page (same math as isoT+projection);
// lets leader lines/labels be drawn as plain 2D against 3D geometry
function p2(p) = [0.70711 * (p[0] + p[1]),
                  -0.40825 * p[0] + 0.40825 * p[1] + 0.81650 * p[2]];

// ---- primitives ------------------------------------------------
module edge_box(w, l, h, r = 0.16) { // 12-edge cage (platform.scad's)
    for (y = [0, l]) for (z = [0, h])
        translate([0, y, z]) rotate([0, 90, 0]) cylinder(h = w, r = r);
    for (x = [0, w]) for (z = [0, h])
        translate([x, 0, z]) rotate([-90, 0, 0]) cylinder(h = l, r = r);
    for (x = [0, w]) for (y = [0, l])
        translate([x, y, 0]) cylinder(h = h, r = r);
}

// opaque white part with edges; ctx=true for previous-step parts
module wbox(pos, size, off2d = [0, 0], ctx = false) {
    translate(off2d) {
        ifill("White") translate(pos) cube(size);
        ifill(ctx ? EDGE_CTX : INK)
            translate(pos) edge_box(size[0], size[1], size[2], ctx ? 0.11 : 0.16);
    }
}

module orient(v) { // align +Z with v
    lv = norm(v);
    rotate([0, acos(v[2] / lv), atan2(v[1], v[0])]) children();
}

module rod3(p1, p2v, r) {
    d = p2v - p1;
    translate(p1) orient(d) cylinder(h = norm(d), r = r);
}

// black insertion arrow (3D, projected like the parts)
module iarrow(p1, p2v, r = 0.45, off2d = [0, 0]) {
    d = p2v - p1;  lv = norm(d);  hl = min(2.8, lv * 0.4);
    translate(off2d) ifill(INK) {
        rod3(p1, p2v - d * (hl / lv), r);
        translate(p2v - d * (hl / lv)) orient(d) cylinder(h = hl, r1 = r * 2.4, r2 = 0.05);
    }
}

// ---- 2D annotation helpers (drawn in page space) ---------------
module line2d(a, b, w = 0.14) { hull() { translate(a) circle(w); translate(b) circle(w); } }

module dash2d(a, b, w = 0.13, seg = 1.4) {
    v = b - a;  lv = norm(v);  n = max(1, floor(lv / (seg * 2)));
    for (i = [0 : n - 1])
        line2d(a + v * (i * 2 * seg / lv), a + v * min(1, (i * 2 * seg + seg) / lv), w);
}

module cap(txt, x, y, size = 2.2, halign = "center") {
    color(INK) translate([x, y]) text(txt, size = size, halign = halign, valign = "center");
}

// letter/qty label with a leader line back to a 3D anchor point.
// off = page-space offset from the anchor to the text.
module callout(txt, anchor3, off = [6, 4], size = 2.4) {
    q = p2(anchor3);
    t = q + off;
    color(INK) {
        line2d(q, t - off * (2.5 / max(2.5, norm(off))));
        translate(t) text(txt, size = size, halign = off[0] < 0 ? "right" : "left", valign = "center");
    }
}

// screw/fastener mark — a flat-head screw icon (circle with a slot
// cut through it, drawn as an actual difference() rather than a
// nested color() override, since a nested color() inside another
// color() doesn't win in the PNG preview render — see the note atop
// this file) at a 3D anchor point, projected in 2D page space like
// every other annotation here. Use at real screw/bracket locations in
// each assembly step so fasteners are visible, not just named in a
// caption.
module fastener(anchor3, r = 0.55, rot = 0) {
    q = p2(anchor3);
    color(INK) translate(q) rotate(rot)
        difference() {
            circle(r = r);
            square([r * 1.7, r * 0.32], center = true);
        }
}

// same mark, but for landing on an already-solid-black part (e.g. the
// base cleat strips) where a black-on-black fastener() would be
// invisible — drawn as a light ring instead so it still reads
module fastener_light(anchor3, r = 0.55, rot = 0) {
    q = p2(anchor3);
    color("LightGray") translate(q) rotate(rot)
        difference() {
            circle(r = r);
            square([r * 1.7, r * 0.32], center = true);
        }
}

// ---- generic step geometry (any perimeter-frame module) --------
// coords: X centered (-w/2..w/2), Y 0..len, Z floor-up — matches
// platform.scad's module_frame()

// lh: leg_height for Panel C, leg_height_ab for A/B (deck recess —
// A/B legs are 0.75in shorter so the platform-on-rails plane matches
// Panel C's recessed flush deck).
module lib_frame_ring(len, w, ctx = false, lh = leg_height) {
    wbox([-w/2, 0, lh], [frame_rail_sz, len, frame_rail_sz], [0, 0], ctx);
    wbox([w/2 - frame_rail_sz, 0, lh], [frame_rail_sz, len, frame_rail_sz], [0, 0], ctx);
    wbox([-w/2, 0, lh], [w, frame_rail_sz, frame_rail_sz], [0, 0], ctx);
    wbox([-w/2, len - frame_rail_sz, lh], [w, frame_rail_sz, frame_rail_sz], [0, 0], ctx);
}

module lib_legs(len, w, drop = 0, ctx = false, rear_inset = -1, lh = leg_height) {
    ri = rear_inset < 0 ? leg_inset : rear_inset;
    for (x = [-w/2 + leg_inset, w/2 - frame_rail_sz - leg_inset])
        wbox([x, 0, -drop], [frame_rail_sz, frame_rail_sz, lh], [0, 0], ctx);
    for (x = [-w/2 + ri, w/2 - frame_rail_sz - ri])
        wbox([x, len - frame_rail_sz, -drop], [frame_rail_sz, frame_rail_sz, lh], [0, 0], ctx);
}

module lib_frame_ctx(len, w, lh = leg_height) { // whole frame as previous-step context
    lib_frame_ring(len, w, true, lh);
    lib_legs(len, w, 0, true, lh);
}

// step: FRAME — parts kit (plain labels, no leader lines — a kit
// view is sparse enough that a label under each part reads fine)
module lib_frame_parts(len, w, lc = leg_cut_length, lh = leg_height) {
    // end rail recedes DOWN-right (X axis), side rail UP-right (Y
    // axis), leg straight up (Z) — the 2D offsets below account for
    // each part's own projected extent so labels never cross a part
    wbox([0, 0, 0], [w, frame_rail_sz, frame_rail_sz]);
    cap(str("A  2x end rail 2x2 x ", w, "\""), w * 0.35, -24, 2.6);
    wbox([0, 0, 0], [frame_rail_sz, len, frame_rail_sz], [0, -46]);
    cap(str("B  2x side rail 2x2 x ", len, "\""), len * 0.42, -50, 2.6);
    wbox([0, 0, 0], [frame_rail_sz, frame_rail_sz, lh], [w * 1.1, -46]);
    cap(str("C  4x leg 2x2 x ", lc, "\" cut (+1\" leveling foot)"), w * 1.1 + 2, -50, 2.6);
    cap(str("K  bottom rails 2x2 (cube frame — count/faces per panel, see assembly)"), w * 0.5, -56, 2.2);
    cap("+ 4 corner brackets, 2\" screws, glue", w * 0.5, -60, 2.2);
}

// step: FRAME — exploded assembly (legs dropped, arrows up).
// bottom: "ends" (Panel A — both end faces), "front" (Panel C —
// tailgate face stays open, rear legs at the TRUE corners), or
// "all" (Panel B — the full cube). These are the CUBE-FRAME bottom
// rails at bottom_rail_z, just above the leveling feet.
module lib_frame_assembly(len, w, bottom = "ends", lh = leg_height) {
    drop = 9;
    ri = bottom == "front" ? 0 : leg_inset; // rear-leg inset (Panel C: corners)
    lib_frame_ring(len, w, false, lh);
    lib_legs(len, w, drop, false, ri, lh);
    for (x = [-w/2 + leg_inset, w/2 - frame_rail_sz - leg_inset])
        iarrow([x + frame_rail_sz/2, frame_rail_sz/2, lh - drop + 1.5],
               [x + frame_rail_sz/2, frame_rail_sz/2, lh - 0.5]);
    for (x = [-w/2 + ri, w/2 - frame_rail_sz - ri])
        iarrow([x + frame_rail_sz/2, len - frame_rail_sz/2, lh - drop + 1.5],
               [x + frame_rail_sz/2, len - frame_rail_sz/2, lh - 0.5]);

    // bottom rails (part K)
    wbox([-w/2 + leg_inset, 0, bottom_rail_z], [w - 2 * leg_inset, frame_rail_sz, frame_rail_sz]);
    if (bottom != "front")
        wbox([-w/2 + ri, len - frame_rail_sz, bottom_rail_z], [w - 2 * ri, frame_rail_sz, frame_rail_sz]);
    if (bottom == "all")
        for (x = [-w/2 + leg_inset, w/2 - frame_rail_sz - leg_inset])
            wbox([x, frame_rail_sz, bottom_rail_z], [frame_rail_sz, len - 2 * frame_rail_sz, frame_rail_sz]);

    // corner bracket screws — end rail meets side rail at all 4 corners
    for (x = [frame_rail_sz/2 - w/2, w/2 - frame_rail_sz/2])
        for (y = [frame_rail_sz * 1.4, len - frame_rail_sz * 1.4])
            fastener([x, y, lh + frame_rail_sz * 0.75]);
    callout("A", [0, len - frame_rail_sz/2, lh + frame_rail_sz], [7, 6]);
    callout("B", [w/2 - frame_rail_sz/2, len * 0.35, lh + frame_rail_sz], [8, -4]);
    callout("C", [w/2 - frame_rail_sz - leg_inset + frame_rail_sz/2, 0, lh/2 - drop], [7, -3]);
    callout("K", [0, frame_rail_sz/2, bottom_rail_z + frame_rail_sz], [-8, -5]);
    cap(str("K: bottom rails (2x2, underside at ", bottom_rail_z, "\") close the frame into a box — ",
            bottom == "all" ? "all 4 faces (full cube)" :
            bottom == "front" ? "front face only (appliances exit the tailgate; rear legs at the TRUE corners)" :
            "both end faces only (drawer + WAVE 3 exit the sides)"), 0, -30, 1.8);
}

// step: fixed TOP — parts kit. DECK RECESS: the top is cut to the
// BETWEEN-RAILS opening and drops INTO the frame onto 3/4x3/4
// cleats, flush with the rail tops (buys 3/4in of headroom).
module lib_top_parts(len, w) {
    wbox([0, 0, 0], [w - 2 * frame_rail_sz, len - 2 * frame_rail_sz, panel_thickness]);
    // the plank's projected extent is dominated by the WIDTH's
    // down-right descent (w * 0.408), not the length — anchor the
    // labels below that, or they cross the plank on short modules
    cap(str("D  1x top ", len - 2 * frame_rail_sz, "\" x ", w - 2 * frame_rail_sz, "\"  (3/4\" ply — drops BETWEEN the rails)"), w * 0.42, -w * 0.42 - 3, 2.6);
    cap("E  3/4 x 3/4 bearer cleats on the rails' inner faces, tops 3/4\" down", w * 0.42, -w * 0.42 - 8, 2.2);
    cap("+ 1-1/4\" screws down into the cleats + toe-screws into the rails", w * 0.42, -w * 0.42 - 13, 2.2);
}

// the lifted top + arrows/callout/guides WITHOUT any context —
// callers layer their own previous-step parts underneath first
// (2D projection stacks in declaration order, so anything drawn
// after the top would paint over it)
module lib_top_drop(len, w) {
    lift = 9;
    // recessed: the (smaller) top hovers above the frame, drops
    // BETWEEN the rails onto the bearer cleats — landed top surface
    // flush with the rail tops (deck_surface_z)
    wbox([-w/2 + frame_rail_sz, frame_rail_sz, deck_surface_z + lift], [w - 2 * frame_rail_sz, len - 2 * frame_rail_sz, panel_thickness]);
    for (x = [-w/3, w/3])
        iarrow([x, len/2, deck_surface_z + lift - 1],
               [x, len/2, deck_surface_z - panel_thickness + 1]);
    callout("D", [(w/2 - frame_rail_sz) * 0.9, len - frame_rail_sz, deck_surface_z + lift + panel_thickness], [6, 5]);
    // bearer cleats on the rails' inner faces (part E), landed height
    for (cx = [-w/2 + frame_rail_sz, w/2 - frame_rail_sz - 0.75])
        wbox([cx, frame_rail_sz, deck_surface_z - panel_thickness - 0.75], [0.75, len - 2 * frame_rail_sz, 0.75]);
    callout("E", [w/2 - frame_rail_sz - 0.375, len * 0.3, deck_surface_z - panel_thickness - 0.375], [8, -4]);
    // dashed drop guides at the inner-opening corners, plan-style
    color(INK) for (cx = [-w/2 + frame_rail_sz, w/2 - frame_rail_sz])
        dash2d(p2([cx, frame_rail_sz, deck_surface_z + lift]), p2([cx, frame_rail_sz, deck_surface_z]));
    // screws down into the cleats below, shown at their landed
    // (post-drop) height along both long edges
    for (x = [-w/2 + frame_rail_sz + 0.4, w/2 - frame_rail_sz - 0.4])
        for (y = [len * 0.22, len * 0.5, len * 0.78])
            fastener([x, y, deck_surface_z - panel_thickness * 0.4]);
}

// step: fixed TOP — exploded assembly (frame context + lifted top)
module lib_top_assembly(len, w) {
    lib_frame_ctx(len, w);
    lib_top_drop(len, w);
}

// ============================================================
// HEADER-TRIO helpers (IKEA-style component header: hero drawing,
// accessory list, numbered part list). All page-space 2D, layered
// on top of / beside the projected iso geometry. Used by
// component_headers.scad; accessory-cell + hardware icons live in
// hardware_icons.scad (which includes this file).
// ============================================================

// numbered PART-LIST badge — a boxed 2-digit number ("01","02"...)
// on a leader line back to a 3D anchor on the exploded geometry.
// Mirrors callout() but with the reference's boxed-number style.
// A solid black badge with a WHITE number on top — drawn this way (not
// white-fill + black number) because OpenSCAD's preview PNG z-fights
// coincident coplanar 2D fills and black wins; white-on-black always
// renders (same technique as the accessory letter tabs / markers).
module part_badge(n, anchor3, off = [6, 4], size = 1.9) {
    q = p2(anchor3);
    t = q + off;
    color(INK) line2d(q, t - off * (2.6 / max(2.6, norm(off))));
    translate(t) {
        color(INK) square([size * 2.1, size * 1.7], center = true);
        color("white") text(n, size = size, halign = "center", valign = "center");
    }
}

// same badge as part_badge, but anchored at an explicit 2D page point
// (for heroes drawn directly in page space, not projected 3D geometry).
module badge2d(n, at, off = [6, 4], size = 1.9) {
    t = at + off;
    color(INK) line2d(at, t - off * (2.6 / max(2.6, norm(off))));
    translate(t) {
        color(INK) square([size * 2.1, size * 1.7], center = true);
        color("white") text(n, size = size, halign = "center", valign = "center");
    }
}

// a titled, bordered header section (2D page space). Draw the section
// content with a translate into the box; the title sits in a bar on top.
module hdr_frame(x, y, w, h, title, tsize = 2.6) {
    translate([x, y]) {
        color(INK) difference() {
            square([w, h]);
            translate([0.35, 0.35]) square([w - 0.7, h - 0.7]);
        }
        // title bar
        color(INK) translate([0, h - 4.2]) square([w, 0.3]);
        color(INK) translate([w / 2, h - 2.4]) text(title, size = tsize, halign = "center", valign = "center");
    }
}

// thin divider between sub-cells (2D)
module hdr_divider(x, y, len, vertical = false) {
    color(INK) translate([x, y])
        square(vertical ? [0.28, len] : [len, 0.28]);
}
