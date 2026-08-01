// ============================================================
// Van measurements (V1-V10) — one WHOLE-VEHICLE plan per section
// ============================================================
// The companion to floor_survey_keys.scad, in the same format and for
// the same reason: the "measure the van" checklist was a table, and a
// table can tell you a dimension's name but not where on the vehicle to
// put the tape. Each section now gets a full page-width plan of the
// Sienna with just its own measurement drawn in red and dimensioned.
//
// The body, glass, wheels, front seats, sliding doors and hatch come
// from the SHARED van_plan.scad, so these read as the same vehicle as
// the Section 0 survey plans and the platform floorplan.
//
// Several of these are NOT plan dimensions — interior height, the gate
// opening, wall-to-wall width up at platform height, floor slope — so
// those keys carry an ELEVATION or SECTION inset as well, and the plan
// just locates where the inset is taken.
//
// Layout matches the survey plans: vehicle in the middle, fore-aft
// dimensions in the band above it, badge + wording in the band below,
// insets to the right of the wording.
//
// Orientation: FRONT at the LEFT, TAILGATE at the RIGHT; driver side
// along the bottom. Fore-aft datum is the CLOSED HATCH, as everywhere
// else in Section 0.
//
// Render with: openscad -o renders/vanmeas-v1.svg -D key=1 van_measure_keys.scad
//   key = 1..10  ->  V1..V10
// ============================================================

include <params.scad>
include <van_plan.scad>   // also pulls in sheet2d.scad — the shared 2D
                          // primitives and house style. Don't re-include it.

key = 1;

SW = 230; SH = 158;

BODY_X0 = 12; BODY_X1 = BODY_X0 + VP_L;
BODY_Y0 = 44; BODY_Y1 = BODY_Y0 + VP_W;
CL = BODY_Y0 + VP_W/2;

DIM1_Y = 128; DIM2_Y = 137;
TITLE_Y = 152;
CO_Y = 32; CO_X = 21;
INSET_X = 126;

HATCH_X = BODY_X1 - VP_HATCH;
FLOOR_Y0 = CL - van_interior_width/2;
FLOOR_Y1 = CL + van_interior_width/2;

function sx(y) = HATCH_X - y;          // y = distance forward of the closed hatch
function sy(x) = FLOOR_Y0 + x;         // x = distance from the driver-side floor edge

SEAT_MID_Y = (VP_SEAT_X0 + VP_SEAT_X1)/2 - VP_HATCH;
DOOR_Y0 = VP_DOOR_X0 - VP_HATCH;       // sliding-door opening, in survey Y
DOOR_Y1 = VP_DOOR_X1 - VP_HATCH;

// ---- helpers -------------------------------------------------
module callout(n, lines) {
    badge(n, 13, CO_Y);
    for (i = [0 : len(lines)-1]) txt(lines[i], CO_X, CO_Y - i*4.7, 3.0);
}

// ---- the shared base plan ------------------------------------
module van_base() {
    color("Black") rect_ol(0, 0, SW, SH, 0.5);
    translate([HATCH_X + VP_HATCH, CL]) mirror([1, 0]) vp_van_context();

    // the usable interior floor, and the vent intrusion strips at its edges
    color(GRY) {
        dash_rect(sx(van_interior_length), FLOOR_Y0, van_interior_length, van_interior_width, THIN);
        dash_x(sy(vent_intrusion_width), sx(van_interior_length), HATCH_X, THIN);
        dash_x(sy(van_interior_width - vent_intrusion_width), sx(van_interior_length), HATCH_X, THIN);
    }

    txt("FRONT SEATS", sx(SEAT_MID_Y), CL - 26, 2.7, "center", GRY);
    txt("SLIDING DOOR", sx((DOOR_Y0+DOOR_Y1)/2), BODY_Y0 - 4.5, 2.7, "center", GRY);
    txt("SLIDING DOOR", sx((DOOR_Y0+DOOR_Y1)/2), BODY_Y1 + 4.5, 2.7, "center", GRY);
    txt("usable interior floor (2nd row OUT)", sx(60), CL, 2.7, "center", GRY);

