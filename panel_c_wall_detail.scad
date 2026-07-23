// ============================================================
// Panel C front wall — flat pattern, dimensioned, with EVERY hole
// measured. 2D line art, woodworking-plan style.
// ============================================================
// This is the ONE wall any panel gets (owner walls/skirts audit,
// July 2026): Panel A has none (both bays face the side doors),
// Panel B has none (bare-frame deep storage, never seen), and Panel
// C gets exactly this piece on its front (B-facing) face. It does
// several jobs: mounts the 120mm intake fan (with a low passive
// cool-air louver below it), and passes the fridge DC line and
// Power strip 1's line through two grommets. Panel C's sides stay
// open (van wall ~1in away) and its tailgate face needs no wall —
// fridge + cabinet door + kitchen unit + kitchen drawer face fill
// it completely.
//
// Render with: openscad -o renders/panel-c-wall-detail.svg panel_c_wall_detail.scad
// ============================================================

include <params.scad>

stroke = 0.18;

WW = panel_width;   // 46 — wall width
WH = pcwall_h;      // 17 — floor to the front rail's underside
fan_d  = intake_fan_dia;                              // 4.75 (120mm)
fan_x  = panel_width/2 + x_fridge_module;             // 10.86 — centered on the fridge bay (which now sits against the rear corner leg, 1.5 in from the edge)
fan_z  = fridge_tray_gap + fridge_tray_t + fridge_ext_height/2; // 8.8 — centered on the fridge's height (tray hangs 0.5in up between its side-mount rails)
gr_d   = pcwall_grommet_dia;                          // 1 — fridge DC line
gr_x   = 3;   // from the driver edge — the DC line hugs the driver-side floor run
gr_z   = 3;   // low, at cord height
gr2_x  = 3;   // 2nd grommet: Power strip 1's line, exiting the rear pantry's under-deck run
gr2_z  = 5.5; // stacked above the DC grommet — the two lines run the same driver-side channel

module label(txt, x, y, size = 1.2, halign = "center") {
    color("black") translate([x, y]) text(txt, size = size, halign = halign, valign = "center");
}
module ring(r) {
    color("black") difference() { circle(r = r, $fn = 48); circle(r = r - stroke, $fn = 48); }
}
module dim_h(x0, x1, y, txt, size = 1.1) {
    color("black") {
        translate([x0, y]) square([stroke, 1.4], center = true);
        translate([x1, y]) square([stroke, 1.4], center = true);
        translate([x0, y - stroke/2]) square([x1 - x0, stroke]);
        label(txt, (x0 + x1)/2, y - 1.8, size);
    }
}
module dim_v(x, z0, z1, txt, size = 1.1) {
    color("black") {
        translate([x, z0]) square([1.4, stroke], center = true);
        translate([x, z1]) square([1.4, stroke], center = true);
        translate([x - stroke/2, z0]) square([stroke, z1 - z0]);
        label(txt, x + 1.4, (z0 + z1)/2, size, "left");
    }
}

module drawing() {
    // the wall blank
    color("BurlyWood") difference() {
        square([WW, WH]);
        translate([stroke, stroke]) square([WW - 2*stroke, WH - 2*stroke]);
        translate([fan_x, fan_z]) circle(r = fan_d/2, $fn = 48);
        translate([gr_x, gr_z]) circle(r = gr_d/2, $fn = 32);
        translate([gr2_x, gr2_z]) circle(r = gr_d/2, $fn = 32);
        translate([intake_vent_x - intake_vent_w/2, intake_vent_z - intake_vent_h/2])
            square([intake_vent_w, intake_vent_h]);
    }
    // hole edges
    translate([fan_x, fan_z]) ring(fan_d/2);
    translate([gr_x, gr_z]) ring(gr_d/2);
    translate([gr2_x, gr2_z]) ring(gr_d/2);
    // low intake vent: rectangular opening with louver hints
    color("black") difference() {
        translate([intake_vent_x - intake_vent_w/2 - stroke, intake_vent_z - intake_vent_h/2 - stroke])
            square([intake_vent_w + 2*stroke, intake_vent_h + 2*stroke]);
        translate([intake_vent_x - intake_vent_w/2, intake_vent_z - intake_vent_h/2])
            square([intake_vent_w, intake_vent_h]);
    }
    color("DimGray") for (i = [1 : 3])
        translate([intake_vent_x - intake_vent_w/2 + 0.4, intake_vent_z - intake_vent_h/2 + i * intake_vent_h/4])
            square([intake_vent_w - 0.8, 0.12]); // louver slats
    // fan mounting screw holes: 105mm (4.13in) square pattern,
    // standard 120mm fan bolt circle
    for (dx = [-2.07, 2.07]) for (dz = [-2.07, 2.07])
        translate([fan_x + dx, fan_z + dz]) ring(0.11);
    // perimeter mounting screws: into the front legs (2 per leg) +
    // up into the front rail zone (2, top edge) + into the front
    // BOTTOM rail (2, low — the cube-frame rail behind the wall)
    for (p = [[leg_inset + frame_rail_sz/2, 3], [leg_inset + frame_rail_sz/2, 13],
              [WW - leg_inset - frame_rail_sz/2, 3], [WW - leg_inset - frame_rail_sz/2, 13],
              [WW * 0.33, WH - 0.75], [WW * 0.67, WH - 0.75],
              [WW * 0.33, bottom_rail_z + frame_rail_sz/2], [WW * 0.67, bottom_rail_z + frame_rail_sz/2]])
        translate(p) ring(0.11);

