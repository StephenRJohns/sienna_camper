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
// ALL MEASURED (owner, Aug 1 2026 — Section 0 survey V1-V10, taken
// with the 2nd row physically out and the 3rd row folded as it sits
// in camper mode). These are no longer estimates. Three of them came
// back tighter than the numbers this design was built on, and the
// knock-on edits are marked "(V1 Aug 2026)" etc. wherever they land:
//   V1 length  96   -> 93.75  (-2.25) — the whole panel train shrank
//   V3 height  44   -> 42     (-2)    — mid-van; at the gate it is 37
//   V4 vent    2.5  -> 3.5    (+1)    — per side, so leg_inset grew
//   V5 hatch   2    -> 0             — the build never gets high
//                                      enough to reach the glass
//                                      curvature, so nothing is
//                                      reserved at the tailgate end
// V2 came back 49" at the wheel-well pinch (54" further forward, but
// the pinch is what gates the 46"-wide boxes) — 0.5" better than the
// 48.5" this was designed against, so nothing downstream changes.
van_interior_length     = 93.75; // MEASURED V1 (Aug 2026) — closed hatch to front seatbacks, 2nd row out
van_interior_width      = 49;    // MEASURED V2 (Aug 2026) — floor pinch between wheel wells (54" forward of them); HARD MAX for the boxes
van_interior_height     = 42;    // MEASURED V3 (Aug 2026) — cargo floor to headliner, mid-van; HARD MAX
vent_intrusion_width    = 3.5;   // MEASURED V4 (Aug 2026) — rear lower heat vent intrusion, per side, at floor level only (sketched ~3.25" over a ~15" run; 3.5" is the value to build to)
hatch_curvature_clearance = 0;   // MEASURED V5 (Aug 2026) — nothing reserved: the deck never rises far enough to meet the hatch glass/trim curvature
// Wall-to-wall width UP at the sleeping plane, which is what the
// cantilevered bed platform actually has to fit between — NOT the
// floor pinch above. MEASURED V7 (Aug 2026): 50" at ~18.5" above the
// floor, 49.5" at ~22.5". The walls barely flare over the wheel
// wells, so 50" is the usable width (owner, Aug 2026) — the plan had
// assumed >=53" here, which is what forced bed_frame_width down from
// 52" to 49". See bed_frame_width below.
van_platform_width      = 50;    // MEASURED V7 (Aug 2026) — usable wall-to-wall at platform height

// usable design envelope after reserving hatch curvature clearance
usable_length = van_interior_length - hatch_curvature_clearance; // 93.75 (V5 reserves nothing)
usable_floor_width = van_interior_width - 2 * vent_intrusion_width; // 42 — floor-level width, legs must stay inside this

/* [Rear liftgate opening — MEASURED (owner, Aug 1 2026, V6)] */
// Every module must physically pass through this opening to be
// lifted in/out — that's the entire point of the modular design.
// Both numbers are now tape measurements, and both came back BETTER
// than the web-sourced estimates they replace (48 x 36): the
// narrowest width is 50" and the clear height is 37".
// The corners still round off hard, though — the opening is down to
// 20.5" of height by the time you are out at the rounded corner
// (V6b), so a module that only just clears 37" in the middle of the
// gate will foul if it is carried in flat against one side. Carry
// the 18.5"-tall boxes through the centre of the opening.
gate_opening_width  = 50; // MEASURED V6a (Aug 2026) — narrowest point of the liftgate opening
gate_opening_height = 37; // MEASURED V6b (Aug 2026) — clear height at the centre; only 20.5" out where the corner radius starts

/* [Rear pantry — PREFAB drawer cluster (owner, July 2026). The old
   plywood pantry is GONE, replaced by BOUGHT storage: a 2-wide x
   2-high array of IRIS USA 12in-W stackable storage drawers (Home
   Depot model 500163, sold as 3-packs — buy 2, use 4) sitting on the
   tailgate end of Panel C's deck, in the same last-pantry_len
   footprint (79.25in of sleeping run remains), plus a rigid pot/
   pan crate in the leftover open deck bay beside it. NOTHING is
   built or clamped: a cleat pocket (cab side + both sides, tailgate
   side open) plus ONE cam-buckle strap across the drawer fronts hold
   it — the strap doubles as the keep-the-drawers-shut retainer, and
   each unit lifts straight out (a few lb each, trivially clears the
   liftgate). Power strip 1 and the ROLL bubble level relocate to the
   deck edge in the open bay. Layout, tailgate to front seats:
   Kitchen (Panel C's void, below deck) -> this cluster (on the deck)
   -> Bed -> front seats. */
// (V5 Aug 2026) pantry_len went 14 -> 14.5. The drawer units are
// 14.3in deep and used to be allowed to sit 0.3in PROUD of the deck
// edge, on the grounds that 2in was reserved at the tailgate end for
// the hatch glass curvature anyway. V5 measured that reserve at ZERO
// (the build never rises far enough to meet the curve), so there is
// no reserve left to hang over into — Panel C's deck now has to carry
// the whole drawer. Costs 0.5in of sleeping run (79.75 -> 79.25in,
// still 1.25in clear of the 78in mattress).
pantry_len       = 14.5;  // Y footprint reserved on Panel C's deck
pantry_unit_w    = 12.1;  // one IRIS drawer unit — X (width)
pantry_unit_d    = 14.3;  // Y (depth) — now fully carried by the deck, 0.2in to spare
pantry_unit_h    = 8.4;   // Z (height)
pantry_cluster_w = 2 * pantry_unit_w; // 24.2 — 2 units wide, against the driver edge
pantry_cluster_h = 2 * pantry_unit_h; // 16.8 — 2 units high (top at deck 18.5 + 16.8 = 35.3, ~6.7in of roof clearance against the MEASURED 42in height (V3 Aug 2026) — a 3rd 8.4in tier no longer fits, it would foul the headliner by 1.7in)
pantry_bay_w     = 46 - pantry_cluster_w; // 21.8 — open deck bay, passenger side (pot crate + relocated power)
pantry_pot_bin   = 13;    // rigid pot/pan crate footprint in the bay (~13x13 milk crate; the pots' 11x11 box drops inside)

/* [Panel B deep storage — CONTAINERIZED (owner, July 2026): 4x
   Sterilite 28-Qt under-bed lidded totes (23.5 x 16.9 x 5.9 each),
   2 wide x 2 high on the van floor inside Panel B's bare-frame bay.
   Top-loaded: lift the platform, lift out whole labeled totes
   instead of rummaging a loose pile. Plain lidded totes, NOT the
   slide-drawer kind — Panel B has no side access, so a drawer front
   would be a wasted feature. ]*/
