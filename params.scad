// ============================================================
// Shared dimension parameters — Sienna camper platform
// ============================================================
// Source of truth: sienna_camper_build_plan.md
// All dimensions in inches, matching the build plan exactly.
// Change a value here and re-run render.sh to regenerate every
// view (3D model, top/iso/side renders, and step diagrams).
//
// Layout assumption (not explicit in the build plan, needed to
// place solids in space): front-to-back along Y, from the
// compressed 2nd row (Y=0) toward the tailgate. Panel A -> Panel B
// -> Panel C, then the fridge bay and kitchen box SIDE BY SIDE
// (sharing the same Y range, split across the width) rather than
// one after the other — the 72" hard length limit doesn't leave
// room to stack them in series. Width is centered on X=0. Flag if
// this isn't how you're actually laying it out.
// ============================================================

/* [Vehicle constraints — 2nd row seats REMOVED entirely] */
// van_interior_length below is an UNVERIFIED ESTIMATE, not a
// measurement — same status as the gate opening numbers further
// down. The 72" figure from the earlier design was measured with
// the 2nd row seats still installed (pushed fully forward on their
// tracks); now that those seats are being removed completely, the
// van gains roughly the depth the seats themselves occupied at
// that forward position (~24-26" for a typical minivan 2nd-row
// bench/captain's chair, plus a little track). 96" here is that
// estimate, rounded — MEASURE THE ACTUAL EMPTY INTERIOR (closed
// hatch to the front seatbacks) once the seats are physically out
// and correct this value before cutting anything.
// Width/height/vent/hatch numbers are unaffected by seat removal
// (they're structural, not seat-related) and remain the originally
// verified figures.
van_interior_length     = 96;   // UNVERIFIED ESTIMATE — closed hatch to front seatbacks, 2nd row removed
van_interior_width      = 48.5; // floor clearance between wheel wells — HARD MAX, verified
van_interior_height     = 44;   // HARD MAX, verified
vent_intrusion_width    = 2.5;  // rear lower heat vent intrusion, per side, at floor level only
hatch_curvature_clearance = 2;  // reserved at the tailgate end for the curved hatch — not to be built into

// usable design envelope after reserving hatch curvature clearance
usable_length = van_interior_length - hatch_curvature_clearance; // 94
usable_floor_width = van_interior_width - 2 * vent_intrusion_width; // 43.5 — floor-level width, legs must stay inside this

/* [Rear liftgate opening — UNVERIFIED, confirm by physical measurement] */
// Every module must physically pass through this opening to be
// lifted in/out — that's the entire point of the modular design.
// These numbers came from an AI-summarized web search (Reddit/
// YouTube sourced), NOT a direct measurement like the vehicle
// interior constraints above. Some of the resulting margins are
// tight (see the asserts below) — measure the actual opening
// (narrowest width, height, and how far the upper corners round
// off) with a tape measure before cutting anything.
gate_opening_width  = 48; // UNVERIFIED — widest point of the liftgate opening
gate_opening_height = 36; // UNVERIFIED — upper corners are heavily rounded, reducing
                          // effective clearance near the edges; treat this as optimistic

/* [Headboard/pantry — NO LONGER its own lift-out module. It's a
   shelving superstructure, CAM-LEVER clamped directly onto Panel
   C's existing fixed deck (tool-free), occupying the LAST
   headboard_length (14in) of Panel C's own length — the end flush to
   the tailgate, right next to the kitchen/fridge void underneath.
   Layout, tailgate to front seats: Kitchen (Panel C's fridge/kitchen
   void) -> this shelving -> Bed (rest of Panel C + Panel B + Panel A)
   -> front seats. CURRENT LAYOUT (see the markdown + elevation
   renders for the full story): 2 fixed full-depth shelves + 1
   adjustable shelf on pins make full-width food tiers held by fiddle
   lips + lash straps; the personal area is an ENCLOSED bed cubby in
   the middle tier (not a single open shelf). No separate frame/legs/
   floor contact of its own — it rides entirely on Panel C's structure.
   headboard_length used to be just 8in (the leftover open floor at
   the front, once the headboard stopped needing its own module) —
   Panel A now moves flush to the front seatbacks instead (see
   panel_a_y0 below) so that 8in of previously-wasted floor gets used:
   2in restores the full 80in sleeping run (the HEST Dually Long mattress is 78in), and the
   remaining 6in adds to this shelving's own depth. ]
   WORTH VERIFYING: this 22in-tall structure sits right at the
   tailgate opening — confirm it doesn't interfere with the tailgate's
   own swing-up clearance or with reaching the fridge/kitchen as they
   slide out (Section 0). */
headboard_length = 14;  // Y depth — how much of Panel C's own length this consumes
headboard_width  = 46;  // matches panel_width
headboard_height = 22;  // above Panel C's deck level — as tall as the roof allows (see assert below)
                        // was 14; the extra height is all storage volume, split
                        // front/back by headboard_food_depth below

// depth split: kitchen-facing (food) compartment vs. mattress-facing
// (personal-item) compartment, separated by one full-height divider
// panel_thickness thick. The personal shelf is a fixed, deliberately
// shallow depth (just enough for a phone/glasses case) — all of the
// extra depth headboard_length gained (6in, see above) goes to the
// food side instead, since that's the actual pantry storage. See
// headboard_food_depth below (after panel_thickness is defined) for
// the derived food-compartment depth.
headboard_shelf_depth = 2.75;     // clear depth, mattress-facing personal NOOK in the top tier — fixed, not derived
headboard_food_shelf_count = 2;   // FULL-DEPTH shelf boards -> 3 full-width tiers (owner's July 2026 pattern: no full-height divider, no top; only a short nook divider in the top tier)

