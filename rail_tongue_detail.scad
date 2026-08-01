// ============================================================
// Tongue -> 2nd-row rail connection detail (Section 8)
// ============================================================
// The anchor board's PRIMARY forward connection: two steel flat-bar
// tongues running forward off the board's bridge to the rear ends of the
// 2nd row's long-slide floor rails — the strongest bolted-to-floor steel
// in the cabin, and the whole reason this design needs no new holes.
//
// What the Aug 2026 survey settled, and why this sheet exists:
//   F8a — the rail rear ends measure 42" from the closed hatch, so the
//         tongues are SHORT: 16" overall, only 9" of open span.
//   F8's "what is AT each end" question is answered by the photos —
//         a moulded PLASTIC END CAP with one exposed fastener, and an
//         OPEN-TOP TRACK CHANNEL under it. That is the best of the three
//         cases the survey was written to tell apart: the tongue can
//         bolt into the vehicle's own seat-track steel.
//   F7 removed the alternative — there is no hard square step face at
//         the striker row to butt the tongues against (carpet over a
//         soft ~1" step), so this connection is not optional any more.
//
// The FORWARD LOAD goes through a butt joint — a downturned lug on the
// tongue bearing on the rail's rear end face — not through a fastener.
// The rail's slot runs fore-aft, the same way as the load, so anything
// sitting in it resists forward motion by friction alone (~215lb per
// bolt). Bearing beats that by orders of magnitude. Three HOLD-DOWN
// options are drawn because only their convenience differs now.
//
// DRAWING CONVENTION: line-art, in the same house style as the survey
// sheets — RED is the thing this drawing is about (the tongue and its
// fasteners), GRY is context (the van, the rails, the board). Each band
// declares its own scale and converts explicitly; do not mix them.
//
// Render with: openscad -o renders/rail-tongue-detail.svg rail_tongue_detail.scad
// ============================================================

include <params.scad>
include <van_plan.scad>   // also pulls in sheet2d.scad — the shared 2D
                          // primitives. Same include order as the other
                          // bordered sheets; van_plan does NOT bring params.

// Vertical budget, bottom to top — keep the bands inside these:
//   band 3 (cases)  8..52     band 2 (section) 58..104
//   band 1 (plan) 108..172    header         176..190
SW = 200;   // sheet
SH = 195;

// ---------- small shared bits ----------------------------------
// a bolt seen end-on (plan) — ring with a cross
module bolt_plan(x, y, r = 1.2, col = RED) {
    color(col) {
        difference() { circle(r = r, $fn = 28); circle(r = r - 0.34, $fn = 28); }
        translate([-r, -0.17]) square([2 * r, 0.34]);
        translate([-0.17, -r]) square([0.34, 2 * r]);
    }
}
// a bolt seen from the side: head, shank, nut
module bolt_side(x, y, len, col = RED, head_w = 3.0) {
    color(col) translate([x, y]) {
        translate([-head_w / 2, 0]) square([head_w, 1.5]);           // head
        translate([-0.45, -len]) square([0.9, len]);                 // shank
        translate([-head_w / 2 * 0.9, -len]) square([head_w * 0.9, 1.4]); // nut
    }
}

// ============================================================
// BAND 1 — PLAN: both tongues, bridge to rail ends
// ============================================================
S1 = 1.6;                       // sheet units per model inch
function p1x(mx) = 30 + mx * S1;         // model x 0..46 across the board
function p1y(my) = 108 + (my - 20) * S1; // model y = inches forward of the closed hatch

module plan_band() {
    txt("1  PLAN — looking down. Board's bridge at the bottom, both rails running forward.",
        6, 166, 3.0, "left", "Black");

    // ---- the anchor board: bridge full width + comb strips broken off
    color(GRY) {
        rect_ol(p1x(0), p1y(aboard_depth - aboard_bridge_d), 46 * S1, aboard_bridge_d * S1, MED);
        for (sx = [1.5, 46 / 2 - aboard_strip_w / 2, 46 - 1.5 - aboard_strip_w])
            rect_ol(p1x(sx), p1y(20), aboard_strip_w * S1, (aboard_depth - aboard_bridge_d - 20) * S1, THIN);
    }
    // Both of these used to sit inside the plan and got crossed by the
    // tongues / the comb strips — they live in the note column now.
    txt(str("anchor board bridge — 46\" x ", aboard_bridge_d, "\", 3/4\" ply on its mat"),
        p1x(46) + 6, p1y(31), 2.2, "left", GRY);
    txt("its comb strips continue on to the tailgate", p1x(46) + 6, p1y(29.2), 2.1, "left", GRY);

