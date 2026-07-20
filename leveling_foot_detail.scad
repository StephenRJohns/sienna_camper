// ============================================================
// Leg leveling foot detail — exploded isometric reference,
// woodworking-plan style (see steps/lego_lib.scad).
// ============================================================
// Leveling lives at the FLOOR now: each leg is cut 1in short
// (leg_cut_length) and gets a 3/8-16 threaded insert in its bottom
// end grain, taking a leveling glide bolt with a broad floor pad and
// a ~2in star knob jam-nutted on the shaft as the hand grip.
// Effective leg height stays 17in, so the deck doesn't move — but
// the old between-layers adjusters (1in) and platform battens
// (1/4in) are gone, buying 1.25in of extra headroom above the
// mattress. 12 feet total: 4 per panel x 3 panels. To adjust: kneel
// at the side door, tip that corner of the box slightly, spin the
// knob. Shown at 3x real scale — labels give real size.
//
// Render with: openscad -o renders/leveling-foot-detail.svg leveling_foot_detail.scad
// ============================================================

include <steps/lego_lib.scad>
include <colors.scad>

SC = 3;
RS = frame_rail_sz;      // 1.5 — 2x2 leg cross-section
leg_show_h = 6;          // bottom portion of the leg only — zoomed detail
insert_h = 0.75;
NH = leveling_foot_nominal_h; // 1 — exposed foot height at mid-adjustment
pad_h = 0.3;

module marker3d(n, anchor3, off = [6, 4]) {
    q = p2(anchor3) * SC;
    t = q + off;
    color(marker_col(n)) translate(t) circle(r = 1.3);
    color("white") translate(t) text(str(n), size = 1.3, halign = "center", valign = "center");
    color(INK) line2d(q, t - off * (2.2 / max(2.2, norm(off))));
}

module side_list(list_x, top_y, items) {
    color(INK) {
        translate([list_x, top_y - 1]) text("Component", size = 1.4, halign = "left", valign = "center");
        translate([list_x, top_y - 3.6]) text("Position / fastener / material", size = 1.1, halign = "left", valign = "center");
    }
    for (i = [0 : len(items) - 1]) {
        y = top_y - 10 - i * 9;
        color(marker_col(i + 1)) translate([list_x, y + 3.8]) circle(r = 1.2);
        color("white") translate([list_x, y + 3.8]) text(items[i][0], size = 1.2, halign = "center", valign = "center");
        color(INK) {
            translate([list_x + 3.2, y + 3.8]) text(items[i][1], size = 1.15, halign = "left", valign = "center");
            translate([list_x + 3.2, y + 1.9]) text(items[i][2], size = 1.0, halign = "left", valign = "center");
            translate([list_x + 3.2, y]) text(items[i][3], size = 1.0, halign = "left", valign = "center");
        }
    }
}

module drawing() {
    scale([SC, SC, SC]) {
        // leg stub (bottom of the CUT leg), floating above the foot
        wbox([0, 0, NH + 2.5], [RS, RS, leg_show_h]);

        // threaded insert, up into the leg's bottom end grain
        ifill(COL_HARDWARE) translate([RS/2, RS/2, NH + 2.5 - 0.05])
            cylinder(h = insert_h, d = 0.5, $fn = 16);
        iarrow([RS/2, RS/2, NH + 1.9], [RS/2, RS/2, NH + 2.4]);

        // glide bolt: shank up into the insert, star knob jam-nutted
        // mid-shaft, broad pad on the floor
        ifill(COL_HARDWARE) translate([RS/2, RS/2, pad_h]) cylinder(h = NH + 1.6, d = 0.5, $fn = 16);
        ifill(COL_HARDWARE) translate([RS/2, RS/2, pad_h + 0.35]) cylinder(h = 0.4, d = 2.0, $fn = 5); // 2in star knob
        ifill("Black") translate([RS/2, RS/2, 0]) cylinder(h = pad_h, d1 = leveling_foot_pad_dia, d2 = leveling_foot_pad_dia * 0.7, $fn = 24);

        // floor line
        color(INK) translate([-3, -3, 0]) cube([12, 0.15, 0.05]);
    }

    marker3d(1, [RS/2, RS/2, NH + 2.5 + leg_show_h * 0.5], [14, 10]);
    marker3d(2, [RS/2, RS/2, NH + 2.5 + insert_h/2], [16, -2]);
    marker3d(3, [RS/2, RS/2, pad_h + 0.55], [18, -10]);
    marker3d(4, [RS/2, RS/2, pad_h/2], [16, -18]);

    cap(str("LEG LEVELING FOOT — shown ", SC, "x actual size (", leveling_foot_count, " total: 4 per panel x 3 panels)"), 24, -12, 2.0);
    cap(str("Legs are CUT to ", leg_cut_length, "\" — the foot makes up the last ", NH, "\", keeping the effective ", leg_height, "\" leg height."), 24, -15.5, 1.3);
    cap("To level: kneel at the side door, tip that corner of the box slightly, spin the star knob. Every leg is exposed at", 24, -18.5, 1.3);
    cap("floor level — nothing boxes it in. The platform above rests DIRECTLY on the box rails (no adjusters up top anymore).", 24, -21.5, 1.3);

    side_list(30, 42, [
        ["1", "Leg (bottom end shown)", str("2x2 pine (1.5\" x 1.5\" actual), cut to ", leg_cut_length, "\""), "drill centered, 3/8\" pilot x 7/8\" deep for the insert"],
        ["2", str(leveling_foot_thread, " threaded insert"), "driven UP into the leg's end grain", "screw-in style, 7/16\" OD coarse outer thread"],
        ["3", "Star knob, ~2\" dia (hand grip)", "3/8-16 thru-hole knob + jam nut on the bolt shaft", "the adjustment — big enough to turn with the box tipped"],
        ["4", "Leveling glide bolt + pad", str(leveling_foot_pad_dia, "\" floor pad; +/-", leveling_foot_travel, "\" travel around ", NH, "\" nominal"), "threads into the insert — leveling only, not height changes"],
    ]);
}

drawing();