// Bottom-bay ADJUSTABLE shelf (owner, July 2026): the 13in bottom
// tier is deep enough for tall bottles/boxes/pots but wastes air
// above short items, so it gets ONE extra full-depth shelf on pins —
// run the bay as a single 13in bay OR split it into two ~6in tiers
// per trip. Pin-hole columns up both side panels let the board sit
// anywhere between headboard_pin_lo and headboard_pin_hi.
headboard_adj_shelf   = true;
headboard_adj_shelf_z = 6.5;  // default board position (splits the bottom bay ~6.5in / ~5.75in)
headboard_pin_lo      = 3;    // lowest pin hole above the deck
headboard_pin_hi      = 11;   // highest pin hole below the bed shelf
headboard_pin_step    = 1;    // pin-hole spacing (5mm shelf-pin holes)

// RETENTION (owner, July 2026): plain bungee nets don't hold rigid
// camp-kitchen items (plates, cans, bottles, utensils) under braking
// — they slide, rattle, and load the screw-eyes. Switched to the
// marine-galley system: a FRONT FIDDLE LIP on each food shelf
// (primary retention — stops the forward slide under braking) + an
// elastic lash strap across each opening (for the taller items) +
// bins for small/loose items + non-slip liner. A net stays only on
// the one soft-goods tier (bread/chips/produce).
headboard_fiddle_lip_h = 1.5;  // front-lip height on each food shelf

/* [Panels A/B/C — fixed tops, one continuous full-length deck] */
// The deck is now ONE continuous raised platform on uniform legs —
// not sleeping panels plus a separate shorter rear row. Panel C's
// under-void houses the fridge (on a side-pull slide) and the
// kitchen unit (its own tailgate slide) INSTEAD OF the side drawers
// A and B get — see fridge_bay_module()/kitchen_box_module() in
// platform.scad.
// panels_total_length is 94" — Panel A now sits flush with the front
// seatbacks (panel_a_y0 = 0, below) instead of leaving 8" of open
// floor in front of it, so the 3 panels fill the entire usable_length
// with nothing left over. The headboard/pantry still doesn't add its
// own separate length; it rides on the LAST headboard_length (14")
// of Panel C's own 36", so the sleeping run available for the
// mattress is panels_total_length - headboard_length = 80" — a full,
// 80in sleeping run — the HEST Dually Long mattress (78in) leaves ~2in of spare.
panel_a_length   = 29;
panel_b_length   = 29;
panel_c_length   = 36; // holds the fridge + kitchen unit underneath, AND the headboard/pantry (last 14in) on top
panel_width      = 46;  // deck width — see leg_inset for floor-level clearance
panel_thickness  = 0.75; // 3/4" Baltic birch (Section 3)
headboard_food_depth = headboard_length - headboard_shelf_depth - panel_thickness; // 10.5 — clear depth of the TOP tier's kitchen-facing side, behind the nook divider (the middle/bottom tiers are FULL depth now — no divider down there)
// Mattress: bought HEST Dually Long (hest.com) — 78 x 50 x 4in solid
// foam (memory-foam top over polyfoam, NO air chambers), washable
// waterproof cover included. 25in of width per person on the 52in
// cantilevered platform; the 2in of spare length sits at the head
// end under the headboard shelf. BUDGET FALLBACK (Section 4/6): the
// old DIY foam build — queen 60x80 blanks cut to 50x78, using the
// foam_* layer params below (they only drive the fallback's step
// diagrams now, steps/mattress_lego.scad).
mattress_length  = 78;  // HEST Dually Long
mattress_width   = 50;  // HEST Dually Long — 25in per person
mattress_blank_width = 60;   // DIY FALLBACK: queen foam blank, before trimming
foam_base_t    = 4;    // DIY FALLBACK: firm polyurethane base layer
foam_mid_t     = 0;    // DIY FALLBACK: egg-crate layer DROPPED (thickness parity with the HEST)
foam_topper_t  = 1.5;  // DIY FALLBACK: memory-foam topper
mattress_total_thickness = 4; // HEST Dually Long thickness (DIY fallback: 4in base + 1.5in topper = 5.5, ~1.5in less headroom)

// The ONE personal shelf sits 1ft above the mattress TOP (not the
// deck) — a comfortable reach while lying on your back. Measured, per
// the existing convention, as height above the shelving-compartment
// floor (= Panel C's deck surface). The mattress base now sits a full
// platform stack above that deck: adjuster pads (nominal 1in) + the
// bed platform itself — see bed_platform_stack, defined after the
// adjuster/platform sections below (OpenSCAD needs those first).

// Component 2: the one-piece slatted bed platform. Stack order,
// bottom to top: the panel boxes sit on the van floor on their
// leveling feet -> the flush platform rests DIRECTLY on Panel A and
// B's top rails -> mattress on top. Leveling happens down at the leg
// feet (see the leveling section below), not between layers.
//
// The platform spans Panel A + B ONLY and ENDS at the B/C seam:
// Panel C keeps its own fixed 3/4in deck at exactly the same
// surface height (rail top + 3/4in), so the two meet flush and the
// mattress's last ~20in simply rides Panel C's deck. An 80in
// platform would have to sit ON that deck — 3/4in too high — so
// don't build one.
//
// SOURCING (Section 6, Component 2): ten 45in slats cut from five
// 1x4 x 8ft pine boards (two per board) + two 58in side rails from
// two more — 7 boards total. Bought queen slat sets usually ride on
// metal frames or stapled webbing that don't survive cutting down,
// so plain boards are cheaper AND simpler.
bed_frame_length = panel_a_length + panel_b_length; // 58 — Panel A + B only; ends flush at the B/C seam (Panel C's own deck carries the rest of the mattress)
// The platform CANTILEVERS past the 46in boxes: the boxes are stuck
// at 46 (legs must land between the floor vents; boxes pass the 48in
// gate), but the mattress rides 19-27in up where the Sienna is wider
// than the 48.5in floor pinch. UNVERIFIED: measure wall-to-wall at
// ~19in and ~23in above the floor along the whole run — need >=53in
// for this width (Section 0). The 52x58 platform enters the van
// tilted diagonally through the gate (gate diagonal ~60in).
bed_frame_width    = 52;  // 3in overhang past the boxes on each side
platform_overhang  = (bed_frame_width - panel_width) / 2; // 3 — reference
bed_slat_t       = 0.75;  // 3/4in solid-wood slat (typical bought queen slat, ~1x4 pine/poplar)
bed_slat_width   = 3.5;   // in, each slat's own width (1x4 actual)
bed_slat_count   = 10;    // -> 9 gaps across the 58in span, ~2.6in each — fine for a foam mattress
// FLUSH LADDER platform: two 1x4 side rails run the full 58in, and
// the slats (cut to 45in) sit BETWEEN them, pocket-screwed into the
// rails' inner edges — everything in one 3/4in plane, top and bottom
// flush. No battens underneath anymore.
bed_rail_width   = 3.5;   // 1x4 side rails, actual width
bed_slat_length  = bed_frame_width - 2 * bed_rail_width; // 45 — slats span between the rails
bed_frame_thickness = bed_slat_t; // 0.75 — one flush plane, rests directly on the box rails


