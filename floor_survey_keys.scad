// ============================================================
// Rear-floor survey (F1-F8) — one WHOLE-VEHICLE plan per section
// ============================================================
// Appendix A's rear-floor survey used to be a table with thumbnail key
// maps of the cargo zone alone. It is now one section per measurement,
// and each gets a full page-width drawing of the WHOLE Sienna in plan,
// so the thing you are being asked to measure is located against the
// actual vehicle rather than an abstract rectangle.
//
// Every drawing is the same base plan — body outline, front seats, the
// empty 2nd-row bay with its long-slide floor rails, the folded 3rd row
// and its stowage well, the sliding-door openings, Panel C's footprint
// — with only that section's measurement drawn in RED, labelled, and
// dimensioned. F3 and F7 also carry a small section inset, because a
// depth and a step height cannot be shown in plan; F8 carries three
// detail bubbles for the rail-end cases you have to tell apart.
//
// Layout: the vehicle sits in the middle, fore-aft dimension lines go
// in the band ABOVE it, and the badge + wording for that section goes
// in the band BELOW it (with any insets to the right of the wording).
// Keeping text in its own band is what stops it colliding with the
// drawing or running off the sheet.
//
// Orientation: FRONT at the LEFT, TAILGATE at the RIGHT, matching the
// side-profile render. Looking down from above with the nose at the
// left puts the DRIVER side along the BOTTOM edge.
//
// Datum: the survey's own Y = 0 is the CLOSED HATCH, +Y forward, and
// its X = 0 is the DRIVER-side edge of the usable floor — the same
// datum every other Appendix A/8 drawing uses. sx()/sy() convert those
// survey coordinates into sheet coordinates, so the numbers in this
// file stay readable as survey numbers.
//
// The body outline is ILLUSTRATIVE (published Sienna exterior figures,
// ~200" x 78"); the interior features are the ASSUMED positions this
// very survey exists to confirm, so they are drawn dashed.
//
// Render with: openscad -o renders/survey-f1.svg -D key=1 floor_survey_keys.scad
//   key = 1..8  ->  F1..F8
// ============================================================

include <params.scad>
include <van_plan.scad>   // also pulls in sheet2d.scad — the shared 2D
                          // primitives and house style. Don't re-include it.

key = 1;

// ---- sheet + bands ------------------------------------------
SW = 230; SH = 158;

BODY_X0 = 12; BODY_L = 200; BODY_X1 = BODY_X0 + BODY_L;
BODY_Y0 = 44; BODY_W = 78;  BODY_Y1 = BODY_Y0 + BODY_W;
CL = BODY_Y0 + BODY_W/2;

DIM1_Y = 128; DIM2_Y = 137;      // fore-aft dimension lines, above the van
TITLE_Y = 152;                    // sheet title
CO_Y = 36;                        // first line of the section's wording
CO_X = 21;                        // its left margin (badge sits left of it)
INSET_X = 148;                    // insets live right of the wording

HATCH_X = BODY_X1 - 6;
FLOOR_Y0 = CL - van_interior_width/2;
FLOOR_Y1 = CL + van_interior_width/2;

function sx(y_survey) = HATCH_X - y_survey;
function sy(x_survey) = FLOOR_Y0 + x_survey;

// ASSUMED interior geography — what this survey goes and confirms
WELL_Y0 = 8;  WELL_Y1 = 30;
WELL_X0 = 3;  WELL_X1 = 43;
STRIKER_Y = 48;  STRIKER_X = [8, 23, 38];
RAILEND_Y = 44;  RAIL_X = [15, 30];  RAIL_FWD_Y = 118;
STEP_Y = 46;
ROW3_Y0 = 36; ROW3_Y1 = 52;
// seat/door label anchors, derived from the shared geometry (survey Y =
// distance forward of the hatch = canonical X - VP_HATCH)
SEAT_MID_Y = (VP_SEAT_X0 + VP_SEAT_X1)/2 - VP_HATCH;
DOOR_MID_Y = (VP_DOOR_X0 + VP_DOOR_X1)/2 - VP_HATCH;

// ---- primitives ---------------------------------------------