    // ---- the two rails, from their rear ends forward off the crop
    for (s = [-1, 1]) {
        cx = 23 + s * rail_spacing / 2;
        color(GRY) {
            rect_ol(p1x(cx - 0.8), p1y(rail_end_y), 1.6 * S1, (48 - rail_end_y) * S1, MED);
            rect_ol(p1x(cx - 0.4), p1y(rail_end_y), 0.8 * S1, (48 - rail_end_y) * S1, THIN);
        }
        // the plastic end cap that has to come off, shown dashed in place
        color("Black") dash_rect(p1x(cx - 0.9), p1y(rail_end_y - 1.6), 1.8 * S1, 1.6 * S1, THIN);

        // ---- the tongue, in red: lap on the bridge -> span -> rail
        color(RED) rect_ol(p1x(cx - aboard_tongue_w / 2),
                           p1y(aboard_depth - tongue_lap),
                           aboard_tongue_w * S1, tongue_len * S1, HEAVY);
        // 2 bolts down through the bridge, 1 up into the rail channel
        translate([p1x(cx), p1y(aboard_depth - tongue_lap + 1)]) bolt_plan(0, 0, 1.1);
        translate([p1x(cx), p1y(aboard_depth - 1)]) bolt_plan(0, 0, 1.1);
        translate([p1x(cx), p1y(rail_end_y + tongue_engage / 2)]) bolt_plan(0, 0, 1.4);
    }

    // ---- notes off to the right
    nx = p1x(46) + 6;
    txt("rail rear end — the moulded plastic END CAP", nx, p1y(rail_end_y - 0.5), 2.3, "left", "Black");
    txt("comes off first (one fastener). Keep it: it goes", nx, p1y(rail_end_y - 2.4), 2.1, "left", "Black");
    txt("back on when the seats do.", nx, p1y(rail_end_y - 4.3), 2.1, "left", "Black");
    txt("Under it the rail is an OPEN-TOP CHANNEL —", nx, p1y(rail_end_y + 4), 2.1, "left", RED);
    txt("that slot takes the HOLD-DOWN bolt (H1/H2) — not the load.", nx, p1y(rail_end_y + 2.1), 2.1, "left", RED);
    txt(str("tongue: ", aboard_tongue_w, "\" x 3/16\" steel flat bar, ", tongue_len, "\" long"),
        nx, p1y(aboard_depth + 1), 2.3, "left", RED);
    txt(str(tongue_lap, "\" lapped on the bridge (2 bolts) + ", tongue_span, "\" span + ",
            tongue_engage, "\" on the rail"), nx, p1y(aboard_depth - 1), 2.1, "left", RED);

    // ---- dimensions
    dim_y(p1y(aboard_depth), p1y(rail_end_y), p1x(0) - 5, str(tongue_span, "\" open span"), 2.3, RED, "left");
    dim_x(p1x(23 - rail_spacing / 2), p1x(23 + rail_spacing / 2), 158,
          str(rail_spacing, "\" rail spacing — ESTIMATED off the photo, TAPE IT"), 2.3, RED, 4);
    // NOT drawn as a dimension line: 42" from the hatch would be a
    // 67-unit leader straight down through the section band below, so it
    // lives in the note column instead.
    txt(str("rail ends: ", rail_end_y, "\" forward of the closed hatch (F8a)"),
        p1x(46) + 6, p1y(rail_end_y + 6), 2.3, "left", RED);
}

// ============================================================
// BAND 2 — SIDE SECTION through one tongue
// ============================================================
SX = 5.2;   // sheet units per model inch, along the run
SZ = 9;     // ...and vertically. Deliberately exaggerated: the parts are
            // fractions of an inch thick over a 16" run.
function s2x(mx) = 16 + (mx + 8) * SX;
function s2z(mz) = 72 + mz * SZ;

module side_band() {
    txt("2  SIDE SECTION through one tongue — vertical scale exaggerated",
        6, 100, 3.0, "left", "Black");
    txt("Forward load path: board -> tongue -> its END FACE + PIN -> the rail's structural steel END CAP -> the rail's floor bolts.",
        6, 96, 2.2, "left", GRY);
    txt("Bearing plus shear, not friction. Nothing is drilled into the van, and every part of this comes back apart.",
        6, 93, 2.2, "left", GRY);

    // van floor pan
    color(GRY) translate([s2x(-8), s2z(0) - 1.1]) square([s2x(20) - s2x(-8), 1.1]);
    txt("van floor pan", s2x(-8), s2z(0) - 17.2, 2.0, "left", GRY);
    // carpet over the open span
    color(GRY) rect_ol(s2x(0), s2z(0), s2x(9) - s2x(0), 0.3 * SZ, THIN);
    txt("carpet", s2x(3.5), s2z(0.15), 2.0, "left", GRY);