/* [Frame / legs] */
// leg_height is now driven by the fridge (see below): the fridge
// section is built INTO the sleeping platform (a lift-off deck
// hatch over the fridge, not a separate free-standing module at
// its own height), so leg_height must be tall enough to hide the
// fridge's full 15.79in height underneath the deck, plus a little
// wiggle room. That's also why it went up from the original 11in
// (sized only for a folded 3rd-row well) — measure your well depth
// and adjust if 17in doesn't clear it (Section 1/2).
leg_height     = 17;    // 15.79in fridge height + ~1.5in clearance, rounded
frame_rail_sz  = 1.5;   // 2x2 pine actual dimension (Section 3)
leg_inset      = vent_intrusion_width; // legs sit inset this much from the deck's outer edge so they land clear of the floor-level vent intrusion
// EXCEPTION: Panel C's REAR leg pair sits at the TRUE corners (zero
// inset) — the fridge/kitchen slide paths pass exactly where inset
// legs would stand. UNVERIFIED (Section 0): confirm the floor vents
// don't reach the last ~4in at the tailgate corners.

// CUBE FRAMES (owner, July 2026): each box also gets BOTTOM rails
// (2x2, between the legs just above the leveling feet) wherever a
// face doesn't need to stay open — closing the frame into a full
// box beats diagonal braces alone for racking stiffness. Which
// faces: Panel A gets its 2 END faces only (both SIDE faces must
// stay open — the drawer and WAVE 3 exit there at floor level);
// Panel B gets ALL 4 (nothing exits it sideways — the full cube);
// Panel C gets its FRONT face only (the appliances slide out the
// tailgate at floor level, and their bays occupy both sides' floor
// runs). The existing diagonal corner braces stay on top.
bottom_rail_z  = 1;     // underside of the bottom rails — dropped to the leg bottoms (owner, July 2026): as low as they go without hitting the leveling feet (0-1in) below, giving the tallest box section (marginally stiffer) and the lowest floor-edge curb. Leaves hand room at the corners to reach the star knobs.

// Leg leveling feet — back at the FLOOR (the between-layers
// adjusters cost 1.25in of headroom for no real gain): each leg is
// CUT 1in short (leg_cut below) and gets a 3/8"-16 threaded insert
// in its bottom end grain, taking a leveling glide bolt with a broad
// pad + star-knob hand grip. Effective leg height stays leg_height
// (17in), so nothing else moves. Every leg is exposed at floor level
// with nothing boxing it in — kneel at the side door, tip that
// corner slightly, and spin the knob. 12 total: 4 per panel x 3.
leveling_foot_count    = 12;
leveling_foot_travel   = 0.5;  // in, +/- adjustment from nominal
leveling_foot_nominal_h = 1;   // in, exposed foot height at mid-adjustment (legs are cut this much short)
leveling_foot_pad_dia  = 1.5;  // in, floor pad diameter
leveling_foot_thread   = "3/8-16"; // insert + glide bolt thread size, text only (not a dimension)
// LOAD CHECK (owner concern, July 2026): worst case ~700lb total
// (2 people + mattress + platform + boxes + cargo) over 12 feet =
// ~60lb/foot nominal vs the feet's 330lb rating each — a 5x margin
// before dynamic factors. The feet are not the weak point; see the
// Section 6 leveling note for the access answer: level the VAN at
// the wheels per site (leveling blocks + the Block Calculator); the
// interior feet are set ONCE. Electric feet were considered and
// REJECTED (owner, July 2026).
leg_cut_length = leg_height - leveling_foot_nominal_h; // 16 — the actual saw cut; foot makes up the rest

// deck surface -> mattress underside: just the flush platform now —
// it rests DIRECTLY on the box top rails, no adjusters between
bed_platform_stack = bed_frame_thickness; // 0.75in
// Bed shelf 9in above the MATTRESS TOP (owner). The personal nook is
// now an ENCLOSED middle-band cubby (owner's July-18 layout sketch):
// a full-depth food tier runs ABOVE it and a taller one BELOW it, and
// the nook divider spans the middle tier from the bed shelf up to the
// upper shelf, so the cubby has a floor, a back wall, and a ceiling —
// open only toward the mattress.
headboard_personal_shelf_z = bed_platform_stack + mattress_total_thickness + 9 - panel_thickness; // 13.0 — bed-shelf board; SURFACE at 13.75 = 9in above the mattress top
headboard_upper_shelf_z    = 18;  // upper food shelf — makes the top tier (18.75..22) and forms the bed cubby's ceiling; the bottom tier (0..13) is one tall open compartment
headboard_nook_divider_h = headboard_upper_shelf_z - (headboard_personal_shelf_z + panel_thickness); // 4.25 — divider fills the middle tier, bed-shelf top to upper-shelf underside (enclosed cubby)