panelb_tote_l = 23.5;  // fore-aft (bay clear span ~26in between legs)
panelb_tote_w = 16.9;  // 2 across = 33.8 vs ~43in clear width
panelb_tote_h = 5.9;   // restacked ON the spare: cleats 3 + spare 6.4 + tote 5.9 = 15.3 of 18.5
panelb_tote_n = 2;     // was 4 — the spare tire now takes the other half of the bay
// SPARE TIRE (owner, July 2026): RJ-MODINI kit (T155/85R18 on an 18x4
// STEEL wheel, 60.1mm hub-centric bore, 28.5in dia — only -2% vs the
// ~29.1in OE tires, the closest-matched kit found — ~6.4in stored,
// ~40lb w/ 2-ton jack/wrenches/case; VERIFY weight+dims on arrival;
// the tool case nests inside the wheel barrel) stows FLAT in Panel B's
// bay at the AXLE — the best weight placement in the van; no hitch
// basket needed. Raised on 3in cleats above the bottom-rail curb,
// cam-strapped to the bottom rails, 2 totes restacked on top. The
// 27.7in disc clears the bay interior (29x43 between rails) — it
// does NOT fit above the kitchen (only ~24in before the fridge).
spare_dia   = 28.5;
spare_w     = 6.4;   // stored width incl. case (T155 section 6.1)
spare_cleat = 3;
assert(spare_dia <= panel_b_length && spare_cleat + spare_w + panelb_tote_h <= leg_height_ab + frame_rail_sz,
       "Spare stack doesn't fit Panel B's bay — check spare/cleat/tote dims");

/* [Panels A/B/C — fixed tops, one continuous full-length deck] */
// The deck is now ONE continuous raised platform on uniform legs —
// not sleeping panels plus a separate shorter rear row. Panel C's
// under-void houses the fridge (on a side-pull slide) and the
// kitchen unit (its own tailgate slide) INSTEAD OF the side drawers
// A and B get — see fridge_bay_module()/kitchen_box_module() in
// platform.scad.
// panels_total_length is 93.75" — Panel A now sits flush with the front
// seatbacks (panel_a_y0 = 0, below) instead of leaving 8" of open
// floor in front of it, so the 3 panels fill the entire usable_length
// with nothing left over. The rear pantry (prefab drawer cluster)
// doesn't add its own separate length; it rides on the LAST pantry_len (14.5")
// of Panel C's own 35.75", so the sleeping run available for the
// mattress is panels_total_length - pantry_len = 79.25" — the HEST
// Dually Long mattress (78in) still leaves ~1.25in of spare.
// (V1 Aug 2026) The measured interior came in 2.25" shorter than the
// 96" estimate AND V5 freed up the 2" that used to be reserved for
// the hatch curvature, so the train only had to give up 0.25" net.
// PANEL C absorbs all of it (36 -> 35.75), for two reasons that both
// rule out taking it off Panel A or B: (1) Panels A and B must stay
// the SAME length — steps/panel_ab_lego.scad asserts it, because they
// share one set of step diagrams and one cut list entry; (2) their
// combined length IS bed_frame_length, so shaving either one would
// change the bed platform's side rails from 58" and ripple through
// the lumber list for no reason. Panel C has ~7in of fore-aft slack
// around the 28.74in fridge, which is where the 1/4in comes from.
panel_a_length   = 29;
panel_b_length   = 29;
panel_c_length   = 35.75; // (V1 Aug 2026) was 36 — absorbs the 0.25" the measured interior lost; holds the fridge + kitchen unit underneath, AND the rear-pantry drawer cluster (last 14.5in) on top
panel_width      = 46;  // deck width — see leg_inset for floor-level clearance
panel_thickness  = 0.75; // 3/4" Baltic birch (Section 3)
// Mattress: bought HEST Dually Long (hest.com) — 78 x 50 x 4in solid
// foam (memory-foam top over polyfoam, NO air chambers), washable
// waterproof cover included. 25in of width per person; the ~1.75in of
// spare length sits at the head end at the rear-pantry cluster.
// (V7 Aug 2026) The mattress is the widest thing in the van: 50in
// wide, against a measured 50in of usable width at the sleeping plane
// and a 49in platform under it, so the foam overhangs its own frame by
// ~0.5in per side. DRY-FIT CONFIRMED (owner, Aug 2026): it goes in
// with a little play. Solid foam is what makes that work — it is not
// sprung, and the wall pinch lands only on the top of its 4in
// thickness. Do NOT narrow the mattress; build the platform at 49in.
// BUDGET FALLBACK (Section 4/6): the
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

// Component 2: the slatted bed platform — THREE pieces since Aug 2026,
// but only TWO of them loose: Panel A's full-width section is screwed
// down, and Panel B's two centreline halves lift out (see the split
// block below). Stack order, bottom to top: the panel boxes sit on the
// van floor on their leveling feet -> the flush platform rests DIRECTLY
// on Panel A and B's top rails -> mattress on top. Leveling happens
// down at the leg feet (see the leveling section below), not between
// layers. Every piece bears on the boxes' own rails (plus, for Panel
// B's two halves, a new centre bearer) exactly as the old one-piece
// platform did — nothing is carried by hardware.
//
// The platform spans Panel A + B ONLY and ENDS at the B/C seam:
// Panel C keeps its own fixed 3/4in deck at exactly the same
// surface height (deck_surface_z, 18.5 — C's deck recessed flush,
// A/B rails 3/4in lower under the platform), so the two meet flush and the
// mattress's last ~20in simply rides Panel C's deck. An 80in
// platform would have to sit ON that deck — 3/4in too high — so
// don't build one.
//
// SOURCING (Section 6, Component 2): everything is 1x4 x 8ft pine,
// CROSSCUT ONLY — a 1x4 is already 3/4 x 3-1/2, which is the slat spec,
// so there is no ripping anywhere in this component. Five 42in slats
// (Panel A) + ten 17.5in slats (Panel B's halves) + six 29in side rails
// = 7 boards, plus 52in of 2x2 for the centre bearer. Bought queen slat
// sets are deliberately NOT used: they come stapled to fabric webbing
// or riveted to metal side frames, and neither survives being cut down
// — you destroy the kit to salvage boards you could have bought
// straight.
bed_frame_length = panel_a_length + panel_b_length; // 58 — Panel A + B only; ends flush at the B/C seam (Panel C's own deck carries the rest of the mattress)
// The platform CANTILEVERS past the 46in boxes: the boxes are stuck
// at 46 (legs must land between the floor vents; boxes pass the 50in
// gate), but the mattress rides 19-27in up, off the 49in floor pinch.
//
// (V7 Aug 2026) THE CANTILEVER GOT CUT BACK. This design assumed the
// walls flare to >=53in up at the sleeping plane. They do not: the
// measured wall-to-wall is 50in at ~18.5in up and 49.5in at ~22.5in
// up, and 50in is the usable width (owner). So the 52in platform was
// 2in too wide and is now 49in — 1.5in of overhang per side instead
// of 3in, keeping ~0.5in of insertion clearance per side at the
// sleeping plane. Knock-on: the mattress is 50in wide (a BOUGHT HEST
// Dually Long), so it now overhangs the frame by ~0.5in per side and
// is a zero-clearance fit between the walls — see mattress_width.
// The 49x58 platform still enters the van tilted diagonally through
// the gate (50 x 37 gate, diagonal ~62in).
bed_frame_width    = 49;  // (V7 Aug 2026) was 52 — 1.5in overhang past the boxes on each side, inside the measured 50in usable width
platform_overhang  = (bed_frame_width - panel_width) / 2; // 1.5 — reference
assert(bed_frame_width <= van_platform_width,
       str("Bed platform is ", bed_frame_width, "in wide but only ", van_platform_width,
           "in of usable wall-to-wall width exists at the sleeping plane (V7)"));
