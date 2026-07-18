// ============================================================
// Headboard/pantry — all 4 sides, flat dimensioned elevations,
// every piece labeled with its material type and cut size.
// ============================================================
// Companion to headboard_storage_detail.scad (the exploded isometric)
// and Section 6 Component 1. Owner's July 2026 pattern: NO full-height
// divider and NO top — two FULL-DEPTH shelves split the height into
// 3 full-width tiers, and a short nook divider in the TOP tier only
// splits a 2.75in personal nook (mattress side) from the top food
// tier (kitchen side). Four views:
//   1. MATTRESS-FACING — what you see lying in bed looking rearward
//      (the personal nook on the top shelf + the open lower tiers)
//   2. KITCHEN-FACING — what you see from the open tailgate (the
//      netted food tiers)
//   3/4. LEFT + RIGHT SIDE — the 14in-deep cross-sections (side
//      panels, shelf heights, nook divider, bolt-down base + brace)
//
// Render with: openscad -o renders/headboard-elevations.svg headboard_elevations.scad
// ============================================================

include <params.scad>
include <colors.scad>

stroke = 0.22;
W  = headboard_width;   // 46
L  = headboard_length;  // 14
H  = headboard_height;  // 22
PT = panel_thickness;   // 0.75
Yf = headboard_food_depth;   // 10.5 — top tier's kitchen side, behind the nook divider
Yp = headboard_shelf_depth;  // 2.75 — personal nook depth
psz = headboard_personal_shelf_z; // 16.75 — TOP shelf
zm  = headboard_mid_shelf_z;      // 8.375 — MIDDLE shelf
ndh = headboard_nook_divider_h;   // 4.5 — nook divider height

module rect_outline(w, l, s = stroke) {
    color("black") difference() {
        square([w, l]);
        translate([s, s]) square([w - 2*s, l - 2*s]);
    }
}
module label(txt, x, y, size = 1.25, halign = "center") {
    color("black") translate([x, y]) text(txt, size = size, halign = halign, valign = "center");
}

// front/back elevations share a carcass: 2 side panels, open middle,
// open top (there is NO top panel)
module face_frame() {
    color("BurlyWood") {
        translate([0, 0]) square([PT, H]);          // left side panel edge
        translate([W - PT, 0]) square([PT, H]);     // right side panel edge
    }
    rect_outline(W, H);
}

// both full-depth shelves, seen edge-on from either face
module shelf_edges() {
    for (sz = [zm, psz])
        color("BurlyWood") translate([PT, sz]) square([W - 2*PT, PT]);
}

// vertical bungee-net hint across a tier opening
module net_hint(z0, z1) {
    color("DimGray") for (k = [0 : 3])
        translate([PT + 2 + k * (W - 2*PT - 4)/4, z0]) square([0.2, z1 - z0]);
}

module mattress_facing() {
    face_frame();
    shelf_edges();
    color("SaddleBrown") translate([PT, psz + PT]) square([W - 2*PT, 0.4]); // half-round lip
    color("Black") translate([W * 0.62, psz + PT + 0.5]) square([5, 2]);    // Power strip 1
    color("DimGray") translate([W * 0.22, psz + PT + 0.5]) square([2.5, 0.75]); // RV bar bubble level (roll)
    net_hint(zm + PT + 0.4, psz - 0.4); // middle tier, bed side
    net_hint(0.4, zm - 0.4);            // bottom tier, bed side
    label("MATTRESS-FACING (looking from the bed toward the tailgate)", W/2, H + 5, 1.5);
    label(str("personal NOOK on the top shelf: surface at ", psz, "\", ", Yp, "\" deep, divider behind"), W/2, H + 2.6, 1.15);
    label("half-round lip + Power strip 1 + ROLL bubble level, all on the nook", W/2, psz - 1.8, 1.05);
    label("middle + bottom tiers open to the bed side too — bungee across both", W/2, zm - 1.8, 1.05);
    label(str("side panels: 3/4\" ply, ", L, "\" x ", H, "\" (x2) — NO top panel, tiers open above"), W/2, 1.6, 1.1);
}

module kitchen_facing() {
    face_frame();
    shelf_edges();
    net_hint(zm + PT + 0.4, psz - 0.4);       // middle tier
    net_hint(0.4, zm - 0.4);                  // bottom tier
    net_hint(psz + PT + 0.4, H - 0.4);        // top tier
    label("KITCHEN-FACING (looking forward from the open tailgate)", W/2, H + 5, 1.5);
    label("2 full-depth shelves -> 3 netted tiers (no top — the top tier loads from above too)", W/2, H + 2.6, 1.15);
    label(str("shelves: 3/4\" ply, ", W - 2*PT, "\" x ", L, "\" FULL depth (x2) — the carcass webs"), W/2, zm - 1.8, 1.15);
    label(str("top tier: ", Yf, "\" deep (nook divider behind); middle + bottom: the full ", L, "\""), W/2, psz + PT + ndh/2, 1.05);
    label("bungee/shock-cord net, screw-eye anchors, every tier", W/2, zm + PT + (psz - zm)/2, 1.05);
    label(str("side panels: 3/4\" ply, ", L, "\" x ", H, "\" (x2)"), W/2, 1.6, 1.1);
}

