// ============================================================
// Electrical system layout — icon-based, all purchased parts
// ============================================================
// Every electrical component bought for the build (fans, W1209
// controller, Nilight fuse block, switches, enclosure, SAE
// cables, grommets, power strips),
// drawn as a recognizable icon at its REAL position:
//
//   SECTION 1: whole-platform top-down — where everything lives
//   SECTION 2: utility cabinet back wall elevation (X-Z) — how
//              the control cluster mounts
//   SECTION 3: fan mounting detail — screw pattern + airflow
//              direction for both fans
//
// Numbered markers use the shared hue-coded palette
// (colors.scad) and pair with the side legend, same convention
// as the other detail views.
//
// SECTION 1 COORDS: X 0-46 left to right (standing at the
// tailgate facing forward), Y 0 at Panel A's front edge (flush
// with the front seatbacks) increasing toward the tailgate (94
// total).
//
// Render with: openscad -o renders/electrical-layout.svg electrical_layout_detail.scad
// ============================================================

include <params.scad>
include <colors.scad>

stroke = 0.25;

module rect_outline(w, l, s = stroke) {
    color("black")
    difference() {
        square([w, l]);
        translate([s, s]) square([w - 2*s, l - 2*s]);
    }
}

module label(txt, x, y, size = 1.4) {
    color("black") translate([x, y]) text(txt, size = size, halign = "center", valign = "center");
}
module label_left(txt, x, y, size = 1.2) {
    color("black") translate([x, y]) text(txt, size = size, halign = "left", valign = "center");
}
module marker(n, x, y) {
    translate([x, y]) {
        color(marker_col(n)) circle(r = 1.5);
        color("white") text(str(n), size = 1.6, halign = "center", valign = "center");
    }
}
// Counter-mirrored text emitters for the MIRRORED top-down section:
// section 1 is drawn inside mirror([1,0,0]) so the tailgate-at-top
// bird's-eye puts the PASSENGER side on the page LEFT (a real
// overhead view, not a mirror image). These re-mirror just the
// glyphs so the text stays readable; centered text stays centered.
module mlabel(txt, x, y, size = 1.4) {
    color("black") translate([x, y]) mirror([1, 0, 0]) text(txt, size = size, halign = "center", valign = "center");
}
module mmarker(n, x, y) {
    translate([x, y]) {
        color(marker_col(n)) circle(r = 1.5);
        color("white") mirror([1, 0, 0]) text(str(n), size = 1.6, halign = "center", valign = "center");
    }
}
module wire(pts, w = 0.28, col = "Black") { // solid polyline
    color(col) for (i = [0 : len(pts) - 2])
        hull() { translate(pts[i]) circle(w); translate(pts[i+1]) circle(w); }
}