bed_slat_t       = 0.75;  // 3/4in solid-wood slat (1x4 pine, crosscut only — no ripping, no bought slat kit)
bed_slat_width   = 3.5;   // in, each slat's own width (1x4 actual)
// FLUSH LADDER platform: 1x4 side rails with the slats sitting BETWEEN
// them, pocket-screwed into the rails' inner edges — everything in one
// 3/4in plane, top and bottom flush. No battens underneath.
bed_rail_width   = 3.5;   // 1x4 side rails, actual width
bed_slat_length  = bed_frame_width - 2 * bed_rail_width; // 42 — slats span between the rails
bed_frame_thickness = bed_slat_t; // 0.75 — one flush plane, rests directly on the box rails

// ---- SPLIT INTO 3 LIFT-OUT PIECES (owner, Aug 2026) ------------
// The platform is no longer one 58in piece. Panel B's bay is
// top-load-ONLY: the side door aperture measures 35 x 45in with only
// 29in of CLEAR gap at the door's stop (V8), and it sits over Panel A's
// footprint, not Panel B's — so nothing can be reached or pulled
// sideways out of Panel B at all. The ONLY way in is from the top, and
// that used to mean lifting the whole 49x58 platform off and finding
// somewhere in a packed van to put it.
//
// It is now THREE pieces, and only two of them are loose:
//
//   * Panel A's section — 29 x 49in, one piece, SCREWED DOWN and
//     permanent (owner, Aug 2026: it never needed to lift out, because
//     Panel A's two bays are both reached through the side doors —
//     the DELTA 3 drawer pulls out the passenger side, the WAVE 3 bay
//     is reached by hand from the driver side). Fixing it is a real
//     simplification, not just one less loose part:
//       - it becomes a screwed-down DIAPHRAGM across Panel A's rails,
//         putting back some of the torsional stiffness the design lost
//         when Panels A and B gave up their plywood tops (the diagonal
//         corner braces were added to cover that; they now have help
//         rather than carrying it alone),
//       - it is the fore-aft DATUM the two loose halves locate against,
//       - and it needs no anti-rattle pads, because it cannot rattle.
//     Trade: Panel A's bay loses its from-above deep-cleaning route and
//     is side-door-only. Acceptable — the 29in clear side gap exactly
//     spans Panel A's 29in length, and the DELTA drawer (25in fore-aft)
//     comes out through it.
//   * Panel B's TWO HALVES — 29 x 24.5in each, split on the
//     CENTRELINE, each lifting out on its own. Owner's call, Aug 2026.
//
// Why halves rather than one hinged hatch (the design this replaces):
//   1. 24.5in wide PASSES THROUGH the 35in side door. A 49in-wide leaf
//      does not — it could only ever come out the tailgate. Since the
//      whole point is working from a side door with the mattress lifted
//      clear, that difference decides it.
//   2. You remove only the half on the side you are standing at, so the
//      mattress only has to be lifted off half the width.
//   3. No hinge, no lid stay, and no opening-angle limit. A hinged
//      29in leaf could only reach ~67deg before hitting the headliner
//      (there is just 23.5in above the deck), so it needed a prop.
//   4. The centre bearer the halves land on (below) also HALVES the
//      bed's unsupported span over Panel B, from 46in to ~22in. Panel B
//      had no centre divider — Panel A always did — so this is the
//      stiffest the sleeping surface has been.
// Cost of the swap: two loose parts to set down instead of one captive
// lid, and ~+1.7lb over the hinged version.
//
// STILL TRUE: the mattress comes off (or gets folded clear) first. It
// is one 78in piece and Panel B is the MIDDLE third of the bed, so no
// fold uncovers it. Halving the width is what makes that manageable.
bed_split_y      = panel_a_length;        // 29 — the A/B seam, where the Panel A section ends
bed_sect_a_len   = panel_a_length;        // 29 — Panel A's one-piece section
bed_bhalf_len    = panel_b_length;        // 29 — each Panel B half, fore-aft
bed_bhalf_width  = bed_frame_width / 2;   // 24.5 — each half, across the van; fits the 35in side door
bed_bhalf_slat_l = bed_bhalf_width - 2 * bed_rail_width; // 17.5 — short slats, between each half's own rails
// Centre bearer: the halves' inner rails land on this, so it has to be
// wider than a single 2x2 or each rail only gets 3/4in of bearing. Two
// 2x2s side by side (or one 2x4 laid flat) gives 3in — 1.5in each,
// matching what the outer rails get from Panel B's long rails. Its top
// sits flush with those long rails at 17.75in, NOT at the deck plane.
// NOTE the literals: frame_rail_sz (1.5) is assigned further DOWN this
// file, and OpenSCAD evaluates assignments in order — referring to it
// here silently yields undef. Spelled out, with a cross-check assert
// alongside frame_rail_sz itself so the two can never drift apart.
bed_bearer_w   = 3;                  // two 2x2s side by side (= 2 x frame_rail_sz)
bed_bearer_len = panel_b_length - 3; // 26 — fits between Panel B's 1.5in end rails
// 5 slats per piece: 4 would leave 5.0in gaps, the widest unsupported
// span in the build and right where a side-sleeper's shoulder and hip
// load the foam. 5 holds every gap to 2.9in.
bed_slat_n_a     = 5;   // 42in slats, Panel A section
bed_slat_n_bhalf = 5;   // 17.5in slats, per Panel B half
bed_slat_count   = bed_slat_n_a + 2 * bed_slat_n_bhalf; // 15 pieces (5 long + 10 short)
bed_gap_a     = (bed_sect_a_len - bed_slat_n_a * bed_slat_width) / (bed_slat_n_a - 1);     // 2.875
bed_gap_bhalf = (bed_bhalf_len  - bed_slat_n_bhalf * bed_slat_width) / (bed_slat_n_bhalf - 1); // 2.875
assert(max(bed_gap_a, bed_gap_bhalf) <= 4.4,
       str("Slat gaps (", bed_gap_a, "in / ", bed_gap_bhalf,
           "in) exceed what solid foam bridges without a soft spot — add a slat"));
assert(2 * bed_bhalf_width == bed_frame_width,
       "Panel B's two halves must add up to the platform width");
assert(bed_bhalf_width <= side_door_opening_width,
       str("A Panel B half is ", bed_bhalf_width, "in wide but the side door aperture is only ",
           side_door_opening_width, "in — it could not be carried out that way"));