    // centerline crosses on both holes
    color("DimGray") {
        translate([fan_x - fan_d/2 - 1, fan_z]) square([fan_d + 2, stroke]);
        translate([fan_x, fan_z - fan_d/2 - 1]) square([stroke, fan_d + 2]);
        translate([gr_x - gr_d/2 - 1, gr_z]) square([gr_d + 2, stroke]);
        translate([gr_x, gr_z - gr_d/2 - 1]) square([stroke, gr_d + 2]);
    }

    // ---- hole dimensions (all of them) ----
    dim_h(0, fan_x, -3, str(fan_x, "\" driver edge -> fan center"));
    dim_v(WW + 2.5, 0, fan_z, str(round(fan_z * 10) / 10, "\" floor -> fan center"));
    dim_h(0, gr_x, -6.5, str(gr_x, "\" -> both grommet centers"));
    dim_v(WW + 7.5, 0, gr_z, str(gr_z, "\" -> DC grommet"));
    dim_v(WW + 12, 0, gr2_z, str(gr2_z, "\" -> strip-line grommet"));
    dim_h(0, WW, -10, str(WW, "\" wide"));
    dim_v(-2.5, 0, WH, str(WH, "\" tall"));

    label(str("fan hole: ", fan_d, "\" dia (120mm) — hole saw or jigsaw"), fan_x + fan_d/2 + 1.5, fan_z + 1.6, 1.15, "left");
    label("4x #8 fan screws on a 4.13\" (105mm) square", fan_x + fan_d/2 + 1.5, fan_z + 0.2, 1.0, "left");
    label(str("grommets: ", gr_d, "\" dia x2 — fridge DC line (low) + Power strip 1's line (upper)"), gr2_x + 1.5, gr2_z + 2.6, 1.05, "left");
    label(str("LOW INTAKE VENT: ", intake_vent_w, "\" x ", intake_vent_h, "\" louver at ", intake_vent_x, "\" over, ", intake_vent_z, "\" up — admits cool floor-level air"), intake_vent_x + 2, intake_vent_z - intake_vent_h/2 - 1.2, 1.0);
    label("8x #8 x 1-1/4\" perimeter screws: 2 into each front leg + 2 into the top rail + 2 into the bottom rail", WW/2, WH + 1.4, 1.05);

    // ---- title + notes ----
    label("PANEL C FRONT WALL — 3/8\" ply, flat pattern (the ONLY wall on any panel)", WW/2, WH + 6.4, 1.8);
    label("Mounts on Panel C's front (B-facing) face, floor to rail underside. Intake fan bolts over the big hole (blows IN); the low louver is a passive cool-air scoop below it.", WW/2, WH + 4.4, 1.15);
    label("Panel A/B: no walls or skirts anywhere. Panel C sides: open. Panel C tailgate face: no wall — fridge + cabinet door + kitchen + kitchen drawer fill it.", WW/2, WH + 3.1, 1.05);
    label("DRIVER side at left (the fridge bay's side) — PASSENGER at right. All positions computed from params.scad.", WW/2, -13, 1.05);
}

color("black") drawing();
