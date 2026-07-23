// ============================================================
// Whole-vehicle overview — side profile silhouette with the
// camper platform build shown to scale inside the cargo area.
// ============================================================
// Purpose: a single "how does this all fit in the van" picture —
// not a cutting/measurement diagram. The exterior body outline
// (hood, windshield, roofline, tailgate, wheels) is a simplified,
// ILLUSTRATIVE side profile, sized close to a real 4th-gen Sienna
// but not traced from a CAD drawing. The interior cargo envelope,
// the liftgate opening callout, and the platform assembly (legs,
// deck height, fridge bay height) all use the SAME verified/
// unverified numbers from params.scad as every other diagram in
// this plan, drawn to scale relative to each other.
//
// Render with: openscad -o renders/vehicle-overview.svg vehicle_overview.scad
// ============================================================

include <params.scad>

stroke = 0.4;

// illustrative exterior proportions — not measured, just close
// enough to read as "a minivan" (see note above)
vehicle_length = 203;
rear_overhang  = 10;  // bumper face to tailgate inner face
floor_z        = 14;  // cargo floor height above ground (underbody/floor pan)
wheel_r        = 13.5; // ~27in tire diameter
front_wheel_x  = 48;
rear_wheel_x   = 160;

// where the usable cargo interior sits, working back from the
// tailgate — this is what ties the illustrative body to the real
// verified interior dimensions
interior_x0 = vehicle_length - rear_overhang - van_interior_length;

// smooth wheel-arch bump: n+1 points from (cx-half_w, rocker_z) up to
// a peak of (cx, arch_z) and back down to (cx+half_w, rocker_z), used
// to cut a recognizable fender arch into the body's lower edge instead
// of a flat rocker line straight through the wheel
function arch(cx, half_w = 17, rocker_z = 7, arch_z = 19, n = 10) =
    [for (i = [0 : n]) let(t = i / n, x = cx - half_w + 2 * half_w * t)
        [x, rocker_z + (arch_z - rocker_z) * sin(180 * t)]];
function rev(l) = [for (i = [len(l) - 1 : -1 : 0]) l[i]];

// Minivan side silhouette, front at low X: long low hood (typical
// minivan cab-forward proportions), a big windshield rake up to a
// mostly-flat roofline (the boxy roof is a strong minivan cue vs. a
// sedan/SUV's tapered greenhouse), a near-vertical liftgate at the
// tailgate end, and 2 wheel arches cut into the lower body line —
// illustrative proportions (see header note), not traced from CAD.
module van_body() {
    polygon(concat(
        [
            [6, 9],    // front lower fascia, leading-bottom corner
            [1, 13],   // bumper lower lip juts forward
            [0, 21],   // bumper face (near vertical)
            [4, 26],   // grille top / hood leading edge
            [16, 31],  // hood rising fast (short, high Sienna hood)
            [34, 35],  // hood rear / cowl
            [72, 62],  // windshield — one long continuous rake
            [84, 66],  // roof, front corner
            [116, 68], // roof peak (just aft of the B-pillar)
            [160, 66], // roofline easing rearward
            [186, 60], // rear spoiler tip (overhangs the gate)
            [184, 56], // spoiler underside kick
            [193, 38], // liftgate, slightly raked
            [198, 21], // rear bumper top
            [197, 9],  // rear bumper, trailing-bottom corner
        ],
        rev(arch(rear_wheel_x)),  // rear fender arch (high-X to low-X)
        rev(arch(front_wheel_x))  // front fender arch
        // implicit close back to [6, 9] via the front rocker straight
    ));
}

// greenhouse: the light-gray window band from the windshield back to
// the D-pillar, with pillar strokes — drawn FIRST (background) so all
// the black envelope/label work stays readable on top of it. This
// band plus the rising beltline is what makes the profile read as a
// Sienna rather than a generic MPV.
module greenhouse() {
    // separate convex panes with natural pillar gaps between them —
    // one big concave band polygon z-fought in the preview renderer
    color("Gainsboro") {
        polygon([[46, 40], [64, 55], [68, 57.5], [52, 41.5]]);          // windshield
        polygon([[68, 46], [78, 59.5], [85, 60.6], [85, 45.8]]);        // front door glass (A-pillar gap before it)
        polygon([[90, 46], [90, 61], [144, 61.6], [144, 47.6]]);        // sliding-door glass
        polygon([[150, 47.8], [150, 61.4], [166, 60], [172, 52.6]]);    // quarter glass, beltline kick-up
    }
    // headlight + taillight slivers
    color("Silver") polygon([[3, 25.4], [15, 29.8], [15.5, 27.6], [4.5, 23.8]]);
    color("Silver") polygon([[186, 58.5], [190, 50], [192.5, 50.5], [188.5, 59]]);
}