// ---- component icons -------------------------------------------
module fan_icon(r = 2.2) { // square frame, blades, hub, 4 screws
    color("DimGray") difference() {
        square([2*r + 1, 2*r + 1], center = true);
        circle(r = r);
    }
    color("DarkGray") for (a = [0, 90, 180, 270])
        rotate(a) translate([r*0.45, 0]) scale([1, 0.45]) circle(r = r*0.5);
    color("DimGray") circle(r = r*0.3);
    color("Black") for (sx = [-1, 1]) for (sy = [-1, 1])
        translate([sx*(r + 0.15), sy*(r + 0.15)]) circle(r = 0.22);
}
module strip_icon(n = 4, horiz = true) { // power strip w/ outlets
    w = n * 1.6 + 1;
    rotate(horiz ? 0 : 90) {
        color("Black") square([w, 2.2], center = true);
        color("White") for (i = [0 : n - 1])
            translate([-w/2 + 1.3 + i * 1.6, 0]) square([1.0, 1.3], center = true);
    }
}
module fusebox_icon() { // Nilight 6-way: 2 cols x 3 fuses
    color("DimGray") square([3.4, 4.4], center = true);
    for (i = [0:2]) for (s = [-1, 1])
        color(i == 0 ? "Crimson" : i == 1 ? "Goldenrod" : "RoyalBlue")
            translate([s * 0.8, -1.2 + i * 1.2]) square([0.9, 0.7], center = true);
}
module w1209_icon() { // PCB + red 3-digit display + relay
    color("SeaGreen") square([4.4, 2.8], center = true);
    color("Black") translate([-0.7, 0]) square([2.2, 1.3], center = true);
    color("Crimson") translate([-0.7, 0]) text("26.0", size = 0.9, halign = "center", valign = "center");
    color("RoyalBlue") translate([1.6, 0]) square([0.9, 1.8], center = true);
}
module switch_icon() { // round illuminated rocker
    color("Black") circle(r = 0.85);
    color("RoyalBlue") square([0.55, 1.0], center = true);
}
module co_icon() { // CO monitor: rounded body + grill dots
    color("DimGray") offset(r = 0.5) square([2.2, 1.4], center = true);
    color("White") for (i = [-1:1]) translate([i * 0.7, 0]) circle(r = 0.18);
}
module sae_icon() { // SAE quick-disconnect: two mating halves
    color("Black") translate([-1.0, 0]) square([1.6, 1.4], center = true);
    color("DimGray") translate([1.0, 0]) square([1.6, 1.4], center = true);
    color("White") square([0.35, 0.8], center = true);
}
module grommet_icon() {
    color("Black") difference() { circle(r = 0.9); circle(r = 0.45); }
}
module enclosure_icon(w = 6, h = 4) { // hinged box, lid seam + latches
    // frame is 4 plain strips, NOT a difference() ring — in preview
    // mode a difference's subtracted interior ghost-occludes any
    // coplanar fill beneath it (renders the whole box black)
    fr = 0.3;
    color("Gainsboro") square([w, h], center = true);
    color("Black") {
        for (sy = [-1, 1]) translate([0, sy * (h - fr)/2]) square([w, fr], center = true);
        for (sx = [-1, 1]) translate([sx * (w - fr)/2, 0]) square([fr, h], center = true);
        translate([-w/2 + 1.2, 0]) square([0.15, h], center = true); // hinge line
    }
    color("DimGray") for (sy = [-1, 1]) translate([w/2 - 0.6, sy * h/4]) square([0.5, 0.9], center = true);
}
module outlet12v_icon() { // factory 12V socket
    color("DimGray") circle(r = 1.1);
    color("Black") circle(r = 0.7);
    color("White") circle(r = 0.2);
}
module outletAC_icon() { // factory household AC duplex outlet, wall-plate style
    color("Gainsboro") square([2.2, 3.0], center = true);
    color("DimGray") for (sy = [-1, 1]) translate([0, sy * 0.75]) {
        square([1.5, 1.1], center = true);
        color("Black") translate([-0.35, 0.15]) square([0.15, 0.5], center = true);
        color("Black") translate([0.35, 0.15]) square([0.15, 0.5], center = true);
        color("Black") translate([0, -0.3]) circle(r = 0.13);
    }
}

// ============================================================
// SECTION 1 — top-down layout
// ============================================================
module section1() {
    // MIRRORED so the bird's-eye orientation is true: tailgate at top
    // -> nose points down the page -> PASSENGER side on the page LEFT.
    translate([panel_width, 0]) mirror([1, 0, 0]) section1_content();
}

module section1_content() {
    y_front = 0;                                   // Panel A flush to the front seatbacks, no open-floor gap
    y_ab = y_front + panel_a_length;               // 29
    y_bc = y_ab + panel_b_length;                  // 58
    y_tg = y_bc + panel_c_length;                  // 94
    W = panel_width;

    rect_outline(W, y_tg);
    mlabel("ELECTRICAL LAYOUT — top-down (front of van at bottom, tailgate at top)", W/2, y_tg + 3.4, 1.5);
    mlabel("DRIVER side", 4, y_tg + 1.2, 1.1);
    mlabel("PASSENGER side", W - 6, y_tg + 1.2, 1.1);
    color("Silver") for (y = [y_ab, y_bc]) translate([0, y - 0.1]) square([W, 0.2]);
    mlabel("PANEL A", W/2 - 12, (y_front + y_ab)/2, 1.2);
    mlabel("PANEL B", W/2, (y_ab + y_bc)/2 + 6, 1.2);
    mlabel("PANEL C", 27, y_bc + 2.2, 1.2);

