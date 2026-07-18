// ============================================================
// Headboard/pantry — Lego-manual step diagrams, woodworking-plan
// line-art style (see lego_lib.scad).
// ============================================================
// NO LONGER its own base module (no frame/legs/top steps here) — it
// mounts directly onto Panel C's ALREADY-BUILT deck (Component 4),
// at the tailgate end (the last headboard_length of Panel C's own
// length). Context in every step below is Panel C's own frame + top,
// shown at its full panel_c_length, with the shelving positioned at
// the tailgate end (local Y = panel_c_length - headboard_length to
// panel_c_length) rather than spanning a dedicated frame of its own.
//
// Owner's July 2026 pattern: NO full-height divider, NO top — two
// FULL-DEPTH shelves make 3 full-width tiers; a short nook divider
// in the MIDDLE tier encloses a bed cubby (mattress side) from the
// top food tier (kitchen side).
//
//   1  2 side panels + 2 FIXED shelves + 1 ADJUSTABLE shelf on pins
//   2  bolt-down base cleats + L-angle sway braces to Panel C's rails
//   3  nook divider (middle tier) + RETENTION: fiddle lips + lash straps
//   4  nook fit-out: half-round edging + Power strip 1 + roll bubble level
// Part letters: E side panel, H full-depth shelves, F nook divider,
// G base cleats.
// ============================================================

include <lego_lib.scad>

step = 1;
view = "assembly";

L  = headboard_length;   // 14
W  = headboard_width;    // 46, matches panel_width
PCL = panel_c_length;    // 36 — Panel C's own full length, the context frame
RS = frame_rail_sz;
LH = leg_height;
PT = panel_thickness;
HH = headboard_height;   // 22, shelving height above deck level
Yf = headboard_food_depth;       // 10.5 — the MIDDLE tier's kitchen side, behind the nook divider
Yp = headboard_shelf_depth;      // 2.75 — bed cubby depth (fixed)
n  = headboard_food_shelf_count; // 2 full-depth shelves -> 3 tiers
zm = headboard_upper_shelf_z;    // 18.0 — upper food shelf (cubby ceiling)
zp = headboard_personal_shelf_z; // 13.0 — bed shelf (cubby floor), 9" above the mattress
ndh = headboard_nook_divider_h;  // 4.25 — divider fills the enclosed middle tier
za  = headboard_adj_shelf_z;     // 6.5 — adjustable shelf (default position in the bottom bay)
lip = headboard_fiddle_lip_h;    // 1.5 — front fiddle-lip height
z_deck = LH + RS + PT;   // top of Panel C's own deck = shelving floor
y0 = PCL - L;            // headboard zone's start within Panel C's own length (tailgate end)
y_div = headboard_shelf_depth; // nook divider position within the headboard zone, from the mattress-facing (local Y=0) end

// the full carcass: 2 side panels + 2 full-depth shelves
module shell_geom(lift = 0, ctx = false, with_adj = true) {
    wbox([-W/2, y0, z_deck + lift], [PT, L, HH], [0, 0], ctx);       // side panel
    wbox([W/2 - PT, y0, z_deck + lift], [PT, L, HH], [0, 0], ctx);   // side panel
    for (sz = [zm, zp])
        wbox([-W/2, y0, z_deck + lift + sz], [W, L, PT], [0, 0], ctx); // fixed full-depth shelf
    if (with_adj)                                                     // adjustable shelf on pins
        wbox([-W/2, y0, z_deck + lift + za], [W, L, PT], [0, 0], ctx);
}

// Panel C's own frame + already-built fixed top, shown as context —
// this replaces the old dedicated lib_frame_ctx()/own-top pattern
module panel_c_ctx() {
    lib_frame_ctx(PCL, W);
    wbox([-W/2, 0, LH + RS], [W, PCL, PT], [0, 0], true); // Panel C's own top, context
}