/* [Frame / legs] */
// leg_height is now driven by the fridge (see below): the fridge
// section is built INTO the sleeping platform (a lift-off deck
// hatch over the fridge, not a separate free-standing module at
// its own height), so leg_height must be tall enough to hide the
// fridge's full 15.79in height underneath the deck, plus a little
// wiggle room. That's also why it went up from the original 11in
// (sized only for a folded 3rd-row well) — measure your well depth
// and adjust if 17in doesn't clear it (Section 1/2).
leg_height     = 17;    // fridge_stack_top (16.67 = 0.5in tray gap + 3/8in tray + 15.79in fridge) + 0.33in running clearance under the tailgate end rail — see the fridge-slide SIDE-MOUNT stack + assert below
frame_rail_sz  = 1.5;   // 2x2 pine actual dimension (Section 3)
// the bed's centre bearer is spelled out as literals up in the bed
// section (it is assigned before this line) — keep the two in step
assert(bed_bearer_w == 2 * frame_rail_sz && bed_bearer_len == panel_b_length - 2 * frame_rail_sz,
       "Bed centre-bearer literals have drifted from frame_rail_sz — fix the bed section");
leg_inset      = vent_intrusion_width; // legs sit inset this much from the deck's outer edge so they land clear of the floor-level vent intrusion

// DECK RECESS (owner, July 2026 — the one real headroom lever left):
// the sleeping plane drops 3/4in by recessing the horizontal ply INTO
// the rail plane instead of stacking it on top. Panel C's fixed deck
// sits BETWEEN its rails on 3/4x3/4 cleats (deck top flush with the
// rail tops); Panels A/B instead get legs cut deck_drop shorter, so
// the 3/4in bed platform resting ON their rails tops out at the same
// plane. Panel C's legs stay leg_height — the fridge stack + end-rail
// clearance need all 17in, and nothing under its deck changes.
// Sleeping surface: 19.25 -> 18.5; sitting headroom over the 4in
// mattress: 20.75 -> 21.5.
deck_drop      = panel_thickness;              // 0.75 — how far the sleeping plane dropped
leg_height_ab  = leg_height - deck_drop;       // 16.25 — Panel A/B legs (platform-on-rails matches C's flush deck)
deck_surface_z = leg_height + frame_rail_sz;   // 18.5 — the ONE deck/sleeping plane (Panel C rail tops)
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
leveling_foot_pad_dia  = 1.375; // in, floor pad diameter (Anwenk kit, from the listing — VERIFY on arrival)
leveling_foot_thread   = "3/8-16"; // insert + glide bolt thread size, text only (not a dimension)
// LOAD CHECK (owner concern, July 2026): worst case ~700lb total
// (2 people + mattress + platform + boxes + cargo) over 12 feet =
// ~60lb/foot nominal vs the feet's 330lb rating each — a 5x margin
// before dynamic factors. The feet are not the weak point; see the
// Section 6 leveling note for the access answer: level the VAN at
// the wheels per site (leveling blocks + the Block Calculator); the
// interior feet are set ONCE. Electric feet were considered and
// REJECTED (owner, July 2026).
leg_cut_length    = leg_height - leveling_foot_nominal_h;    // 16 — Panel C's actual saw cut; foot makes up the rest
leg_cut_length_ab = leg_height_ab - leveling_foot_nominal_h; // 15.25 — Panel A/B legs (deck recess, see above)

// deck surface -> mattress underside: just the flush platform now —
// it rests DIRECTLY on the box top rails, no adjusters between
bed_platform_stack = bed_frame_thickness; // 0.75in
// Bed shelf 9in above the MATTRESS TOP (owner). The personal nook is
// now an ENCLOSED middle-band cubby (owner's July-18 layout sketch):
// a full-depth food tier runs ABOVE it and a taller one BELOW it, and
// the nook divider spans the middle tier from the bed shelf up to the
// upper shelf, so the cubby has a floor, a back wall, and a ceiling —
// open only toward the mattress.
// (The plywood pantry's bed-shelf/cubby geometry is gone with the prefab
// swap — Power strip 1 + the ROLL level live on the deck edge instead.)

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
// the van's own body structure, not just an awkward reach). Both the
// gap and the door's position are now measured — see side_door_y0
// below and the reachability check further down.
//
// V8 (Aug 2026) resolved in two passes. The 50"/58" first written on
// the survey sheet turned out to be the DOOR PANEL's own external
// dimensions, not the aperture. The owner then measured the opening
// itself: 35" wide x 45" tall. Separately, V8c is the USABLE CLEAR
// fore-aft gap once the door is parked at its real stopping point —
// 29", i.e. the door's leading edge does not retract all the way to
// the aperture's forward edge, so 6" of the 35" is never open.
//
// The reach check below runs off the CLEAR figure, not the aperture:
// what matters is the gap you can actually put an arm and a drawer
// through, and it is 11" under the 40" this was designed against.
side_door_opening_width  = 35; // MEASURED (Aug 2026) — the aperture's fore-aft width
side_door_opening_height = 45; // MEASURED (Aug 2026) — the aperture's height
side_door_clear_width    = 29; // MEASURED V8c (Aug 2026) — usable CLEAR fore-aft gap at the door's actual stop; THIS is what gates reach
// Fore-aft position of the door opening's FRONT edge, measured from
// the same Y=0 reference as van_interior_length (the front seatbacks).
// MEASURED (owner, Aug 2026): the front seatback is essentially even
// with the door opening at build height — if anything the seatback
// intrudes about 1/4in INTO the opening. So the opening's front edge is
// at Y=0 for every practical purpose, and anything forward of that is
// behind the seatback anyway. The long-standing placeholder guess turns
// out to have been right; it is now a measurement.
//
// This matters more than it looks: it is what confirms the DELTA 3
// stack belongs in Panel A. The 29in clear gap (V8c) starting at Y=0
// spans Panel A's 29in EXACTLY, so Panel A is reachable end to end,
// and Panel B (29..58) gets nothing — which is why its bed top is two
// lift-out halves instead of drawers. Both decisions now rest on a
// measured number rather than a guess.
side_door_y0 = 0; // MEASURED (Aug 2026) — seatback is even with the opening (~1/4in into it)