// side elevation: Y (depth) x Z. mattress side at local Y=0 (left).
module side_elev(mirror_it = false) {
    sx = mirror_it ? -1 : 1;
    translate([mirror_it ? L : 0, 0]) scale([sx, 1]) {
        rect_outline(L, H); // the side panel itself, seen face-on
        // 2 full-depth shelves, edge-on
        for (sz = [zm, psz])
            color("BurlyWood") translate([stroke, sz]) square([L - 2*stroke, PT]);
        // nook divider (edge-on), TOP tier only — on the top shelf
        color("SeaGreen") translate([Yp, psz + PT]) square([PT, ndh]);
        // base cleat + bolt-down row at the floor, centered on the depth
        color("DimGray") translate([L/2 - 1.5, -1.2]) square([3, 1.2]);
        // sway brace stub: from ~20in up the mattress face, angling
        // forward/down to Panel C's OWN side rail below the deck
        // (continues off this view — see the Sway Brace Detail)
        color("DimGray") hull() { translate([0.4, 20]) circle(0.35); translate([-4.5, 13]) circle(0.35); }
    }
}

module drawing() {
    // top row: the two 46in-wide faces
    mattress_facing();
    translate([W + 14, 0]) kitchen_facing();

    // bottom row: the two 14in-deep sides
    translate([6, -H - 18]) {
        side_elev(false);
        label("LEFT SIDE (driver side)", L/2, H + 4.4, 1.4);
        label("mattress <- | -> kitchen", L/2, H + 2.2, 1.0);
        label(str("side panel: 3/4\" ply, ", L, "\" x ", H, "\""), L/2, -3.2, 1.05);
        label(str("shelves: 3/4\" ply, full ", L, "\" depth, at ", zm, "\" and ", psz, "\""), L/2 + 3, -5.4, 1.05);
        label("base: 2x 46\"x3\" ply cleats, 4x 1/4-20 Kipp cam levers + T-nuts thru deck", L/2 + 3, -7.6, 1.05);
    }
    translate([6 + L + 30, -H - 18]) {
        side_elev(true);
        // Power strip 1's cord route (crimson): from the strip on the
        // nook, cable-clipped down the side panel's inner face, out a
        // 1" grommet through Panel C's deck, then under the deck and
        // out the front wall's upper grommet toward the console
        color("Crimson") {
            translate([L - Yp * 0.6, 0.6]) square([0.22, psz + PT - 0.6]);
            translate([L - Yp * 0.6 + 0.11, 0.6]) difference() { circle(r = 0.7, $fn = 20); circle(r = 0.5, $fn = 20); }
        }
        label("RIGHT SIDE (passenger side)", L/2, H + 4.4, 1.4);
        label("kitchen <- | -> mattress", L/2, H + 2.2, 1.0);
        label("mirror image of the left side — same parts", L/2, -3.2, 1.05);
        label(str("nook divider (green): 1/2\" ply, ", W - 2*PT, "\" x ", ndh, "\", at ", Yp, "\" from the mattress face, TOP tier only"), L/2 + 4, -5.4, 1.05);
        label("stub arrows = 30\" steel L-angle braces, ~45 deg down to Panel C's side rail", L/2 + 4, -7.6, 1.05);
        label("crimson = Power strip 1 cord: down the side panel, 1\" grommet thru the deck, out the front wall (Section 5)", L/2 + 4, -9.8, 1.05);
    }

    // shared caption
    label("HEADBOARD/PANTRY — ALL 4 SIDES (14\" deep x 46\" wide x 22\" tall, on Panel C's deck — NO TOP, open tiers)", W + 7, -H - 32, 1.8);
    label("Carcass: 2 side panels + 2 FULL-DEPTH shelves, 3/4\" ply, glued + screwed (2\" screws, 2 per shelf end); nook divider 1/2\" ply.", W + 7, -H - 35, 1.2);
    label("Clamped to Panel C's deck (4x 1/4-20 Kipp CAM LEVERS into T-nuts) + 2 L-angle braces (cam-lever nuts at the rail ends) — flips off in a minute, NO tools.", W + 7, -H - 37.5, 1.2);
}

drawing();