// fore-aft dimension: extension lines down to the feature, ticks, label



module loop_icon(x, y, r = 2.0, t = 0.7, col = GRY) {
    color(col) difference() {
        translate([x, y]) circle(r = r, $fn = 24);
        translate([x, y]) circle(r = r - t, $fn = 24);
    }
}

// the section's badge + wording, in the band below the vehicle
module callout(n, lines) {
    badge(n, 13, CO_Y);
    for (i = [0 : len(lines) - 1]) txt(lines[i], CO_X, CO_Y - i * 4.7, 3.0);
}


// ---- the shared base plan -----------------------------------
module van_base() {
    color("Black") rect_ol(0, 0, SW, SH, 0.5);

    // Body, glass, wheels, front seats, sliding doors and the hatch all
    // come from the SHARED plan geometry, so this and the platform
    // floorplan are literally the same vehicle. van_plan.scad's frame is
    // X = fore-aft from the REAR bumper, Y = lateral from the centreline;
    // this sheet runs fore-aft the other way (+Y survey = forward = -X
    // sheet), hence the mirror. Mirroring keeps the driver side on low y,
    // where this sheet labels it, and the steering wheel with it.
    translate([HATCH_X + VP_HATCH, CL]) mirror([1, 0]) vp_van_context();

    // usable floor between the wheel wells
    color(GRY) dash_rect(sx(van_interior_length), FLOOR_Y0, van_interior_length, van_interior_width, THIN);

    // 2nd-row bay: seats removed, rails remain
    color(GRY) for (rx = RAIL_X) {
        rect_ol(sx(RAIL_FWD_Y), sy(rx) - 1, RAIL_FWD_Y - RAILEND_Y, 2, THIN);
        for (t = [0 : 6 : RAIL_FWD_Y - RAILEND_Y - 4])
            translate([sx(RAILEND_Y) - t - 3, sy(rx) - 1]) square([1, 2]);
    }

    // folded 3rd row + the well under it
    color(GRY) {
        rect_ol(sx(ROW3_Y1), FLOOR_Y0, ROW3_Y1 - ROW3_Y0, van_interior_width, THIN);
        dash_rect(sx(WELL_Y1), sy(WELL_X0), WELL_Y1 - WELL_Y0, WELL_X1 - WELL_X0, THIN);
        dash_y(sx(STRIKER_Y), FLOOR_Y0, FLOOR_Y1, THIN);
        dash_rect(sx(panel_c_length), FLOOR_Y0, panel_c_length, van_interior_width, THIN);
    }
    for (s = STRIKER_X) loop_icon(sx(STRIKER_Y), sy(s));

    // ---- base labels. The cargo zone is tight, so these are placed on
    // two rows OUTSIDE the floor (passenger side) plus a row below it,
    // chosen so nothing lands on the striker column or a wheel well. ----
    txt("FRONT SEATS", sx(SEAT_MID_Y), CL - 26, 3.5, "center", GRY);
    txt("SLIDING DOOR", sx(DOOR_MID_Y), BODY_Y0 - 4.5, 3.5, "center", GRY);
    txt("SLIDING DOOR", sx(DOOR_MID_Y), BODY_Y1 + 4.5, 3.5, "center", GRY);
    txt("2nd ROW REMOVED", sx(88), CL + 14, 3.5, "center", GRY);
    txt("(carriages parked fwd)", sx(88), CL + 9.6, 3.0, "center", GRY);
    txt("PANEL C", sx(16), FLOOR_Y1 + 4, 3.5, "center", GRY);
    txt("STRIKERS", sx(STRIKER_Y), FLOOR_Y1 + 4, 3.4, "center", GRY);
    txt("WELL", sx(19), FLOOR_Y1 + 9.2, 3.4, "center", GRY);
    // Sits between the two rails (sy 23 is just under the centreline) and well
    // FORWARD, at sx(100). Every section's red overlay lives at the tailgate end
    // (sx < ~55: the strikers on F4, the 3rd row on F6, Panel C on F5), and at
    // sx(82) the red labels F4b/F6a were landing on this one. "FRONT SEATS" is
    // in a different lateral band (y 57 vs 81.5), so passing over it is fine.
    txt("long-slide FLOOR RAILS", sx(100), sy(23), 3.4, "center", GRY);
    txt("3rd ROW FOLDED", sx(50), FLOOR_Y1 + 9.2, 3.4, "center", GRY);