module van_outline() {
    difference() {
        offset(r = stroke) van_body();
        van_body();
    }
}

// small side mirror, a rounded paddle shape attached right at the
// base of the A-pillar/front edge of the glass — the single detail
// that most reads as "minivan" rather than a generic box in a quick
// side-profile glance
module mirror_bump() {
    color("black") translate([63, 43]) scale([1.2, 1.5]) circle(r = 2.0);
}

// sliding door seam lines (leading + trailing edge of the door
// opening) and the liftgate/D-pillar seam — thin vertical strokes,
// not shape changes, so they read as panel gaps rather than steps
module body_seams() {
    color("black") {
        translate([88 - stroke/2, 20]) square([stroke, 24]);  // sliding door, front edge (below the glass band)
        translate([148 - stroke/2, 20]) square([stroke, 26]); // sliding door, rear edge
        translate([180 - stroke/2, 18]) square([stroke, 32]); // liftgate / D-pillar seam
    }
}

module wheel() {
    difference() {
        circle(r = wheel_r);
        circle(r = wheel_r - 2.5);
    }
}

module drawing() {
    // ground line
    translate([-5, 0]) square([vehicle_length + 10, stroke]);

    // greenhouse band first — everything else draws on top of it
    greenhouse();

    // body outline (fender arches already cut into its lower edge)
    color("black") van_outline();
    mirror_bump();
    body_seams();

    // wheels
    color("black") translate([front_wheel_x, wheel_r]) wheel();
    color("black") translate([rear_wheel_x, wheel_r]) wheel();

    // cargo interior envelope (dashed feel via a thin outline —
    // this is the van_interior_length x van_interior_height hard
    // max box from params.scad, positioned against the tailgate)
    color("DimGray") translate([interior_x0, floor_z])
        difference() {
            square([van_interior_length, van_interior_height]);
            translate([stroke, stroke]) square([van_interior_length - 2*stroke, van_interior_height - 2*stroke]);
        }
    color("black") translate([vehicle_length/2, -4.5])
        text(str("Cargo interior envelope (thin outline): ", van_interior_length, "in x ", van_interior_height, "in, 2nd row removed — UNVERIFIED length"), size = 2.0, halign = "center", valign = "center");

    // liftgate opening callout (UNVERIFIED — see params.scad) drawn
    // against the tailgate face
    color("Black") translate([vehicle_length - rear_overhang - 3, floor_z])
        square([stroke * 2, gate_opening_height]);
    color("Black") translate([vehicle_length - rear_overhang + 6, floor_z + gate_opening_height/2])
        text(str("Liftgate opening ", gate_opening_height, "in tall (UNVERIFIED)"), size = 2.2, halign = "left", valign = "center");

    // -------------------------------------------------------
    // Platform assembly, to scale, inside the cargo envelope. ONE
    // continuous deck now (Panels A/B/C, all the same height) — the
    // fridge and kitchen unit live INSIDE Panel C's void, hidden below
    // deck level, not a separate taller module. The rear pantry
    // is no longer its own module at the front — it's mounted ON TOP
    // of Panel C's deck at the tailgate end (see below).
    // -------------------------------------------------------
    platform_x0 = interior_x0; // Panel A now sits flush with the 2nd-row end, no gap

    panel_top    = floor_z + panel_module_height;
    panels_x0    = platform_x0;

    // deck line across all three panels
    color("Gray") translate([panels_x0, panel_top])
        square([panels_total_length, stroke]);
    // legs under the panels (4 simple posts for a clean read, not
    // one per actual leg position)
    for (x = [panels_x0 + 2, panels_x0 + panels_total_length/2, panels_x0 + panels_total_length - 2])
        color("Gray") translate([x, floor_z]) square([stroke * 2, panel_module_height]);