    // anchor board: mat + ply bridge
    color(GRY) {
        rect_ol(s2x(-8), s2z(0), s2x(0) - s2x(-8), aboard_mat_t * SZ, THIN);
        rect_ol(s2x(-8), s2z(aboard_mat_t), s2x(0) - s2x(-8), aboard_t * SZ, MED);
    }
    txt("mat + 3/4\" ply bridge", s2x(-7.5), s2z(aboard_mat_t + aboard_t / 2) - 1, 2.1, "left", GRY);

    // the rail: METAL track to rail_top_z, PLASTIC housing above it
    color(GRY) {
        rect_ol(s2x(9), s2z(0), s2x(20) - s2x(9), rail_top_z * SZ, MED);           // metal
        rect_ol(s2x(9), s2z(rail_top_z), s2x(11.6) - s2x(9),
                (rail_housing_z - rail_top_z) * SZ, THIN);                          // plastic, near side
        rect_ol(s2x(14.4), s2z(rail_top_z), s2x(20) - s2x(14.4),
                (rail_housing_z - rail_top_z) * SZ, THIN);                          // plastic, far side
    }
    txt("2nd-row rail — METAL track", s2x(15.8), s2z(0) - 4, 2.0, "left", "Black");
    txt(str("top at ", rail_top_z, "\", ", rail_slot_w, "\" slot"), s2x(15.8), s2z(0) - 6.4, 1.9, "left", "Black");
    // No in-place label on the housing: it would land under the T-bolt
    // callout. It is named in the crush-tube note below instead.

    // CRUSH TUBE: carries the clamp load tongue -> metal, so the plastic
    // is never squeezed. This is what makes the housing survivable.

    txt(str("Variant (ii) instead runs the tongue ON over the rail for an in-slot hold-down; that one needs a crush tube so the ",
            rail_housing_z, "\" housing is not squeezed."), s2x(-8), s2z(0) - 14.6, 2.0, "left", GRY);

    // THE TONGUE, and the LUG that carries the forward load
    tz = s2z(aboard_top);
    color(RED) rect_ol(s2x(-5), tz, s2x(8.9) - s2x(-5), tongue_t * SZ, HEAVY);
    txt("steel tongue", s2x(1.5), tz + 3.8, 2.3, "left", RED);
    // NO LUG. The cap's hole is at 1.0in and the tongue's own mid-thickness
    // is at 0.94in, so the pin goes through the bar itself and the bar's
    // end face does the bearing. The tongue simply STOPS at the cap.
    // a plain 2D arrow: iarrow() lives in steps/lego_lib.scad, which this
    // sheet does not include (it is a sheet2d drawing, not a lego one).
    color(RED) {
        translate([s2x(5.6), s2z(0.22)]) square([s2x(8.2) - s2x(5.6), 0.55]);
        translate([s2x(8.2), s2z(0.22) - 0.9]) polygon([[0, 0], [0, 2.35], [2.4, 1.175]]);
    }
    // the PIN through the lug into the cap's measured 1/4" hole: this is
    // what makes the joint positive in shear without needing a nut
    // anywhere behind the cap.
    color(RED) rect_ol(s2x(8.9), s2z(0.22), s2x(9.9) - s2x(8.9), tongue_pin_d * SZ, MED);
    txt(str(tongue_pin_d, "\" PIN into the cap's hole"), s2x(10.2), s2z(0.34), 2.0, "left", RED);
    txt("The tongue STOPS at the cap: its own end face bears on the structural steel END CAP,", s2x(-8), s2z(0) - 4.2, 2.1, "left", RED);
    txt(str("and a ", tongue_pin_d, "\" PIN through the bar enters the cap's ", rail_cap_hole_d,
            "\" hole — measured ", rail_cap_hole_z, "\" up, centred."),
        s2x(-8), s2z(0) - 6.8, 2.1, "left", RED);
    txt("The hole is at the bar's own mid-thickness (0.94\"), so there is NO lug and no bend: drill the bar's end.",
        s2x(-8), s2z(0) - 9.4, 2.1, "left", RED);
    txt("Shear, so NO nut is needed behind the cap. Retain against lift with the H3 saddle.",
        s2x(-8), s2z(0) - 12, 2.1, "left", RED);

    // bolts: 2 down through the bridge (nylock under), 1 into the channel
    for (bx = [-5.5, -1.5])
        bolt_side(s2x(bx) + 6, tz + tongue_t * SZ, aboard_top * SZ + 3.2);
    txt("2x 1/4\"-20 through the bridge,", s2x(-8), tz + 9, 2.2, "left", RED);
    txt("washer + NYLOCK under the board", s2x(-8), tz + 6, 2.2, "left", RED);





