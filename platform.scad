// ============================================================
// Toyota Sienna Camper Platform — Parametric 3D Model
// ============================================================
// Dimensions live in params.scad — edit there, not here.
//
// Modular lift-out design: Panel A, Panel B, Panel C, the fridge
// bay, and the kitchen box are each an independent, self-
// supporting module (own perimeter frame + own 4 legs). None of
// them touch a shared frame — every module lifts straight out and
// drops straight back in on its own. Grab handles sit at both
// ends of every module; felt/rubber bumper strips sit at every
// seam between modules so nothing rubs or rattles in transit.
// ============================================================

include <params.scad>

show_van_shell = true;

$fn = 32;

// ------------------------------------------------------------
// Shared building blocks
// ------------------------------------------------------------

// Wireframe cage (12 edges only) for a w x l x h box, corner at
// the origin. Used for the van shell in the isometric line
// drawing so it reads as a see-through reference volume instead
// of a solid block that hides the platform.
module edge_box(w, l, h, r = 0.15) {
    for (y = [0, l]) for (z = [0, h])
        translate([0, y, z]) rotate([0, 90, 0]) cylinder(h = w, r = r);
    for (x = [0, w]) for (z = [0, h])
        translate([x, 0, z]) rotate([-90, 0, 0]) cylinder(h = l, r = r);
    for (x = [0, w]) for (y = [0, l])
        translate([x, y, 0]) cylinder(h = h, r = r);
}

// A box that's either solid (normal 3D model / preview) or drawn
// as a 12-edge wireframe cage. The isometric vector line drawing
// (iso_view.scad) needs the wireframe form for every large flat
// surface — otherwise projection() renders it as one big filled
// silhouette that hides everything behind it, rather than the thin
// outlines a technical line drawing needs.
module bx(w, l, h, wireframe = false) {
    if (wireframe) edge_box(w, l, h);
    else cube([w, l, h]);
}

// A single leg support, standing on the van floor (Z=0) up to the
// underside of a module's frame (Z=leg_height).
module leg(x, y) {
    translate([x, y, 0])
        cube([frame_rail_sz, frame_rail_sz, leg_height]);
}

// Independent perimeter frame + 4 corner legs for one module.
// Sized to the module's own footprint — no shared rails with
// neighboring modules, so this module comes free on its own.
// leg_inset shifts only the legs (not the rail) inward from the
// module's outer edge — needed on the wide panels so the legs land
// clear of the floor-level vent intrusion (see leg_inset in
// params.scad); fridge bay/kitchen box are narrow enough not to
// need it (default 0).
// handle_ends: 2 = routed hole through both end rails (front and
// back), 1 = front end rail only (e.g. the kitchen box, which only
// gets a single handle), 0 = no holes.
// bottom_ends / bottom_sides: CUBE-FRAME bottom rails (see the
// params.scad note for which faces each panel closes). rear_inset:
// the REAR leg pair's own inset — Panel C passes 0 so its rear legs
// sit at the true corners, clear of the appliance slide paths.
// (Hand-hold holes are gone — bare frames are gripped by these
// exposed top rails.)
module module_frame(length, width, frame_leg_inset = 0, bottom_front = false, bottom_rear = false, bottom_sides = false, rear_inset = -1) {
    r_inset = rear_inset < 0 ? frame_leg_inset : rear_inset;
    color("SaddleBrown") {
        translate([-width/2, 0, leg_height])
            cube([frame_rail_sz, length, frame_rail_sz]);
        translate([width/2 - frame_rail_sz, 0, leg_height])
            cube([frame_rail_sz, length, frame_rail_sz]);
        translate([-width/2, 0, leg_height])
            cube([width, frame_rail_sz, frame_rail_sz]);
        translate([-width/2, length - frame_rail_sz, leg_height])
            cube([width, frame_rail_sz, frame_rail_sz]);

        // bottom rails, just above the leveling feet
        if (bottom_front)
            translate([-width/2 + frame_leg_inset, 0, bottom_rail_z])
                cube([width - 2 * frame_leg_inset, frame_rail_sz, frame_rail_sz]);
        if (bottom_rear)
            translate([-width/2 + r_inset, length - frame_rail_sz, bottom_rail_z])
                cube([width - 2 * r_inset, frame_rail_sz, frame_rail_sz]);
        if (bottom_sides)
            for (x = [-width/2 + frame_leg_inset, width/2 - frame_rail_sz - frame_leg_inset])
                translate([x, frame_rail_sz, bottom_rail_z])
                    cube([frame_rail_sz, length - 2 * frame_rail_sz, frame_rail_sz]);
    }