/* [Side door opening — UNVERIFIED, confirm by physical measurement] */
// Same status as the gate opening numbers below: a typical 4th-gen
// Sienna sliding door opening estimate, NOT a measurement. Every
// drawer needs to physically pass through this opening to be
// pulled fully out. Both sliding doors are used (one per side).
// NOTE ON POSITION: a ~40in-wide door opening won't expose the full
// 58in drawer run (Panel A + Panel B) from one position — the
// drawers nearest the door are easy reach, the far ones need a
// lean/reach, and if the door doesn't overlap a panel AT ALL, that
// panel's drawers are unreachable from the side entirely (blocked by
// the van's own body structure, not just an awkward reach). Confirm
// your door's actual fore-aft position once measured (side_door_y0
// below), and see the reachability check further down.
side_door_opening_width  = 40; // UNVERIFIED — fore-aft span of the opening
side_door_opening_height = 40; // UNVERIFIED
// Fore-aft position of the door opening's FRONT edge, measured from
// the same Y=0 reference as van_interior_length (closed hatch to the
// front seatbacks). This is a genuinely unmeasured placeholder, not
// even a researched estimate like the numbers above — sliding doors
// on this generation of minivan typically start close to the front
// seatbacks (roughly where the old 2nd row began), so Y=0 is used
// here as a rough starting guess. MEASURE THIS: stand outside the
// open side door and measure from the front seatback to the door
// opening's front edge (Section 0).
side_door_y0 = 0; // UNVERIFIED PLACEHOLDER — not yet even roughly researched

/* [Side-access sliding drawers — one pair (left + right) per panel] */
// Each panel module gets 2 drawers (left + right), riding on
// full-extension slides, separated by a center divider rail so
// they don't collide. Drawers replace the old hinged-top access —
// tops are now fixed, screwed to the frame.
drawer_slide_length = 20; // standard full-extension slide hardware size
drawer_divider_t    = frame_rail_sz; // center divider rail, same 2x2 stock as the frame
drawer_side_clear   = 0.75; // gap between drawer box and rail/divider each side, for slide hardware
drawer_box_t        = 0.5;  // drawer box material thickness (thin plywood/melamine), also used below to size clear interior space
// drawer box footprint, derived from the panel's own dimensions —
// assumes all three panels are the same length (true above; if you
// change one panel's length independently, revisit this)
drawer_depth   = panel_a_length - 2 * frame_rail_sz - 1; // fore-aft (Y) span, between the front/back legs
drawer_travel  = panel_width/2 - frame_rail_sz - drawer_divider_t/2 - drawer_side_clear; // X extent (how far it slides); drawer box's own outer width too, per drawer_module()
drawer_height  = leg_height - frame_rail_sz - 1; // Z, inside the leg-height storage bay, under the fixed deck
// interior clear space once the box's own walls/floor are subtracted —
// what actually fits inside a drawer (used for the DELTA3 stack fit
// check below)
drawer_clear_width  = drawer_travel - 2 * drawer_box_t;
drawer_clear_depth  = drawer_depth - 2 * drawer_box_t;
drawer_clear_height = drawer_height - drawer_box_t; // open-top drawer, only the floor to subtract

/* [Modular lift-out design] */
// Each panel, the fridge bay, and the kitchen box are built as an
// independent, self-supporting module (own perimeter frame + own
// 4 legs) so any one of them lifts straight out without touching
// the others. Not for using a subset of features — every module
// is still needed — this is purely so install/removal is fast and
// each piece is a manageable one-or-two-person lift.
// Hand-hold holes + router jig: REMOVED from the plan (owner, July
// 2026). With no tops and no side skirts, every panel's 2x2 top
// rails are fully exposed — grip those to lift; routed hand-holds
// were a holdover from when the panels had solid plywood tops. The
// handle/router constants stay defined only so the retired
// jig_detail.scad still compiles if ever revisited.
handle_width  = 4;    // RETIRED — see note above
handle_radius = 0.75; // RETIRED
router_base_dia = 5.875; // RETIRED — Porter Cable plunge router base
router_bit_dia  = 0.5;   // RETIRED

bumper_thickness  = 0.25; // felt/rubber anti-rattle pad at each module seam
alignment_pin_dia = 0.375; // locating dowel diameter, keeps modules registered

/* [Seam draw-latches — clamp adjacent modules together (owner, July
   2026)] */
// Over-center draw latches tie each lift-out module to its neighbour at
// the A/B and B/C seams. The alignment pins only LOCATE the modules;
// these PULL them tight against the bumper strip so the three boxes act
// as one long beam instead of three that can walk apart or rock
// relative to each other. Combined with the bed platform (which already
// ties the A/B tops together), a low latch completes a top-and-bottom
// couple — that's what kills sway and rattle. They are HAND-released
// (over-center handles), so the modules still lift out in seconds — the
// modular design is preserved. Mounted LOW on the bottom-rail band, at
// BOTH side faces of each seam, reachable from the side door / tailgate.
// NOTE (honest scope): this buys rigidity + quiet, not a higher load
// rating — the cube-framed boxes are already strong (see the leg-foot
// load check). Don't rely on it to carry more weight.
seam_latch_count = 4;                                // 2 seams x 2 sides
seam_latch_z     = bottom_rail_z + frame_rail_sz/2;  // 1.75 — centered on the bottom-rail band
seam_latch_len   = 3;                                // over-center draw latch, closed body length
seam_latch_x     = panel_width/2 - leg_inset;        // 20.5 — latch sits over the inset leg line, each side

/* [Panel C front wall — the ONE wall any panel gets] */
// Skirts/walls audit (owner Q&A, July 2026): Panel A — none (both
// bays face the side doors); Panel B — none (nothing visible, bare
// frame deep storage); Panel C — exactly ONE, on its front
// (B-facing) face: it mounts the 120mm intake fan and passes the
// fridge DC line (grommet). No side walls on C either (the van wall
// is ~1in away, and the exhaust fan still pulls a net flow across
// the fridge), and its tailgate face needs no wall — fully occupied
// by the fridge, cabinet door, kitchen unit, and kitchen drawer
// face. See panel_c_wall_detail.scad for the dimensioned holes.
pcwall_t = 0.5;         // 1/2in ply
pcwall_h = leg_height;  // 17 — van floor up to the front rail's underside
pcwall_grommet_dia = 1; // fridge DC line pass-through