    dim_y(s2z(rail_top_z), tz, s2x(19), str(-tongue_step, "\" step"), 2.1, RED, "right");
}

// ============================================================
// BAND 3 — the three HOLD-DOWN options
// ============================================================
module case_box(i, title, lines) {
    x0 = 6 + i * 63.5;
    y0 = 8;
    w = 60;
    h = 34;
    inset(x0, y0, w, h, title) {
        // graphic sits ABOVE the note lines, not on top of them
        gx = x0 + 5;
        gy = y0 + 19;
        // rail in section, common to all three
        color(GRY) {
            rect_ol(gx, gy, 30, 7, MED);
            if (i != 2) rect_ol(gx + 10, gy + 4.4, 10, 2.6, THIN);
        }
        // the tongue over it
        color(RED) rect_ol(gx + 2, gy + 7, 28, 1.7, MED);
        if (i == 0) {                       // T-bolt into the channel
            color(RED) {
                translate([gx + 14.5, gy + 4.6]) square([1.0, 5.2]);
                translate([gx + 12, gy + 4.6]) square([6, 1.0]);       // the T, turned
                translate([gx + 13, gy + 8.7]) square([4, 1.4]);       // nut on top
            }
        } else if (i == 1) {                // saddle clamp under the flanges
            color(RED) {
                translate([gx + 6, gy - 2.2]) square([20, 1.2]);
                translate([gx + 6, gy - 2.2]) square([1.2, 10.1]);
                translate([gx + 24.8, gy - 2.2]) square([1.2, 10.1]);
            }
        } else {                            // into the cap's own boss
            color(GRY) rect_ol(gx + 22, gy, 8, 7, THIN);
            color(RED) translate([gx + 25.5, gy + 1.6]) square([1.0, 7.1]);
        }
        for (j = [0 : len(lines) - 1])
            txt(lines[j], x0 + 3, y0 + 14 - j * 2.6, 1.95, "left", "Black");
    }
}

module cases_band() {
    txt("3  HOLD-DOWN OPTIONS — the lug carries the load; these only stop the tongue lifting",
        6, 47, 3.0, "left", "Black");
    case_box(0, "H1 — T-bolt in the slot", [
        "Slot MEASURED 3/4\" wide, channel 1\" deep.",
        "Stock 1/4\"-20 T-track bolt, ~1-3/4\" long,",
        "turned 90 deg under the lips. Cheapest and",
        "testable today. NEEDS the slot to have",
        "undercut lips — the one thing unconfirmed."]);
    case_box(1, "H2 — RULED OUT (Aug 2026)", [
        "Slide a tapped bar in from the open end:",
        "IMPOSSIBLE. Under the plastic cap there is a",
        "STEEL cap over the channel and a PIN behind",
        "it blocking entry from the rear (photo).",
        "Recorded so it is not proposed again."]);
    case_box(2, "H3 — saddle clamp (DEFAULT)", [
        "A 2\" steel saddle wrapping under the rail's",
        "flanges, 2 bolts pinching it to the tongue.",
        "Touches the slot not at all, so it works",
        "even if there are no undercut lips, and it is",
        "unaffected by the pinned metal end cap."]);
}

// ============================================================
module sheet() {
    color("Black") rect_ol(0, 0, SW, SH, 0.5);
    txt("SECTION 8 — HOW THE STEEL TONGUES CONNECT TO THE 2ND-ROW RAILS",
        6, SH - 8, 3.5, "left", "Black");
    txt(str("MEASURED Aug 1 2026 (F8a): the rail rear ends sit ", rail_end_y,
            "\" from the closed hatch. The board is 46\" x ", aboard_depth,
            "\", so each tongue spans ", tongue_span, "\" of open floor — cut both ",
            tongue_len, "\" long."), 6, SH - 13, 2.4, "left", GRY);
    txt(str("ALL MEASURED Aug 2026: spacing ", rail_spacing, "\", slot ", rail_slot_w,
            "\" (standard 3/4\" T-track, so stock 1/4\"-20 T-bolts fit), metal track ",
            rail_top_z, "\" up, plastic housing ", rail_housing_z, "\" up."),
        6, SH - 17, 2.4, "left", "Black");
    txt("UNRESOLVED — DO NOT BUILD YET: this sheet assumes the cap's 1/4\" hole faces REARWARD so the pin enters horizontally. If it is",
        6, SH - 21, 2.4, "left", RED);
    txt("really a flat tab past the rail's end, the pin is VERTICAL, the tongue rests ON the tab, and there may be no bearing face. See Section 8.",
        6, SH - 24.5, 2.4, "left", RED);
    plan_band();
    side_band();
    cases_band();
}

sheet();