/* [Side-access sliding drawers — one pair (left + right) per panel] */
// Each panel module gets 2 drawers (left + right), riding on
// full-extension slides, separated by a center divider rail so
// they don't collide. Drawers replace the old hinged-top access —
// tops are now fixed, screwed to the frame.
drawer_slide_length = 20; // standard full-extension slide hardware size
drawer_divider_t    = frame_rail_sz; // center divider rail, same 2x2 stock as the frame
drawer_side_clear   = 0.75; // gap between drawer box and rail/divider each side, for slide hardware
drawer_box_t        = 0.375; // WEIGHT SWAP (owner, July 2026): 1/2in -> 3/8in birch (-~4lb) — glue + biscuit the corners since it carries the 48lb DELTA stack; keep a 1/2in bottom. Also used below to size clear interior space (thinner box = more clearance, all fit asserts still pass)
// drawer box footprint, derived from the panel's own dimensions —
// assumes all three panels are the same length (true above; if you
// change one panel's length independently, revisit this)
drawer_depth   = panel_a_length - 2 * frame_rail_sz - 1; // fore-aft (Y) span, between the front/back legs
drawer_travel  = panel_width/2 - frame_rail_sz - drawer_divider_t/2 - drawer_side_clear; // X extent (how far it slides); drawer box's own outer width too, per drawer_module()
drawer_height  = leg_height_ab - frame_rail_sz - 1; // 13.75 — Z, inside Panel A's bay under the recessed platform plane (A/B legs are leg_height_ab now)
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
pcwall_t = 0.375;       // WEIGHT SWAP: 1/2in -> 3/8in ply (-~2.5lb) — non-structural wall, just holds the intake fan + grommets
pcwall_h = leg_height;  // 17 — van floor up to the front rail's underside
pcwall_grommet_dia = 1; // fridge DC line pass-through
// ONE grommet, not two. The verified-outlet round (the van has exactly 2 AC
// outlets) moved Power strip 1 onto the REAR outlet, so its line no longer
// crosses this wall — Section 2's parts table and Component 6's step both say
// one, and the drawing was still showing the deleted second hole.
// It sits in the driver-side strip OUTBOARD of the front leg (leg occupies
// x 3.5-5.0), a natural cord chase, clear of the bottom rail and the louver.
pcwall_grommet_x  = 3;   // center X from the driver edge
pcwall_grommet_z  = 4;   // fridge DC line — 1.0in of ply above the bottom rail

// Passive cooling vents (owner, July 2026 refinements). Both are
// cheap louvered RV vents, no wiring:
//  - a LOW intake louver in the front wall's driver-side corner
//    admits the coolest floor-level cabin air straight to the
//    fridge's condenser, supplementing the powered intake fan above
//    it (summer-heat margin);
//  - a LOW louver in the utility-cabinet door gives the exhaust fan's
//    warm air a direct path OUT low toward the tailgate instead of
//    only bleeding around the door edges.
// RE-LAID OUT Aug 2026. The old numbers (7x2.5 at x=5.5, z=5) put three
// openings on top of each other in one corner of a 3/8in wall: the upper
// grommet was drilled INSIDE the vent cut-out, the lower grommet's edge
// landed on the bottom rail (top at 2.5, not 3.5 as the old comment said),
// and the vent's top edge left 0.18in of ply against the fan hole. The vent
// now sits squarely UNDER the fan, on the fan's centerline, with the cord
// grommets moved into the clear driver-side strip outboard of the front leg.
// Widened 7 -> 9 so the passive area (18 sq in) still covers the 120mm fan's
// own aperture (17.7 sq in) despite losing 0.5in of height.
intake_vent_w = 9;    // low front-wall intake louver — width
intake_vent_h = 2;    // height — set by the gap between bottom rail and fan hole
intake_vent_x = 10.86; // center X = the fan's center (cross-checked by assert below)
intake_vent_z = 4.4;  // center Z: 0.9in of ply over the bottom rail, 1.0in under the fan hole
cabinet_vent_w = 2;   // low cabinet-door exhaust louver — width (the door narrowed to ~3.3in with the side-mount rail stack; was 3in in a ~4.3in door)
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
fridge_ext_height = 15.79; // Z — drives leg_height above via fridge_stack_top (16.67 mounted: 0.5in tray gap + 3/8in tray + fridge — see the SIDE-MOUNT stack below)
// Clearance: the manual wants 200mm behind the compressor + 100mm
// sides for PASSIVE venting — the bay can't give that, which is
// exactly what the forced intake/exhaust fan system compensates for
// (aim the airflow across the compressor end).
fridge_side_clearance = 2;  // with forced airflow; manual's passive figures are 7.9/3.9in

/* [Fridge slide — heavy duty, loaded weight is real. SIDE-MOUNT (owner,
   July 2026)] */
// Empty the Rocky 40 is 40.6 lb (18.4 kg, manual), and loaded with
// food/drinks it can hit ~60-90 lb — too heavy to pull by hand
// without tipping or binding. It sits on its
// own plywood tray riding a pair of heavy-duty full-extension slides
// (VADANIA VD2576 24in industrial w/ lock, 379lb — purchased, see BOM)
// rated well above the load.
//
// MOUNTING (fixes an undermount-vs-side-mount inconsistency an earlier
// draft had): the VADANIA's 3in (76mm) rails stand VERTICALLY, one
// flanking each side of the tray — NOTHING is stacked under the tray.
// Per side, outboard-to-inboard: a steel riser angle bolted to the
// NO-DRILL ANCHOR BOARD's rail-line strip (Section 8 — mat + 3/4in ply
// on the van floor, T-nuts from below; the rail's fixed member screws
// to the riser's vertical face), the rail itself, then a 1x3 side
// apron glued+screwed to the tray's edge (the moving member screws to
// it; its top edge doubles as the fridge's anti-shift lip, and the
// hold-down D-rings go into it). The tray hangs BETWEEN the rails with
// a small floor gap, so the slide hardware adds ZERO height to the
// fridge stack — an undermount arrangement (rail flat under the tray)
// would add ~1.2in and the fridge would no longer clear Panel C's
// tailgate end rail. The board raises only the RAILS (aboard_top
// below); the moving member simply screws to the apron ~0.85in lower
// in their shared overlap, so the TRAY keeps its 0.5in floor hang and
// the stack height is untouched. The cost lands on WIDTH instead: see
// fridge_rail_stack below and the cabinet-gap assert — the utility
// cabinet narrows to ~3.3in.
fridge_slide_length = 24;   // VADANIA VD2576 24in pair, 379lb, locks closed + extended
fridge_tray_t       = 0.375; // WEIGHT SWAP: 1/2in -> 3/8in ply (-~1.5lb); stiffened by the 2 glued 1x3 side aprons
fridge_tray_gap     = 0.5;  // clear air under the hanging tray panel (nothing beneath it)
fridge_rail_t       = 0.75; // VADANIA rail thickness (19mm), standing vertically beside the tray
fridge_riser_t      = 0.25; // steel riser angle between the fixed rail and the anchor board (2x2x3/16in angle + fit allowance)
fridge_rail_stack   = fridge_rail_t + fridge_riser_t; // 1.0 per side, OUTBOARD of the tray apron (the apron itself lives in fridge_slide_margin)