// Passive cooling vents (owner, July 2026 refinements). Both are
// cheap louvered RV vents, no wiring:
//  - a LOW intake louver in the front wall's driver-side corner
//    admits the coolest floor-level cabin air straight to the
//    fridge's condenser, supplementing the powered intake fan above
//    it (summer-heat margin);
//  - a LOW louver in the utility-cabinet door gives the exhaust fan's
//    warm air a direct path OUT low toward the tailgate instead of
//    only bleeding around the door edges.
intake_vent_w = 7;    // low front-wall intake louver — width
intake_vent_h = 2.5;  // height
intake_vent_x = 5.5;  // center X from the driver edge (low-driver corner, clear of the fan)
intake_vent_z = 5;    // center Z, just above the front bottom rail (top at 3.5)
cabinet_vent_w = 3;   // low cabinet-door exhaust louver — width (fits the ~4.3in door)
cabinet_vent_h = 4;   // height
cabinet_vent_z = 5;   // center Z, low in the door

/* [Fridge — BougeRV ROCKY 40 (CR04001), 41QT dual-zone] */
// Dimensions VERIFIED against the user manual the owner saved at
// ~/Downloads/Rocky_metal_fridge_user_manual.pdf: body 712x450x401mm
// (28.03 x 17.72 x 15.79in); the product page's 28.74in depth
// includes the handles — that larger figure is used for the bay.
// 40.6 lb (18.4 kg) empty per the manual spec table, 60W max / 45W
// ECO, 12/24V DC + AC + solar input, dual-zone
// (17L + 19L boxes, removable partition), optional detachable B240
// battery (inserts at the compressor end — face that end toward the
// TAILGATE so the battery swaps without a full slide-out). The LID
// IS REVERSIBLE (manual section 4.4) — re-hinge it to open whichever
// way suits once in the van. Long axis runs fore-aft; the 17.72in
// side runs left-right, beside the kitchen. On its own slide — see
// fridge_slide_length below — pulled out the open TAILGATE for lid
// access. Manual notes: <5 deg tilt while running, let it stand 12h
// before first power-up.
fridge_ext_length = 17.72; // X — left-right (the 450mm side)
fridge_ext_width  = 28.74; // Y — front-to-back depth into the bay (incl. handles)
fridge_ext_height = 15.79; // Z — drives leg_height above (16.29 with tray, 0.71in spare)
// Clearance: the manual wants 200mm behind the compressor + 100mm
// sides for PASSIVE venting — the bay can't give that, which is
// exactly what the forced intake/exhaust fan system compensates for
// (aim the airflow across the compressor end).
fridge_side_clearance = 2;  // with forced airflow; manual's passive figures are 7.9/3.9in

/* [Fridge slide — heavy duty, loaded weight is real] */
// Empty the Rocky 40 is 40.6 lb (18.4 kg, manual), and loaded with
// food/drinks it can hit ~60-90 lb — too heavy to pull by hand
// without tipping or binding. It sits on its
// own plywood tray (screwed down, with a lip) riding a pair of
// heavy-duty full-extension slides rated well above the load.
fridge_slide_length = 24;   // 24in, 200lb-rated full-extension slide pair
fridge_tray_t       = 0.5;  // plywood tray thickness

/* [Fridge cooling — intake fan + exhaust fan + temp sensor] */
// TWO 120mm fans, both wired to the same PWM temperature controller
// (Section 4/7): the INTAKE fan (mounted on the fridge bay's front,
// Panel-B-facing wall) pushes outside cabin air INTO the bay; the
// EXHAUST fan (mounted on the bay's KITCHEN-facing wall, blowing into the utility cabinet, where an
// earlier draft of this plan used a passive vent instead) actively
// pulls warm air OUT into the control compartment next door. An NTC
// thermistor probe sits inside the bay, on the kitchen-facing wall
// next to the exhaust fan (in the path of the warmest air, so it
// reacts quickly when the compressor is working), and feeds the
// controller that drives both fans together — they only spin up
// when the bay is actually warming up. See fridge_wiring.scad for
// the full electrical wiring diagram.
intake_fan_dia  = 4.75; // 120mm, converted to inches
exhaust_fan_dia = 4.75; // 120mm, same size as the intake fan
sensor_dia = 0.4; // NTC thermistor probe, shown as a small marker

/* [Control compartment — power switches, surge protection, CO detector, fan controller] */
// Mounted on Panel C's tailgate-facing end rail, up at deck height
// (z_deck = leg_height + frame_rail_sz) — the fridge travels below
// that, through the open space between the corner legs, so the two
// don't collide even though the fridge now exits through the same
// tailgate opening the end rail spans. Small vertical panel, not its
// own floor footprint.
control_panel_width = 2.8; // the LMioEtool enclosure mounted TALL-ways (its 2.8in dimension across) — the cabinet gap is ~4.3in now that the appliances sit against Panel C's rear corner legs

// Fridge zone width: the fridge itself plus a small margin each
// side for the slide hardware, flush to Panel C's RIGHT edge so its
// tailgate-ward slide path stays clear of the kitchen unit's own
// path on the left.
fridge_slide_margin = 0.5;
fridge_module_width = fridge_ext_length + 2 * fridge_slide_margin;

/* [Kitchen unit — real JAGAHAHA slide-out camp kitchen, standalone] */
// Exterior dimensions from the actual product listing (JAGAHAHA
// wooden overland slide-out kitchen w/ drawer, left side, 2-burner,
// amazon.com/dp/B0FLDCNYZX): closed 26in L x 20in W x 11.8in H, 45
// lb, extends to 70in when slid out in use (with the tailgate open —
// that extension happens outside the vehicle, not something this
// design needs to make room for while driving/stowed).
// This is a self-contained manufactured unit, not something we
// build — it sits directly on the van floor (secured with straps to
// tie-down anchors, Section 6) rather than getting its own custom
// lift-out frame like the fridge does. It lives under the deck in
// Panel C too, flush to the LEFT edge, sliding out the tailgate on
// its own built-in rails.
kitchen_box_width  = 20;   // X
kitchen_box_length = 26;   // Y, closed/stowed length
kitchen_box_height = 11.8; // Z, closed

