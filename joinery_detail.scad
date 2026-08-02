// ============================================================
// Joinery & fasteners — reference sheet (Ryobi DBJ50 biscuit guide)
// ============================================================
// Where every wooden joint in the build gets a BISCUIT (R-series,
// cut with the Ryobi DBJ50 detail biscuit joiner) vs. SCREWS. The
// DBJ50 cuts R1/R2/R3 slots up to 9/32in deep with a 1-1/2in 6-tooth
// blade, 45/90 fence — small "detail" biscuits, ideal for this
// build's 1/2in + 3/4in ply.
//
// RULE OF THUMB: first biscuit 2in from each end, then every ~6in on
// center, ALWAYS centered on the stock thickness. Glue slot AND face;
// clamp until set. Biscuits align + reinforce, so they replace
// visible screws on show-face ply joints.
//
// Render with: openscad -o renders/joinery-detail.svg joinery_detail.scad
// ============================================================

include <params.scad>

stroke = 0.05;
INK = "black";
BISC = "Peru";
SCRW = "Crimson";

module lbl(txt, x, y, s = 0.9, h = "center") { color(INK) translate([x, y]) text(txt, size = s, halign = h, valign = "center"); }
module rr(w, h, s = stroke) { color(INK) difference() { square([w, h]); translate([s, s]) square([w - 2*s, h - 2*s]); } }
// A ply rectangle: ONE filled shape, deliberately with no separate
// outline. OpenSCAD merges touching 2D shapes into a single polygon set
// and paints it with one colour, so a coplanar fill + ink frame came out
// SOLID BLACK — which is how every ply part on this sheet had been
// rendering, hiding the biscuit ovals the sheet exists to show. Tan on
// the cream ground reads fine on its own, and the Peru ovals sit on it
// with plenty of contrast.
module ply(w, h, s = stroke) {
    color("BurlyWood") square([w, h]);
}
module bisc(x, z, lx = 0.5, lz = 1.4) { color(BISC) translate([x, z]) resize([lx, lz]) circle(r = 1, $fn = 20); }
module screwmark(x, z, r = 0.28) { color(SCRW) translate([x, z]) { circle(r = r, $fn = 16); color("white") { translate([-r*0.7, 0]) square([r*1.4, 0.08], center = true); translate([0, -r*0.7]) square([0.08, r*1.4], center = true); } } }
module tick(x, y) { color(INK) translate([x, y]) square([stroke*2, 0.6], center = true); }

// ---- TITLE ----
lbl("JOINERY & FASTENERS — Ryobi DBJ50 (R1/R2/R3)", 26, 56, 2.4);
lbl("ovals = biscuit slots     red = screws     grey = 2x2 frame", 26, 52.5, 1.6);

// ---- VIGNETTE 1 — spacing rule ----
translate([2, 44]) {
    lbl("1 — SPACING RULE", 0, 3.6, 1.8, "left");
    ply(40, 1.5);
    for (x = [2, 8, 14, 20, 26, 32, 38]) bisc(x, 0.75);
    tick(0, -0.8); tick(2, -0.8); tick(8, -0.8); tick(38, -0.8); tick(40, -0.8);
    color(INK) translate([0, -0.8]) square([40, stroke]);
    lbl("2\"", 1, -1.7, 1.4); lbl("~6\"", 5, -1.7, 1.4); lbl("2\"", 39, -1.7, 1.4);
}

// ---- VIGNETTE 2 — shelf-into-side reference joint (3/4, R3) ----
translate([2, 33]) {
    lbl("2 — SHELF INTO A SIDE PANEL (3/4\", R3)", 0, 5.4, 1.8, "left");
    ply(0.75, 4);                                               // side panel edge
    translate([0.75, 1.6]) ply(14, 0.75);                       // shelf, plan
    // 3 biscuits along the shelf end (in the 0.75" thickness), at 2/7/12" from the front
    for (yy = [2, 7, 12]) color(BISC) translate([0.75, yy]) resize([0.4, 1.2]) circle(r = 1, $fn = 20);
    color(INK) translate([0.75, -0.6]) square([14, stroke]);
    for (yy = [2, 7, 12]) tick(0.75 + yy, -0.6);
    lbl("2\"", 0.75 + 2, -1.5, 1.4); lbl("7\"", 0.75 + 7, -1.5, 1.4); lbl("12\"", 0.75 + 12, -1.5, 1.4);
}

// ---- VIGNETTE 3 — box corner (1/2, R1) ----
translate([2, 22]) {
    lbl("3 — BOX CORNERS (1/2\", R1)", 0, 6.2, 1.8, "left");
    ply(8, 0.5);                                                // front wall
    ply(0.5, 5);                                                // side wall
    for (zz = [1.5, 4]) color(BISC) translate([0.25, zz]) resize([0.35, 1.1]) circle(r = 1, $fn = 20);
    tick(-0.7, 1.5); tick(-0.7, 4); color(INK) translate([-0.7, 1.5]) square([stroke, 2.5]);
    lbl("1.5\"", -1.4, 1.5, 1.4); lbl("4\"", -1.4, 4, 1.4);
}

// ---- VIGNETTE 4 — 2x2 frame corner (SCREWS) ----
translate([2, 12]) {
    lbl("4 — 2x2 FRAMES: SCREWS ONLY", 0, 5.6, 1.8, "left");
    // no coplanar ink outline here either — see the ply() note above
    color("Gray") square([9, 1.5]); color("Gray") square([1.5, 4.5]);
    color("DimGray") translate([1.5, 1.5]) difference() { square([2, 2]); translate([0.35, 0.35]) square([1.65, 1.65]); }
    screwmark(2.4, 0.75); screwmark(3.6, 0.75); screwmark(0.75, 2.4); screwmark(2.5, 2.5);
    lbl("2x 2\" screws + glue + bracket", 10.5, 2.2, 1.4, "left");
}

// ---- VIGNETTE 5 — ply to frame (SCREWS) ----
translate([2, 0]) {
    lbl("5 — PLY TO FRAME: SCREWS + glue", 0, 3.9, 1.8, "left");
    color("Gray") square([14, 1.2]);
    translate([0, 1.2]) ply(14, 0.75);
    for (x = [2, 6, 10, 14 - 2]) screwmark(x, 1.95);
    tick(2, 0.4); tick(6, 0.4); color(INK) translate([2, 0.4]) square([4, stroke]); lbl("~8\" o.c.", 4, -1.4, 1.4);
    lbl("1-1/4\" screws ~8\" o.c. + glue", 16, 1.5, 1.4, "left");
}

// The METHOD TABLE that used to sit here is markdown now (Section 3,
// "Joinery & Fasteners"). Its third column ran to ~85 units, which set
// this sheet's whole width and drove every label on it to ~4.6pt on the
// page — a figure's printed text height is size x (page_width /
// sheet_width). Vignette headings went the same way: what is left on the
// sheet is a short name per vignette plus its dimension callouts.
