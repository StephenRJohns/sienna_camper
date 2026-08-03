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
// fridge + open utility bay + kitchen unit + kitchen drawer face fill
// it completely.
//
// Render with: openscad -o renders/panel-c-wall-detail.svg panel_c_wall_detail.scad
// ============================================================
// LEGIBILITY (Aug 2026): 5 prose line(s) moved out of this
// sheet into the document, and every text size scaled x1.8. Those
// sentences were setting the sheet's width, and a figure's printed
// text height is size x (page_width / sheet_width) — so they were
// holding every other label on the sheet down to 3-6pt on paper.
// Keep prose in the markdown; this sheet carries geometry and short
// labels only.

include <params.scad>

stroke = 0.18;

WW = panel_width;   // 46 — wall width
WH = pcwall_h;      // 17 — floor to the front rail's underside
fan_d  = intake_fan_dia;                              // 4.75 (120mm)
fan_x  = panel_width/2 + x_fridge_module;             // 11.11 — centered on the fridge bay (which now sits against the rear corner leg, 1.5 in from the edge)
fan_z  = fridge_tray_gap + fridge_tray_t + fridge_ext_height/2; // 8.8 — centered on the fridge's height (tray hangs 0.5in up between its side-mount rails)
gr_d   = pcwall_grommet_dia;                          // 1 — fridge DC line
gr_x   = pcwall_grommet_x;   // driver-side cord chase, outboard of the front leg
gr_z   = pcwall_grommet_z;   // fridge DC line
// (a 2nd grommet for Power strip 1's line used to sit above this one; the
// verified-outlet round put that strip on the van's rear outlet instead)

module label(txt, x, y, size = 2.16, halign = "center") {
    color("black") translate([x, y]) text(txt, size = size, halign = halign, valign = "center");
}
// text on a leader line: kink from the feature out to the label
module callout(txt, fx, fz, tx, tz, size = 1.7) {
    color("black") {
        hull() { translate([fx, fz]) circle(r = stroke/2, $fn = 8);
                 translate([tx - 0.8, tz]) circle(r = stroke/2, $fn = 8); }
        translate([fx, fz]) circle(r = 0.3, $fn = 16);
    }
    label(txt, tx, tz, size, "left");
}
module ring(r) {
    color("black") difference() { circle(r = r, $fn = 48); circle(r = r - stroke, $fn = 48); }
}
module dim_h(x0, x1, y, txt, size = 1.98) {
    color("black") {
        translate([x0, y]) square([stroke, 1.4], center = true);
        translate([x1, y]) square([stroke, 1.4], center = true);
        translate([x0, y - stroke/2]) square([x1 - x0, stroke]);
        label(txt, (x0 + x1)/2, y - 1.8, size);
    }
}
// tx/ta let the caller pull the text out to a shared column and choose a
// side. at_top puts it level with the upper tick instead of the midpoint —
// three dims that all start at the floor have near-identical midpoints, so
// midpoint text piles up in one band.
module dim_v(x, z0, z1, txt, size = 1.98, tx = undef, ta = "left", at_top = false) {
    color("black") {
        translate([x, z0]) square([1.4, stroke], center = true);
        translate([x, z1]) square([1.4, stroke], center = true);
        translate([x - stroke/2, z0]) square([stroke, z1 - z0]);
        label(txt, is_undef(tx) ? x + 1.4 : tx,
              at_top ? z1 : (z0 + z1)/2, size, ta);
    }
}

module drawing() {
    // the wall blank
    color("BurlyWood") difference() {
        square([WW, WH]);
        translate([stroke, stroke]) square([WW - 2*stroke, WH - 2*stroke]);
        translate([fan_x, fan_z]) circle(r = fan_d/2, $fn = 48);
        translate([gr_x, gr_z]) circle(r = gr_d/2, $fn = 32);
        translate([intake_vent_x - intake_vent_w/2, intake_vent_z - intake_vent_h/2])
            square([intake_vent_w, intake_vent_h]);
    }
    // hole edges
    translate([fan_x, fan_z]) ring(fan_d/2);
    translate([gr_x, gr_z]) ring(gr_d/2);
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
    dim_h(0, fan_x, -3, str(fan_x, "\" → fan center"));
    dim_h(0, gr_x, -7, str(gr_x, "\" → grommet"));
    dim_h(0, WW, -11, str(WW, "\" wide"));
    TXCOL = WW + 13.5;   // shared text column for the three floor-referenced dims
    dim_v(WW + 2.5, 0, fan_z, str(round(fan_z * 10) / 10, "\" fan"),
          tx = TXCOL, at_top = true);
    dim_v(WW + 7.5, 0, gr_z, str(gr_z, "\" DC grommet"),
          tx = TXCOL, at_top = true);
    // the height dim reads outward to the LEFT; text inside the blank would
    // land on the vent and grommet callouts
    dim_v(-2.5, 0, WH, str(WH, "\" tall"),
          tx = -3.6, ta = "right");

    // Callouts sit in the wall's empty passenger half on leader lines. Set
    // beside the openings they had nowhere to go — the fan, louver and
    // grommets are all in the driver third.
    // stacked in one column in the wall's empty upper-right quadrant, in the
    // same top-to-bottom order as the features they point at
    callout(str("FAN ", fan_d, "\" dia"), fan_x + fan_d/2, fan_z + 1.4, 21, 7);
    callout(str("LOUVER ", intake_vent_w, "\" x ", intake_vent_h, "\""),
            intake_vent_x + intake_vent_w/2, intake_vent_z, 21, 4.4);
    callout("DC GROMMET 1\"", gr_x + gr_d/2, gr_z, 21, 1.8);

    // The control cluster mounts on THIS wall's far (Panel-B) face — dashed,
    // because from this side you are looking at the back of it. It moved here
    // Aug 2026 when Panel C's width chain left the utility bay 1.28in wide.
    color("DimGray") for (i = [0 : 3]) {
        translate([cluster_x, cluster_z + i * cluster_h/3]) square([cluster_w, 0.12]);
        translate([cluster_x + i * cluster_w/3, cluster_z]) square([0.12, cluster_h]);
    }
    label("CONTROL CLUSTER", cluster_x + cluster_w/2, cluster_z + cluster_h + 1.4, 1.6);
    // MOVED TO THE DOCUMENT: label("8x #8 x 1-1/4\" perimeter screws: 2 into each front leg + 2 into the top rail + 2 into the bottom rail", WW/2, WH + 1.4, 1.05);

    // ---- title + notes ----
    label("PANEL C FRONT WALL — 3/8\" ply, flat pattern", WW/2, WH + 4.5, 2.4);
    // MOVED TO THE DOCUMENT: label("Mounts on Panel C's front (B-facing) face, floor to rail underside. Intake fan bolts over the big hole (blows IN); the low louver is a passive cool-air scoop below it.", WW/2, WH + 4.4, 1.15);
    // MOVED TO THE DOCUMENT: label("Panel A/B: no walls or skirts anywhere. Panel C sides: open. Panel C tailgate face: no wall — fridge + open utility bay + kitchen + kitchen drawer fill it.", WW/2, WH + 3.1, 1.05);
    label("DRIVER side at left (the fridge bay) — PASSENGER at right", WW/2, -15.5, 1.9);
}

color("black") drawing();