/* [No-drill anchor board — Section 8] */
// The securing chassis: a rubber mat + 3/4in ply board (bridge + rail-
// line strips) on the van floor, strapped to the 3rd-row striker loops.
// Nothing bolts to the vehicle. The board is ONE comb-shaped piece,
// 46 x 33 overall — bridge and strips continuous, so there is no
// ply-to-ply joinery (no glue, no lap screws; assembly sheet V1/V5).
// Strip outlines are cut only after the Section 0 F1-F7 floor survey.
// (F4 Aug 2026) That survey is now DONE: the striker row measures
// 44.5in from the closed hatch — 1.5in nearer than the 46-50in that
// was assumed, so the steel tongues come in at the SHORT end of the
// 10-14in range. All 3 loops are exposed and hookable with the seats
// folded, ~1.5in of inside clearance each, spaced ~12.5-13in apart
// with the outer two ~11in in from each sidewall (photos, Aug 2026).
// The survey also killed two of the fallbacks: there is no hard step
// face at the striker row for the tongues to butt against (F7 — it is
// carpet over a ~1in soft step), and the stowage well is filled by
// the folded seats rather than open (F1/F2/F3), so the load path is
// the rail ends plus the straps. These drive the renders, not a cut list.
aboard_mat_t = 0.1;   // non-slip rubber mat under every strip
aboard_t     = 0.75;  // anchor board ply thickness
aboard_top   = aboard_mat_t + aboard_t; // 0.85 — the riser/rail base plane
aboard_strip_w = 2.5; // rail-line strip width (covers riser flange + rail line)
aboard_bridge_d = 6;  // full-width bridge depth (fore-aft), at the appliance zone's front
aboard_tongue_w = 2;  // steel flat-bar tongue width (2 x 3/16in), bridge -> the rail ends
aboard_depth      = 33; // board overall fore-aft, hatch (y=0) forward
aboard_strip_len  = 27; // the three comb strips; the bridge is the last aboard_bridge_d

// ---- TONGUE -> RAIL CONNECTION (Aug 2026, fully measured) -------
// The anchor board's forward load path. Everything here is measured on
// the vehicle; the reasoning below is compressed on purpose, because this
// joint went through five revisions and the dead ends are worth keeping
// short but not losing.
//
// THE GEOMETRY, as photographed and taped Aug 1 2026:
//   The rail's rear end is closed by a STEEL SADDLE CAP straddling it: a
//   flat TOP face at 1.0in above the floor carrying a single 1/4in round
//   hole (with two closed oblong stiffening dimples either side), two
//   vertical SIDE SKIRTS hanging down, and an OPEN REAR between them.
//   Over the whole thing sits a plastic end cap held by one flush slotted
//   fastener — try a 90deg turn first, that shape is often a quarter-turn
//   catch. Keep both plastic caps for passenger mode.
//
// THE DESIGN: the tongue runs forward off the bridge, steps UP 0.15in,
// rides ON the cap's top face, and a VERTICAL 1/4in PIN drops through the
// tongue into the cap's 1/4in hole. Forward load is carried entirely by
// that pin in SHEAR. Nothing is drilled into the vehicle, and the joint
// comes apart by lifting the tongue.
//
// WHY NOT THE OBVIOUS ALTERNATIVES — all four were tried and dropped:
//   * A FASTENER IN THE TRACK SLOT (T-bolt, channel nut). The slot runs
//     FORE-AFT, the same direction as the load, so it resists forward
//     motion by FRICTION only: ~1,200lb clamp x mu 0.18 = ~215lb per
//     bolt, ~430lb for the pair. That was the original plan's forward
//     path and it was its weakest link.
//   * A NUT BAR SLID IN FROM THE END. Impossible: the steel cap closes
//     the channel and a pin behind it blocks entry from the rear.
//   * BUTTING THE TONGUE ON THE RAIL'S END FACE. There is no such face —
//     the cap's rear is open and its rear edge is a rolled hem.
//   * A BOLT THROUGH THE CAP'S HOLE. Possible but awkward; there is no
//     access behind the top face to start a nut. A pin needs no nut,
//     because the load is shear, not clamp.
//   * (And F7 had already killed butting the striker-row step: carpet
//     over soft trim, not a hard face.)
//
// CAPACITY, and where the limit actually sits:
//   1/4in mild-steel pin, single shear: ~0.049 sq in x ~36ksi
//     ~= 1,760lb per pin, ~3,500lb for the pair.
//   But the GOVERNING limit is HOLE-EDGE BEARING / TEAR-OUT in the cap's
//   stamped top face, not the pin. At an assumed 0.08in thickness the
//   bearing area is 0.25 x 0.08 = 0.02 sq in -> roughly 1,400lb per
//   tongue, ~2,800lb for the pair. Still ~18g on a ~155lb loaded board,
//   and ~6x the friction-only option — but it is the number that matters.
//   MEASURE THE CAP'S THICKNESS to replace that assumption.
//   Nothing in this design is crash-rated; the plan says so throughout.
//
// THE HOLD-DOWN IS ESSENTIAL, NOT OPTIONAL. A vertical pin lifts straight
// out, so something must keep the tongue seated. The cap's open rear makes
// that easy: a clip hooked over the side skirts, or the saddle clamp on
// the rail just forward of the cap. This is the one part of the joint
// still to be chosen by whoever builds it.
rail_end_y      = 42;    // MEASURED F8a (Aug 2026) — hatch -> rail rear ends
rail_spacing    = 17.5;  // MEASURED F8b (Aug 2026) — rail centre to rail centre
rail_slot_w     = 0.75;  // MEASURED — the track slot at the surface (unused by the
                         // final design; kept because it rules the T-bolt option in/out)
rail_chan_d     = 1.0;   // MEASURED — internal channel depth
rail_chan_d_min = 0.75;  // MEASURED — bosses rise ~0.25in off the bottom in places
rail_top_z      = 0.5;   // MEASURED — the METAL track top above the floor pan
rail_housing_z  = 1.0;   // MEASURED — top of the plastic housing over the rail
rail_cap_hole_d = 0.25;  // MEASURED — the round hole in the steel saddle cap
rail_cap_hole_z = 1.0;   // MEASURED — its centre above the floor pan, and the cap's top face
rail_cap_hole_x = 0;     // MEASURED — centred on the rail, laterally
rail_cap_t_est  = 0.08;  // ASSUMED, not measured — the cap's sheet thickness. This is the
                         // one number the joint's capacity now hinges on; go measure it.
tongue_t        = 0.1875; // 3/16in flat bar
tongue_pin_d    = 0.25;  // vertical pin; slightly undersize + a lead chamfer so it drops in
tongue_lap      = 4;     // how far the tongue lies ON the bridge, bolted through
tongue_span     = rail_end_y - aboard_depth;  // 9 — open floor it crosses
tongue_len      = tongue_lap + tongue_span + 3; // 16 — 3in of overlap on the cap
tongue_step_up  = rail_cap_hole_z - aboard_top; // 0.15 — shim this under the lap on the bridge
tongue_bolt_d   = 0.25;  // the 2 bolts through the bridge
// pin bearing capacity in the cap's top face, on the ASSUMED thickness
tongue_pin_bearing_area = tongue_pin_d * rail_cap_t_est; // 0.02 sq in

assert(tongue_lap <= aboard_bridge_d,
       str("Tongue lap (", tongue_lap, "in) must sit within the bridge's ",
           aboard_bridge_d, "in depth so both its bolts land in plywood"));
assert(rail_spacing + aboard_tongue_w <= panel_width,
       "Tongue pair at the measured rail spacing must land inside the board's width");
