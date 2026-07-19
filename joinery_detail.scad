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
module bisc(x, z, lx = 0.5, lz = 1.4) { color(BISC) translate([x, z]) resize([lx, lz]) circle(r = 1, $fn = 20); }
module screwmark(x, z, r = 0.28) { color(SCRW) translate([x, z]) { circle(r = r, $fn = 16); color("white") { translate([-r*0.7, 0]) square([r*1.4, 0.08], center = true); translate([0, -r*0.7]) square([0.08, r*1.4], center = true); } } }
module tick(x, y) { color(INK) translate([x, y]) square([stroke*2, 0.6], center = true); }

// ---- TITLE ----
lbl("JOINERY & FASTENERS — Ryobi DBJ50 detail biscuit joiner (R1 / R2 / R3 biscuits)", 30, 47, 1.7);
lbl("Legend:  Peru ovals = biscuit slots (glue + biscuit, centered on thickness)     Crimson = screws (+ glue)     Grey = 2x2 frame", 30, 44.6, 1.0);

// ---- VIGNETTE 1 — spacing rule ----
translate([2, 38]) {
    lbl("1 — SPACING RULE (any biscuited joint, edge-on): 2\" from each end, then ~6\" o.c., centered on thickness", 0, 3.2, 1.05, "left");
    color("BurlyWood") square([40, 1.5]); rr(40, 1.5);
    for (x = [2, 8, 14, 20, 26, 32, 38]) bisc(x, 0.75);
    tick(0, -0.8); tick(2, -0.8); tick(8, -0.8); tick(38, -0.8); tick(40, -0.8);
    color(INK) translate([0, -0.8]) square([40, stroke]);
    lbl("2\"", 1, -1.7, 0.8); lbl("~6\"", 5, -1.7, 0.8); lbl("2\"", 39, -1.7, 0.8);
}

// ---- VIGNETTE 2 — shelf-into-side reference joint (3/4, R3) ----
translate([2, 30]) {
    lbl("2 — REFERENCE: any shelf into a side panel (3/4\" ply): 3x R3 biscuits/end at 2\" / 7\" / 12\" from the front, centered on 3/4\", glue + clamp", 0, 3.4, 1.05, "left");
    color("BurlyWood") square([0.75, 4]); rr(0.75, 4);          // side panel edge
    color("BurlyWood") translate([0.75, 1.6]) square([14, 0.75]); translate([0.75, 1.6]) rr(14, 0.75); // shelf, plan
    // 3 biscuits along the shelf end (in the 0.75" thickness), at 2/7/12" from the front
    for (yy = [2, 7, 12]) color(BISC) translate([0.75, yy]) resize([0.4, 1.2]) circle(r = 1, $fn = 20);
    color(INK) translate([0.75, -0.6]) square([14, stroke]);
    for (yy = [2, 7, 12]) tick(0.75 + yy, -0.6);
    lbl("2\"", 0.75 + 2, -1.5, 0.8); lbl("7\"", 0.75 + 7, -1.5, 0.8); lbl("12\"", 0.75 + 12, -1.5, 0.8);
}

// ---- VIGNETTE 3 — box corner (1/2, R1) ----
translate([2, 22]) {
    lbl("3 — BOX CORNERS (1/2\" ply -> R1): 2x R1 biscuits/corner + glue, all 4 corners — Panel A drawer, kitchen drawer, fridge-tray apron", 0, 4, 1.05, "left");
    color("BurlyWood") square([8, 0.5]); rr(8, 0.5);            // front wall
    color("BurlyWood") square([0.5, 5]); rr(0.5, 5);            // side wall
    for (zz = [1.5, 4]) color(BISC) translate([0.25, zz]) resize([0.35, 1.1]) circle(r = 1, $fn = 20);
    tick(-0.7, 1.5); tick(-0.7, 4); color(INK) translate([-0.7, 1.5]) square([stroke, 2.5]);
    lbl("1.5\"", -1.4, 1.5, 0.8); lbl("4\"", -1.4, 4, 0.8);
    lbl("bottom sits in a glued rabbet (or glue + brads) — clean box, no visible fasteners", 9.5, 2.5, 0.9, "left");
}