/* [Kitchen drawer — hung under Panel C's deck, above the kitchen unit] */
// The kitchen unit is only 11.8in tall but Panel C's void is 17in
// clear (rail underside) — a shallow slide-out drawer lives in that
// dead air, hung from the deck by two 3/4in ply cheeks, pulling out
// the open TAILGATE directly above the kitchen unit (the "kitchen
// drawer": utensils, cutting board, flat dry goods, griddle plate).
// Width: the outer cheek butts the side rail's inner face
// (panel_width/2 - frame_rail_sz = 21.5 from center), the pair sits
// kdrawer_span apart, and side-mount slides eat 1/2in per side.
// Height: 1/2in clear over the kitchen's lid, top clears under the
// tailgate-face rail (17in) — see the assert below.
kdrawer_gap_below = 0.5;   // clearance above the kitchen unit's lid
kdrawer_box_h     = 4.5;   // exterior height (~3.5in clear inside)
kdrawer_span      = 17;    // cheek inner face to cheek inner face
kdrawer_box_w     = kdrawer_span - 1; // 16 — 1/2in slide clearance per side
kdrawer_box_len   = 26;    // Y — matches the kitchen unit's footprint
kdrawer_slide_len = 24;    // side-mount full-extension pair, 100lb class
kdrawer_cheek_t   = 0.75;  // hanging cheeks, 3/4in ply
kdrawer_z0        = kitchen_box_height + kdrawer_gap_below; // 12.3 — drawer underside
assert(kdrawer_z0 + kdrawer_box_h <= leg_height,
       str("Kitchen drawer top (", kdrawer_z0 + kdrawer_box_h,
           "in) must clear under Panel C's tailgate-face rail (", leg_height, "in)"));

/* [EcoFlow DELTA 3 Plus + Smart Extra Battery — Panel A, right drawer] */
// Real dimensions from EcoFlow's own spec sheets, not yet confirmed
// against the physical units — more trustworthy than the forum-
// sourced UNVERIFIED figures above, but still worth a tape-measure
// check before you build the drawer's internal blocking. Both units
// are stowed UNSTACKED, side by side (their 15.7in dimension running
// fore-aft), in Panel A's RIGHT (+X) drawer (Section 1's side-door
// reachability check). Stacked (Pogo-pin) height is ~19in, which does
// NOT fit a drawer's ~14in clear interior — unstacked is the only
// configuration that fits. Charged at camp via shore power/wall
// outlet or solar — this design does NOT route van power back to
// this drawer.
delta3_length        = 15.7;  // Y, shared by both units
delta3_plus_width    = 7.95;  // X, DELTA 3 Plus (main unit)
delta3_plus_height   = 11.16; // Z, DELTA 3 Plus
delta3_batt_width    = 8;     // X, Smart Extra Battery
delta3_batt_height   = 7.8;   // Z, Smart Extra Battery
delta3_combined_weight = 48;  // lb, ~28 (DELTA 3 Plus) + ~20 (extra battery)

/* [EcoFlow WAVE 3 — Panel A, left (driver-side) bay, open storage] */
// Real dimensions from ecoflow.com/us/wave-3-portable-air-conditioner/specs
// (unit only — the WAVE 3's own optional add-on battery is not part
// of this build). STORED (driving, not in use) directly in Panel A's
// left under-deck bay — no drawer box, no slide hardware, just resting
// on the bay floor between the frame rail and the center divider,
// reached by hand through the driver's side door. This is the ONE
// place in the build that skips the standard drawer construction: the
// unit is 20.4in wide, but a boxed drawer's clear interior is only
// 19in (drawer_clear_width, above) — too tight. The raw bay itself
// (wave3_bay_width below, no box walls or slide clearance to eat into
// it) is 20.75in, just enough. A couple of UHMW or laminate glide
// strips on the bay floor (Section 6) cut friction sliding it in/out
// by hand, since there's no slide hardware to do that job.
// USED (camp time): carried to wherever it actually runs — Panel C's
// deck at the tailgate end (tent pitched, blowing through the open
// tailgate) or the front passenger seat (no tent, hoses through a
// window vent kit) — see the "WAVE 3 sleeping configurations" note,
// Section 1. A cheap non-slip mat at the point of use keeps it from
// creeping while it runs; unlike the old tailgate tray, that's no
// longer a built plywood tray since the unit doesn't live there
// anymore. See delta3_wave3_detail.scad.
wave3_width  = 20.4; // X
wave3_depth  = 11.7; // Y
wave3_height = 13.2; // Z
wave3_weight = 33.7; // lb, unit only
wave3_bay_width = panel_width/2 - frame_rail_sz - drawer_divider_t/2; // raw open-storage bay width, no box/slide clearance subtracted — same formula as drawer_travel before its 0.75in slide allowance

// FOUND STORAGE (owner, July 2026) — reclaim the dead headroom above
// two units, no structural change:
//  - the DELTA 3 stack is 11.16in tall in a 14.5in drawer -> ~3in of
//    clear headroom above it takes a shallow lift-out TRAY (cables,
//    the DELTA 3's own cords, dongles);
//  - the WAVE 3 is 13.2in tall in the 17in left bay -> a thin SHELF
//    on cleats just above it holds flat soft goods / the WAVE 3's
//    hoses+remote, and the WAVE 3 still slides out beneath it.
delta3_tray_h  = 3;                       // shallow tray on top of the DELTA 3 stack
wave3_shelf_z  = wave3_height + 0.5;       // 13.7 — cleat-mounted shelf just above the WAVE 3
wave3_shelf_clear = leg_height - wave3_shelf_z - panel_thickness/2; // ~2.9in usable above the shelf
wave3_intake_hose_dia  = 6; // in
wave3_exhaust_hose_dia = 5; // in

// ------------------------------------------------------------
// Derived values
// ------------------------------------------------------------
panels_total_length   = panel_a_length + panel_b_length + panel_c_length; // 94
// The headboard/pantry no longer occupies its own separate slot — it
// rides on Panel C's own deck — so the assembly's real length is just
// the 3 panels. With Panel A flush to the front seatbacks (panel_a_y0
// = 0, below), this now fills usable_length(94) exactly — no leftover
// open floor anywhere.
assembly_total_length = panels_total_length; // 94 — must be <= usable_length (94)
// bed_length is what's actually available for the mattress: Panel C's
// own length minus the headboard/pantry's 14in bite out of its
// tailgate end, plus all of Panel B and Panel A.
bed_length = panels_total_length - headboard_length; // 80
rear_row_width = fridge_module_width + kitchen_box_width; // just for reference/BOM text — the two don't need to touch, see the gap check below