// The plastic-housing clash the earlier revisions fought is GONE: the
// tongue now stops on the steel cap and never passes over the housing, so
// there is no crush tube and no windowing. What is left open is the
// hold-down choice, and the cap's sheet thickness.
echo(str("NOTE (Section 8): tongue pin is VERTICAL into the cap's ", rail_cap_hole_d,
         "in hole. Capacity is governed by hole-edge bearing in the cap's top face, on an ASSUMED ",
         rail_cap_t_est, "in thickness (~1,400lb/tongue) — measure it. Hold-down still to be chosen."));
fridge_stack_top    = fridge_tray_gap + fridge_tray_t + fridge_ext_height; // 16.67 — top of the mounted fridge
fridge_exit_clearance_min = 0.25; // required running clearance under Panel C's tailgate end rail (van bounce)
// The DRIVER-side rail+riser tucks into the corner-leg band (the 1.5in
// between Panel C's driver edge and the fridge module) — the fixed rail
// is ~24in long vs the tray's 28.74in run, so setting it back ~2.5in
// from the tailgate face clears the rear corner leg entirely. Only the
// PASSENGER-side stack eats into the utility-cabinet gap.
assert(fridge_rail_stack <= frame_rail_sz,
       str("Driver-side rail+riser stack (", fridge_rail_stack,
           "in) is thicker than the corner-leg band (", frame_rail_sz,
           "in) it tucks into"));
assert(fridge_stack_top + fridge_exit_clearance_min <= leg_height,
       str("Mounted fridge stack tops out at ", fridge_stack_top,
           "in (tray gap + tray + fridge) but must pass under Panel C's tailgate end rail at ",
           leg_height, "in with ", fridge_exit_clearance_min, "in running clearance"));
// the anchor board raises the rails but NOT the tray: the moving
// member must still overlap the 1x3 apron enough to screw to it
assert((fridge_tray_gap + 2.5) - (aboard_mat_t + aboard_t + fridge_riser_t) >= 1.5,
       str("Rail bottom on the anchor board (", aboard_mat_t + aboard_t + fridge_riser_t,
           "in) leaves under 1.5in of moving-member overlap on the apron (top ",
           fridge_tray_gap + 2.5, "in) — not enough screw band"));

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
control_panel_width = 2.8; // the LMioEtool enclosure mounted TALL-ways (its 2.8in dimension across) — the cabinet gap is ~3.3in now that the fridge's passenger-side slide rail + riser stand in it (side-mount fix; was ~4.3in)

// Fridge zone width: the fridge itself plus a small margin each
// side for the slide hardware, flush to Panel C's RIGHT edge so its
// tailgate-ward slide path stays clear of the kitchen unit's own
// path on the RIGHT (passenger) side — fridge LEFT/driver, kitchen
// RIGHT/passenger, per the owner.
fridge_slide_margin = 0.5;
fridge_module_width = fridge_ext_length + 2 * fridge_slide_margin;

/* [Kitchen unit — real JAGAHAHA slide-out camp kitchen, standalone] */
// Exterior dimensions from the actual product listing (JAGAHAHA
// wooden overland slide-out kitchen w/ drawer — the maker's 'left
// side' VARIANT (which side its own drawer is on, NOT its position
// in the van; it mounts on the van's RIGHT/passenger side), 2-burner,
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
// (owner, Aug 2026) span 17 -> 19. The assembly used to sit 2in shy of
// the kitchen's inboard edge for no reason: cheeks + span came to 18in
// inside a 20in kitchen footprint. Moving the INNER cheek flush with
// that edge is free — +2in of box, +2in of clear interior, same sheet,
// same slides (slide length is fore-aft). 19in is the hard ceiling:
// inboard of the kitchen is the utility bay, which measures 3.28in
// against a control-panel enclosure needing 3.2in.
kdrawer_span      = 19;    // cheek inner face to cheek inner face
kdrawer_box_w     = kdrawer_span - 1; // 18 — 1/2in slide clearance per side
kdrawer_box_len   = 26;    // Y — matches the kitchen unit's footprint
kdrawer_slide_len = 24;    // side-mount full-extension pair, 100lb class
kdrawer_cheek_t   = 0.5;   // WEIGHT SWAP: 3/4in -> 1/2in ply hanging cheeks (-~2lb) — they only hang a shallow utensil drawer
kdrawer_z0        = kitchen_box_height + kdrawer_gap_below; // 12.3 — drawer underside
// There was no width guard here at all — only the height one below — so
// the drawer could have been widened until its inner cheek overhung the
// utility bay and fouled the control panel. It cannot now.
assert(kdrawer_span + 2 * kdrawer_cheek_t <= kitchen_box_width,
       str("Kitchen drawer assembly (", kdrawer_span + 2 * kdrawer_cheek_t,
           "in incl. cheeks) must stay inside the kitchen unit's ",
           kitchen_box_width, "in footprint — any wider and it overhangs the utility bay"));
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
// NOT fit a drawer's ~13.4in clear interior — unstacked is the only
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
delta3_tray_h  = 2;                       // shallow tray on top of the DELTA 3 stack (was 3 — the deck recess cut the drawer's clear height to 13.375in over the 11.16in stack)
wave3_shelf_z  = wave3_height + 0.5;       // 13.7 — cleat-mounted shelf just above the WAVE 3
wave3_shelf_clear = leg_height_ab - wave3_shelf_z - panel_thickness/2; // ~2.2in usable above the shelf (was ~2.9 before the deck recess)
wave3_intake_hose_dia  = 6; // in
wave3_exhaust_hose_dia = 5; // in

// Nighttime van+tent cooling setup (owner accessory, NOT part of the
// build's own structure — no assert() against it): an example
// footprint for a VEVOR SUV/tailgate tent (~10.6ft x 8ft), whose
// elastic sleeve wraps the open liftgate/tailgate opening rather than
// attaching to anything built here. Used only by
// night_cooling_setup_detail.scad, to show the WAVE 3 running on
// Panel C's deck blowing through the open tailgate into the shared
// van+tent air volume (Section 1, "WAVE 3 sleeping configurations").
// Swap these two numbers for your own tent's spec sheet — they don't
// feed anything else in the model.
tent_example_length = 127; // Y, ~10.6ft — VEVOR SUV tent
tent_example_width  = 96;  // X, ~8ft

// ------------------------------------------------------------
// Derived values
// ------------------------------------------------------------
panels_total_length   = panel_a_length + panel_b_length + panel_c_length; // 93.75
// The rear pantry no longer occupies its own separate slot — it
// rides on Panel C's own deck — so the assembly's real length is just
// the 3 panels. With Panel A flush to the front seatbacks (panel_a_y0
// = 0, below), this now fills usable_length(94) exactly — no leftover
// open floor anywhere.
assembly_total_length = panels_total_length; // 93.75 — must be <= usable_length (93.75)
// bed_length is what's actually available for the mattress: Panel C's
// own length minus the rear pantry's 14in bite out of its
// tailgate end, plus all of Panel B and Panel A.
bed_length = panels_total_length - pantry_len; // 79.25
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
platform_length = panels_total_length; // full sleeping-deck length, pantry excluded