    // kitchen / cabinet / fridge footprints inside Panel C
    color("Gainsboro") translate([W - frame_rail_sz - kitchen_box_width, y_tg - kitchen_box_length]) square([kitchen_box_width - 0.4, kitchen_box_length - 0.4]);
    mlabel("KITCHEN", W - frame_rail_sz - kitchen_box_width/2, y_tg - kitchen_box_length/2, 1.1);
    fr_x0 = 1.9;                                   // fridge against the driver-side rear corner leg (1.5in leg + margin)
    color("Silver") translate([fr_x0, y_bc + 0.4]) square([fridge_ext_length - 0.4, fridge_ext_width]);
    mlabel("FRIDGE", fr_x0 + fridge_ext_length/2, y_bc + fridge_ext_width/2, 1.1);
    mlabel("cabinet", 19.5, y_tg - 6.5, 0.9);

    // Rear-pantry footprint: the prefab drawer cluster ON Panel C's
    // deck, at the tailgate end (last pantry_len of Panel C's own length) —
    // shares the same X-Y footprint as the fridge/kitchen/cabinet
    // above (different Z height), drawn as a distinguishing outline
    hb_y0 = y_tg - pantry_len;
    color("DarkGray") rect_outline(W, pantry_len, 0.15);
    translate([0, hb_y0]) color("DarkGray") square([W, 0.15]); // divider line at the pantry's front edge
    mlabel("REAR PANTRY — prefab drawers (on Panel C's deck, above)", W/2, y_tg - pantry_len - 2.2, 1.0);

    // 1: Power strip 1 — on the deck edge in the pantry's open bay
    // (the enclosed middle-band nook), at its mattress-facing edge
    // (hb_y0), NOT Panel A — see the Rear Pantry render
    translate([8, hb_y0 + 1.5]) strip_icon(4);
    mmarker(1, 8, hb_y0 + 4);

    // 2+3: Power strip 1's OWN dedicated cord run — the pantry is
    // now at the TAILGATE end, not the front, so this cord runs the
    // long way down to the console, crossing BOTH remaining seams
    // (Panel C -> B -> A) just like the cooktop and fridge DC lines.
    // Routed along the left (kitchen) side, clear of the cooktop/
    // fridge-DC/DELTA3 lines clustered on the right.
    ps1_cord = [[8, hb_y0], [8, y_bc + 3], [8, y_ab - 3], [18, -3.5]];
    wire(ps1_cord, 0.3, marker_col(2));
    mmarker(2, 8, (y_bc + y_ab)/2);
    for (y = [y_ab, y_bc]) translate([8, y]) sae_icon();
    mmarker(3, 5, y_ab - 4);

    // 4: cooktop cord run — kitchen forward along the right rail to the console
    cord = [[16, y_tg - 5], [42.5, y_tg - 8], [42.5, y_front - 3], [24, -3.5]];
    wire(cord, 0.3, marker_col(4));
    translate([24, -3.5]) outletAC_icon();
    translate([30, -3.5]) outletAC_icon();
    mlabel("front console — 2 AC outlets (per owner-supplied floor plan, UNVERIFIED)", 27, -6.2, 0.9);
    mmarker(4, 44.8, 52);

    // 5+6: SAE quick-disconnects + grommets where the COOKTOP cord crosses each seam
    for (y = [y_ab, y_bc]) {
        translate([42.5, y]) sae_icon();
        translate([40.2, y + 2.2]) grommet_icon();
    }
    mmarker(5, 45.5, y_ab + 3.5);
    mmarker(6, 38, y_ab + 2.2);

    // 7: Power strip 2 — mounted ON the slide-out kitchen unit so it
    // travels to the cook position; its cord to the console carries a
    // slack loop for the slide travel (Section 5)
    translate([10, y_tg - 3.8]) strip_icon(4);
    mmarker(7, 3.5, y_tg - 7);

    // 8: control enclosure — inside the utility cabinet, behind its door (footprint; see Section 2)
    translate([33, y_tg - 1.9]) enclosure_icon(5, 2.6);
    mmarker(8, 28, y_tg - 4.5);