module s1_parts() {
    wbox([0, 0, 0], [PT, L, HH]);
    cap(str("E  2x side panel ", L, "\" x ", HH, "\" (3/4\" ply) — drill 5mm pin-hole columns, ", headboard_pin_lo, "-", headboard_pin_hi, "\" o.c."), 8, -HH * 0.42 - 3, 2.6);
    wbox([0, 0, 0], [W, L, PT], [PT + 10, 0]);
    cap(str("H  2x FIXED + 1x ADJUSTABLE full-depth shelf ", W, "\" x ", L, "\" (3/4\" ply)"), PT + 10 + W * 0.3, -12, 2.6);
}
module s1_assembly() {
    lift = 9;
    panel_c_ctx();
    shell_geom(lift);
    iarrow([-W/2 + PT/2, y0 + L/2, z_deck + lift - 1], [-W/2 + PT/2, y0 + L/2, z_deck + 1]);
    iarrow([W/2 - PT/2, y0 + L/2, z_deck + lift - 1], [W/2 - PT/2, y0 + L/2, z_deck + 1]);
    // fixed shelves screwed to the side panels; adjustable one rests on pins (no screws)
    for (x = [-W/2 + PT/2, W/2 - PT/2]) for (sz = [zm, zp])
        fastener([x, y0 + L/2, z_deck + lift + sz + PT/2], 0.4, 90);
    callout("E", [-W/2 + PT/2, y0 + L, z_deck + lift + HH], [-6, 4]);
    callout("H", [0, y0 + L, z_deck + lift + zp + PT/2], [8, 5]);
    callout("adjustable — on pins", [0, y0 + L, z_deck + lift + za + PT/2], [8, -3]);
    cap("2 FIXED shelves = the structure (glued + screwed). The 3rd shelf is ADJUSTABLE on pins in the 13\" bottom bay — one tall bay OR two ~6\" tiers.", 0, -26, 2.0);
}

module s2_parts() {
    wbox([0, 0, 0], [W, 3, PT]);
    cap(str("G  2x base cleat ", W, "\" x 3\" (3/4\" ply) + 4x 1/4-20 Kipp cam levers/T-nuts + 2x 30\" steel L-angle braces"), W * 0.35, -8, 2.2);
}
module s2_assembly() {
    lift = 3; // small lift showing it CAN be lifted straight off
    panel_c_ctx();
    shell_geom(lift, false);
    // cleat pair: one half on Panel C's deck, one on the shelving's underside
    ifill(INK) translate([-W/2, y0 + L/2 - 1.5, LH + RS + PT]) cube([W, 3, 0.4]);
    ifill(INK) translate([-W/2, y0 + L/2 - 1.5, z_deck + lift - 0.4]) cube([W, 3, 0.4]);
    iarrow([0, y0 + L/2, z_deck + lift + 3], [0, y0 + L/2, z_deck + lift + 0.5]);
    // screws pinning each cleat half to its own surface (deck / shelving underside) —
    // light-colored marks since the cleat itself is solid black
    for (x = [-W/2 + 6, 0, W/2 - 6]) {
        fastener_light([x, y0 + L/2, LH + RS + PT + 0.2]);
        fastener_light([x, y0 + L/2, z_deck + lift - 0.2]);
    }
    callout("G", [0, y0 + L/2, LH + RS + PT], [9, -4]);
    cap("clamped down: 4x 1/4-20 Kipp CAM LEVERS into T-nuts through the deck — flip to release, no tools; 2 L-angle braces to Panel C's side rails at ~45 deg.", 0, -20, 1.7);
}

