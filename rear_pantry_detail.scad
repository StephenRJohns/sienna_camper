// ============================================================
// Rear pantry — prefab drawer cluster + pot bay, EXPLODED ISOMETRIC
// (woodworking-plan line-art, see steps/lego_lib.scad). Looking at
// the tailgate end of Panel C's deck: a 2x2 array of IRIS 12in-W
// stackable drawers (driver side) + a pot/pan crate + relocated
// power (passenger side), held by cleats + a cam strap. Replaces the
// old plywood pantry (Component 1).
//
// Render with: openscad -o renders/rear-pantry-detail.svg rear_pantry_detail.scad
// ============================================================

include <steps/lego_lib.scad>
include <colors.scad>

PT = panel_thickness;
DW = 46;                        // deck width (X)
DD = 15;                        // deck depth drawn (Y)
CW = pantry_cluster_w;          // 24.2 cluster width
CH = pantry_cluster_h;          // 16.8 cluster height (2 rows)
uw = CW / 2;                    // one drawer unit width
uh = CH / 2;                    // one drawer unit height
POT = pantry_pot_bin;           // ~13

module marker3d(n, anchor3, off = [6, 4]) {
    q = p2(anchor3); t = q + off;
    color(INK) line2d(q, t - off * (2.2 / max(2.2, norm(off))));
    color(marker_col(n)) translate(t) circle(r = 1.4);
    color("white") translate(t) text(str(n), size = 1.4, halign = "center", valign = "center");
}
module side_list(list_x, top_y, items) {
    color(INK) translate([list_x, top_y]) text("Hold-down + fit-out", size = 1.7, halign = "left", valign = "center");
    for (i = [0 : len(items) - 1]) {
        y = top_y - 4 - i * 3.0;
        color(marker_col(i + 1)) translate([list_x + 0.8, y]) circle(r = 1.2);
        color("white") translate([list_x + 0.8, y]) text(str(i + 1), size = 1.1, halign = "center", valign = "center");
        color(INK) translate([list_x + 3.4, y]) text(items[i], size = 1.15, halign = "left", valign = "center");
    }
}

module drawing() {
    // Panel C deck (context — cluster + bay just sit on it)
    wbox([-DW/2, 0, 0], [DW, DD, PT], [0, 0], true);

    // 2x2 IRIS drawer cluster (driver side), fronts facing the tailgate (-Y)
    for (c = [0, 1]) for (r = [0, 1])
        wbox([-DW/2 + c*uw + 0.3, 0.5, PT + r*uh + 0.2], [uw - 0.6, CH*0.82, uh - 0.4]);
    // drawer pulls on the tailgate faces
    ifill(INK) for (c = [0, 1]) for (r = [0, 1])
        translate([-DW/2 + c*uw + uw/2 - 1.4, 0.3, PT + r*uh + uh/2]) cube([2.8, 0.3, 0.8]);

    // cam strap across the drawer fronts (shut + hold-down)
    ifill("Crimson") translate([-DW/2 - 0.6, 0.1, PT + CH*0.5 - 0.4]) cube([CW + 1.2, 0.5, 0.9]);
    ifill("Crimson") translate([-DW/2 + CW/2 - 1.4, -0.1, PT + CH*0.5 - 1.3]) cube([2.8, 0.7, 2.6]); // cam buckle

    // side + cab cleats (birch) that pocket the cluster
    ifill("SaddleBrown") {
        translate([-DW/2 - 0.9, 0, PT]) cube([0.9, CH*0.82, 5]);
        translate([-DW/2 + CW, 0, PT]) cube([0.9, CH*0.82, 5]);
        translate([-DW/2, CH*0.82, PT]) cube([CW, 0.9, 5]);          // cab-side cleat (stops fwd slide)
    }
    // flush deck D-rings at the cluster base corners
    ifill("DarkSlateGray") for (dx = [-DW/2 + 1.5, -DW/2 + CW - 1.5])
        translate([dx, 1, PT]) cylinder(h = 0.4, r = 0.9, $fn = 20);

    // pot/pan crate (passenger side, ~19in open bay)
    wbox([2, 0.5, PT], [POT, POT, 11]);
    // relocated Power strip 1 + ROLL bubble level on the deck edge
    ifill(INK) translate([DW/2 - 6, 1, PT]) cube([4, 2, 2]);
    ifill("GreenYellow") translate([DW/2 - 5, 4, PT]) cube([3.5, 1.6, 0.6]);

    // markers
    marker3d(1, [-DW/2 + CW/2, 0.3, PT + CH*0.5], [2, 12]);          // strap
    marker3d(2, [-DW/2 - 0.5, CH*0.4, PT + 3], [-12, 4]);           // cleats
    marker3d(3, [-DW/2 + 1.5, 1, PT], [-12, -4]);                   // D-ring
    marker3d(4, [2 + POT/2, POT/2, PT + 11], [8, 8]);              // pot crate
    marker3d(5, [DW/2 - 4, 2, PT + 2], [10, -2]);                  // power strip

    cap(str("REAR PANTRY — prefab 2x2 IRIS drawer cluster (", CW, "\" x ", CH, "\") + pot crate, on Panel C's deck (Component 1)"), 0, -15, 1.9);
    cap("Replaces the plywood pantry — ~27 lb lighter, nothing built. Each drawer unit lifts straight out once the cam strap is loosened.", 0, -17.5, 1.3);
    cap("Canned goods LOW, boxed dry goods UP. Cab-side cleat stops the forward slide under braking; the strap doubles as drawer-shut + hold-down.", 0, -19.7, 1.3);

    side_list(DW/2 + 12, CH + 2, [
        "Cam strap across drawer fronts (shut + hold-down)",
        "Birch cleats: cab side + both sides (tailgate stays open)",
        "Flush deck D-rings (cam-strap anchors)",
        "Pot/pan crate (~13\") in the ~19\" open bay",
        "Power strip 1 + ROLL bubble level, on the deck edge",
    ]);
}

drawing();