    txt("<- FRONT", 4, TITLE_Y, 3.2, "left", "Black");
    txt("TAILGATE ->", SW - 4, TITLE_Y, 3.2, "right", "Black");
    color(GRY) translate([BODY_X0 - 4, BODY_Y0 + 2]) rotate(90) text("DRIVER side", size = 2.7, valign = "center");
    color(GRY) translate([BODY_X0 - 4, BODY_Y1 - 2]) rotate(-90) text("PASSENGER side", size = 2.7, valign = "center");
    txt("CLOSED HATCH (the right-hand edge) = the fore-aft datum", 4, 134, 2.6, "left", "Black");
    txt("Body outline illustrative. Interior features are drawn at the MEASURED dimensions (owner, Aug 1 2026) — this is a record, not a checklist.",
        4, 1.6, 2.6, "left", GRY);
}

// ============================================================
// V1 — interior length, closed hatch to front seatbacks
// ============================================================
module v1() {
    color(RED) {
        dash_y(sx(van_interior_length), FLOOR_Y0 - 3, FLOOR_Y1 + 3, HEAVY);
        translate([HATCH_X - 0.8, FLOOR_Y0 - 3]) square([1.6, van_interior_width + 6]);
    }
    dim_x(HATCH_X, sx(van_interior_length), DIM1_Y, "V1", 2.9, RED, DIM1_Y - FLOOR_Y1 - 2);
    callout("V1", [
        "INTERIOR LENGTH — closed hatch to the front seatbacks, along the floor.",
        "This is the number the whole panel train is sized against: Panel A + B + C",
        "fill it exactly, so if it comes back short every panel shrinks.",
        "-> params.scad: van_interior_length. MEASURED 93.75\" (Aug 2026)",
        "   — 2.25\" under the old 96\" estimate; Panel C absorbed it.",
    ]);
}

// ============================================================
// V2 — interior width, between the wheel wells
// ============================================================
module v2() {
    color(RED) {
        dash_y(sx(van_interior_length), FLOOR_Y0, FLOOR_Y1, MED);
        dash_x(FLOOR_Y0, sx(van_interior_length), HATCH_X, HEAVY);
        dash_x(FLOOR_Y1, sx(van_interior_length), HATCH_X, HEAVY);
    }
    dim_y(FLOOR_Y0, FLOOR_Y1, sx(70), "V2");
    callout("V2", [
        "INTERIOR WIDTH at the FLOOR — the pinch between the two wheel wells,",
        "measured at its narrowest, not at a wider spot fore or aft of them.",
        "Every 46\"-wide panel and the floor envelope come off this.",
        "-> params.scad: van_interior_width. MEASURED 49\" at the pinch",
        "   (54\" forward of the wheel wells) — Aug 2026.",
    ]);
}

// ============================================================
// V3 — interior height, floor to headliner (elevation)
// ============================================================
module v3() {
    color(RED) dash_y(sx(50), FLOOR_Y0, FLOOR_Y1, HEAVY);
    txt("section taken here", sx(50), FLOOR_Y1 + 4.5, 2.6, "center", RED);
    callout("V3", [
        "INTERIOR HEIGHT — cargo floor up to the headliner, at the",
        "sleeping run (not at the tailgate, where the roof drops).",
        "-> params.scad: van_interior_height. MEASURED 42\" mid-van",
        "   (37\" back at the gate) — Aug 2026. It caps the whole",
        "   stack: deck + mattress + sitting headroom (now 19.5\").",
    ]);
    inset(INSET_X, 6, 98, 30, "V3  REAR SECTION — floor to headliner") {
        color("Black") {
            translate([INSET_X + 20, 8]) square([58, 0.7]);              // floor
            translate([INSET_X + 20, 27]) square([58, 0.7]);             // headliner
            translate([INSET_X + 20, 8]) square([0.7, 19]);
            translate([INSET_X + 77.3, 8]) square([0.7, 19]);
        }
        txt("headliner", INSET_X + 22, 29, 2.4, "left", GRY);
        txt("cargo floor", INSET_X + 22, 6, 2.4, "left", GRY);
        dim_y(8.7, 27, INSET_X + 15, "V3", 2.7);
    }
}

