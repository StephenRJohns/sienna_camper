// ============================================================
// Anchor board — ACCESSORY INSTALL MAP (A-G) + BUILD ORDER (2D)
// ============================================================
// The banner (renders/steps/comp-11-header) lists accessories A-G as
// isolated icons, which says WHAT to buy but not WHERE any of it goes.
// This sheet closes that gap:
//
//   LEFT   the one-piece board in plan, with every accessory drawn in
//          its real position and ballooned with its banner letter.
//   RIGHT  one row per letter: what it is, where it goes, how it
//          fastens, and how many.
//   BELOW  the 7-step build order, split into BENCH work (steps 1-6,
//          done on sawhorses) and IN-VAN work (step 7).
//
// The board itself is ONE comb-shaped piece of 3/4" ply (46"x33", no
// wood joints — see the assembly sheet's V1/V5). Every fastener on
// this sheet therefore holds HARDWARE to the ply, never ply to ply.
//
// Positions are ASSUMED until the Section 0 F1-F8 floor survey.
//
// Render with: openscad -o renders/anchor-board-install.svg anchor_board_install.scad
// ============================================================

include <params.scad>
include <colors.scad>

stroke = 0.22;

// ---- shared line-art helpers (same style as anchor_board_assembly) --
module label(txt, x, y, size = 1.2) {
    color("black") translate([x, y]) text(txt, size = size, halign = "center", valign = "center");
}

module label_left(txt, x, y, size = 1.05) {
    color("black") translate([x, y]) text(txt, size = size, halign = "left", valign = "center");
}

// the board draws as a single outline: one piece, so no butt lines
module board_poly(pts) {
    xs = [for (p = pts) p[0]];  ys = [for (p = pts) p[1]];
    x0 = min(xs); y0 = min(ys); w = max(xs) - x0; l = max(ys) - y0;
    color("Peru") difference() {
        polygon(pts);
        offset(delta = -0.15) polygon(pts);
    }
    color("Tan") intersection() {
        offset(delta = -0.3) polygon(pts);
        union() {
            for (d = [2 : 4 : w + l])
                translate([x0, y0 + d]) rotate(-45) square([(w + l) * 1.5, 0.08]);
        }
    }
}

module dring_icon(x, y) {
    color("Black") translate([x, y]) difference() { circle(r = 0.55, $fn = 28); circle(r = 0.3, $fn = 20); }
}

module bolt_dot(x, y, r = 0.28) {
    color("Black") translate([x, y]) circle(r = r, $fn = 18);
}

module dash_v(x, y0, y1, w = 0.15) {
    for (dy = [0 : 1.6 : y1 - y0 - 0.8]) color("Gray") translate([x, y0 + dy]) square([w, 0.8]);
}

// lettered balloon + leader line back to what it points at. Drawn as
// an OPEN ring (like the D-ring icon) rather than a white-filled disc:
// a white fill over the hatch doesn't survive the 2D export, and the
// leader is trimmed to the ring's edge so it never crosses the letter.
module balloon(letter, bx, by, tx, ty) {
    d = [tx - bx, ty - by];
    len = max(norm(d), 0.001);
    u = [d[0]/len, d[1]/len];
    r = 1.45;
    color("Black") hull() {                          // leader: ring edge -> target
        translate([bx + u[0]*r, by + u[1]*r]) circle(r = 0.11, $fn = 12);
        translate([tx, ty]) circle(r = 0.11, $fn = 12);
    }
    color("Black") difference() {                    // the ring itself
        translate([bx, by]) circle(r = r, $fn = 36);
        translate([bx, by]) circle(r = r - 0.26, $fn = 36);
    }
    color("Black") translate([bx, by]) text(letter, size = 1.6, halign = "center", valign = "center");
}

// ============================================================
// LEFT — the board in plan, every accessory in its real position
// ============================================================
module install_map() {
    ds_w = 2.5;   cs_x0 = 19.35; cs_w = 4.65; rs_x0 = 44.5; rs_w = 1.5;
    y0 = 2;  br_y0 = 29;  br_d = aboard_bridge_d;   // strips Y 2-29, bridge Y 29-35
    br_top = br_y0 + br_d;

    // ---- the one-piece comb ----
    comb = [[0, y0], [ds_w, y0], [ds_w, br_y0],
            [cs_x0, br_y0], [cs_x0, y0], [cs_x0 + cs_w, y0],
            [cs_x0 + cs_w, br_y0], [rs_x0, br_y0], [rs_x0, y0],
            [rs_x0 + rs_w, y0], [panel_width, br_top], [0, br_top]];
    board_poly(comb);

