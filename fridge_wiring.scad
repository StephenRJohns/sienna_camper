// ============================================================
// Fridge system wiring diagram — schematic, NOT to physical scale
// ============================================================
// Block diagram of how the fridge, its 2 cooling fans, the NTC temp
// sensor are powered and connected — down to EVERY physical wire
// landing: each numbered connection point (P1-P12) names the exact
// terminal, connector type, and crimp/fastener used, and the side
// table lists them all in order. Pairs with
// fridge_install_detail.scad (where) and rear_view.scad (elevation)
// — this file answers how the electrical side connects.
//
// The fridge (and its fan/cooling system) runs off the EcoFlow
// DELTA 3 stack instead of the Sienna's rear 12V accessory outlet —
// see Section 1's "Why the fridge runs off the DELTA 3 stack" note.
// The DELTA 3 itself gets AC-charged from the front console's
// confirmed 1500W outlet while driving (a near-exact match for the
// DELTA 3 Plus's own 1500W max AC input — full charge in ~56 min),
// so it stays topped off between drives without relying on the van's
// ignition state at all.
//
// ONE 16AWG SAE line runs from the DELTA 3 (Panel A's drawer)
// through both seams into Panel C's open utility bay and lands on the Nilight
// 6-way fuse block's main studs; BOTH circuits branch from there:
//   F1 (10A) -> SW1 -> 12V socket pigtail -> the fridge's own cord.
//   F2 (3A)  -> SW2 -> W1209 controller -> both 120mm fans in
//   parallel (WAGO splits), NTC probe on the W1209's probe header.
// Every black (-) return lands on the same block's negative bus.
// The CO detector is intentionally NOT on either circuit — standard
// RV propane/CO detectors are self-contained, battery-powered units,
// not an omission.
//
// Box widths are sized by hand to each box's own longest line (text
// at size s runs roughly 0.6*s per character) — keep that rule when
// editing, or labels overflow their boxes.
//
// Render with: openscad -o renders/fridge-wiring.svg fridge_wiring.scad
// ============================================================
// LEGIBILITY (Aug 2026): 7 prose line(s) moved out of this
// sheet into the document, and every text size scaled x2.4. Those
// sentences were setting the sheet's width, and a figure's printed
// text height is size x (page_width / sheet_width) — so they were
// holding every other label on the sheet down to 3-6pt on paper.
// Keep prose in the markdown; this sheet carries geometry and short
// labels only.

module label(txt, x, y, size = 1.95) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "center", valign = "center");
}

module label_left(txt, x, y, size = 1.85) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "left", valign = "center");
}

// box with an arbitrary number of stacked lines: lines = [[text, size], ...]
module box(x, y, w, h, lines, col = "black") {
    translate([x - w/2, y - h/2]) {
        color(col)
        difference() {
            square([w, h]);
            translate([0.15, 0.15]) square([w - 0.3, h - 0.3]);
        }
    }
    n = len(lines);
    line_h = h / (n + 1);
    for (i = [0 : n - 1])
        label(lines[i][0], x, y + h/2 - line_h * (i + 1), lines[i][1]);
}

module wire(x0, y0, x1, y1, col = "black") {
    color(col)
    hull() {
        translate([x0, y0]) circle(r = 0.12);
        translate([x1, y1]) circle(r = 0.12);
    }
    color(col)
    translate([x1, y1])
        rotate([0, 0, atan2(y1 - y0, x1 - x0) - 90])
            polygon([[-0.6, 0], [0.6, 0], [0, -1.2]]);
}

module signal_wire(x0, y0, x1, y1, col = "DarkGray") {
    len = sqrt((x1 - x0) * (x1 - x0) + (y1 - y0) * (y1 - y0));
    n = max(3, round(len / 1.2));
    for (i = [0 : n - 1])
        if (i % 2 == 0) {
            t0 = i / n; t1 = min(1, (i + 0.6) / n);
            color(col)
            hull() {
                translate([x0 + (x1 - x0) * t0, y0 + (y1 - y0) * t0]) circle(r = 0.1);
                translate([x0 + (x1 - x0) * t1, y0 + (y1 - y0) * t1]) circle(r = 0.1);
            }
        }
}

