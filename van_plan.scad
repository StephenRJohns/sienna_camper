// ============================================================
// Shared Sienna PLAN-VIEW geometry (2D) — body, glass, wheels,
// front seats, sliding-door openings
// ============================================================
// The whole-vehicle plan context used by more than one drawing, so
// every plan view in the plan reads as the same vehicle instead of
// each one inventing its own body outline.
//
// Pulls in sheet2d.scad for the shared 2D primitives, so anything that
// includes THIS file gets those too and must not include it again.
//
// GEOMETRY ONLY — no text. That is deliberate: callers draw in
// different orientations (the Appendix A survey plans run front-at-left,
// the platform floorplan runs front-at-top), and rotating a module that
// contained labels would rotate the labels with it. Each caller adds
// its own labels in its own frame.
//
// Canonical frame:
//   X = fore-aft, 0 at the REAR BUMPER face, +X toward the front
//   Y = lateral,  0 on the CENTRELINE, +Y toward the PASSENGER side
// so a caller wanting front-at-top just does rotate(90).
//
// The outline is ILLUSTRATIVE — published Sienna exterior figures
// (~200" long x 78" wide), close enough to read as the actual vehicle.
// Nothing here is a verified dimension; the verified interior numbers
// live in params.scad.
// ============================================================

include <sheet2d.scad>

VP_L  = 200;    // bumper to bumper
VP_W  = 78;     // body width
VP_HW = VP_W / 2;
VP_HATCH   = 6;     // rear bumper face -> closed hatch inner face
VP_STROKE  = 0.6;   // body outline weight
VP_THIN    = 0.34;  // interior/context line weight

// front-seat block, as distance from the rear bumper. The seatbacks are
// pinned to VP_HATCH + van_interior_length, because that param IS defined
// as "closed hatch to front seatbacks" — drawing them further forward
// opens a phantom gap between Panel A and the seats it sits flush against.
VP_SEAT_X0 = VP_HATCH + 96; VP_SEAT_X1 = VP_SEAT_X0 + 22;
// sliding-door opening, as distance from the rear bumper
VP_DOOR_X0 = 56;  VP_DOOR_X1 = 96;





// ---- the body ---------------------------------------------------
// +X is FORWARD, so the tapered nose belongs at HIGH X and the squarer
// tail at X = 0. (Getting this backwards puts the nose on the tailgate.)
function vp_body_pts() = [
    [8, -VP_HW], [VP_L - 26, -VP_HW + 3], [VP_L - 6, -VP_HW + 13],
    [VP_L, -7], [VP_L, 7], [VP_L - 6, VP_HW - 13], [VP_L - 26, VP_HW - 3],
    [8, VP_HW], [0, VP_HW - 7], [0, -VP_HW + 7],
];

module vp_body(col = "Black") { color(col) ol(vp_body_pts(), VP_STROKE); }

// hood + windshield at the nose, glass band down each side
module vp_glass(col = "DimGray") {
    color(col) {
        ol([[VP_L - 4, -12], [VP_L - 30, -VP_HW + 8], [VP_L - 44, -VP_HW + 9],
               [VP_L - 44, VP_HW - 9], [VP_L - 30, VP_HW - 8], [VP_L - 4, 12]], VP_THIN);
        rect_ol(VP_L - 58, -VP_HW + 9, 14, VP_W - 18, VP_THIN);
        dash_x(-VP_HW + 9, 10, VP_L - 58, VP_THIN);
        dash_x(VP_HW - 9, 10, VP_L - 58, VP_THIN);
    }
}

// rear axle then front axle, as distance from the rear bumper
module vp_wheels(col = "DimGray") {
    color(col) for (wx = [13, 125]) for (wy = [-VP_HW - 1, VP_HW - 8])
        rect_ol(wx, wy, 27, 9, VP_THIN);
}

// two front seats + the steering wheel, forward of the driver's seat
module vp_front_seats(col = "DimGray") {
    color(col) {
        for (fy = [-22, 3]) round_ol(VP_SEAT_X0, fy, VP_SEAT_X1 - VP_SEAT_X0, 19, 4, VP_THIN);
        translate([VP_SEAT_X0 + 16, -12.5]) difference() {
            circle(r = 5, $fn = 28); circle(r = 4.3, $fn = 28);
        }
    }
}

module vp_sliding_doors(col = "Black") {
    color(col) for (dy = [-VP_HW, VP_HW - 1.4])
        translate([VP_DOOR_X0, dy]) square([VP_DOOR_X1 - VP_DOOR_X0, 1.4]);
}

// the closed hatch — the Y datum every Appendix A measurement works from
module vp_hatch(col = "Black") {
    color(col) translate([VP_HATCH - 0.8, -VP_HW + 5]) square([1.6, VP_W - 10]);
}

// everything at once, for callers that want the standard context
module vp_van_context() {
    vp_body();
    vp_glass();
    vp_wheels();
    vp_front_seats();
    vp_sliding_doors();
    vp_hatch();
}