    txt("<- FRONT", 4, TITLE_Y, 4.2, "left", "Black");
    txt("TAILGATE ->", SW - 4, TITLE_Y, 4.2, "right", "Black");
    color(GRY) translate([BODY_X0 - 4, BODY_Y0 + 2]) rotate(90) text("DRIVER side", size = 3.4, valign = "center");
    color(GRY) translate([BODY_X0 - 4, BODY_Y1 - 2]) rotate(-90) text("PASSENGER side", size = 3.4, valign = "center");
    // datum note goes in the LEFT of the top band — the dimension lines all
    // live at the tailgate end, so nothing crosses it there
    txt("CLOSED HATCH (the right-hand edge) = the Y datum for all Appendix A measurements",
        4, 134, 3.0, "left", "Black");
    txt("Body outline illustrative. Dashed features were ASSUMED — the Aug 2026 survey confirmed or corrected each one.",
        4, 4, 3.0, "left", GRY);
}

// ============================================================
module f1() {
    color(RED) rect_ol(sx(panel_c_length), FLOOR_Y0, panel_c_length, van_interior_width, HEAVY);
    color(RED) intersection() {
        translate([sx(panel_c_length) + 1, FLOOR_Y0 + 1]) square([panel_c_length - 2, van_interior_width - 2]);
        union() {
            for (yy = [FLOOR_Y0 + 3 : 4 : FLOOR_Y1 - 2]) translate([sx(WELL_Y0 - 1), yy]) square([WELL_Y0 - 2, 0.7]);
            for (xx = [sx(WELL_Y1) : 4 : sx(WELL_Y0)]) for (yy = [FLOOR_Y0 + 3 : 4 : FLOOR_Y1 - 2])
                translate([xx, yy]) square([2, 0.7]);
            for (xx = [sx(panel_c_length) - 8 : 4.5 : sx(WELL_Y1)]) translate([xx, FLOOR_Y0 + 1]) rotate(52) square([26, 0.7]);
        }
    }
    callout("F1", [
        "MAP the load surface across Panel C's whole footprint: press and knock",
        "along it, and mark with masking tape which zones are SOLID PAN, which",
        "are the WELL/TUB (hollow underneath), and which are FOLDED SEATBACK.",
        "-> Tells you where the anchor board can bear solidly, and where it needs",
        "   filler blocking. Do it with the 3rd row folded exactly as in camper mode.",
    ]);
}

module f2() {
    color(RED) {
        dash_y(sx(WELL_Y0), sy(WELL_X0), sy(WELL_X1), HEAVY);
        dash_y(sx(WELL_Y1), sy(WELL_X0), sy(WELL_X1), HEAVY);
    }
    dim_x(HATCH_X, sx(WELL_Y0), DIM1_Y, "F2a", 3.6, RED, DIM1_Y - FLOOR_Y1 - 2);
    dim_x(HATCH_X, sx(WELL_Y1), DIM2_Y, "F2b", 3.6, RED, DIM2_Y - FLOOR_Y1 - 2);
    callout("F2", [
        "Fore-aft position of the STOWAGE WELL: where its rear and forward edges",
        "sit, both measured from the CLOSED HATCH — the same Y datum as every",
        "other Appendix A measurement.",
        "-> Sets the anchor board's strip lengths, and where filler blocking has",
        "   to start and stop.",
    ]);
}

