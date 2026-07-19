// ============================================================
// Fridge system wiring diagram — schematic, NOT to physical scale
// ============================================================
// Block diagram of how the fridge, its 2 cooling fans, the NTC temp
// sensor are powered and connected. Pairs with
// fridge_install_detail.scad (where) and rear_view.scad (elevation)
// — this file answers how the electrical side connects.
//
// The fridge (and its fan/cooling system) now runs off the EcoFlow
// DELTA 3 stack instead of the Sienna's rear 12V accessory outlet —
// see Section 1's "Why the fridge runs off the DELTA 3 stack" note.
// The DELTA 3 itself gets AC-charged from the front console's
// confirmed 1500W outlet while driving (a near-exact match for the
// DELTA 3 Plus's own 1500W max AC input — full charge in ~56 min),
// so it stays topped off between drives without relying on the van's
// ignition state at all. Both circuits below moved off the rear
// outlet onto the DELTA 3, not just the fridge — the fans exist to
// vent the fridge's compressor heat, so they need to keep running
// under the same conditions the fridge does (e.g., parked with people
// away from the vehicle), which only works if they're on the same
// always-available source as the fridge itself.
//
//   1. Fridge — DC line from the DELTA 3's output (Panel A's drawer),
//      routed through Panel B into Panel C (2 quick-disconnects at
//      the Panel A/B and B/C seams — Section 5). The Rocky 40's
//      built-in dual 12/24V DC + AC power supply needs no inverter
//      and no fusing beyond what's already inside the unit.
//   2. Fan system — a second tap off the same DELTA 3 output, through
//      a fuse/surge protector and a manual ON/OFF switch, into the
//      PWM temperature controller, which reads the NTC sensor
//      (mounted in the fridge bay) and drives both 120mm fans in
//      parallel.
// The CO detector is intentionally NOT on either circuit — standard
// RV propane/CO detectors are self-contained, battery-powered units,
// shown here as a disconnected box for that reason, not an omission.
//
// Box widths are sized by hand to each box's own longest line (text
// at size s runs roughly 0.6*s per character) — the first draft of
// this file used one-size-fits-all box widths and nearly every label
// overflowed its own box. Multi-line text + generous per-box widths
// fixes that; vertical row spacing is also widened throughout so no
// box's text touches the row above/below it.
//
// Render with: openscad -o renders/fridge-wiring.svg fridge_wiring.scad
// ============================================================

module label(txt, x, y, size = 1.3) {
    color("black")
    translate([x, y]) text(txt, size = size, halign = "center", valign = "center");
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

module drawing() {
    label("Fridge System Wiring — schematic, not to physical scale", 0, 58, 1.8);

    // ---- AC charge source: front console outlet, charges the DELTA 3 ----
    box(0, 53, 41, 4.5, [
        ["Front console AC outlet — 1500W", 1.3],
        ["VERIFIED — charges DELTA 3; one 1500W inverter feeds BOTH van outlets", 0.9],
    ], "Gray");

    wire(0, 50.7, 0, 47.3);

    // ---- DELTA 3 stack: the new source for BOTH circuits below ----
    box(0, 43.5, 40, 6.5, [
        ["EcoFlow DELTA 3 Plus + Smart Extra Battery", 1.3],
        ["2048Wh combined — Panel A right drawer", 0.95],
        ["AC in 1500W (0-100% in ~56 min) · DC out to fridge + fans", 0.9],
    ], "SteelBlue");
    label("Charge + discharge simultaneously supported — running the fridge/fans", 0, 39.4, 0.85);
    label("while AC-charging is normal, just slows the charge rate a bit", 0, 38.4, 0.85);

    // ---- branch 1: fridge, DC line from the DELTA 3 ----
    wire(-15, 40.3, -15, 35.3);
    box(-16, 32, 28, 6, [
        ["BougeRV Rocky 40 (CR04001)", 1.2],
        ["dual-zone 41QT · 40.6 lb · 60W max / 45W ECO", 0.78],
        ["built-in 12/24V DC + AC + solar input", 0.8],
        ["— no inverter needed", 0.8],
    ]);
    label("Circuit 1: fridge — DC line from DELTA 3", -15, 27.5, 0.95);
    label("(Panel A -> B -> C, 2 quick-disconnects)", -15, 26.3, 0.95);

    // ---- branch 2: fan system, also off the DELTA 3 now ----
    wire(11, 40.3, 11, 35.9);
    box(11, 33.5, 21, 3, [["Fuse / surge protector", 1.25]]);

    wire(11, 32, 11, 29.3);
    box(11, 27, 22, 3, [["ON/OFF switch (manual)", 1.25]]);

    wire(11, 25.5, 11, 21.9);
    box(11, 19, 27, 5.5, [
        ["PWM fan speed controller", 1.25],
        ["W1209-style, NTC input,", 0.95],
        ["relay/PWM output", 0.95],
    ]);

    // NTC sensor feeds the controller — signal, not power, dashed +
    // a different color to visually distinguish from the 12V wiring.
    // Placed well left and below the controller so its own box and
    // the "reads bay temp" signal-line caption both stay clear.
    box(-16, 15, 21, 4.5, [
        ["NTC temp sensor", 1.2],
        ["mounted in fridge bay,", 0.9],
        ["near exhaust fan", 0.9],
    ], "DarkGray");
    signal_wire(-5.5, 15.5, -2.5, 17.5);
    label("reads bay", -9, 19.3, 0.85);
    label("temperature", -9, 18.2, 0.85);

    // controller drives both fans in parallel
    wire(11, 16.2, 11, 13.2);
    label("drives both fans in parallel", 11, 12, 1.0);
    wire(11, 10.6, -3, 6.9, "Gray");
    wire(11, 10.6, 25, 6.9, "DimGray");
    box(-3, 4.7, 19, 4, [
        ["Intake fan (120mm)", 1.2],
        ["cabin air IN", 0.95],
    ], "DimGray");
    box(25, 4.7, 19, 4, [
        ["Exhaust fan (120mm)", 1.2],
        ["warm air OUT", 0.95],
    ], "Gray");

    label("Circuit 2: fan system — off the DELTA 3 too now, fused + switched, controller-driven off the NTC sensor", 11, 0.5, 1.0);

    // legend
    leg_x = -16; leg_y = -7;
    color("black") translate([leg_x, leg_y + 0.15]) square([2, 0.3]);
    label("solid line = 12V power", leg_x + 12, leg_y, 1.0);
    for (i = [0:2])
        color("DarkGray") translate([leg_x + i * 0.9, leg_y - 2 + 0.15]) square([0.5, 0.3]);
    label("dashed line = sensor signal, not power", leg_x + 15.5, leg_y - 2, 1.0);
}

// NOTE: no outer color("black") wrapper — every box()/wire()/label()
// call already self-colors (see top_view.scad/rear_view.scad for why
// a nested color() can't override an outer one in this pipeline).
drawing();
