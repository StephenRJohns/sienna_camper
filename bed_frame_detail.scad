// ============================================================
// Bed platform detail — exploded isometric reference, woodworking-
// plan style (see steps/lego_lib.scad).
// ============================================================
// Component 2: a FLUSH LADDER platform — two 1x4 side rails running
// the full 58in (Panel A + B — it ENDS at the B/C seam, flush with
// Panel C's own deck), with the slats (cut to 45in) pocket-screwed BETWEEN
// them, everything in one 3/4in plane. It rests DIRECTLY on the
// boxes' top rails (leveling happens at the leg feet, floor level —
// leveling_foot_detail.scad) and lifts straight off as one piece for
// drawer-bay access. Slats + rails all cut from 1x4 x 8ft pine.
//
// Render with: openscad -o renders/bed-frame-detail.svg bed_frame_detail.scad
// ============================================================

include <steps/lego_lib.scad>
include <colors.scad>

L = bed_frame_length; // 58
W = bed_frame_width;  // 52
RW = bed_rail_width;  // 3.5
SL = bed_slat_length; // 39
lift = 6;

module marker3d(n, anchor3, off = [6, 4]) {
    q = p2(anchor3);
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
    // the 2 side rails, full length, in the final plane
    for (x = [-W/2, W/2 - RW])
        wbox([x, 0, 0], [RW, L, bed_slat_t]);

    // slats, lifted above their slots between the rails
    slat_gap = (L - bed_slat_count * bed_slat_width) / (bed_slat_count - 1);
    for (i = [0 : bed_slat_count - 1]) {
        y = i * (bed_slat_width + slat_gap);
        wbox([-W/2 + RW, y, lift], [SL, bed_slat_width, bed_slat_t]);
        // pocket screws: 2 per slat end, into the rails' inner edges
        for (x = [-W/2 + RW + 0.6, W/2 - RW - 0.6])
            fastener([x, y + bed_slat_width/2, lift + bed_slat_t/2], 0.35, 90);
    }
    for (x = [-W/2 + RW + SL * 0.25, -W/2 + RW + SL * 0.75])
        iarrow([x, L * 0.5, lift - 0.8], [x, L * 0.5, bed_slat_t + 0.3]);

    // RV bar bubble level, screwed to the driver-side rail's outer
    // EDGE (the 3/4" face) at mid-span — reads fore-aft PITCH from
    // the slider door while the leg-foot knobs are being turned
    ifill("DimGray") translate([-W/2 - 0.25, L * 0.5 - 1.25, 0.08]) cube([0.25, 2.5, 0.6]);

    marker3d(1, [-W/2 + RW/2, L * 0.85, bed_slat_t], [-12, -6]);
    marker3d(2, [0, bed_slat_width/2, lift + bed_slat_t], [10, 10]);
    marker3d(3, [-W/2 + RW + 0.6, L * 0.4, lift + bed_slat_t/2], [-14, 4]);
    marker3d(4, [-W/2 - 0.1, L * 0.5, 0.4], [-13, 8]);

    cap(str("BED PLATFORM — flush ladder, exploded (Component 2, ", L, "\" x ", W, "\", ", bed_slat_count, " slats, ", bed_frame_thickness, "\" thick total)"), 13, -14, 1.9);
    cap("One 3/4\" plane: slats sit BETWEEN the two full-length side rails, pocket-screwed — no battens below, nothing above.", 13, -17, 1.3);
    cap("Rests DIRECTLY on Panel A/B's top rails and ENDS at the B/C seam, flush with Panel C's deck (the mattress's last ~20\" rides that deck).", 13, -19.5, 1.3);

    side_list(W/2 + 24, L * 0.55 + 16, [
        ["1", "Side rails (x2)", str(L, "\" x ", RW, "\" x ", bed_slat_t, "\" — 1x4 pine, full length"), "the platform's spine — slats screw into their inner edges"],
        ["2", str("Slats (x", bed_slat_count, ")"), str(SL, "\" x ", bed_slat_width, "\" x ", bed_slat_t, "\" — 1x4 pine, two per 8ft board"), str("~", round(slat_gap * 10) / 10, "\" gaps — fine for a foam mattress")],
        ["3", "Pocket screws", "2x 1-1/4\" pocket-hole screws per slat end", "Kreg-style jig; or 2\" corner braces if you don't have one"],
        ["4", "Bubble level (PITCH)", "Larbeti stick-on bar level (self-adhesive — degrease the rail edge first)", "its twin (ROLL) mounts on the rear-pantry deck edge — read while leveling"],
    ]);
}

drawing();
