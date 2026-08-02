// ============================================================
// Bed platform detail — exploded isometric reference, woodworking-
// plan style (see steps/lego_lib.scad).
// ============================================================
// Component 2: a FLUSH LADDER platform in THREE PIECES — but only TWO of
// them loose (Panel A's is screwed down) — all in
// one 3/4in plane, all cut from 1x4 x 8ft pine (crosscuts only — a 1x4
// is already 3/4 x 3-1/2, the slat spec, so nothing gets ripped):
//
//   * Panel A section (29 x 49in) — 2 side rails + 5 slats, SCREWED DOWN
//     and permanent (owner, Aug 2026). It never needed to lift: both of
//     Panel A's bays are reached through the side doors. Fixing it makes
//     it a diaphragm across Panel A's rails, puts back some of the
//     torsional stiffness lost when A and B gave up their plywood tops,
//     and makes it the datum the two loose halves locate against.
//   * Panel B halves (29 x 24.5in each) — 2 side rails + 5 short slats
//     each, split on the CENTRELINE, each lifting out on its own.
//     Owner's call, Aug 2026: Panel B is top-load-ONLY (the 35x45in
//     side door sits over Panel A, and only 29in of it is ever clear),
//     so this is its only access. 24.5in wide is what lets a half be
//     carried out THROUGH the side door — a 49in piece could not be.
//   * Centre bearer (26in of 3in-wide 2x2, in Panel B's frame) — the
//     halves' inner rails land on it. It also halves the bed's
//     unsupported span over Panel B, 46in -> ~22in; Panel B never had a
//     centre divider, so this is the stiffest the deck has been.
//
// Every piece bears on the boxes' own rails — nothing is carried by
// hardware, and there is no hinge to limit how far it opens. Leveling
// happens at the leg feet, floor level (leveling_foot_detail.scad).
//
// Render with: openscad -o renders/bed-frame-detail.svg bed_frame_detail.scad
// ============================================================

include <steps/lego_lib.scad>
include <colors.scad>

L  = bed_frame_length;  // 58 overall (Panel A section + Panel B halves)
W  = bed_frame_width;   // 49 (was 52 — cut back by measurement V7, Aug 2026)
RW = bed_rail_width;    // 3.5
SL = bed_slat_length;   // 42   — Panel A's slats, full width between its rails
LA = bed_sect_a_len;    // 29   — Panel A section, Y 0..29
LB = bed_bhalf_len;     // 29   — each Panel B half, Y 29..58
HW = bed_bhalf_width;   // 24.5 — each Panel B half, across the van
HS = bed_bhalf_slat_l;  // 17.5 — the short slats inside each half
lift = 6;               // how far slats float above their slots
riseB = 10;             // how far the Panel B halves float, to read as removable

// Badges are the ONLY text left on this sheet now that the prose moved to
// markdown, so they can be sized for the page rather than squeezed in
// beside paragraphs: r/size 2.0 prints near 11pt, where 1.3 printed at 7.
module marker3d(n, anchor3, off = [6, 4]) {
    q = p2(anchor3);
    t = q + off;
    color(marker_col(n)) translate(t) circle(r = 2.0);
    color("white") translate(t) text(str(n), size = 2.0, halign = "center", valign = "center");
    color(INK) line2d(q, t - off * (2.8 / max(2.8, norm(off))));
}

// (side_list is gone: the parts list it drew is a markdown table now.)


// one ladder piece: 2 side rails spanning y0..y0+len at x0..x0+wid,
// with n slats floating above their slots between them.
module ladder(x0, y0, wid, len, n, z_rail, z_slat) {
    for (x = [x0, x0 + wid - RW])
        wbox([x, y0, z_rail], [RW, len, bed_slat_t]);

    gap = (len - n * bed_slat_width) / (n - 1);
    for (i = [0 : n - 1]) {
        y = y0 + i * (bed_slat_width + gap);
        wbox([x0 + RW, y, z_slat], [wid - 2 * RW, bed_slat_width, bed_slat_t]);
        for (x = [x0 + RW + 0.6, x0 + wid - RW - 0.6])
            fastener([x, y + bed_slat_width/2, z_slat + bed_slat_t/2], 0.35, 90);
    }
}

module drawing() {
    // ---- Panel A section: 29 x 49, one piece, SCREWED DOWN ---------
    ladder(-W/2, 0, W, LA, bed_slat_n_a, 0, lift);
    for (x = [-W/2 + RW + SL * 0.25, -W/2 + RW + SL * 0.75])
        iarrow([x, LA * 0.5, lift - 0.8], [x, LA * 0.5, bed_slat_t + 0.3]);

    // ---- Panel B: two centreline halves, each lifting out ----------
    ladder(-W/2, LA, HW, LB, bed_slat_n_bhalf, riseB, riseB + lift);        // driver half
    ladder(0,    LA, HW, LB, bed_slat_n_bhalf, riseB, riseB + lift);        // passenger half
    // straight up and out — no hinge, no swing arc
    for (x = [-HW/2, HW/2])
        iarrow([x, LA + LB * 0.5, riseB + lift + 3], [x, LA + LB * 0.5, riseB + lift + 9]);

    // ---- centre bearer: part of Panel B's FRAME, not the platform ---
    // ctx = true -> drawn as existing context (Panel B's frame), not as
    // a part of this component. wbox handles the iso projection of both
    // the fill and the edge cage; hand-rolling it with projection()
    // under a 3D translate silently misplaces the outline.
    wbox([-bed_bearer_w/2, LA + frame_rail_sz, -frame_rail_sz],
         [bed_bearer_w, bed_bearer_len, frame_rail_sz], [0, 0], true);

    // RV bar bubble level, on the driver-side rail's outer EDGE (the
    // 3/4" face) at mid-span of the Panel A section — reads fore-aft
    // PITCH from the slider door while the leg-foot knobs are turned
    ifill("DimGray") translate([-W/2 - 0.25, LA * 0.5 - 1.25, 0.08]) cube([0.25, 2.5, 0.6]);

    // Leaders point LEFT/DOWN into open page space — the parts list
    // occupies the right-hand side.
    marker3d(1, [-W/2 + RW/2, LA * 0.8, bed_slat_t], [-12, -6]);
    marker3d(2, [0, bed_slat_width/2, lift + bed_slat_t], [11, -7]);
    marker3d(3, [-W/2 + RW/2, LA + LB * 0.55, riseB + bed_slat_t], [-15, -3]);
    marker3d(4, [HW/2, LA + LB * 0.3, riseB + lift + bed_slat_t], [13, 6]);
    marker3d(5, [0, LA + bed_bearer_len * 0.7, -frame_rail_sz/2], [-17, -9]);
    marker3d(6, [-W/2 - 0.1, LA * 0.5, 0.4], [-13, 9]);

    // The four caption lines and the six-row parts list that used to sit
    // here are MARKDOWN now (Section "Bed Platform Detail"). They took the
    // sheet to 160 units wide, and a figure's printed text height is
    // size x (page_width / sheet_width) — so every label on it landed at
    // 3-4pt. With only the drawing and its numbered markers left, the
    // sheet is ~60 wide and the same labels print near 10pt.
    // Keep it that way: no paragraphs on this sheet.
    // -17/-21: the exploded far rail reaches to about -10 in page space,
    // so anything higher than this prints over it.
    cap(str(L, "\" x ", W, "\" overall — ", bed_slat_count, " slats in one 3/4\" plane"),
        0, -17, 2.6);
    cap("1-6 keyed to the parts table in the text", 0, -21, 2.2);
}

drawing();