    color("SaddleBrown") {
        for (x = [-width/2 + frame_leg_inset, width/2 - frame_rail_sz - frame_leg_inset])
            leg(x, 0);
        for (x = [-width/2 + r_inset, width/2 - frame_rail_sz - r_inset])
            leg(x, length - frame_rail_sz);
    }
}

// Routed hand-hold hole through an end rail — a stadium-shaped
// through-cut (two rounded ends joined by a straight run), not
// mounted hardware. y_center should land on the rail's own center
// (frame_rail_sz/2 in from that end) so the hole actually passes
// through solid rail material. z_center is the rail's mid-height.
// Subtract this from the frame with difference(), don't add it.
module routed_handle_hole(y_center, z_center) {
    straight_run = handle_width - 2 * handle_radius;
    translate([0, y_center, z_center])
        rotate([-90, 0, 0])
            hull() {
                translate([-straight_run/2, 0, 0])
                    cylinder(h = frame_rail_sz + 0.4, r = handle_radius, center = true);
                translate([straight_run/2, 0, 0])
                    cylinder(h = frame_rail_sz + 0.4, r = handle_radius, center = true);
            }
}

// Felt/rubber anti-rattle bumper strip laid across a seam between
// two adjacent modules, so their frames/panels don't touch bare
// wood-on-wood in transit. Y-oriented: runs across X at a fixed Y
// (used between modules that are front-to-back neighbors).
module bumper_strip(width, y, z, x_center = 0) {
    color("DarkRed")
        translate([x_center - width/2, y - bumper_thickness/2, z])
            cube([width, bumper_thickness, bumper_thickness]);
}

// Alignment dowel pin marker: keeps adjacent modules registered in
// the same spot every time so they don't creep/shift in transit.
module alignment_pin(x, y, z, h = 0.75) {
    color("DimGray")
        translate([x, y, z])
            cylinder(h = h, d = alignment_pin_dia);
}

// ------------------------------------------------------------
// Modules
// ------------------------------------------------------------

// One panel module: own frame + legs, a routed hand-hold hole through
// each end rail for whole-module lift-out (Section 3/6). Panels A
// and B get the usual left+right sliding drawer pair reached through
// the side doors (see drawer_module()); Panel C (has_kitchen_fridge =
// true) instead houses the fridge (on its own tailgate-pull slide)
// and the kitchen unit (its own tailgate slide) in the same void —
// see fridge_bay_module()/kitchen_box_module() below. Panel A's left
// bay is further special-cased (wave3_bay = true) to hold the WAVE 3
// as open storage instead of a boxed drawer — see wave3_bay_module().
//
// Panel A's old fixed top and Panel B's old hinged lift-top (piano
// hinge + latches + struts) are GONE — the one-piece slatted bed
// frame (Component 2, still being designed) is ~79.5-80in long,
// fully covering both (58in combined), and caps them directly; it's
// what lifts off for access to either drawer bay now.
//
// Panel C KEEPS its fixed top, unlike A/B: the bed frame only
// reaches about 22in into Panel C's own 36in length (bed_length minus
// Panel A/B's combined 58in), leaving the last 14in for the
// rear pantry's own zone — not exposed deck, but the drawer cluster's
// cleat mounted shelving — and the fridge/kitchen void beneath needs
// the enclosure regardless of what's resting on top of it. The bed's
// foot end simply rests on top of Panel C's existing deck for the
// overlap.
module panel_module(length, width, y_offset, wireframe = false, has_kitchen_fridge = false, wave3_bay = false, bare_bay = false) {
    // CUBE-FRAME bottom rails, per panel (params.scad note):
    // Panel C (has_kitchen_fridge): FRONT only, rear legs at the true
    // corners; Panel B (bare_bay): all 4 faces — the full cube;
    // Panel A: both ENDS only (drawer + WAVE 3 exit the sides).
    translate([0, y_offset, 0]) {
        if (has_kitchen_fridge)
            module_frame(length, width, leg_inset, true, false, false, 0);
        else if (bare_bay)
            module_frame(length, width, leg_inset, true, true, true);
        else
            module_frame(length, width, leg_inset, true, true, false);
    }