// numbered connection-point marker — pairs with the side table
module pmark(n, x, y) {
    translate([x, y]) {
        // no filled badge: circle + numeral touch and merge to one colour
        color("DarkSlateBlue") text(str("P", n), size = 2.28, halign = "center", valign = "center");
    }
}

module drawing() {
    label("Fridge System Wiring — every connection point (P1-P12), schematic, not to physical scale", 8, 58, 1.8);

    // ---- AC charge source: front console outlet, charges the DELTA 3 ----
    box(-14, 53, 41, 4.5, [
        ["Front console AC outlet — 1500W", 1.3],
    ], "Gray");

    wire(-14, 50.7, -14, 47.8);

    // ---- DELTA 3 stack: the ONE source for both circuits below ----
    box(-14, 44, 40, 6.5, [
        ["EcoFlow DELTA 3 Plus + Smart Extra Battery", 1.3],
    ], "SteelBlue");
    // MOVED TO THE DOCUMENT: label("Charge + discharge simultaneously supported — running the fridge/fans", -14, 39.6, 0.85);
    // MOVED TO THE DOCUMENT: label("while AC-charging is normal, just slows the charge rate a bit", -14, 38.6, 0.85);

    // ---- ONE 16AWG SAE line, DELTA 3 -> fuse block, 4 hops ----
    wire(-14, 38, -14, 36.9);
    pmark(1, -38.0, 34.8);
    box(-14, 34.8, 36, 3.8, [
        ["Male car-plug -> SAE adapter, FUSED 15A", 1.05],
    ]);

    wire(-14, 32.9, -14, 31.7);
    pmark(2, -38.0, 29.8);
    box(-14, 29.8, 36, 3.6, [
        ["SAE quick-disconnect #1 — Panel A/B seam", 1.0],
    ]);

    wire(-14, 28, -14, 26.8);
    pmark(3, -38.0, 24.9);
    box(-14, 24.9, 36, 3.6, [
        ["SAE quick-disconnect #2 — Panel B/C seam", 1.0],
    ]);

    wire(-14, 23.1, -14, 21.9);
    pmark(4, -38.0, 20);
    box(-14, 20, 36, 3.6, [
        ["1\" grommet — Panel C front wall, LOW driver side", 1.0],
    ]);

    wire(-14, 18.2, -14, 16.6);
    pmark(5, -39.0, 12.5);
    box(-14, 12.5, 38, 7.5, [
        ["Nilight 6-way fuse block + NEG bus — in the open utility bay", 1.1],
    ]);

    // ---- fridge branch: F1 -> SW1 -> socket pigtail -> fridge ----
    wire(5, 13.5, 11, 13.5);
    label("F1 out", 8, 15.3, 0.7);
    label("16AWG red", 8, 14.3, 0.7);
    pmark(6, 38.5, 15.5);
    box(26, 13.2, 30, 4.6, [
        ["SW1 \"FRIDGE\" — Ampper rocker, 3 spade tabs", 1.0],
    ]);

    wire(26, 10.9, 26, 9.4);
    pmark(7, 38.5, 7.5);
    box(26, 7.5, 30, 3.6, [
        ["SAE -> female 12V socket pigtail", 1.0],
    ]);

    wire(26, 5.7, 26, 4.4);
    pmark(8, 38.5, 2.2);
    box(26, 2.2, 30, 4.4, [
        ["BougeRV Rocky 40 — DC INPUT jack", 1.05],
    ]);

    // SW3 note: the BOM's third switch
    box(26, 19.5, 30, 3.6, [
        ["SW3 — spare switch (unused)", 0.8],
    ], "Gray");

    // ---- fan branch: F2 -> SW2 -> W1209 -> WAGO splits -> 2 fans ----
    wire(-14, 8.7, -14, 7.3);
    label("F2 out, 18AWG red", -7.5, 8, 0.75);
    pmark(9, -38.0, 5);
    box(-14, 5, 36, 4.4, [
        ["SW2 \"FANS\" — Ampper rocker, 3 spade tabs", 1.0],
    ]);

    wire(-14, 2.8, -14, 1.4);
    pmark(10, -39.1, -0.6);
    box(-14, -2.5, 38, 7, [
        ["W1209 controller — 4 SCREW terminals + probe header", 1.05],
    ]);

