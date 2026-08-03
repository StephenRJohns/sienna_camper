// ============================================================
// Rear view (2D) — looking into the Sienna from the open tailgate
// with the fridge and kitchen unit DEPLOYED for use: both pulled
// out the tailgate on their slides and opened up. Companion to
// rear_view.scad (the STOWED-for-driving version).
// ============================================================
// The slide travel is along Y (toward the viewer, out the gate),
// which a straight X-Z elevation can't show as motion — so the
// convention here is: everything ABOVE the floor line is what stays
// in the van (deck, pantry, the now-empty bays); everything
// BELOW the floor line is drawn "pulled out the tailgate and set up
// for use." Same direct-drawing technique as rear_view.scad.
//
// Render with: openscad -o renders/rear-view-deployed.svg rear_view_deployed.scad
// ============================================================
// LEGIBILITY (Aug 2026): 1 prose line(s) moved out of this
// sheet into the document, and every text size scaled x1.4. Those
// sentences were setting the sheet's width, and a figure's printed
// text height is size x (page_width / sheet_width) — so they were
// holding every other label on the sheet down to 3-6pt on paper.
// Keep prose in the markdown; this sheet carries geometry and short
// labels only.

include <params.scad>
include <colors.scad>

stroke = 0.3;

module rect_outline(w, l, s = stroke) {
    color("black") difference() {
        square([w, l]);
        translate([s, s]) square([w - 2*s, l - 2*s]);
    }
}
module label(txt, x, y, size = 2.24) {
    color("black") translate([x, y]) text(txt, size = size, halign = "center", valign = "center");
}
module label_left(txt, x, y, size = 1.82) {
    color("black") translate([x, y]) text(txt, size = size, halign = "left", valign = "center");
}
// Numeral BESIDE the icon: OpenSCAD merges touching 2D shapes into one polygon
// set and paints them a single colour, so a white numeral centred in a filled
// circle vanishes and the marker reads as an anonymous blob.
module marker(n, x, y, nx = 1.9) {
    translate([x, y]) {
        color(marker_col(n)) circle(r = 1.1);
        color(marker_col(n)) translate([nx, 0])
            text(str(n), size = 2.2, halign = nx > 0 ? "left" : "right",
                 valign = "center");
    }
}
module fan_icon(x, z, r) {
    color("DimGray") translate([x, z]) {
        difference() { circle(r = r, $fn = 40); circle(r = r - 0.25, $fn = 40); }
        circle(r = r * 0.18, $fn = 16);
        for (a = [0 : 90 : 270])
            rotate(a) translate([r * 0.52, 0]) scale([1, 0.45]) circle(r = r * 0.4, $fn = 20);
    }
}
module arrow_down(x, z0, len) {
    color("Crimson") {
        translate([x - 0.12, z0 - len]) square([0.24, len]);
        translate([x, z0 - len]) polygon([[-0.9, 0], [0.9, 0], [0, -1.4]]);
    }
}

module deployed() {
    z_deck = leg_height + frame_rail_sz;

    // ---------- IN THE VAN (above the floor line) ----------
    translate([-van_interior_width/2, 0]) rect_outline(van_interior_width, van_interior_height);
    label("Sienna interior envelope (width x height)", 0, van_interior_height + 3, 1.7);
    label("DRIVER side", -van_interior_width/2 + 8, van_interior_height - 2, 1.9);
    label("PASSENGER side", van_interior_width/2 - 10, van_interior_height - 2, 1.9);

    // Panel C frame + deck
    color("Gray") {
        translate([-panel_width/2, 0]) rect_outline(frame_rail_sz, leg_height);
        translate([panel_width/2 - frame_rail_sz, 0]) rect_outline(frame_rail_sz, leg_height);
        translate([-panel_width/2, leg_height]) rect_outline(panel_width, frame_rail_sz); // tailgate end rail — deck recessed flush behind it
    }
    // No deck-plane caption here. Anywhere it fits on this view it touches the
    // grey frame — and OpenSCAD merges touching 2D shapes into one polygon set
    // and paints them a single colour, so the text came out grey-on-grey over
    // the legs. The 46" deck is dimensioned on the Panel C sheets; this view is
    // about the deployed state, not the geometry.

    // rear pantry on the deck (context outline): 2x2 drawer cluster + pot bin
    px0 = -panel_width/2;
    color("DarkGray") {
        translate([px0, z_deck]) rect_outline(pantry_cluster_w, pantry_cluster_h, 0.25);
        for (c = [0, 1]) for (r = [0, 1])
            translate([px0 + c*pantry_unit_w + 0.6, z_deck + r*pantry_unit_h + 0.6])
                rect_outline(pantry_unit_w - 1.2, pantry_unit_h - 1.2, 0.18);
        translate([px0 + pantry_cluster_w + 1.5, z_deck])
            rect_outline(pantry_pot_bin, pantry_pot_bin, 0.2);
    }
    label("Rear pantry — stays put", 0, z_deck + pantry_cluster_h + 2.4, 1.8);