    if (has_kitchen_fridge) {
        color("BurlyWood", 0.9)
            translate([-width/2, y_offset, leg_height + frame_rail_sz])
                bx(width, length, panel_thickness, wireframe);
        // Panel C's ONE wall: the front (B-facing) face, 1/2in ply —
        // the intake fan mounts on it and the fridge DC line passes
        // through it (grommet). No side walls (the van wall is ~1in
        // away), and the tailgate face needs none — it's fully
        // occupied by the fridge, cabinet door, kitchen unit, and
        // kitchen drawer face. See panel_c_wall_detail.scad.
        color("Tan", 0.9)
            translate([-width/2, y_offset + frame_rail_sz, 0])
                bx(width, pcwall_t, leg_height, wireframe);
        fridge_bay_module(y_offset, wireframe, x_fridge_module, length);
        kitchen_box_module(y_offset, wireframe, x_kitchen, length);
        cabinet_door_module(y_offset, wireframe, length);
    } else if (bare_bay) {
        // Panel B: NO drawers, NO divider — the side doors don't
        // reach this panel, so its whole void is deep storage,
        // loaded from above by lifting the platform + mattress.
    } else {
        // center divider rail, splits the storage bay into a left
        // and right drawer run
        color("SaddleBrown")
            translate([-drawer_divider_t/2, y_offset + frame_rail_sz, 0])
                bx(drawer_divider_t, length - 2 * frame_rail_sz, leg_height, wireframe);

        if (wave3_bay) {
            wave3_bay_module(length, y_offset, wireframe); // left (-X) bay, WAVE 3 open storage
        } else {
            drawer_module(length, width, y_offset, -1, wireframe); // left (-X) drawer
        }
        drawer_module(length, width, y_offset, 1, wireframe, wireframe ? 0 : 0.35); // right (+X) drawer, shown partly open on the solid model
    }
}

// WAVE 3 open storage: the unit rests directly on Panel A's left bay
// floor, no drawer box or slide hardware — it's 20.4in wide, wider
// than a boxed drawer's 19in clear interior, but fits the raw 20.75in
// bay (params.scad, wave3_bay_width). Centered fore-aft in the bay,
// flush against the center divider the same way a closed drawer would
// sit. A couple of thin glide strips on the bay floor (Section 6) cut
// friction sliding it in/out by hand through the driver's side door —
// cosmetic-only in this model, not modeled as separate geometry.
module wave3_bay_module(length, y_offset, wireframe = false) {
    y0 = y_offset + frame_rail_sz + (length - 2 * frame_rail_sz - wave3_depth) / 2;
    x0 = -drawer_divider_t/2 - wave3_width;
    color("DimGray", 0.85)
        translate([x0, y0, 0])
            bx(wave3_width, wave3_depth, wave3_height, wireframe);
    // FOUND-STORAGE shelf on cleats just above the WAVE 3 (the unit
    // still slides out beneath it) — flat soft goods / hoses
    bx0 = -drawer_divider_t/2 - wave3_bay_width;
    color("BurlyWood")
        translate([bx0, y_offset + frame_rail_sz, wave3_shelf_z])
            bx(wave3_bay_width, length - 2 * frame_rail_sz, panel_thickness, wireframe);
}

// One sliding drawer box: side = -1 (left, -X) or 1 (right, +X).
// open_frac (0-1) shows the drawer pulled out that fraction of its
// full travel, so the solid/preview model reads as a drawer, not a
// sealed box — the SVG line views stay closed (open_frac = 0) so
// the footprint drawn matches the closed, driving-position state.
module drawer_module(length, width, y_offset, side, wireframe = false, open_frac = 0) {
    box_t = drawer_box_t; // drawer box material thickness (thin plywood/melamine)
    y0 = y_offset + frame_rail_sz + (length - 2 * frame_rail_sz - drawer_depth) / 2;
    slide_out = open_frac * drawer_travel; // how far the box has been pulled outward from closed
    // x0 = the box's low-X corner. Closed, the box fills the bay
    // from the divider face out to the frame's inner face; open,
    // the whole box translates further away from the divider.
    x0 = side > 0
        ? drawer_divider_t/2 + slide_out
        : -drawer_divider_t/2 - drawer_travel - slide_out;