// ============================================================
// V4 — vent intrusion width, each side, at floor level
// ============================================================
module v4() {
    color(RED) {
        dash_x(sy(vent_intrusion_width), sx(van_interior_length), HATCH_X, HEAVY);
        dash_x(sy(van_interior_width - vent_intrusion_width), sx(van_interior_length), HATCH_X, HEAVY);
    }
    // the strips are only ~2.5" wide, so a centred dim label lands on top
    // of the line — put the tags outboard of the floor edges instead
    dim_y(FLOOR_Y0, sy(vent_intrusion_width), sx(24), "", 2.9, RED, "left");
    dim_y(sy(van_interior_width - vent_intrusion_width), FLOOR_Y1, sx(24), "", 2.9, RED, "right");
    txt("V4a", sx(24), FLOOR_Y0 - 5, 2.9, "center", RED);
    txt("V4b", sx(24), FLOOR_Y1 + 5, 2.9, "center", RED);
    callout("V4", [
        "VENT INTRUSION at FLOOR LEVEL, one measurement per side: how far the",
        "floor vent / trim kick eats into the usable width down at the floor.",
        "The deck may overhang it, but a LEG may not stand on it.",
        "-> params.scad: vent_intrusion_width. MEASURED 3.5\" per side",
        "   (Aug 2026) — 1\" deeper each side than assumed; leg_inset grew.",
    ]);
}

// ============================================================
// V5 — hatch curvature clearance
// ============================================================
module v5() {
    color(RED) {
        dash_y(sx(hatch_curvature_clearance), FLOOR_Y0, FLOOR_Y1, HEAVY);
        translate([HATCH_X - 0.8, FLOOR_Y0]) square([1.6, van_interior_width]);
    }
    dim_x(HATCH_X, sx(hatch_curvature_clearance), DIM1_Y, "V5", 2.9, RED, DIM1_Y - FLOOR_Y1 - 2);
    callout("V5", [
        "HATCH CURVATURE CLEARANCE — how far forward of the closed hatch you have",
        "to stop building, because the glass and trim curve inward above the floor.",
        "-> params.scad: hatch_curvature_clearance. MEASURED 0\" (Aug 2026):",
        "   the build never rises high enough to reach the curvature, so",
        "   nothing is reserved and the panels total the full 93.75\".",
    ]);
}

// ============================================================
// V6 — the gate opening: narrowest width, and height (elevation)
// ============================================================
module v6() {
    color(RED) translate([HATCH_X - 0.8, FLOOR_Y0 - 4]) square([1.6 + HEAVY, van_interior_width + 8]);
    txt("elevation taken at the open tailgate ->", sx(14), FLOOR_Y1 + 4.5, 2.6, "right", RED);
    callout("V6", [
        "The TAILGATE (gate) opening, from outside at the open",
        "hatch: WIDTH at its NARROWEST point (V6a), and HEIGHT",
        "where the rounded corners start cutting in (V6b).",
        "-> MEASURED Aug 2026: gate_opening_width 50\",",
        "   gate_opening_height 37\" at the centre — but only",
        "   20.5\" at the corner radius. Carry modules up the MIDDLE.",
    ]);
    inset(INSET_X, 6, 98, 30, "V6  REAR ELEVATION — the gate opening") {
        // opening with radiused corners, drawn small-scale
        color("Black") translate([INSET_X + 26, 7]) difference() {
            offset(r = 4) translate([4, 4]) square([44, 16]);
            offset(r = 3.4) translate([4, 4]) square([44, 16]);
        }
        dim_x(INSET_X + 26, INSET_X + 78, 25.5, "V6a", 2.6);
        dim_y(7, 31, INSET_X + 22, "V6b", 2.6);
        txt("measure the NARROWEST width and the height", INSET_X + 26, 4.6, 2.3, "left", GRY);
        txt("where the corner radius starts", INSET_X + 26, 2.2, 2.3, "left", GRY);
    }
}