// Kitchen unit on Panel C's RIGHT (passenger) side — its shelves
// swing out on that side, per the owner — fridge module on the LEFT
// (driver) side. NO LONGER FLUSH TO THE DECK EDGES: Panel C's REAR
// leg pair sits at the true corners (the appliances' slide paths
// pass right where inset legs used to stand — a collision the Rocky
// 40's extra 5in of width exposed), so both appliances sit flush
// against those corner legs' INNER faces, 1.5in in from each edge.
// Both still slide out the open TAILGATE between the legs. The gap
// between them is the utility cabinet (~4.3in — see the door/panel
// asserts below).
x_kitchen       = panel_width/2 - frame_rail_sz - kitchen_box_width/2;
x_fridge_module = -panel_width/2 + frame_rail_sz + fridge_module_width/2;
x_fridge        = x_fridge_module; // fridge cavity center = module center now (no separate control-panel column)
x_control_panel = (x_fridge_module + fridge_ext_length/2 + fridge_slide_margin
                   + x_kitchen - kitchen_box_width/2)/2; // cabinet-gap center — the panel lives INSIDE the cabinet, behind its door (unused by the drawings, kept as the named reference)

// Deck width/length aliases (deck can be wider than usable_floor_width
// since it's up on legs, clear of the floor-level vent intrusion —
// only the legs themselves need to stay inset; see leg_inset above)
platform_width  = panel_width;
platform_length = panels_total_length; // full sleeping-deck length, headboard excluded

// Total height of each module standing on its own legs — this is
// what has to clear the liftgate opening height when carrying a
// module in its natural upright orientation (legs down, the way
// it sits once installed).
panel_module_height = leg_height + frame_rail_sz + panel_thickness; // 19.25
// The fridge lives inside Panel C's own void (same leg_height,
// same fixed top as A/B — no hatch needed since access is through
// the side door, not from above) — so its "module height" for
// gate-fit purposes is really just Panel C's own height, same as
// every other panel. The fridge itself (15.79in) sits on its slide
// tray inside the leg_height void, hidden below deck level, not
// stacked on top of the frame — that's what let leg_height (17in)
// absorb the fridge's height without the panel getting any taller.
fridge_bay_module_height = panel_module_height; // 19.25
// The kitchen unit is a standalone manufactured product sitting
// directly on the van floor (no custom frame) — its own height,
// not leg_height-driven. Kept as its own name for the gate-fit
// assert below and the BOM/text that reference it.
kitchen_box_module_height = kitchen_box_height; // 11.8

// ------------------------------------------------------------
// Hard-limit guards — fail every render loudly instead of
// silently overflowing the van if a dimension above gets bumped
// ------------------------------------------------------------
assert(assembly_total_length <= usable_length,
       str("Assembly is ", assembly_total_length,
           "in long but only ", usable_length, "in is usable (", van_interior_length, "in hatch-to-seats minus ",
           hatch_curvature_clearance, "in hatch clearance)"));
assert(kitchen_box_width + fridge_module_width + 2 * frame_rail_sz <= panel_width,
       str("Kitchen unit (", kitchen_box_width, "in) + fridge module (", fridge_module_width,
           "in) + Panel C's 2 rear corner legs is wider than the ", panel_width, "in panel — they'd overlap"));
assert(x_kitchen - kitchen_box_width/2 - (x_fridge_module + fridge_module_width/2) >= control_panel_width + 0.4,
       str("Utility-cabinet gap (", x_kitchen - kitchen_box_width/2 - (x_fridge_module + fridge_module_width/2),
           "in) is too narrow for the control panel (", control_panel_width, "in) plus working clearance"));
assert(panel_width - 2 * leg_inset <= usable_floor_width,
       "Panel legs (deck width minus 2x leg_inset) land inside the vent intrusion zone");
assert(panel_width <= van_interior_width,
       str("Deck is ", panel_width, "in wide but the interior is only ",
           van_interior_width, "in between the wheel wells"));
assert(fridge_bay_module_height <= van_interior_height,
       "Fridge bay top exceeds the interior height limit");
assert(fridge_ext_width + fridge_side_clearance <= panel_c_length,
       str("Fridge (", fridge_ext_width, "in deep) plus its ", fridge_side_clearance,
           "in clearance guideline needs ", fridge_ext_width + fridge_side_clearance,
           "in, but Panel C is only ", panel_c_length, "in long"));
assert(kitchen_box_length <= panel_c_length,
       str("Kitchen unit is ", kitchen_box_length, "in long (closed) but Panel C is only ",
           panel_c_length, "in long"));
assert(fridge_ext_height <= leg_height,
       str("Fridge is ", fridge_ext_height, "in tall but leg_height is only ", leg_height,
           "in — it won't fit under the deck"));
assert(mattress_length <= bed_length,
       str("Mattress (", mattress_length, "in) is longer than the ", bed_length,
           "in sleeping run (Panel C minus the headboard/pantry's 14in, plus Panels B and A)"));
assert(drawer_height >= 4,
       str("Drawer box is only ", drawer_height, "in tall — raise leg_height or trim frame_rail_sz"));
assert(drawer_depth >= 10,
       str("Drawer box is only ", drawer_depth, "in deep (fore-aft) — panel is too short for a usable drawer"));
assert(drawer_travel >= 10,
       str("Drawer only travels ", drawer_travel, "in before hitting the divider — panel is too narrow for a usable drawer"));
assert(delta3_plus_width + delta3_batt_width <= drawer_clear_width,
       str("DELTA 3 stack is ", delta3_plus_width + delta3_batt_width,
           "in wide side by side, but a drawer's clear interior is only ", drawer_clear_width, "in"));