    // 9: intake fan — on Panel C's FRONT wall, over the fridge's B-facing end
    translate([fr_x0 + fridge_ext_length/2, y_bc - 2.6]) fan_icon(1.7);
    mmarker(9, fr_x0 + fridge_ext_length/2 - 6, y_bc - 2.6);

    // 10: exhaust fan (blows into cabinet) + NTC probe (just inside the bay at that wall) — fridge's kitchen-facing side
    translate([fr_x0 - 2.4, y_bc + fridge_ext_width/2 + 4]) fan_icon(1.7);
    color("SeaGreen") translate([fr_x0 - 1.2, y_bc + fridge_ext_width/2 + 8]) circle(r = 0.45);
    mmarker(10, fr_x0 - 7, y_bc + fridge_ext_width/2 + 4);


    // 11+12: fridge DC line — DELTA 3 (Panel A right drawer) forward
    // to the fridge in Panel C, along its own path (offset from the
    // cooktop's rail run at x=42.5) so the two don't overlap. Fridge
    // and fan system both moved off the old factory rear 12V outlet
    // onto the DELTA 3 — see Section 1/5.
    fridge_dc_cord = [[34, 20], [44, y_ab - 3], [44, y_bc + 3], [fr_x0 + 2, y_bc + 3]];
    wire(fridge_dc_cord, 0.3, marker_col(12));
    mmarker(11, 34, 20);
    for (y = [y_ab, y_bc]) translate([44, y]) sae_icon();
    mmarker(12, 47, y_bc - 6);

    // 13: DELTA 3 AC charging cord — front console (confirmed 1500W)
    // back to the DELTA 3 in Panel A's right drawer, sharing the
    // cooktop's near-side outlet icon (all 3 AC lines — cooktop, PS1,
    // DELTA3 — land on the console's shared circuit via a splitter,
    // see the shared-wattage note, Section 5)
    delta3_charge_cord = [[34, 20], [30, y_front - 3], [30, -3.5]];
    wire(delta3_charge_cord, 0.3, marker_col(14));
    mmarker(13, 37, y_front + 4);

    // 14: DELTA 3 drawer grommet — WAVE 3 charge cable exit (Panel A right drawer)
    translate([34, y_ab - 1.6]) grommet_icon();
    mmarker(14, 34, y_ab - 5);
}

// ============================================================
// SECTION 2 — control cluster elevation (inside the cabinet, on the backer board behind the door)
// ============================================================
module section2() {
    z_deck = leg_height + frame_rail_sz; // 18.5
    label("CONTROL CLUSTER — inside the cabinet on its backer board, elevation (looking forward from tailgate)", 23, 36, 1.4);
    rect_outline(30, 33);                              // wall section, x 0-30, z 0-33
    label("backer board inside the cabinet, behind its door", 15, -2.2, 1.0);
    color("Silver") translate([0, z_deck - 0.1]) square([30, 0.2]);
    label_left("deck level", -8.5, z_deck + 0.8, 0.9);
    label_left("18.5\"", -8.5, z_deck - 0.8, 0.9);

    // enclosure with the whole cluster inside
    translate([10, z_deck + 4]) {
        enclosure_icon(13, 9);
        translate([-3, 2]) w1209_icon();
        translate([4.2, 2]) fusebox_icon();
        for (i = [0:2]) translate([-4.5 + i * 3.2, -2.6]) switch_icon();
    }

    label_left("A", 3.2, z_deck + 9.5, 1.4);
    label_left("B", 5.5, z_deck + 6.3, 1.4);
    label_left("C", 12.2, z_deck + 7, 1.4);
    label_left("D", 4.2, z_deck + 0.6, 1.4);
    label_left("E", 26.5, 29.5, 1.4);

    label_left("A  LMioEtool enclosure — 4x #8 x 1\" screws through its mounting ears into the wall", 34, 31.5, 1.0);
    label_left("B  W1209 controller (in its case) — NTC probe wire exits the bottom grommet,", 34, 28.5, 1.0);
    label_left("    runs to the fridge's kitchen-facing wall (Section 3)", 34, 26.8, 1.0);
    label_left("C  Nilight 6-way fuse block — feed from the DELTA 3's DC output (Panel A); fans + W1209 each", 34, 24.0, 1.0);
    label_left("    get their own fused circuit (5A is plenty)", 34, 22.3, 1.0);
    label_left("D  3x Ampper switches (fridge / cooktop strip / fans) — 20mm holes in the", 34, 19.5, 1.0);
    label_left("    enclosure face, switches snap in from the front", 34, 17.8, 1.0);
}