module f3() {
    color(RED) rect_ol(sx(WELL_Y1), sy(WELL_X0), WELL_Y1 - WELL_Y0, WELL_X1 - WELL_X0, HEAVY);
    dim_y(sy(WELL_X0), sy(WELL_X1), sx(WELL_Y1) - 8, "F3a");
    callout("F3", [
        "The well's WIDTH across the van (in plan, at left),",
        "and its DEPTH below the surrounding load floor — a",
        "section dimension, see the inset at right.",
        "-> Sizes the filler blocking that carries a board",
        "   strip across the well, onto its structural bottom.",
    ]);
    inset(INSET_X, 6, 74, 30, "F3b  WELL DEPTH — section") {
        color("Black") {
            translate([INSET_X + 6, 25]) square([62, 0.7]);
            translate([INSET_X + 22, 12]) square([30, 0.7]);
            translate([INSET_X + 22, 12]) square([0.7, 13]);
            translate([INSET_X + 51.3, 12]) square([0.7, 13]);
        }
        txt("load floor", INSET_X + 6, 27.2, 3.2, "left", GRY);
        dim_y(12.7, 25, INSET_X + 19, "depth", 3.4);
        txt("structural bottom", INSET_X + 24, 9.6, 3.2, "left", GRY);
    }
}

module f4() {
    for (s = STRIKER_X) loop_icon(sx(STRIKER_Y), sy(s), 3.0, 1.1, RED);
    color(RED) dash_y(sx(STRIKER_Y), FLOOR_Y0, FLOOR_Y1, MED);
    dim_x(HATCH_X, sx(STRIKER_Y), DIM1_Y, "F4a", 3.6, RED, DIM1_Y - FLOOR_Y1 - 2);
    dim_y(sy(STRIKER_X[0]), sy(STRIKER_X[2]), sx(STRIKER_Y) - 9, "F4b");
    txt("F4c", sx(STRIKER_Y - 5), sy(STRIKER_X[2]), 3.6, "left", RED);   // each loop's inside clearance
    callout("F4", [
        "All 3 STRIKER LOOPS: each loop's fore-aft distance from the hatch, its",
        "lateral position, and its inside clearance — a strap hook has to SEAT in",
        "it. Check the folded seatbacks leave all 3 exposed and hookable.",
        "-> Sets Section 8's striker straps and the steel tongues' length. The",
        "   loops are confirmed PRESENT (photo, July 2026) but not yet measured.",
    ]);
}

module f5() {
    kx0 = 24.5;
    color(RED) {
        for (lx = [1.5, panel_width - 4.5]) for (ly = [1.5, panel_c_length - 4.5])
            translate([sx(ly + 3), sy(lx)]) square([3, 3]);
        rect_ol(sx(26), sy(kx0), 26, 20, HEAVY);
    }
    txt("F5a", sx(panel_c_length + 4), sy(1.5), 3.6, "right", RED);
    txt("F5b", sx(12), sy(kx0 + 10), 3.6, "center", RED);
    callout("F5", [
        "What Panel C's 4 LEG PADS (red squares) and the KITCHEN UNIT's footprint",
        "actually bear on: solid floor, or folded seatback? A deck leg standing on",
        "a seat cushion is springy — it won't sit level or solid.",
        "-> Drives leg_height, how level the deck ends up, and the kitchen unit's",
        "   strap-down.",
    ]);
}

module f6() {
    color(RED) {
        rect_ol(sx(ROW3_Y1), FLOOR_Y0, ROW3_Y1 - ROW3_Y0, van_interior_width, HEAVY);
        intersection() {
            translate([sx(ROW3_Y1) + 1, FLOOR_Y0 + 1]) square([ROW3_Y1 - ROW3_Y0 - 2, van_interior_width - 2]);
            union() for (xx = [sx(ROW3_Y1) - 26 : 4.5 : sx(ROW3_Y0)]) translate([xx, FLOOR_Y0]) rotate(52) square([34, 0.8]);
        }
        for (s = STRIKER_X) translate([sx(ROW3_Y0 - 2.5), sy(s) - 1.4]) square([2.8, 2.8]);
    }
    txt("F6a", sx(ROW3_Y1 + 4), CL, 3.6, "right", RED);
    txt("F6b", sx(ROW3_Y0 - 6), sy(WELL_X1 - 2), 3.6, "left", RED);
    callout("F6", [
        "Does a solid bearing surface require REMOVING the 3rd row rather than",
        "folding it? If so, does the 3rd row carry its own SRS / seatbelt-",
        "pretensioner wiring? Section 9 covers 2nd-row removal only, so this",
        "would be NEW scope (and possibly more emulators).",
        "-> Removal also exposes its own seat-mount bolts (red squares) as bolt-in",
        "   anchor-plate hardpoints — the strongest points in the zone, no new holes.",
    ]);
}