    color("Wheat", 0.95) {
        if (wireframe) {
            // one simple cage for the whole drawer volume — the
            // isometric line drawing just needs a footprint, and 5
            // separate wireframe boxes per drawer (30 total across
            // all 6 drawers) made projection() very slow for no
            // visual benefit over a single outline
            translate([x0, y0, 0])
                bx(drawer_travel, drawer_depth, drawer_height, true);
        } else {
            translate([x0, y0, 0])
                bx(drawer_travel, drawer_depth, box_t, false); // bottom
            translate([x0, y0, 0])
                bx(drawer_travel, box_t, drawer_height, false); // front (divider-facing) wall
            translate([x0, y0 + drawer_depth - box_t, 0])
                bx(drawer_travel, box_t, drawer_height, false); // back wall
            translate([x0, y0, 0])
                bx(box_t, drawer_depth, drawer_height, false); // inner side wall
            translate([x0 + drawer_travel - box_t, y0, 0])
                bx(box_t, drawer_depth, drawer_height, false); // outer (pull) side wall
        }
    }
}

// Fridge zone, living inside Panel C's own void (no separate frame —
// Panel C's own frame/legs/fixed-top already drawn by the caller).
// The fridge sits on a plywood tray riding a pair of heavy-duty
// slides (fridge_slide_length, 200lb rated) and pulls out through
// the open TAILGATE for top-lid access — same exit as the kitchen
// unit — flush to Panel C's right edge the rest of the time. Includes: a
// 120mm intake fan pulling cabin air into the cavity from the front
// (Panel-B-facing) side, a 2nd 120mm exhaust fan actively pulling
// warm air out on the tailgate-facing side into the control
// compartment, an NTC temperature sensor probe next to the exhaust
// fan (see fridge_wiring.scad for how these 3 are wired together),
// and the control panel itself (power switches, surge protector,
// fan speed controller) mounted on the tailgate-facing
// end rail above the fridge's slide path — the rail sits up at deck
// height while the fridge travels below it, so the two don't collide
// even though the fridge now exits through the same opening the rail
// spans.
module fridge_bay_module(y_offset, wireframe = false, x_offset = 0, panel_length) {
  translate([x_offset, 0, 0]) {
    z = leg_height + frame_rail_sz;
    fridge_y0 = panel_length - fridge_ext_width; // flush to the tailgate-facing edge
    open_frac = wireframe ? 0 : 0.4;
    slide_out = open_frac * fridge_slide_length;
    x0 = -fridge_ext_length/2; // fixed, flush to Panel C's right edge
    y0 = fridge_y0 + slide_out; // slides out in +Y (toward the open tailgate)

    // fridge tray (plywood sled the fridge is screwed to)
    color("SaddleBrown")
        translate([x0, y_offset + y0, 0])
            bx(fridge_ext_length, fridge_ext_width, fridge_tray_t, wireframe);

    // fridge (real BougeRV exterior dimensions, rotated 12.6in side
    // left-right), sitting on its tray, hidden below deck level
    color("DimGray", 0.85)
        translate([x0, y_offset + y0, fridge_tray_t])
            bx(fridge_ext_length, fridge_ext_width, fridge_ext_height, wireframe);

    // 120mm intake fan, mounted ON Panel C's front (B-facing) wall —
    // the panel's one wall (see panel_module) — pulling cabin air
    // into the cavity through the wall's fan hole. Wall-mounted, so
    // it never moves with the sliding tray.
    color("SteelBlue")
        translate([0, y_offset + frame_rail_sz + pcwall_t + 0.3, fridge_ext_height/2 + fridge_tray_t])
            rotate([90, 0, 0])
                cylinder(h = 0.3, r = intake_fan_dia/2, $fn = 24);

    // 120mm exhaust fan, mounted on the fridge cavity's LEFT
    // (kitchen-facing) wall, actively pulling warm air out into the
    // utility cabinet between the kitchen unit and the fridge — not
    // the tailgate-facing wall as an earlier draft had it, since the
    // control compartment it exhausts into lives in that cabinet, not
    // out at the open tailgate. Frame-mounted like the intake fan,
    // fixed at the CLOSED position regardless of open_frac.
    color("CornflowerBlue")
        translate([fridge_ext_length/2 - 0.3, y_offset + fridge_y0 + fridge_ext_width/2, fridge_ext_height/2 + fridge_tray_t])
            rotate([0, 90, 0])
                cylinder(h = 0.3, r = exhaust_fan_dia/2, $fn = 24);

    // NTC temperature sensor probe, mounted just inside the bay next
    // to the exhaust fan (in the path of the warmest air so it
    // reacts quickly) — feeds the PWM fan controller in the control
    // compartment (fridge_wiring.scad)
    color("GreenYellow")
        translate([fridge_ext_length/2 - 1, y_offset + fridge_y0 + fridge_ext_width/2 - 1.5, fridge_ext_height/2 + fridge_tray_t])
            sphere(r = sensor_dia/2, $fn = 12);

    // control compartment: switches, surge protector, fan speed
    // controller — INSIDE the utility cabinet between the fridge and
    // kitchen, just behind the door, on a backer board hung from the
    // deck underside (simplified representative block, not to exact
    // device scale). The CO monitor is owner-placed, not drawn.
    ccx = (x_fridge_module + fridge_ext_length/2 + fridge_slide_margin
           + x_kitchen - kitchen_box_width/2)/2 - x_offset; // cabinet gap center, module-local
    color("Black", 0.85)
        translate([ccx - control_panel_width/2, y_offset + panel_length - 3.5, 6.5])
            bx(control_panel_width, 1.5, 6, wireframe); // panel face + switches/surge strip

    // Floor anchors for the fridge's heavy-duty slide rails — see
    // "Securing heavy components" (Section 8): the slide's OUTER
    // rail bolts to a mounting cleat that is THROUGH-BOLTED to the
    // van floor via E-track anchors (1000lb WLL each), independent of
    // Panel C's own lift-out frame (which never touches the fridge or
    // its slide — Panel C's legs stand clear of this whole zone).
    // 4 anchors: 2 per slide, front and back of each rail's run.
    color("DimGray")
        for (ax = [-fridge_ext_length/2 + 1, fridge_ext_length/2 - 1])
            for (ay = [y_offset + fridge_y0 + 2, y_offset + fridge_y0 + fridge_ext_width - 2])
                translate([ax - 0.75, ay - 2.5, 0])
                    bx(1.5, 5, 0.1, wireframe); // E-track anchor footprint, floor-mounted
  }
}

