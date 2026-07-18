// ============================================================
// Headboard/pantry storage detail — exploded isometric reference,
// woodworking-plan style (see steps/lego_lib.scad for the shared
// primitives: isometric projection, opaque white/black-edge parts,
// insertion arrows, fastener icons).
// ============================================================
// Companion to Section 6, Component 1 — this is the single
// "everything, exploded, in one picture" reference; the numbered
// sequential build steps live in steps/headboard_lego.scad.
//
// Context is Panel C's own finished frame + top (muted gray — this
// component mounts on Panel C's already-built deck, Component 4),
// shown at full panel_c_length, with the shelving positioned at the
// tailgate end (local Y = panel_c_length - headboard_length to
// panel_c_length). The shell (just the 2 side panels — no full-height
// divider, no top) is shown lifted slightly off the deck to reveal
// the bolt-down base cleats between them; the 2 FULL-DEPTH shelves
// are pulled out along their installed axis and the short nook
// divider hovers above its top-tier slot.
//
// Render with: openscad -o renders/headboard-storage-detail.svg headboard_storage_detail.scad
// ============================================================

include <steps/lego_lib.scad>
include <colors.scad>

L   = headboard_length;          // 14
W   = headboard_width;           // 46, matches panel_width
PCL = panel_c_length;            // 36 — Panel C's own full length, the context frame
RS  = frame_rail_sz;
LH  = leg_height;
PT  = panel_thickness;
HH  = headboard_height;          // 22, shelving height above deck level
Yf  = headboard_food_depth;      // 10.5, food compartment clear depth (derived)
Yp  = headboard_shelf_depth;     // 2.75, personal shelf clear depth (fixed)
n   = headboard_food_shelf_count; // 2 shelves -> 3 tiers
z_deck = LH + RS + PT;           // top of Panel C's own deck = shelving floor
y0  = PCL - L;                   // headboard zone's start within Panel C's own length (tailgate end)
y_div = Yp;                      // divider START position, measured from the mattress-facing (local Y=0) end

shell_lift = 5; // small gap revealing the French cleat pair underneath
pull = 3;       // how far shelves/personal shelf pull out from the shell along Y

// numbered-marker convention (colors.scad marker_col) — matches every
// other detail view's side-list pairing
module marker3d(n, anchor3, off = [6, 4]) {
    q = p2(anchor3);
    t = q + off;
    color(marker_col(n)) translate(t) circle(r = 1.3);
    color("white") translate(t) text(str(n), size = 1.3, halign = "center", valign = "center");
    color(INK) line2d(q, t - off * (2.2 / max(2.2, norm(off))));
}

module side_list(list_x, top_y, items) {
    color(INK) {
        translate([list_x, top_y - 1]) text("Component", size = 1.4, halign = "left", valign = "center");
        translate([list_x, top_y - 3.6]) text("Position / fastener / material", size = 1.1, halign = "left", valign = "center");
    }
    for (i = [0 : len(items) - 1]) {
        y = top_y - 10 - i * 9;
        color(marker_col(i + 1)) translate([list_x, y + 3.8]) circle(r = 1.2);
        color("white") translate([list_x, y + 3.8]) text(items[i][0], size = 1.2, halign = "center", valign = "center");
        color(INK) {
            translate([list_x + 3.2, y + 3.8]) text(items[i][1], size = 1.15, halign = "left", valign = "center");
            translate([list_x + 3.2, y + 1.9]) text(items[i][2], size = 1.0, halign = "left", valign = "center");
            translate([list_x + 3.2, y]) text(items[i][3], size = 1.0, halign = "left", valign = "center");
        }
    }
}

module drawing() {
    // ---- Panel C context: frame + already-built fixed top, muted ----
    lib_frame_ctx(PCL, W);
    wbox([-W/2, 0, LH + RS], [W, PCL, PT], [0, 0], true);