// ============================================================
// V7 — wall-to-wall width up at platform height
// ============================================================
module v7() {
    color(RED) {
        dash_x(FLOOR_Y0 - 2.5, sx(80), HATCH_X, HEAVY);
        dash_x(FLOOR_Y1 + 2.5, sx(80), HATCH_X, HEAVY);
        translate([sx(80) - 0.8, FLOOR_Y0 - 2.5]) square([1.6, van_interior_width + 5]);
    }
    dim_x(HATCH_X, sx(80), DIM1_Y, "along the whole sleeping run", 2.9, RED, DIM1_Y - FLOOR_Y1 - 4);
    callout("V7", [
        "WALL-TO-WALL WIDTH at PLATFORM HEIGHT — at ~18.5\"",
        "(V7a) and ~22.5\" (V7b) above the floor. 49\" is the",
        "FLOOR pinch; the walls were ASSUMED to flare wider up.",
        "-> MEASURED Aug 2026: they do NOT — 50\" and 49.5\",",
        "   against the >= 53\" needed. So bed_frame_width was",
        "   cut 52\" -> 49\", and the slats 45\" -> 42\".",
    ]);
    inset(INSET_X, 6, 98, 30, "V7  REAR SECTION — width vs. height") {
        color("Black") {
            translate([INSET_X + 22, 7]) square([54, 0.7]);                 // floor
            translate([INSET_X + 22, 7]) square([0.7, 24]);                 // driver wall, flaring
            translate([INSET_X + 75.3, 7]) square([0.7, 24]);
        }
        color(RED) {
            translate([INSET_X + 20, 15]) square([58, 0.6]);   // ~18.5"
            translate([INSET_X + 19, 22]) square([60, 0.6]);   // ~22.5"
        }
        txt("V7a ~18.5\"", INSET_X + 79, 15.3, 2.4, "left", RED);
        txt("V7b ~22.5\"", INSET_X + 79, 22.3, 2.4, "left", RED);
        txt("floor pinch 49\"", INSET_X + 24, 9.2, 2.3, "left", GRY);
    }
}

// ============================================================
// V8 — the side sliding door opening
// ============================================================
module v8() {
    color(RED) for (dy = [BODY_Y0 - 2, BODY_Y1 + 0.6])
        translate([sx(DOOR_Y1), dy]) square([DOOR_Y1 - DOOR_Y0, 1.4]);
    dim_x(sx(DOOR_Y1), sx(DOOR_Y0), DIM1_Y, "V8a", 2.9, RED, DIM1_Y - BODY_Y1 - 3);
    callout("V8", [
        "The SIDE SLIDING DOOR: fore-aft WIDTH (V8a), HEIGHT",
        "(V8b), and the one that actually matters — the USABLE",
        "CLEAR width/height at the door's real STOPPING POINT (V8c).",
        "-> MEASURED Aug 2026: aperture 35 x 45\", but the door parks",
        "   6\" short of its forward edge, so the usable CLEAR gap is",
        "   only 29\" — 11\" tighter than the 40\" assumed.",
    ]);
    inset(INSET_X, 6, 98, 30, "V8  SIDE ELEVATION — the door opening") {
        color("Black") translate([INSET_X + 24, 8]) difference() {
            offset(r = 3) translate([3, 3]) square([46, 16]);
            offset(r = 2.5) translate([3, 3]) square([46, 16]);
        }
        dim_x(INSET_X + 24, INSET_X + 76, 26, "V8a", 2.6);
        dim_y(8, 30, INSET_X + 20, "V8b", 2.6);
        color(RED) translate([INSET_X + 33, 9]) square([34, 0.6]);
        txt("V8c = clear at the door's actual stop", INSET_X + 24, 5.4, 2.3, "left", RED);
    }
}