// ============================================================
// SECTION 3 — fan mounting detail (both fans)
// ============================================================
module section3() {
    label("FAN MOUNTING — face-on, both fans identical hardware", 23, 16, 1.4);

    // intake fan, blowing INTO the bay
    translate([8, 4]) {
        fan_icon(4);
        color(marker_col(9)) translate([0, 7]) text("INTAKE", size = 1.3, halign = "center");
        wire([[-8, 0], [-5.6, 0]], 0.35, "Black");
        color("Black") translate([-5.6, 0]) rotate(-90) polygon([[-1, 0], [1, 0], [0, 1.6]]);
        label("cabin air IN", -8, 2.2, 0.9);
    }
    // exhaust fan, blowing OUT into the cabinet
    translate([38, 4]) {
        fan_icon(4);
        color(marker_col(10)) translate([0, 7]) text("EXHAUST", size = 1.3, halign = "center");
        wire([[5.6, 0], [8, 0]], 0.35, "Black");
        color("Black") translate([8, 0]) rotate(90) polygon([[-1, 0], [1, 0], [0, 1.6]]);
        label("warm air OUT", 11.5, 2.2, 0.9);
        color("SeaGreen") translate([6.5, -3.5]) circle(r = 0.5);
        label("NTC probe: zip-tie 1-2\" from the exhaust cutout", 8, -6.2, 0.9);
    }

    label_left("Cut a 4.5\" round hole (or 4.5\" square) in the wall; fan mounts over it with", 0, -10.5, 1.0);
    label_left("4x #8 x 1-1/4\" screws through the corner holes. Grill goes on the AIR-ENTRY side.", 0, -12.4, 1.0);
    label_left("Arrow on the fan's side frame shows its blow direction — point it per the labels above.", 0, -14.3, 1.0);
    label_left("Wiring: both fans in parallel off the W1209 relay (Section 5 wiring schematic).", 0, -16.2, 1.0);
}

// ---- legend (Section 1's numbered markers) ----------------------
module legend() {
    items = [
        "Power strip 1 — on the rear-pantry deck edge (phone/light/Claymore fan)",
        "Power strip 1's OWN dedicated cord — rear pantry (Panel C's tailgate end) down to the front console",
        "Inline connector pairs — Power strip 1's line, one at each of the 2 seams it now crosses (C->B, B->A)",
        "Cooktop cord run — 16AWG SAE cable, along the right frame rail, its own dedicated line",
        "SAE quick-disconnects — cooktop line, one at each seam it crosses",
        "1\" grommets — cooktop line pass-throughs through the end rails",
        "Power strip 2 — ON the slide-out kitchen unit (cooktop); cord has slack for the slide",
        "Control enclosure — inside the cabinet, behind its door (Section 2 below)",
        "Intake fan 120mm — on Panel C's FRONT wall, over the fridge's B-facing end",
        "Exhaust fan 120mm (into cabinet) + NTC probe (inside the bay at that wall, in the hot exhaust)",
        "Fridge DC line — DELTA 3 (Panel A) forward to the fridge (Panel C), own dedicated run",
        "SAE quick-disconnects — fridge DC line, one at each seam it crosses",
        "DELTA 3 AC charging cord — front console (1500W, verified) back to Panel A's drawer",
        "DELTA 3 drawer grommet — WAVE 3 charge cable exit (see stowage detail)",
    ];
    label_left("Legend", 0, 4, 1.6);
    for (i = [0 : len(items) - 1]) {
        y = -i * 3.4;
        marker(i + 1, 1, y);
        label_left(items[i], 3.4, y, 1.05);
    }
}

// ---- assemble ----------------------------------------------------
section1();
translate([54, 88]) legend();
translate([8, -55]) section2();
translate([8, -85]) section3();
