// ============================================================
// Rear pantry — prefab drawer cluster + pot bay (2D elevation).
// Looking forward from the open tailgate at the tailgate end of
// Panel C's deck: a 2x2 array of IRIS 12in-W stackable drawers on the
// driver side + a pot/pan bay + relocated power on the passenger
// side, with the cleat-pocket + strap hold-down. Replaces the old
// plywood pantry (Component 1).
//
// Render with: openscad -o renders/rear-pantry-detail.svg rear_pantry_detail.scad
// ============================================================

include <params.scad>
include <colors.scad>
stroke = 0.3;

module rect_outline(w, h, s = stroke) {
    color("black") difference() { square([w, h]); translate([s, s]) square([w - 2*s, h - 2*s]); }
}
module label(txt, x, y, size = 1.5, ha = "center") {
    color("black") translate([x, y]) text(txt, size = size, halign = ha, valign = "center");
}
module marker(n, x, y) {
    translate([x, y]) { color(marker_col(n)) circle(r = 1.4); color("white") text(str(n), size = 1.5, halign = "center", valign = "center"); }
}

module drawing() {
    W = 46;                 // deck width
    x0 = -W/2;              // -23 (driver edge)
    // deck line
    color("Gray") translate([x0, -1.5]) rect_outline(W, 1.5);
    label(str("Panel C deck (", W, "\" wide, tailgate end) — cluster + bay just SIT on it, held by cleats + a strap"), 0, -3.2, 1.15);
    label("DRIVER side", x0 + 5, -0.75, 0.8);
    label("PASSENGER side", W/2 - 6, -0.75, 0.8);

    // ---- 2x2 drawer cluster (driver side) ----
    cw = pantry_cluster_w; ch = pantry_cluster_h; cx0 = x0; // cluster left edge at the driver edge
    dcol = cw/2; drow = ch/2;
    color("Gainsboro") translate([cx0, 0]) rect_outline(cw, ch, 0.35);
    for (c = [0, 1]) for (r = [0, 1]) {
        color("DimGray") translate([cx0 + c*dcol + 0.4, r*drow + 0.4]) rect_outline(dcol - 0.8, drow - 0.8, 0.2);
        // drawer pull
        color("DimGray") translate([cx0 + c*dcol + dcol/2 - 1.4, r*drow + drow/2 - 0.4]) square([2.8, 0.8]);
    }
    label("2x2 IRIS 12\"W stackable drawers", cx0 + cw/2, ch + 3, 1.4);
    label(str(cw, "\" W x ", ch, "\" H — 4 units (2x Home Depot 3-packs)"), cx0 + cw/2, ch + 1.2, 1.1);
    label("canned goods LOW, boxed dry goods UP", cx0 + cw/2, ch/2 + 2.2, 1.0);

    // strap across the drawer fronts (double duty: shut + hold-down)
    color("Crimson") translate([cx0 - 1, drow - 0.4]) square([cw + 2, 0.8]);
    color("Crimson") translate([cx0 + cw/2 - 1.6, drow - 1.4]) rect_outline(3.2, 2.8, 0.18); // cam buckle
    // D-rings at the cluster base corners
    color("DarkSlateGray") for (dx = [cx0 + 1.5, cx0 + cw - 1.5]) translate([dx, 0.8]) circle(r = 0.9, $fn = 20);
    // side + base cleats
    color("SaddleBrown") { translate([cx0 - 0.9, 0]) square([0.9, 6]); translate([cx0 + cw, 0]) square([0.9, 6]); }

    // ---- pot/pan bay (passenger side, ~19" of open deck) ----
    bx0 = cx0 + cw;                          // 4
    bw = W/2 - bx0;                          // 19
    color("LightGray") translate([bx0, 0]) rect_outline(bw, ch, 0.2);
    label(str("~", bw, "\" open deck bay"), bx0 + bw/2, ch + 3, 1.3);
    // pot bin (~11 x 11)
    color("BurlyWood") translate([bx0 + 1.5, 0]) rect_outline(pantry_pot_bin, pantry_pot_bin, 0.3);
    label("pots/pans", bx0 + 7, 8, 1.05);
    label("rigid ~13\" crate", bx0 + 7, 6.4, 0.9);
    label("+ corner cleat + bungee", bx0 + 7, 5, 0.85);
    color("SaddleBrown") translate([bx0 + 0.6, 0]) square([0.9, 5]);
    // relocated Power strip 1 + ROLL bubble level (deck edge)
    color("Black") translate([bx0 + 13.5, 1]) square([4, 2]);
    color("GreenYellow") translate([bx0 + 15.5, 5]) rect_outline(3.5, 1.6, 0.15);
    label("Power strip 1", bx0 + 15.5, 3.6, 0.85);
    label("ROLL bubble level", bx0 + 17.2, 7, 0.85);
    label("(deck-edge mount — reach + read them from the bed)", bx0 + 10, 12.5, 0.9);
    // wiring along the back edge
    color("DimGray") for (i = [0:6]) translate([bx0 + 1 + i*2.4, ch - 1]) square([1.4, 0.4]);
    label("12V + wiring routed along the back edge", bx0 + bw/2, ch - 2.4, 0.85);

    // ---- markers + legend ----
    marker(1, cx0 + cw/2, drow + 0);         // strap
    marker(2, cx0 - 0.4, 3);                 // cleat
    marker(3, cx0 + 1.5, 0.8);               // D-ring
    marker(4, bx0 + 7, 10.4);                // pot bin
    marker(5, bx0 + 15.5, 2);                // power strip

    leg_x = W/2 + 4;
    items = ["Cam strap across drawer fronts (shut + hold-down)",
             "Birch cleats: cab side + both sides (tailgate open)",
             "Flush deck D-rings (strap anchors)",
             "Pot/pan crate (~13\") in the open bay",
             "Power strip 1 + ROLL level, relocated to the deck"];
    label("Hold-down + fit-out", leg_x, ch + 1, 1.5, "left");
    for (i = [0 : len(items) - 1]) {
        y = ch - 2 - i * 2.6;
        marker(i + 1, leg_x + 0.8, y);
        label(items[i], leg_x + 3.2, y, 1.05, "left");
    }

    label("REAR PANTRY — prefab 2x2 drawer cluster + pot bay (replaces the plywood pantry; ~27 lb lighter, nothing built)",
          W/2 - 3, -6, 1.5, "center");
    label("Each drawer unit lifts straight out (loosen the strap) — removable, clears the liftgate. Cab-side cleat stops the forward slide under braking.",
          W/2 - 3, -8, 1.15, "center");
}

drawing();
