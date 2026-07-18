// Step 5: Build the sliding drawer boxes. Every drawer on Panels A
// and B is the same size (4 total: left + right on each of the 2
// panels — Panel C's void holds the fridge/kitchen unit instead,
// Section 1) — build one, repeat 4 times. Shown as an unfolded box
// net so every piece and its real dimensions are visible at once.
include <../params.scad>

stroke = 0.3;

module rect_outline(w, l, s = stroke) {
    difference() {
        square([w, l]);
        translate([s, s]) square([w - 2*s, l - 2*s]);
    }
}

module label(txt, x, y, size = 1.7) {
    translate([x, y]) text(txt, size = size, halign = "center", valign = "center");
}

module piece(w, l, x, y, name, dims, name_size = 1.6, dim_size = 1.4) {
    translate([x - w/2, y - l/2]) rect_outline(w, l);
    label(name, x, y + name_size * 1.5, name_size);
    label(dims, x, y - dim_size * 1.5, dim_size);
}

module drawing() {
    dw = drawer_travel; // pull-out direction, box's own length
    dl = drawer_depth;  // fore-aft, box's own width
    dh = drawer_height;
    gap = 1.5;

    // bottom, centered
    piece(dw, dl, 0, 0, "Bottom", str(dw, "\" x ", dl, "\""));

    // side walls (inner, against the divider, and outer, the pull
    // face) unfold left/right — short label, narrow piece
    piece(dh, dl, -(dw/2 + gap + dh/2), 0, "Side (x2)", str(dh, "\" x ", dl, "\""), 1.4, 1.2);
    piece(dh, dl, (dw/2 + gap + dh/2), 0, "Side (x2)", str(dh, "\" x ", dl, "\""), 1.4, 1.2);

    // front/back walls unfold up/down
    piece(dw, dh, 0, -(dl/2 + gap + dh/2), "Front/back wall (x2)", str(dw, "\" x ", dh, "\""));
    piece(dw, dh, 0, (dl/2 + gap + dh/2), "Front/back wall (x2)", str(dw, "\" x ", dh, "\""));

    label("One drawer — 5 pieces (bottom + 4 walls), open top", 0, dl/2 + dh + gap + 7, 1.9);
    label("Build 4 total: left + right on Panel A and Panel B", 0, dl/2 + dh + gap + 3, 1.6);
    label(str("Mount on ", drawer_slide_length, "\" full-extension slides: one side to the frame's long rail, the other to the center divider"),
          0, -(dl/2 + dh + gap + 5), 1.4);
}

color("black") drawing();