    // NTC sensor feeds the controller — signal, not power
    pmark(11, -56.5, -2.2);
    box(-44, -2.2, 14, 5.4, [
        ["NTC probe", 1.1],
    ], "DarkGray");
    signal_wire(-37, -3.6, -33, -3.6);

    wire(-14, -6, -14, -7.6);
    pmark(12, -38.0, -9.8);
    box(-14, -9.8, 36, 4.2, [
        ["WAGO 221-413 lever nuts (x2)", 1.0],
    ]);

    wire(-14, -11.9, -25, -14.6, "Gray");
    wire(-14, -11.9, -3, -14.6, "DimGray");
    box(-25, -16.8, 19, 4, [
        ["Intake fan (120mm)", 1.2],
    ], "DimGray");
    box(-3, -16.8, 19, 4, [
        ["Exhaust fan (120mm)", 1.2],
    ], "Gray");

    // MOVED TO THE DOCUMENT: label("Circuit 1 (right): fridge — F1 10A, switched at SW1. Circuit 2 (left): fans — F2 3A, switched at SW2, W1209-driven off the NTC probe.", -3, -20.5, 1.0);

    // legend
    leg_x = -52; leg_y = -23.5;
    color("black") translate([leg_x, leg_y + 0.15]) square([2, 0.3]);
    label_left("solid line = 12V power", leg_x + 3, leg_y, 1.0);
    for (i = [0:2])
        color("DarkGray") translate([leg_x + i * 0.9, leg_y - 2 + 0.15]) square([0.5, 0.3]);
    label_left("dashed line = sensor signal, not power", leg_x + 3, leg_y - 2, 1.0);

    // ---- side table: every connection point, in install order ----
    tx = 48;
    // MOVED TO THE DOCUMENT: label_left("CONNECTION POINTS — every wire landing, in install order", tx, 54, 1.25);
    rows = [
        ["P1", "DELTA 3 12V car-power outlet -> fused (15A) car-plug/SAE adapter — hand-plug, no tools"],
        ["P2", "SAE #1 at the A/B seam — mate the OYMSAE cord ends; zip-tie a strain loop each side"],
        ["P3", "SAE #2 at the B/C seam — same; both disconnects hang slack, never taut"],
        ["P4", "1\" grommet, Panel C front wall (low, driver side) — push cord through, no termination"],
        ["P5", "Fuse block main studs: red -> +IN, black -> -IN — #10 ring terminals, M5 nuts, 20 in-lb"],
        ["P6", "SW1 FRIDGE: F1(10A) red -> PWR spade; LOAD spade -> pigtail red; GND spade -> NEG bus"],
        ["P7", "Pigtail: SAE mates to SW1 side; female 12V socket zip-tied by the fridge's kitchen wall"],
        ["P8", "Fridge DC jack: fridge's own cord plug -> socket; slack loop to the FIXED rail, 3 clips"],
        ["P9", "SW2 FANS: F2(3A) red -> PWR spade; LOAD spade -> W1209 +12V; GND spade -> NEG bus"],
        ["P10", "W1209 screws: +12V, GND, K0 (jumper from +12V), K1 (fan feed) — strip 1/4\", snug screws"],
        ["P11", "NTC probe: plug on the W1209 header; TIP zip-tied at the kitchen-facing wall by the exhaust fan"],
        ["P12", "WAGO 221 x2: K1 -> both fan reds; fan blacks -> one black -> NEG bus — levers fully closed"],
    ];
    // The right-hand P1-P12 column is GONE: it was only ever there to carry
    // the descriptions, which are a markdown table now (Section 5). The
    // P-numbers beside the boxes already key to it.
    // MOVED TO THE DOCUMENT: label_left("Wire spec: main run 16AWG (the OYMSAE SAE cord itself); in-bay branches 18AWG red/black;", tx, 51 - 12*4 + 0.5, 0.9);
    // MOVED TO THE DOCUMENT: label_left("crimps: heat-shrink ring #10 (block studs) + 0.25\" female spades (switch tabs). Crimp, tug-test, then shrink.", tx, 51 - 12*4 - 1, 0.9);
}

// NOTE: no outer color("black") wrapper — every box()/wire()/label()
// call already self-colors (see top_view.scad/rear_view.scad for why
// a nested color() can't override an outer one in this pipeline).
drawing();