    // the now-EMPTY under-deck bays the appliances slid out of
    color("LightGray") {
        translate([x_fridge_module - fridge_ext_length/2, 0]) rect_outline(fridge_ext_length, leg_height, 0.2);
        translate([x_kitchen - kitchen_box_width/2, 0]) rect_outline(kitchen_box_width, leg_height, 0.2);
    }
    label("empty fridge bay", x_fridge_module, leg_height/2 + 1.2, 1.8);
    label("(slid out)", x_fridge_module, leg_height/2 - 1.2, 1.8);
    label("empty kitchen bay", x_kitchen, leg_height/2 + 1.2, 1.8);
    label("(slid out)", x_kitchen, leg_height/2 - 1.2, 1.8);

    // OPEN utility bay (no door — it was cut), control panel at its back
    bay_x0 = x_fridge_module + fridge_ext_length/2;
    bay_x1 = x_kitchen - kitchen_box_width/2;
    cab_cx = (bay_x0 + bay_x1)/2;
    color("Black") translate([cab_cx - control_panel_width/2, 4.5]) rect_outline(control_panel_width, 6);
    
    // "open utility bay (no door)" printed at 0.85 inside a 3.3in-wide bay,
    // overflowing it on both sides. Marker 3 plus the legend row carry it now.

    // floor line + the two band captions (this band stays otherwise empty)
    color("black") translate([-van_interior_width/2 - 6, 0]) square([van_interior_width + 12, stroke * 1.2]);
    label("VAN FLOOR / TAILGATE SILL", 0, -2.4, 1.9);
    label("pulled out the tailgate & set up for use", 0, -5.6, 1.9);

    // ---------- DEPLOYED AT THE TAILGATE (well below the floor line) ----------
    ftop = -13;                        // body tops sit here, clear of the caption band
    fh = fridge_ext_height;
    fw = fridge_ext_length;
    fx = x_fridge_module;
    arrow_down(fx, -6.5, 4);
    // fridge body + dual-zone divider
    color("DimGray") translate([fx - fw/2, ftop - fh]) rect_outline(fw, fh);
    color("DimGray") translate([fx - 0.15, ftop - fh + 1]) square([0.3, fh - 2]);
    label("17L", fx - fw/4, ftop - fh/2, 1.8);
    label("19L", fx + fw/4, ftop - fh/2, 1.8);
    // two clamshell lids hinged open at the top corners
    color("DarkOrange") {
        translate([fx + fw/2, ftop]) rotate(55) square([5, 0.5]);
        translate([fx - fw/2, ftop]) rotate(125) square([5, 0.5]);
    }
    label("FRIDGE — on 24\" slides", fx - 1.5, ftop - fh - 2.8, 1.8);
    label("both lids open", fx, ftop - fh - 5.2, 1.8);
    label("compressor end → tailgate", fx, ftop - fh - 7.6, 1.8);

    // kitchen: slid out and opened — worktop leaf, 2-burner cooktop, drawer out
    kx = x_kitchen;
    kh = kitchen_box_height;
    kw = kitchen_box_width;
    arrow_down(kx, -6.5, 4);
    color("Gainsboro") translate([kx - kw/2, ftop - kh]) rect_outline(kw, kh);
    color("BurlyWood") translate([kx - kw/2, ftop]) square([kw + 7, 0.5]);              // extended worktop leaf
    color("Black") for (bx = [-1, 1])
        translate([kx + bx * 4.5, ftop + 2.6]) difference() { circle(r = 2, $fn = 32); circle(r = 1.35, $fn = 32); }
    color("Goldenrod") translate([kx + kw/2, ftop - kh + 2]) rect_outline(4.5, 3.5, 0.25); // side drawer out
    label("KITCHEN — 70\" in use", kx + 4, ftop - kh - 2.8, 1.8);
    label("cooktop up, drawer out", kx + 4, ftop - kh - 5.2, 1.8);
    label("Power strip 2 feeds it", kx + 4, ftop - kh - 7.6, 1.8);

    // ---------- markers + legend ----------
    marker(1, fx, ftop - fh + 2.2);
    marker(2, kx, ftop - kh + 1.6);
    marker(3, cab_cx + 2.2, 7);
    marker(4, kx - 4.5, ftop + 2.6);
    marker(5, x_fridge_module - 8, leg_height - 4.5);   // clear of the deck-plane caption

    leg_x = van_interior_width/2 + 6;
    items = ["Fridge — deployed, both lids open",
             "Kitchen unit — deployed, cooktop up, drawer out",
             "Open utility bay (no door): control panel + fans",
             "2-burner induction cooktop on the worktop",
             "Empty bays left behind in Panel C"];
    label_left("Legend", leg_x, van_interior_height - 2, 1.7);
    for (i = [0 : len(items) - 1]) {
        y = van_interior_height - 5.5 - i * 3.2;
        marker(i + 1, leg_x + 0.8, y);
        label_left(items[i], leg_x + 5.0, y, 1.2);
    }

    label("DEPLOYED — looking in the open tailgate, both units set up for use",
          0, ftop - fh - 11.5, 1.9);
}

deployed(); // no outer color() wrapper — helpers self-color (see rear_view.scad)