    // ---- base cleats: T-nut/bolt row on the deck, cleat strip
    // riding up with the shell (shows the bolted connection) --
    ifill(INK) translate([-W/2, y0 + L/2 - 1.5, z_deck]) cube([W, 3, 0.4]);
    ifill(INK) translate([-W/2, y0 + L/2 - 1.5, z_deck + shell_lift - 0.4]) cube([W, 3, 0.4]);
    for (x = [-W/2 + 6, 0, W/2 - 6]) {
        fastener_light([x, y0 + L/2, z_deck + 0.2]);
        fastener_light([x, y0 + L/2, z_deck + shell_lift - 0.2]);
    }

    // ---- shell: just the 2 side panels now (no full-height divider,
    // no top), lifted shell_lift above the deck ----
    wbox([-W/2, y0, z_deck + shell_lift], [PT, L, HH]);
    wbox([W/2 - PT, y0, z_deck + shell_lift], [PT, L, HH]);
    iarrow([-W/2 + PT/2, y0 + L/2, z_deck + shell_lift - 2], [-W/2 + PT/2, y0 + L/2, z_deck + shell_lift - 0.3]);
    iarrow([W/2 - PT/2, y0 + L/2, z_deck + shell_lift - 2], [W/2 - PT/2, y0 + L/2, z_deck + shell_lift - 0.3]);

    // ---- shelves: 2 FIXED full-depth (the carcass webs) + 1
    // ADJUSTABLE (rests on pins in the bottom bay), pulled out along
    // +Y beyond the kitchen-facing edge, one arrow each back to its
    // installed slot. The adjustable one gets no screw fasteners
    // (pins), and a dashed drop line to show it repositions ----
    shelf_zs = [headboard_upper_shelf_z, headboard_personal_shelf_z, headboard_adj_shelf_z];
    for (i = [0 : 2]) {
        zi = z_deck + shell_lift + shelf_zs[i];
        y_pulled = y0 + pull * (i + 1.2);
        wbox([-W/2, y_pulled, zi], [W, L, PT]);
        if (i < 2) for (x = [-W/2 + PT/2, W/2 - PT/2]) for (yf = [0.25, 0.75])
            fastener([x, y_pulled + L * yf, zi + PT/2], 0.35, 90);
        else for (x = [-W/2 + PT/2, W/2 - PT/2]) for (yf = [0.25, 0.75])  // pin dots, not screws
            ifill("DimGray") translate([x, y_pulled + L * yf, zi]) sphere(r = 0.25, $fn = 8);
        iarrow([0, y_pulled - 0.5, zi + PT/2], [0, y0 + L/2, zi + PT/2]);
    }
    // shelf-pin hole column on the shell's near side panel (bottom bay)
    for (z = [headboard_pin_lo : 2 : headboard_pin_hi])
        ifill(INK) translate([-W/2 + PT + 0.3, y0 + 0.4, z_deck + shell_lift + z]) sphere(r = 0.2, $fn = 8);

    // half-round edging + Power strip 1 + roll bubble level, riding
    // the BED shelf's mattress-facing (near) lip — that 2.75in strip
    // of the bed shelf (the lower of the two) IS the bed cubby floor
    top_y = y0 + pull * 2.2;
    top_z = z_deck + shell_lift + headboard_personal_shelf_z;
    ifill("SaddleBrown") translate([-W/2 + 1, top_y + 0.3, top_z + PT])
        rotate([0, 90, 0]) cylinder(h = W - 2, r = 0.35, $fn = 12);
    ifill("Black") translate([W * 0.28, top_y + 1, top_z + PT]) cube([3, 2, 0.6]);
    ifill("DimGray") translate([-W * 0.3, top_y + 1, top_z + PT]) cube([2.5, 0.8, 0.5]);

    // ---- nook divider: raised above the shell, drop arrow down to
    // its slot on the BED shelf (it spans up to the upper shelf,
    // enclosing the cubby), headboard_shelf_depth back from the
    // mattress face ----
    nd_z = z_deck + shell_lift + HH + 4;
    wbox([-W/2, y0 + y_div, nd_z], [W, PT, headboard_nook_divider_h]);
    iarrow([0, y0 + y_div + PT/2, nd_z - 0.3],
           [0, y0 + y_div + PT/2, z_deck + shell_lift + headboard_personal_shelf_z + PT + 1]);