// ---- VIGNETTE 4 — 2x2 frame corner (SCREWS) ----
translate([2, 14]) {
    lbl("4 — FRAMES (2x2 pine, rail/leg/bottom-rail/divider): SCREWS ONLY — a biscuit would blow out the 1.5\" stock", 0, 4, 1.05, "left");
    color("Gray") square([9, 1.5]); color("Gray") square([1.5, 4.5]);
    color(INK) { rr(9, 1.5); rr(1.5, 4.5); }
    color("DimGray") translate([1.5, 1.5]) difference() { square([2, 2]); translate([0.35, 0.35]) square([1.65, 1.65]); }
    screwmark(2.4, 0.75); screwmark(3.6, 0.75); screwmark(0.75, 2.4); screwmark(2.5, 2.5);
    lbl("2x 2\" screws + glue per corner + a steel corner bracket (diagonal corner braces screw on top of the frame)", 10.5, 2.2, 0.9, "left");
}

// ---- VIGNETTE 5 — ply to frame (SCREWS) ----
translate([2, 7]) {
    lbl("5 — PLY TO FRAME (Panel C top / front wall / cleats / cheeks): SCREWS + glue", 0, 3.4, 1.05, "left");
    color("Gray") square([14, 1.2]); color(INK) rr(14, 1.2);
    color("BurlyWood") translate([0, 1.2]) square([14, 0.75]); color(INK) translate([0, 1.2]) rr(14, 0.75);
    for (x = [2, 6, 10, 14 - 2]) screwmark(x, 1.95);
    tick(2, 0.4); tick(6, 0.4); color(INK) translate([2, 0.4]) square([4, stroke]); lbl("~8\" o.c.", 4, -0.3, 0.8);
    lbl("1-1/4\" screws ~8\" o.c. into the rail + glue (front wall: 8 screws per the Front Wall render; cheeks/cleats: 2\" screws ~6\")", 16, 1.5, 0.9, "left");
}

// ---- METHOD TABLE ----
translate([2, -1]) {
    rows = [
        ["COMPONENT", "JOINT", "METHOD (biscuit sizes are Ryobi R1/R2/R3)"],
                ["Panel A drawer + kitchen drawer boxes (1/2)", "box corners", "2x R1 biscuits/corner + glue; bottom in a glued rabbet"],
        ["Fridge tray + slide apron (1/2 + pine)", "edge / face", "R1 biscuits OR 1-1/4\" screws + glue"],
        ["Kitchen-drawer hanging cheeks <-> deck (3/4)", "face-to-face", "2\" screws every ~6\" up into the deck"],
        ["WAVE 3 overhead shelf <-> 1x1 cleats", "shelf-on-cleat", "cleats screwed to the frame; shelf screws down to the cleats"],
        ["Panel C fixed top <-> 2x2 rails", "ply-to-frame", "1-1/4\" screws every ~8\" + glue (R2 optional, corners, to align)"],
        ["Panel C front wall <-> frame", "ply-to-frame", "8x #8 x 1-1/4\" screws (exact positions in the Front Wall render)"],
        ["ALL 2x2 frames (rails/legs/bottom rails/dividers)", "2x2 corners", "2x 2\" screws + glue + a steel corner bracket (NO biscuit)"],
        ["Bed platform slats <-> 1x4 side rails", "end-to-edge", "2x 1-1/4\" pocket screws/end (OR 1x R2 biscuit + glue, cleaner)"],
        ["DELTA 3 tray / cabinet bins / adjustable shelf", "none", "drop in / rest on pins — no fasteners"],
    ];
    for (i = [0 : len(rows) - 1]) {
        y = -i * 1.6; b = (i == 0);
        lbl(rows[i][0], 0, y, 0.92, "left");
        lbl(rows[i][1], 30, y, 0.92, "left");
        lbl(rows[i][2], 40, y, 0.92, "left");
        if (i == 0) color(INK) translate([0, y - 0.95]) square([70, stroke*2]);
    }
}