    // ---- E: rubber mat, cut to the board's own outline and laid under
    // it — a thin gray band FOLLOWING the comb, so the comb shape still
    // reads (a rectangle here would make the board look like a pan) ----
    color("DarkGray") difference() {
        offset(delta = 0.5) polygon(comb);
        polygon(comb);
    }

    // ---- riser-angle footprints + their bolt patterns (D, F) ----
    for (rx = [0.15, 19.85]) {
        dash_v(rx, 3, 27); dash_v(rx + 2, 3, 27);
        for (by = [5, 12, 19, 26]) bolt_dot(rx + 1, by);
    }

    // ---- A: L-track on the two kitchen-side strips, with B in its slots ----
    for (lx = [23, 44.75]) {
        color("DimGray") difference() {
            translate([lx, 3.5]) square([1, 23]);
            translate([lx + 0.12, 3.62]) square([0.76, 22.76]);
        }
        for (dy = [5 : 3 : 25]) bolt_dot(lx + 0.5, dy, 0.16);
    }
    dring_icon(23.5, 6); dring_icon(23.5, 24); dring_icon(45.25, 6); dring_icon(45.25, 24);

    // ---- B: the bridge's 3 striker-strap D-rings ----
    for (sx = [8, 23, 38]) dring_icon(sx, 32);

    // ---- steel tongues under the bridge, running forward (G at their tips) ----
    for (tx = [15, 30]) {
        dash_v(tx - 1, br_y0 + 0.3, br_top - 0.3); dash_v(tx + 0.85, br_y0 + 0.3, br_top - 0.3);
        color("DimGray") difference() {
            translate([tx - 1, br_top]) square([2, 6]);
            translate([tx - 0.85, br_top]) square([1.7, 5.85]);
        }
        bolt_dot(tx, br_y0 + 1.5); bolt_dot(tx, br_y0 + 4.5);   // D: T-nut bolts up into the bridge
        bolt_dot(tx, br_top + 4.6, 0.34);                        // G: the rail-end bolt
    }
    // kept above the straps' arrowheads so nothing crosses the red lines
    label_left("2 STEEL TONGUES -> the 2nd-row FLOOR RAILS' rear ends (F8)", 17, br_top + 13.2, 0.95);

    // ---- C: the 3 striker straps leaving the bridge D-rings ----
    color("Firebrick") for (sx = [8, 38]) {
        hull() { translate([sx, 32.6]) circle(r = 0.22, $fn = 16); translate([sx, br_top + 8]) circle(r = 0.22, $fn = 16); }
        translate([sx, br_top + 8]) polygon([[0, 1.5], [-0.85, 0], [0.85, 0]]);
    }
    color("Firebrick") translate([2, br_top + 11.4]) text("3 RATCHET STRAPS -> 3rd-row STRIKER LOOPS (crash-rated, F4)", size = 0.95);

    // ---- balloons: banner letter -> real position ----
    balloon("A", 50.6, 15, 45.6, 15);         // L-track
    balloon("B", 50.6, 32, 39, 32);           // stud D-ring (bridge)
    balloon("C", 43.5, br_top + 7.5, 38.4, br_top + 6);  // ratchet strap
    balloon("D", -4.6, 12, 0.9, 12);          // bolt into T-nut
    balloon("E", -4.6, 25, -0.5, 26);         // rubber mat
    balloon("F", -4.6, 19, 0.9, 19);          // threadlocker, on every machine screw
    balloon("G", 11, br_top + 6.6, 14.7, br_top + 4.9);  // rail-end bolt

    // ---- orientation ----
    label_left("fwd ->", -8.5, br_top + 1, 1.0);
    label_left("tailgate ->", -10.5, 4, 1.0);
    label("ONE-PIECE 3/4\" PLY BOARD, 46\" x 33\" — see the assembly sheet V1 for dimensions, V5 for the cut", panel_width/2, y0 - 3.2, 1.05);
}