// Total height of each module standing on its own legs — this is
// what has to clear the liftgate opening height when carrying a
// module in its natural upright orientation (legs down, the way
// it sits once installed).
// A/B carry as bare frames (no top); Panel C's deck is recessed
// flush, so its carried height is just legs + rail too — Panel C is
// the tallest module and is what the gate-fit/pantry-roof checks use.
panel_module_height_ab = leg_height_ab + frame_rail_sz; // 17.75 — Panels A/B
panel_module_height = leg_height + frame_rail_sz; // 18.5 — Panel C (was 19.25 before the deck recess)
// The fridge lives inside Panel C's own void (same leg_height,
// same fixed top as A/B — no hatch needed since access is through
// the side door, not from above) — so its "module height" for
// gate-fit purposes is really just Panel C's own height, same as
// every other panel. The fridge itself (15.79in) sits on its slide
// tray inside the leg_height void, hidden below deck level, not
// stacked on top of the frame — that's what let leg_height (17in)
// absorb the fridge's height without the panel getting any taller.
fridge_bay_module_height = panel_module_height; // 18.5
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
assert(kitchen_box_width + fridge_module_width + fridge_rail_stack + 2 * frame_rail_sz <= panel_width,
       str("Kitchen unit (", kitchen_box_width, "in) + fridge module (", fridge_module_width,
           "in) + its passenger-side rail stack (", fridge_rail_stack,
           "in) + Panel C's 2 rear corner legs is wider than the ", panel_width, "in panel — they'd overlap"));
// The passenger-side slide rail + riser (fridge_rail_stack) stand
// between the fridge module and the utility cabinet — the cabinet gap
// is what's left AFTER them. TIGHT since the side-mount fix (~3.3in
// against the control panel's 2.8in + 0.4in working clearance — only
// ~0.1in of assert margin): re-check with the real VADANIA rail +
// riser in hand before fixing the kitchen unit's position.
assert(x_kitchen - kitchen_box_width/2 - (x_fridge_module + fridge_module_width/2 + fridge_rail_stack) >= control_panel_width + 0.4,
       str("Utility-cabinet gap (", x_kitchen - kitchen_box_width/2 - (x_fridge_module + fridge_module_width/2 + fridge_rail_stack),
           "in, after the fridge's passenger-side rail+riser) is too narrow for the control panel (",
           control_panel_width, "in) plus working clearance"));
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
           "in sleeping run (Panel C minus the rear pantry's 14in, plus Panels B and A)"));
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
// CLEAR gap, not the aperture — the door parks 6" short of the
// aperture's forward edge (V8c), and you can only reach through what
// is actually open.
door_y1 = side_door_y0 + side_door_clear_width;
// Panel A sits flush with the front seatbacks (Y=0) — the rear pantry
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
echo(str("Side door reach check (all inputs MEASURED Aug 2026): ",
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

// Rear pantry (prefab drawer cluster): each unit is tiny vs. the gate,
// so the only real checks are roof clearance and the deck footprint.
assert(panel_module_height + pantry_cluster_h <= van_interior_height,
       str("Installed pantry cluster reaches ", panel_module_height + pantry_cluster_h,
           "in above the floor but the cabin is only ", van_interior_height, "in tall"));
assert(pantry_unit_d <= pantry_len + hatch_curvature_clearance,
       str("IRIS drawer unit is ", pantry_unit_d, "in deep but only ", pantry_len,
           "in of deck + ", hatch_curvature_clearance, "in hatch reserve is available"));
assert(panelb_tote_l <= panel_b_length - 2 * frame_rail_sz && 2 * panelb_tote_w <= panel_width - 2 * frame_rail_sz,
       "Panel B totes don't fit the bay 2-wide — check tote dims");
assert(pantry_pot_bin <= pantry_bay_w,
       str("Pot bin (", pantry_pot_bin, "in) is wider than the open deck bay (", pantry_bay_w, "in)"));

// ---- Panel C front wall: the four openings must not eat each other ----
// This wall is 3/8in ply with a 120mm fan hole, a 9x2 louver and two 1in
// cord grommets in it. In Aug 2026 the vent was overlapping BOTH grommets
// and coming within 0.18in of the fan hole; these keep the webs honest.
// Written down here (not in the drawing) because the drawing only shows what
// the numbers produce — it cannot tell you the numbers are wrong.
pcwall_fan_x   = panel_width/2 + x_fridge_module;   // 10.86
pcwall_fan_z   = fridge_tray_gap + fridge_tray_t + fridge_ext_height/2;  // 8.8
pcwall_web_min = 0.75;   // least ply left between any two openings

assert(abs(intake_vent_x - pcwall_fan_x) < 0.02,
       str("The intake louver is meant to sit on the fan's centerline, but intake_vent_x is ",
           intake_vent_x, " and the fan is at ", pcwall_fan_x));
// vent top edge -> fan hole bottom edge
assert((pcwall_fan_z - intake_fan_dia/2) - (intake_vent_z + intake_vent_h/2) >= pcwall_web_min,
       str("Only ", (pcwall_fan_z - intake_fan_dia/2) - (intake_vent_z + intake_vent_h/2),
           "in of ply between the intake louver's top edge and the fan hole — need ",
           pcwall_web_min, "in"));
// vent bottom edge -> bottom rail top face (the rail backs the wall there)
assert((intake_vent_z - intake_vent_h/2) - (bottom_rail_z + frame_rail_sz) >= pcwall_web_min * 0.8,
       str("The intake louver's bottom edge is ",
           (intake_vent_z - intake_vent_h/2) - (bottom_rail_z + frame_rail_sz),
           "in above the bottom rail's top face — it will break through into the rail"));
// grommets clear of the vent in X (they are in the driver-side strip)
assert((intake_vent_x - intake_vent_w/2) - (pcwall_grommet_x + pcwall_grommet_dia/2) >= pcwall_web_min,
       str("The cord grommets at x=", pcwall_grommet_x,
           " run into the intake louver, which starts at x=",
           intake_vent_x - intake_vent_w/2));
// grommets clear of the bottom rail and of each other
assert((pcwall_grommet_z - pcwall_grommet_dia/2) - (bottom_rail_z + frame_rail_sz) >= pcwall_web_min * 0.8,
       str("The DC grommet's bottom edge is only ",
           (pcwall_grommet_z - pcwall_grommet_dia/2) - (bottom_rail_z + frame_rail_sz),
           "in above the bottom rail's top face"));
// everything stays on the wall
assert(pcwall_grommet_z + pcwall_grommet_dia/2 <= pcwall_h &&
       pcwall_fan_z + intake_fan_dia/2 <= pcwall_h &&
       intake_vent_x + intake_vent_w/2 <= panel_width,
       "An opening in the Panel C front wall falls off the edge of the wall");
// the passive louver should be worth cutting: at least the fan's own aperture
assert(intake_vent_w * intake_vent_h >= 3.14159 * pow(intake_fan_dia/2, 2) * 0.95,
       str("The passive louver is only ", intake_vent_w * intake_vent_h,
           " sq in against the fan's ", 3.14159 * pow(intake_fan_dia/2, 2),
           " sq in — widen it or it chokes the fan"));