// Kitchen unit: the real JAGAHAHA slide-out camp kitchen (26x20x11.8
// closed), a standalone manufactured product — NOT a module we
// build, so no custom frame/legs/hand-hold here, just its closed
// footprint living inside Panel C's void (flush to the tailgate-
// facing edge so its own built-in slide can pull it straight out
// the open tailgate) plus its floor anchors + tie-down straps
// (Section 8 — upgraded from a plain strap-to-factory-hook design
// after confirming the Sienna's factory cargo hooks are rated for
// cargo nets only, NOT for restraining a 45lb+ item). It's shorter
// than the sleeping deck (11.8in vs 19.25in) since it doesn't need
// to hide anything — its own slide handles access.
module kitchen_box_module(y_offset, wireframe = false, x_offset = 0, panel_length) {
  translate([x_offset, 0, 0]) {
    x0 = -kitchen_box_width/2;
    y0 = panel_length - kitchen_box_length; // flush to the tailgate-facing edge

    color("BurlyWood", 0.85)
        translate([x0, y_offset + y0, 0])
            bx(kitchen_box_width, kitchen_box_length, kitchen_box_height, wireframe);

    // E-track floor anchors (1000lb WLL each, through-bolted to the
    // van floor — see "Securing heavy components", Section 8) at all
    // 4 corners, with ratchet straps crossing over the top
    color("DimGray")
        for (ax = [x0 + 1, x0 + kitchen_box_width - 1])
            for (ay = [y_offset + y0 + 1.5, y_offset + y0 + kitchen_box_length - 1.5])
                translate([ax - 0.75, ay - 2.5, 0])
                    bx(1.5, 5, 0.1, wireframe);
    color("DarkRed")
        for (sy = [y_offset + y0 + 2, y_offset + y0 + kitchen_box_length - 2])
            translate([x0 - 0.5, sy - 0.5, kitchen_box_height])
                bx(kitchen_box_width + 1, 1, 0.3, wireframe); // ratchet strap, over the top

    // Kitchen drawer (Component 7): a shallow slide-out drawer in
    // the dead air above the kitchen unit, hung from the deck by two
    // 3/4in ply cheeks (outer cheek against the side rail's inner
    // face), riding a 24in full-extension slide pair — pulls out the
    // open tailgate just like everything else in Panel C.
    dck1 = panel_width/2 - frame_rail_sz - x_offset; // outer cheek's outer face, module-local
    ck_h = leg_height + frame_rail_sz - kdrawer_z0;  // deck underside down to the drawer's underside
    color("Peru") {
        translate([dck1 - kdrawer_cheek_t, y_offset + y0, kdrawer_z0])
            bx(kdrawer_cheek_t, kdrawer_box_len, ck_h, wireframe);
        translate([dck1 - 2*kdrawer_cheek_t - kdrawer_span, y_offset + y0, kdrawer_z0])
            bx(kdrawer_cheek_t, kdrawer_box_len, ck_h, wireframe);
    }
    dpull = wireframe ? 0 : 4; // drawn part-open toward the tailgate
    color("Tan")
        translate([dck1 - kdrawer_cheek_t - kdrawer_span + 0.5, y_offset + y0 + dpull, kdrawer_z0])
            bx(kdrawer_box_w, kdrawer_box_len, kdrawer_box_h, wireframe);
  }
}