module f7() {
    color(RED) translate([sx(STEP_Y) - 0.8, FLOOR_Y0]) square([1.6 + HEAVY, van_interior_width]);
    txt("F7a", sx(STEP_Y + 4), sy(WELL_X1 - 2), 3.6, "right", RED);
    callout("F7", [
        "Is there a SQUARE, HARD vertical face at the step/riser",
        "by the striker row — metal under the trim? — for the two",
        "steel tongues to butt against, and how tall is it?",
        "-> The FALLBACK forward load path, in compression, if",
        "   F8 rules the rail ends out. Section at right.",
    ]);
    inset(INSET_X, 6, 74, 30, "F7b  STEP HEIGHT — section") {
        color("Black") {
            translate([INSET_X + 8, 13]) square([30, 0.7]);
            translate([INSET_X + 41.3, 13]) square([0.7, 11]);
            translate([INSET_X + 41.3, 23.3]) square([26, 0.7]);
        }
        color(RED) translate([INSET_X + 39.6, 13]) square([2, 11]);
        txt("cargo floor", INSET_X + 9, 15.2, 3.2, "left", GRY);
        txt("striker row", INSET_X + 45, 25.6, 3.2, "left", GRY);
        dim_y(13.7, 23.3, INSET_X + 37, "height", 3.4);
        txt("tongue butts ->", INSET_X + 8, 10, 3.2, "left", RED);
    }
}

module f8() {
    color(RED) for (rx = RAIL_X) {
        rect_ol(sx(RAILEND_Y + 16), sy(rx) - 1.4, 16, 2.8, MED);
        translate([sx(RAILEND_Y) - 3.4, sy(rx) - 2.4]) square([3.4, 4.8]);
    }
    dim_x(HATCH_X, sx(RAILEND_Y), DIM1_Y, "F8a", 3.6, RED, DIM1_Y - FLOOR_Y1 - 2);
    dim_y(sy(RAIL_X[0]), sy(RAIL_X[1]), sx(RAILEND_Y) - 20, "F8b");
    callout("F8", [
        "With the 2nd-row carriages parked fully FORWARD: where",
        "do the rails' REAR ends sit (from the hatch, and their",
        "lateral spacing), and what is AT each end? Photograph",
        "both close-up.",
        "-> Section 8's PRIMARY forward connection: the 2 steel",
        "   tongues bolt or clamp here, so this decides the",
        "   bracket detail and tongue length.",
    ]);
    // The three cases you have to tell apart. Bubbles widened 23 -> 26 and
    // taller, with 4.4 between the two caption lines instead of 3.4: at the
    // scaled-up text the second line was sitting on the first and on the
    // bubble's own bottom edge.
    for (i = [0 : 2]) translate([INSET_X + i * 27, 4]) {
        color("Black") round_ol(0, 4, 26, 30, 3, 0.45);
        color(GRY) rect_ol(5.5, 19, 15, 9, THIN);
        if (i == 1) { color("Black") translate([13, 23.5]) circle(r = 2.4, $fn = 20); }
        if (i == 2) { color(GRY) translate([7.5, 21.5]) square([11, 4]); }
        txt(i == 0 ? "end cap" : i == 1 ? "track bolt" : "open slot", 13, 13.4, 3.3, "center", "Black");
        txt(i == 0 ? "unclips?" : i == 1 ? "exposed?" : "or a lip?", 13, 9, 3.2, "center", GRY);
    }
    // Shares its row with the bottom SLIDING DOOR label on the plan above,
    // which measures out to x=153, and the bubbles below leave no room to move
    // down. So it is just the question — F8's wording already says what it
    // decides ("the bracket detail and tongue length").
    txt("Which is it?", INSET_X + 10, 40.5, 3.5, "left", "Black");
}

// ============================================================
van_base();
if      (key == 1) f1();
else if (key == 2) f2();
else if (key == 3) f3();
else if (key == 4) f4();
else if (key == 5) f5();
else if (key == 6) f6();
else if (key == 7) f7();
else               f8();