assert(delta3_length <= drawer_clear_depth,
       str("DELTA 3 units are ", delta3_length, "in deep, but a drawer's clear interior is only ",
           drawer_clear_depth, "in"));
assert(max(delta3_plus_height, delta3_batt_height) <= drawer_clear_height,
       str("Taller DELTA 3 unit is ", max(delta3_plus_height, delta3_batt_height),
           "in, but a drawer's clear interior height is only ", drawer_clear_height, "in"));

assert(wave3_width <= wave3_bay_width,
       str("WAVE 3 is ", wave3_width, "in wide, but Panel A's raw open-storage bay is only ",
           wave3_bay_width, "in — it won't fit even without a drawer box"));
assert(wave3_depth <= drawer_depth,
       str("WAVE 3 is ", wave3_depth, "in deep (fore-aft), but Panel A's bay only spans ",
           drawer_depth, "in between the front/back legs"));
assert(wave3_height <= drawer_height,
       str("WAVE 3 is ", wave3_height, "in tall, but Panel A's under-deck void is only ",
           drawer_height, "in tall"));

// ------------------------------------------------------------
// Side-door reachability check (soft warning, not a hard assert() —
// unlike the physical-fit guards above, "reduced reach" is a
// usability judgment, not an impossibility, so this prints a loud
// echo() instead of failing the render). Panel A and Panel B each
// only have ONE door per side spanning their combined 58in run — if
// a panel's Y-range doesn't overlap the door's Y-range AT ALL, that
// panel's drawers aren't just an awkward reach, they're blocked
// entirely by the van's own body structure between door openings.
// ------------------------------------------------------------
door_y0 = side_door_y0;
door_y1 = side_door_y0 + side_door_opening_width;
// Panel A sits flush with the front seatbacks (Y=0) — the headboard
// doesn't need its own slot here anymore (it's on Panel C now), and
// rather than leave that 8in as unused open floor, Panel A moved up
// to close the gap and the 3 panels grew to fill usable_length(94)
// exactly (see panels_total_length above).
panel_a_y0 = 0;
panel_a_y1 = panel_a_length;
panel_b_y0 = panel_a_y1;
panel_b_y1 = panel_b_y0 + panel_b_length;
panel_a_door_overlap = min(door_y1, panel_a_y1) - max(door_y0, panel_a_y0);
panel_b_door_overlap = min(door_y1, panel_b_y1) - max(door_y0, panel_b_y0);
// a few inches of overlap is technically nonzero but not practically
// reachable (you're grabbing at the very edge of a sliding drawer,
// through the narrow sliver of a door opening) — 12in is a rough,
// generous cutoff for "can actually get a hand and the drawer front
// through this," not a precise threshold
panel_a_reach_note = panel_a_door_overlap <= 0 ? "BLOCKED (0in or negative overlap — behind body structure, no opening at all)"
    : panel_a_door_overlap < 12 ? str("SEVERELY LIMITED (only ", panel_a_door_overlap, "in overlap — likely impractical)")
    : str(panel_a_door_overlap, "in overlap — reachable");
panel_b_reach_note = panel_b_door_overlap <= 0 ? "BLOCKED (0in or negative overlap — behind body structure, no opening at all)"
    : panel_b_door_overlap < 12 ? str("SEVERELY LIMITED (only ", panel_b_door_overlap, "in overlap — likely impractical)")
    : str(panel_b_door_overlap, "in overlap — reachable");
echo(str("Side door reach check (side_door_y0 is an UNVERIFIED PLACEHOLDER — measure it, Section 0): ",
         "Panel A = ", panel_a_reach_note, ". Panel B = ", panel_b_reach_note, "."));

// Gate-fit guards — every module must pass through the liftgate
// opening (see the UNVERIFIED note above) carried upright, legs
// down, width-first. These use the SAME hard-fail assert() as the
// vehicle-interior guards above, even though the input numbers are
// lower-confidence — an unverified assumption should still block a
// bad cut, not just print a warning that's easy to scroll past.
// Panels A, B, and C (fridge + kitchen now live inside Panel C, not
// as separate lift-out modules) all share the same width/height, so
// one pair of asserts covers all three modules that actually get
// carried through the gate. The kitchen unit's own slide-out only
// happens with the tailgate open at the campsite — it never needs
// to pass through the gate opening at all.
assert(panel_width <= gate_opening_width,
       str("Panel is ", panel_width, "in wide but the gate opening is only ",
           gate_opening_width, "in — it will not pass through"));
assert(panel_module_height <= gate_opening_height,
       str("Panel module is ", panel_module_height, "in tall but the gate opening is only ",
           gate_opening_height, "in"));

// Headboard/pantry: no longer its own base — it's a shelving
// superstructure cam-lever clamped onto Panel C's already-covered
// deck (Panel C's own frame/legs are already checked by the two
// gate-fit asserts above). It's still a SEPARATE piece for removal
// purposes, lifting off Panel C's deck on its own so its own height
// (not the combined Panel-C-plus-shelving height) has to clear the
// gate opening.
assert(headboard_height <= gate_opening_height,
       str("Headboard/pantry shelving unit is ", headboard_height, "in tall but the gate opening is only ",
           gate_opening_height, "in — it must clear the gate on its own, separate from Panel C"));
assert(panel_module_height + headboard_height <= van_interior_height,
       str("Installed headboard/pantry reaches ", panel_module_height + headboard_height,
           "in above the floor but the cabin is only ", van_interior_height, "in tall"));
assert(headboard_shelf_depth >= 1.5,
       str("Personal shelf is only ", headboard_shelf_depth, "in deep — too shallow for a phone/glasses case"));
assert(headboard_upper_shelf_z + panel_thickness <= headboard_height,
       str("Upper food shelf sits ", headboard_upper_shelf_z, "in up, but the shelving unit is only ",
           headboard_height, "in tall — raise headboard_height or lower the shelves"));
assert(headboard_upper_shelf_z > headboard_personal_shelf_z + panel_thickness,
       "Upper shelf must sit above the bed shelf with the nook cubby between them");