    // ---- numbered markers, drawn LAST so they always land on top of
    // every part (a marker drawn before a later part risked getting
    // painted over by that part's opaque white fill) ----
    marker3d(3, [0, y0 + L/2, z_deck + shell_lift/2], [13, -10]);
    marker3d(4, [0, y0 + y_div + PT/2, nd_z + headboard_nook_divider_h/2], [14, 3]);
    marker3d(1, [-W/2 + W * 0.15, y0 + pull * 1.2 + L, z_deck + shell_lift + shelf_zs[0]], [-8, -4]);
    marker3d(2, [-W/2 + W * 0.7, y0 + pull * 2.2 + L, z_deck + shell_lift + shelf_zs[1]], [8, -3]);
    marker3d(8, [-W/2 + W * 0.5, y0 + pull * 3.2 + L, z_deck + shell_lift + shelf_zs[2]], [10, -4]);
    marker3d(5, [-W * 0.05, top_y + 0.5, top_z + PT], [-13, 6]);
    marker3d(6, [0, top_y + 0.3, top_z + PT + 0.35], [-7, -11]);
    marker3d(7, [W * 0.28 + 1.5, top_y + 1, top_z + PT + 0.6], [12, 10]);

    // ---- captions — all placed below the whole drawing's projected
    // extent (Y down to about -9.4 at the frame's own front corner) ----
    cap("HEADBOARD/PANTRY — exploded detail (mounted on Panel C's deck, Component 4/1)", 13, -16, 2.0);
    cap(str("2 FIXED shelves + 1 ADJUSTABLE (8) -> up to 4 food tiers; nook divider (4) makes the MIDDLE tier an ENCLOSED bed cubby ", Yp, "\" (bed) | food ", Yf, "\" (kitchen)"), 13, -19, 1.4);
    cap("The 13\" bottom bay runs as one tall bay OR splits into two ~6\" tiers on the pin holes. NO full-height divider, NO TOP. Shell clamps to Panel C's deck (3) + 2 L-angle braces.", 13, -22, 1.3);
    cap("RETENTION (1): a 1.5\" fiddle lip on EVERY food shelf + a lash strap across each opening + bins for small items + non-slip liner (a net only on the soft-goods tier).", 13, -24.5, 1.3);

    // side list to the right of the drawing's own rightmost projected
    // extent (~42 at its widest, the shell's kitchen-facing top corner)
    side_list(48, 58, [
        ["1", "Retention system", "1.5\" fiddle lip per shelf + lash strap per opening + bins + non-slip liner", "holds rigid items (plates/cans/bottles/utensils) under braking — replaces plain nets"],
        ["2", "Fixed full-depth shelves", str("x", n, ", ", W, "\" x ", L, "\", 3/4\" ply (bed ", headboard_personal_shelf_z, "\" + upper ", headboard_upper_shelf_z, "\")"), "the carcass webs — glued + screwed into both side panels"],
        ["3", "Clamp-down base cleats", "2x 46\" x 3\" ply strips + 4x 1/4-20 Kipp CAM LEVERS into T-nuts", "flip the levers to release — NO tools; 2 L-angle braces to Panel C's side rails"],
        ["4", "Nook divider", str(W, "\" x ", headboard_nook_divider_h, "\", 1/2\" ply — MIDDLE tier, ", Yp, "\" from the bed face"), "encloses the cubby: bed shelf to upper shelf, into both side panels"],
        ["5", "Bed cubby", str(Yp, "\" deep strip of the bed shelf, surface at ", headboard_personal_shelf_z + panel_thickness, "\" (9\" above the mattress)"), "phones, glasses, flashlights, USB charging"],
        ["6", "Half-round edging", "3/4\" half-round trim, mattress-facing lip", "keeps small items from sliding off in transit"],
        ["7", "Power strip 1 + bubble level", "both mounted on the nook", "strip: own cord run (Section 5); level reads ROLL while leveling"],
        ["8", "Adjustable shelf", str(W, "\" x ", L, "\", 3/4\" ply — rests on 4 pins in the bottom bay"), str("reposition ", headboard_pin_lo, "-", headboard_pin_hi, "\" or lift out: one tall bay or two ~6\" tiers")],
    ]);
}

drawing();