// ============================================================
// V9 — the two AC outlets (both verified)
// ============================================================
module v9() {
    front_x = sx(VP_SEAT_X1 - VP_HATCH + 4);
    color(RED) {
        translate([front_x - 1.6, CL - 1.6]) square([3.2, 3.2]);          // front console
        translate([sx(10) - 1.6, sy(van_interior_width - 16) - 1.6]) square([3.2, 3.2]); // rear quarter trim
    }
    txt("V9a", front_x, CL + 5, 2.9, "center", RED);
    txt("V9b", sx(10), sy(van_interior_width - 16) + 5, 2.9, "center", RED);
    callout("V9", [
        "The van's TWO AC outlets — both fed by the ONE 1500W",
        "inverter, so they share one budget. V9a front centre",
        "console (1500W, VERIFIED). V9b rear passenger-side",
        "quarter trim (VERIFIED — inset shows where exactly).",
        "-> NEW check: confirm the quarter trim / cup holders",
        "   don't intrude inboard of the 46\" deck width.",
    ]);
    inset(INSET_X, 6, 98, 30, "V9b  REAR OUTLET — where it sits") {
        color("Black") translate([INSET_X + 20, 7]) rect_ol(0, 0, 60, 22, 0.45);
        color(RED) translate([INSET_X + 46, 14]) square([4, 4]);
        txt("~9.5\" above the cargo floor,", INSET_X + 22, 25, 2.4, "left", GRY);
        txt("~10\" fwd of the liftgate scuff plate,", INSET_X + 22, 22.4, 2.4, "left", GRY);
        txt("socket centre ~16\" in from the sidewall", INSET_X + 22, 19.8, 2.4, "left", GRY);
        txt("above the 12V battery panel, below the cup holders", INSET_X + 4, 9.5, 2.3, "left", GRY);
    }
}

// ============================================================
// V10 — is the cargo floor level front-to-back?
// ============================================================
module v10() {
    color(RED) for (yy = [8, 30, 52, 74]) dash_y(sx(yy), FLOOR_Y0, FLOOR_Y1, MED);
    txt("check level at several stations along the run", sx(40), FLOOR_Y1 + 4.5, 2.6, "center", RED);
    callout("V10", [
        "Is the CARGO FLOOR LEVEL front-to-back, or sloped?",
        "Lay a long level along the run, check several points.",
        "Every module's 4 legs are one length, which only gives",
        "a level deck if the floor itself is level.",
        "-> MEASURED Aug 2026: mostly level — level at the ends,",
        "   minor change between. The leg feet absorb it.",
    ]);
    inset(INSET_X, 6, 98, 30, "V10  SIDE SECTION — level check") {
        color("Black") translate([INSET_X + 12, 12]) polygon([[0,0],[74,3],[74,4],[0,1]]);
        color(RED) translate([INSET_X + 12, 20]) square([74, 0.7]);
        txt("a true level", INSET_X + 14, 22.6, 2.4, "left", RED);
        txt("floor — sloped? by how much, over what run?", INSET_X + 12, 9, 2.3, "left", GRY);
        txt("TAILGATE ->", INSET_X + 86, 14, 2.3, "right", GRY);
    }
}

// ============================================================
van_base();
if      (key == 1) v1();
else if (key == 2) v2();
else if (key == 3) v3();
else if (key == 4) v4();
else if (key == 5) v5();
else if (key == 6) v6();
else if (key == 7) v7();
else if (key == 8) v8();
else if (key == 9) v9();
else               v10();