// ============================================================
// RIGHT — one row per letter: what / where / how / how many
// ============================================================
module accessory_table() {
    rows = [
        ["A", "L-TRACK, CUT DOWN  (x2)",
              "Bolted flat onto the two KITCHEN-SIDE strips: the center strip's kitchen face",
              "(X=23) and the 1.5\" panel-edge strip (X=44.75), ~23\" each. 7 bolts per length,",
              "~3\" apart, down into T-nuts. Cut the 48\" stock down first; deburr the slots."],
        ["B", "STUD FITTING w/ D-RING  (x7)",
              "No fasteners — each one DROPS INTO an L-track slot and twist-locks. 4 go in the",
              "kitchen L-track (2 per side, at Y=6 and Y=24) as the kitchen strap corners; 3 go",
              "on the BRIDGE (X=8, 23, 38) as the striker-strap points.", ""],
        ["C", "RATCHET STRAP, 400lb WLL  (x7)",
              "Never fastened to the board — they hook to B's D-rings. 4 criss-cross OVER the",
              "kitchen unit into its 4 L-track D-rings; 3 run forward from the bridge D-rings",
              "into the van's 3rd-row striker loops. Tension last; re-tension after 1 drive.", ""],
        ["D", "1/4-20 BOLT + T-NUT  (~30 pairs, incl. spares)",
              "The T-nut goes in the board's UNDERSIDE, counterbored FLUSH so the board still",
              "lies flat on its mat; the bolt comes down from ABOVE through whatever it holds:",
              "riser flanges (4 each = 8), L-track (7 each = 14), steel tongues (2 each = 4).",
              "Seat every T-nut BEFORE any hardware goes on — you cannot reach them afterward."],
        ["E", "NON-SLIP RUBBER MAT  (x1)",
              "Cut to the board's outline and laid UNDER it — friction, trim protection and",
              "rattle control. Not fastened to anything. It goes in only when the finished",
              "board is set into the van (step 7), not on the bench.", ""],
        ["F", "THREADLOCKER, blue 242  (x1)",
              "One drop on every machine screw as you fit it — that is the A, D and G",
              "fasteners (B needs none, it twist-locks). They all end up hidden under the",
              "appliances, so they must never need re-checking. Cure ~24h before loading.", ""],
        ["G", "RAIL-END BOLT  (x2)",
              "IN-VAN only: through the forward end of each steel tongue into the floor rail's",
              "EXISTING end hardware — no new holes in the vehicle. Drill/bend the tongue ends",
              "to match what the F8 survey actually finds. Fallback if the rails don't reach:",
              "butt the tongues against the striker-row floor step (F7) instead."],
    ];
    y = 0;
    for (i = [0 : len(rows) - 1]) {
        r = rows[i];
        // running y: each row is 1 heading line + up to 4 body lines
        ry = -i * 8.2;
        color("Black") translate([0, ry]) circle(r = 1.45, $fn = 32);
        color("White") translate([0, ry]) text(r[0], size = 1.7, halign = "center", valign = "center");
        label_left(r[1], 2.6, ry, 1.15);
        for (k = [2 : 5])
            if (r[k] != "") label_left(r[k], 2.6, ry - 1.55 - (k - 2) * 1.45, 1.0);
    }
}

// ============================================================
// BELOW — the build order: what happens on the bench vs in the van
// ============================================================
module build_order() {
    label_left("BUILD ORDER — steps 1-6 on the bench, step 7 in the van", 0, 0, 1.3);
    steps = [
        "1.  CUT the comb as ONE piece from the 3/4\" sheet's spare — grain along the strips, ~1/2\" fillet at every inside corner (assembly sheet V5).",
        "2.  D  Mark and drill every bolt hole, then counterbore the UNDERSIDE and seat all ~30 T-NUTS flush. Do this before anything is in the way.",
        "3.  D  Bolt the 2 STEEL RISER ANGLES onto the rail-line strips (4 bolts each) — the fridge's fixed slide rails land on these.",
        "4.  A + D  Bolt the two cut-down L-TRACK lengths onto the kitchen-side strips (8 bolts each).",
        "5.  D  Bolt the 2 STEEL TONGUES into the dado in the bridge's UNDERSIDE (2 bolts each). Leave their forward ends unfixed until step 7.",
        "6.  B + F  Drop the 7 STUD D-RINGS into their slots. Threadlocker on every machine screw as it goes in; let it cure ~24h before loading.",
        "7.  E + G + C  IN THE VAN: lay the MAT, set the board on it, bolt the tongue ends to the floor rails (G), notch Panel B's rear bottom rail",
        "     where the tongues and straps pass under it, then hook and TENSION the straps (C) — 3 to the striker loops, 4 over the kitchen unit.",
    ];
    for (i = [0 : len(steps) - 1]) label_left(steps[i], 0, -2.8 - i * 1.85, 1.05);
    label_left("Nothing in this sequence joins plywood to plywood — the board arrives at step 2 already whole.", 0, -2.8 - len(steps) * 1.85 - 0.9, 1.05);
}

// ============================================================
// sheet layout
// ============================================================
// Two columns so nothing collides and the text stays legible: the map
// with the build order under it on the left, the A-G rows on the right.
install_map();
translate([62, 48]) accessory_table();
translate([0, -14]) build_order();
label("ANCHOR BOARD — ACCESSORY INSTALL MAP (A-G) + BUILD ORDER (Section 8)", 52, 55, 1.7);
label("Every letter matches the ACCESSORY LIST on the anchor-board banner. The board is ONE piece of ply:", 52, 52.4, 1.05);
label("every fastener below holds HARDWARE to it, never ply to ply.", 52, 51, 1.05);