    // seam ticks between Panel A/B and B/C
    color("Gray") translate([panels_x0 + panel_a_length, floor_z]) square([stroke, panel_module_height]);
    color("Gray") translate([panels_x0 + panel_a_length + panel_b_length, floor_z]) square([stroke, panel_module_height]);

    // fridge + kitchen unit — dashed indicator within Panel C's own
    // footprint (hidden below deck, not a separate taller block)
    color("DimGray") translate([panels_x0 + panel_a_length + panel_b_length, floor_z + 1])
        for (i = [0 : 2 : panel_c_length])
            translate([i, 0]) square([min(1, panel_c_length - i), stroke]);

    // rear pantry (prefab drawer cluster): ON Panel C's deck, at the
    // tailgate end (the last pantry_len of Panel C's own length) — rises
    // above deck level, relocated from the front
    pantry_x0 = panels_x0 + panels_total_length - pantry_len;
    color("Gray") translate([pantry_x0, floor_z])
        difference() {
            square([pantry_len, panel_module_height + pantry_cluster_h]);
            translate([stroke, stroke]) square([pantry_len - 2*stroke, panel_module_height + pantry_cluster_h - 2*stroke]);
        }

    // mattress, true thickness, on the adjuster+platform stack —
    // spans the 80in sleeping run (the rear pantry takes the rest)
    matt_z0 = floor_z + deck_surface_z; // platform/deck plane at 18.5 (deck recess — platform is flush AT the plane, not on top of it)
    matt_z1 = matt_z0 + mattress_total_thickness;
    color("Gray") translate([panels_x0, matt_z0])
        difference() {
            square([mattress_length, mattress_total_thickness]);
            translate([stroke, stroke]) square([mattress_length - 2*stroke, mattress_total_thickness - 2*stroke]);
        }
    color("black") translate([panels_x0 + mattress_length/2, (matt_z0 + matt_z1)/2])
        text(str("mattress (", mattress_total_thickness, "\" foam on the 3/4\" platform)"), size = 1.8, halign = "center", valign = "center");

    // SITTING HEADROOM: mattress top -> ceiling, dimensioned with
    // ticks so the person-space is explicit
    hx = panels_x0 + 46;
    headroom = van_interior_height - (deck_surface_z + mattress_total_thickness); // 21.5 since the deck recess
    color("black") {
        translate([hx - stroke/2, matt_z1]) square([stroke, floor_z + van_interior_height - matt_z1]);
        translate([hx - 2, matt_z1]) square([4, stroke]);
        translate([hx - 2, floor_z + van_interior_height - stroke]) square([4, stroke]);
    }
    color("black") translate([hx + 2.5, (matt_z1 + floor_z + van_interior_height)/2 + 2])
        text(str(headroom, "\" of sitting headroom"), size = 2.2, halign = "left", valign = "center");
    color("black") translate([hx + 2.5, (matt_z1 + floor_z + van_interior_height)/2 - 1])
        text("(mattress top to ceiling)", size = 1.7, halign = "left", valign = "center");

    color("black") translate([panels_x0 + panels_total_length/2, floor_z + 9])
        text("Panels A / B / C (boxes on the floor; full untrimmed queen mattress above)", size = 1.8, halign = "center", valign = "center");
    color("black") translate([pantry_x0 + pantry_len/2, floor_z + panel_module_height + pantry_cluster_h + 3])
        text("Rear pantry (prefab)", size = 1.6, halign = "center", valign = "center");
    color("black") translate([pantry_x0 + pantry_len/2, floor_z + panel_module_height + pantry_cluster_h + 1])
        text("(on Panel C's deck)", size = 1.3, halign = "center", valign = "center");
    color("black") translate([panels_x0 + 6, floor_z - 3])
        text("Fridge + kitchen unit hidden inside Panel C ->", size = 1.5, halign = "right", valign = "center");

    // front/rear labels for orientation
    color("black") translate([20, 70]) text("FRONT", size = 3.2, halign = "center", valign = "center");
    color("black") translate([190, 70]) text("REAR / TAILGATE", size = 3.2, halign = "center", valign = "center");

    // disclaimer caption
    color("black") translate([vehicle_length/2, -8])
        text("Exterior body outline is illustrative only — cargo interior, liftgate opening, and platform dimensions are to scale.",
             size = 1.8, halign = "center", valign = "center");
}

drawing();