// Utility cabinet door: covers the gap between the kitchen unit and
// the fridge (where the exhaust fan vents and the control panel
// lives) with a simple hinged panel, closing off what would
// otherwise be an open slot at the tailgate face. Hinged on the
// kitchen-side edge, swinging open toward the fridge side, with a
// magnetic catch on the free (fridge-side) edge. Purely cosmetic/
// dust-and-draft control — not airtight, so the exhaust fan doesn't
// need its own separate vent to atmosphere (Section 6).
module cabinet_door_module(y_offset, wireframe = false, panel_length) {
    door_x0 = x_fridge_module + fridge_ext_length/2 + fridge_slide_margin; // flush to the fridge module's right edge
    door_w  = x_kitchen - kitchen_box_width/2 - door_x0; // gap to the kitchen's left edge
    door_h  = leg_height; // floor to deck underside

    color("BurlyWood", 0.7)
        translate([door_x0, y_offset + panel_length - 0.4, 0])
            bx(door_w, 0.4, door_h, wireframe);

    // 2 hinges, on the kitchen-side (high-X) edge
    color("DimGray")
        for (hz = [door_h * 0.2, door_h * 0.8])
            translate([door_x0 + door_w - 0.2, y_offset + panel_length - 0.6, hz - 0.75])
                bx(0.4, 0.8, 1.5, wireframe);

    // magnetic catch, on the free (fridge-side) edge
    color("Black")
        translate([door_x0 + 0.1, y_offset + panel_length - 0.6, door_h/2 - 0.5])
            bx(0.5, 0.8, 1, wireframe);
}

// Simplified Sienna interior cargo envelope — a bounding volume
// only, per request #3. Centered on the platform's width, floor
// starting at the 2nd-row seatback (Y=0). Always a wireframe cage,
// never a solid face — it's a reference/fit-check volume, not a
// real part, and a solid box this much bigger than the platform
// would otherwise hide the whole model behind it.
module van_shell() {
    color("SteelBlue")
        translate([-van_interior_width/2, 0, 0])
            edge_box(van_interior_width, van_interior_length, van_interior_height, r = 0.2);
}

// ------------------------------------------------------------
// Assembly
// ------------------------------------------------------------

// Y offsets: Panels A/B/C as one continuous full-length sleeping
// deck, flush against the front seatbacks (Y=0, see panel_a_y0 in
// params.scad) — no gap between Panel A and the front seats. The
// the rear pantry has no Y slot of its own — it's a prefab drawer
// cluster sitting on Panel C's deck (see pantry_module() below). The fridge and kitchen unit live INSIDE Panel C's own void
// (see panel_module(..., has_kitchen_fridge=true)), not as a separate
// zone.
y_panel_a   = 0;
y_panel_b   = panel_a_length;
y_panel_c   = panel_a_length + panel_b_length;

// front-to-back seams: just Panel A/B and Panel B/C — no seam within
// Panel C (fridge/kitchen/pantry aren't separate lift-out modules
// from Panel C itself).
seam_ys = [y_panel_b, y_panel_c];