module s3_parts() {
    wbox([0, 0, 0], [W, PT, ndh]);
    cap(str("F  1x nook divider ", W, "\" x ", ndh, "\" (1/2\" ply)"), W * 0.42, -6, 2.4);
    wbox([0, 0, 0], [W, 0.5, lip], [0, -14]);
    cap(str("K  fiddle lips ", lip, "\" tall, ripped ply/pine — one per food-shelf front edge (both faces)"), W * 0.42, -22, 2.2);
    cap("L  elastic lash straps (cam/hook ends) — one across each tier opening + bins + non-slip liner", W * 0.42, -26, 2.2);
}
module s3_assembly() {
    panel_c_ctx();
    shell_geom(0, true);
    // nook divider spans the MIDDLE tier (bed shelf to upper shelf), Yp back from the bed face
    wbox([-W/2, y0 + y_div, z_deck + zp + PT], [W, PT, ndh]);
    iarrow([0, y0 + y_div + PT/2, z_deck + HH + 5], [0, y0 + y_div + PT/2, z_deck + zp + PT + ndh + 0.5]);
    for (x = [-W/2 + PT/2, W/2 - PT/2])
        fastener([x, y0 + y_div + PT/2, z_deck + zp + PT + ndh * 0.6], 0.4, 90);
    callout("F", [-W/2, y0 + y_div + PT/2, z_deck + zp + PT + ndh], [-7, 4]);
    // fiddle lips: short strips standing on each food shelf's kitchen (near, y0) edge
    for (fz = [0, za + PT, zp + PT, zm + PT])
        ifill("Peru") translate([-W/2, y0 - 0.1, z_deck + fz]) cube([W, 0.4, lip]);
    callout("K  fiddle lip", [0, y0, z_deck + za + PT + lip], [9, 4]);
    cap(str("nook divider (F) at ", Yp, "\" from the bed face, MIDDLE tier. Then RETENTION: a fiddle lip (K) on every food shelf's front edge (both faces)"), 0, -20, 1.7);
    cap("+ an elastic lash strap (L) across each opening + bins for utensils + non-slip liner. The lip stops the forward slide braking causes; a net stays only on the soft-goods tier.", 0, -23, 1.7);
}

module s4_parts() {
    cap("3/4\" half-round pine trim, 44.5\"", 0, 4, 2.2);
    cap("+ Power strip 1 (own cord run, Component 6)", 0, 0, 2.2);
    cap("+ 1x RV bar bubble level (from the 2-pack — its twin is on the bed platform rail)", 0, -4, 2.2);
}
module s4_assembly() {
    panel_c_ctx();
    shell_geom(0, true);
    // nook divider now context too
    wbox([-W/2, y0 + y_div, z_deck + zp + PT], [W, PT, ndh], [0, 0], true);
    // half-round edging along the bed shelf's mattress-facing lip
    ifill(INK) translate([-W/2 + 1, y0 + 0.3, z_deck + zp + PT]) rotate([0, 90, 0]) cylinder(h = W - 2, r = 0.35, $fn = 12);
    // Power strip 1 + roll bubble level, on the nook surface
    ifill("Black") translate([W * 0.25, y0 + 0.9, z_deck + zp + PT]) cube([3, 1.6, 0.6]);
    ifill("DimGray") translate([-W * 0.32, y0 + 0.9, z_deck + zp + PT]) cube([2.5, 0.8, 0.5]);
    iarrow([0, y0 - 2, z_deck + zp + PT + 3], [0, y0 + 0.5, z_deck + zp + PT + 0.5], 0.4);
    cap("fit out the bed cubby (bed shelf, mattress side): half-round lip glued + pinned, Power strip 1, and the ROLL bubble level —", 0, -20, 1.7);
    cap("read it from the bed or side door while turning the leg-foot knobs; the PITCH level lives on the platform's driver-side rail edge.", 0, -23, 1.7);
}

if (view == "parts") {
    if (step == 1) s1_parts();
    else if (step == 2) s2_parts();
    else if (step == 3) s3_parts();
    else if (step == 4) s4_parts();
} else {
    if (step == 1) s1_assembly();
    else if (step == 2) s2_assembly();
    else if (step == 3) s3_assembly();
    else if (step == 4) s4_assembly();
}