// Rear pantry: a PREFAB 2x2 drawer cluster (4x "like-it" Modular
// Shallow Drawers) sitting on the tailgate end of Panel C's deck —
// bought, not built. Held by a cleat pocket (cab side + both sides)
// plus one cam-buckle strap across the drawer fronts; each unit lifts
// straight out. The remaining ~19in of deck (passenger side) is the
// open bay: a rigid pot/pan bin + the relocated Power strip 1 + ROLL
// bubble level. y_offset here is the pantry boundary (Panel C's own
// y_offset + panel_c_length - pantry_len): local Y=0 is the mattress-
// facing edge, local Y=pantry_len the tailgate edge.
module pantry_module(y_offset) {
    z = leg_height + frame_rail_sz;         // top of Panel C's frame rail
    z_top = z + panel_thickness;            // Panel C's deck surface
    x0 = -panel_width/2;                    // driver edge — the cluster sits here

    // 2x2 like-it drawer cluster (schematic: 4 boxes + drawer faces)
    for (c = [0, 1]) for (r = [0, 1]) {
        color("WhiteSmoke", 0.95)
            translate([x0 + c*pantry_unit_w + 0.1, y_offset + pantry_len - pantry_unit_d, z_top + r*pantry_unit_h + 0.1])
                cube([pantry_unit_w - 0.2, pantry_unit_d, pantry_unit_h - 0.2]);
        color("Gainsboro") // drawer face, tailgate side
            translate([x0 + c*pantry_unit_w + 0.7, y_offset + pantry_len - 0.2, z_top + r*pantry_unit_h + 0.7])
                cube([pantry_unit_w - 1.4, 0.4, pantry_unit_h - 1.4]);
    }

    // hold-down cleats: cab-facing side + both sides (tailgate open)
    color("SaddleBrown") {
        translate([x0, y_offset + pantry_len - pantry_unit_d - 1, z_top])
            cube([pantry_cluster_w, 1, 1]);                                  // cab-side cleat (the braking stop)
        translate([x0 - 0.0, y_offset + pantry_len - pantry_unit_d, z_top]) cube([1, pantry_unit_d, 1]);
        translate([x0 + pantry_cluster_w - 1, y_offset + pantry_len - pantry_unit_d, z_top]) cube([1, pantry_unit_d, 1]);
    }

    // cam-buckle strap across the drawer fronts (keeps drawers shut +
    // snugs the stack) — schematic band at mid-height
    color("Crimson")
        translate([x0 - 0.3, y_offset + pantry_len - 0.6, z_top + pantry_cluster_h/2 - 0.5])
            cube([pantry_cluster_w + 0.6, 0.5, 1]);

    // open bay (passenger side): pot/pan bin + relocated power strip
    bx = x0 + pantry_cluster_w;             // bay start
    color("BurlyWood", 0.9)                 // rigid pot/pan bin
        translate([bx + 1.5, y_offset + pantry_len - pantry_pot_bin - 1, z_top])
            cube([pantry_pot_bin, pantry_pot_bin, pantry_pot_bin]);
    color("Black")                          // Power strip 1, deck edge
        translate([bx + pantry_pot_bin + 3, y_offset + 1, z_top])
            cube([4, 1.5, 1.5]);
    color("GreenYellow")                    // ROLL bubble level beside it
        translate([bx + pantry_pot_bin + 3, y_offset + 3.5, z_top])
            cube([3.5, 0.8, 0.8]);
}

module full_platform() {
    panel_module(panel_a_length, panel_width, y_panel_a, false, false, true); // left bay = WAVE 3 open storage
    panel_module(panel_b_length, panel_width, y_panel_b, false, false, false, true); // bare bay — no drawers, the side doors don't reach Panel B
    panel_module(panel_c_length, panel_width, y_panel_c, false, true);
    pantry_module(y_panel_c + panel_c_length - pantry_len); // prefab drawer cluster on Panel C's tailgate end

    z_deck = leg_height + frame_rail_sz;

    // anti-rattle bumpers + alignment pins at every front-to-back
    // seam between lift-out panels — just 2 now (A/B, B/C): the
    // the pantry no longer lifts out as its own module between two
    // neighbors, so that seam is gone.
    for (i = [0:1]) {
        y = seam_ys[i];
        bumper_strip(panel_width, y, z_deck);
        alignment_pin(-panel_width/2 + 3, y, z_deck);
        alignment_pin(panel_width/2 - 3, y, z_deck);
    }
}

if (show_van_shell) van_shell();
full_platform();
