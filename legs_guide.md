# Project S'mores — Legs & Leveling Feet

A working subset of the full build plan: everything needed to make all **12 platform legs** and fit their leveling hardware, and nothing else. Every dimension here is taken from `params.scad`, which is what drives the drawings.

Read this alongside the full plan for context (Section 3 for the whole cut list, Component 2–4 for the rest of each panel's assembly). Nothing in this document supersedes the full plan; it is the same numbers, gathered.

<div class="callout">
<strong>The one thing to get right.</strong> The three panels do <strong>not</strong> use the same leg. Panel C's legs are cut <strong>16"</strong>; Panels A and B's are cut <strong>15.25"</strong> — 3/4" shorter, because Panel C's deck is recessed <em>into</em> its rail plane while A and B are capped by a 3/4" bed platform sitting <em>on</em> theirs. Both arrangements land the sleeping surface in the same 18.5" plane. Cut them in two clearly-labelled batches.
</div>

## 1. What the legs are

<figure class="floorplan-figure">
<img src="renders/leg-detail.png" alt="Platform leg shop drawing">
<figcaption>The leg as a part: the <strong>Panel C leg</strong> (16" cut, 17" effective), the <strong>Panel A/B leg</strong> (15.25" cut, 16.25" effective), and the <strong>bottom end grain</strong> with its 1/2" × 7/8" insert bore dead centre. This is the sheet to take to the saw. Where the legs then stand in the frame is drawn in Section 8.</figcaption>
</figure>

Twelve legs, 2x2 pine (1.5" × 1.5" actual). Four per panel, one at each corner. Each leg is cut **1" short** of its finished height and gets a screw-in threaded insert in its bottom end grain; a leveling foot threads into that insert and makes up the missing inch, with ±1/2" of adjustment either way.

Leveling therefore lives **at the floor**, not between the frame and the platform. Every foot is exposed at floor level — tip the corner of the box slightly and spin the knob.

| | Panel A | Panel B | Panel C |
|---|---|---|---|
| Legs | 4 | 4 | 4 |
| **Saw cut length** | **15.25"** | **15.25"** | **16"** |
| Foot, nominal exposed | 1" | 1" | 1" |
| **Effective leg height** | **16.25"** | **16.25"** | **17"** |
| + top rail (2x2) | 1.5" | 1.5" | 1.5" |
| = rail-top height | 17.75" | 17.75" | 18.5" |
| What sits on the rails | 3/4" bed platform | 3/4" bed platform | deck is *recessed*, flush with the rails |
| **Sleeping surface** | **18.5"** | **18.5"** | **18.5"** |

The last row is the reason for the two lengths. Get one leg batch wrong and that panel's share of the mattress sits 3/4" proud of its neighbour.

## 2. Cut list

| Piece | Qty | Cut length | Stock |
|---|---|---|---|
| Legs — Panel C | 4 | **16"** | 2x2 pine (or 1"×1" aluminum L-channel) |
| Legs — Panel A | 4 | **15.25"** | 2x2 pine |
| Legs — Panel B | 4 | **15.25"** | 2x2 pine |

**Total: 186" of 2x2** — two 8-ft (96") boards out of the twelve the full build buys.

**Cutting plan, two boards:**

- **Board 1** — 4 × 16" (Panel C) = 64", then 2 × 15.25" out of the remainder. At a 1/8" kerf that is ~95.3" of a 96" board, so it only works if both ends of the board are sound and square. Check the last 31" before you commit to it; if the end is bowed, split, or has a bad knot, take those two legs off Board 2 instead and open a third board for the shortfall.
- **Board 2** — 6 × 15.25" = 91.5" plus kerf ≈ 92.3". Comfortable.

**Before cutting:**

- Sight down each board and reject anything bowed or crowned — a leg is a short column, and a bowed one puts the load off-axis and racks the frame.
- Cut all four of one length in one setup, off a stop block. Legs that differ by 1/16" are legs the feet have to spend their travel correcting.
- Square ends matter more than exact length here: the bottom end grain takes a bore that must be perpendicular, and the top end butts the rail.

## 3. Tools and consumables

| For | What |
|---|---|
| Cutting | Mitre saw or circular saw + square; a stop block for repeatable length |
| Boring | 1/2" brad-point bit (a spade bit wanders in end grain), drill press or a drill guide/right-angle jig, depth stop or tape flag |
| Driving the insert | 3/8-16 bolt ~2" long + two 3/8-16 nuts (jam pair), or the insert's own hex drive; wrench |
| Foot stack | 9/16" wrench (3/8-16 jam nut) |
| Frame | Drill/driver, 2" wood screws, wood glue, 12 × 2"–3" steel corner brackets |
| Test piece | A 6" 2x2 offcut — bore it and test-fit an insert before touching a real leg |

## 4. Step 1 — Cut the legs

Cut **4 at 16"** (mark them "C") and **8 at 15.25"** (mark them "A/B"). Write the length on each leg in pencil on a face that will end up hidden. Keep the two batches physically separated on the bench.

Stack the four legs of one panel and check them end-to-end against each other — the ends should form one flat plane with no daylight.

Both lengths are dimensioned on the shop drawing in Section 1.

## 5. Step 2 — Bore the insert hole

The same hole goes in every one of the 12 legs, in the **bottom** end grain:

<div class="spec">
<strong>1/2" diameter × 7/8" deep, dead centre of the 1.5" × 1.5" end grain.</strong>
</div>

7/8" is the maker's spec: 3/4" of insert plus a little clearance so the flange can pull down flush on the end grain. Bore it **before the leg goes into the frame** — once the frame is together the hole is nearly impossible to keep square, and squareness here is what keeps the finished foot vertical.

Method:

1. Mark the centre by drawing both diagonals of the end grain.
2. Bore on a drill press if you have one; otherwise use a drill guide. Freehand into end grain will wander.
3. Set the depth with a stop or a tape flag on the bit, and measure from the bit's **full diameter**, not the brad point's tip.
4. Blow the chips out. A packed hole reads as "insert bottomed out" long before it has.

The **BOTTOM END GRAIN** view on the Section 1 shop drawing dimensions the hole and its centre; the Panel B sheet below repeats it in the context of the assembled panel.

<figure class="floorplan-figure">
<img src="renders/panel-b-detail.png" alt="Panel B detail">
<figcaption>Panel B, exploded — the <strong>LEG BOTTOM</strong> inset at top left is the bore, drawn at 3× and dimensioned. It is the same hole on all 12 legs of all three panels. (The second inset below it is the end-rail alignment-pin hole, which is Component 5's job, not the legs'.)</figcaption>
</figure>

## 6. Step 3 — Drive the threaded insert

The insert is the screw-in type: a **7/16" OD coarse outer wood thread** with a **3/8-16 bore**, and a 5/8" flange that seats on the end grain.

1. **Test-fit in an offcut first.** Bore a scrap 2x2 to the same 1/2" × 7/8" and drive an insert into it. End grain in soft pine can split; if it does, the fix is a slightly larger pilot, not more force.
2. Lock two 3/8-16 nuts against each other on a spare bolt, thread the insert onto the bolt up to the jammed nuts, and drive the assembly with a wrench on the bolt head. This drives the insert straight and lets you back the bolt out cleanly afterwards. (The insert's own slot or hex will work too, but the bolt method is far better at keeping it square.)
3. Drive it until the flange sits **flush** with the end grain — not proud, or the leg will rock on it, and not sunk, or you lose thread engagement.
4. Back the bolt out by holding the lower nut and turning the upper one loose.

## 7. Step 4 — Assemble the leveling foot

Five parts per foot, twelve feet. The exploded column on the drawing is keyed **A–E** and that is also the assembly order:

<figure class="floorplan-figure">
<img src="renders/leveling-foot-assembly.png" alt="Leg leveling foot engineering drawing">
<figcaption>Leg leveling foot — <strong>section A-A</strong> installed at mid-travel (6× actual size), the <strong>exploded</strong> assembly order A–E, and the <strong>knob top view</strong>. Dimensions on the sheet: 1-1/2" leg, 7/8" deep bore, 1" exposed foot (travel ±1/2"), 1-3/8" floor pad, 2" knob.</figcaption>
</figure>

| Key | Part | What it is / what to do |
|---|---|---|
| **A** | The leg | Bored 1/2" dia × 7/8" deep, centred, per Step 2 |
| **B** | Screw-in threaded insert | 7/16" OD outer thread, 3/8-16 bore. Driven flush on a spare bolt + jam nut, per Step 3 |
| **C** | 3/8-16 jam nut | Spin it ~1" up the stud. This is what locks the knob |
| **D** | PW6103 star knob (hand wheel) | ~2" dia, 3/8-16 thru-hole. Thread it up to the nut, then wrench the nut **down** onto it to lock the two together |
| **E** | Leveling stud + fixed hex collar + pad | 1-3/8" floor pad. Screw the stud into the insert to **1" exposure** |

<div class="warn">
<strong>Lock the knob with the JAM NUT, wrenched down on top of it — never by jamming the knob against the stud's fixed hex collar.</strong>
Jammed on the collar, the knob only grips in the tightening direction: the first time you spin it the other way to <em>lower</em> a corner, it unscrews itself off the stud instead of driving it. Knob and jam nut locked to each other grip in <strong>both</strong> directions, so one knob both raises and lowers the leg.
The hex collar's actual job is to be a wrench flat, so you can break a seized foot loose later.
</div>

**Skip the kit's stick-on felt pads.** The bare nylon pad grips the van floor better and doesn't shed.

<figure class="floorplan-figure">
<img src="renders/leveling-foot-detail.png" alt="Leveling foot detail">
<figcaption>The same foot as a component call-out: <strong>1</strong> the leg, <strong>2</strong> the threaded insert driven up into the end grain, <strong>3</strong> the star knob + jam nut (the adjustment — big enough to turn with the box tipped), <strong>4</strong> the leveling glide bolt and its 1.375" pad, ±0.5" of travel around the 1" nominal. Shown 3× actual size.</figcaption>
</figure>

**Set every foot to 1" exposure before the panels go in the van.** That is mid-travel, and it means the first real leveling pass has adjustment available in both directions. Feet set at the ends of their travel are feet that can only correct one way.

## 8. Step 5 — Set the legs into the frames

Legs go in as part of each panel's frame, before anything else — with the insert already driven (Step 3) and, ideally, the foot already fitted (Step 4).

**Position, all three panels:**

- **Across the width (46"):** legs are inset **3.5"** from each deck side edge, so their outer faces sit 3.5" in and the pair stands 39" apart outside-to-outside. The inset clears the van's floor-level rear heat-vent intrusion, measured at 3.5" per side (V4, Aug 2026 — it was 2.5" in earlier revisions of the plan; use 3.5").
- **Along the length:** legs sit tight in the corners, their outer faces flush with the outside of the end rails. No inset in this direction.
- **Exception — Panel C's REAR pair:** those two go at the **true corners**, not inset. The fridge and kitchen slide paths pass exactly where an inset rear leg would stand. The rear-corner floor vents were checked (Aug 2026) and do not reach the leg area, so those legs land on solid floor.

<figure class="floorplan-figure">
<img src="renders/leg-position.png" alt="Leg position end elevation">
<figcaption>Leg position, end elevation (Panel A/B shown — Panel C is identical except its rear pair). <strong>3.5" inset per side</strong>, <strong>39" leg to leg</strong> across the 46" deck, and the bottom rail's underside level with the leg bottoms, <strong>1"</strong> above the floor. The feet are what stand on the van floor; the leg bottoms never touch it.</figcaption>
</figure>

**Joinery — the one place in the build with no biscuits:**

<div class="spec">
Every 2x2 frame joint — rail-to-rail, rail-to-leg, bottom-rail-to-leg — is <strong>2 × 2" wood screws + glue, plus a steel corner bracket</strong>. A biscuit would blow out 1.5" stock.
</div>

Twelve corner brackets total, four per panel.

**Bottom rails.** Each panel gets 2x2 bottom rails with their **underside at 1"** — level with the leg bottoms, i.e. as low as they go without fouling the feet and knobs below. Two 2" screws + glue into each leg. Which faces get one differs by panel, and it is about what has to exit the panel sideways:

| Panel | Bottom rails | Why |
|---|---|---|
| A | 2 × 46" — **END faces only** | The side faces stay open: the DELTA 3 drawer and the WAVE 3 exit there at floor level |
| B | 2 × 46" + 2 × 26" — **all four faces, the full cube** | Nothing exits Panel B sideways, so every face closes. This is the stiffest frame of the three |
| C | 1 × 46" — **FRONT face only** | The tailgate face stays open for the fridge and kitchen unit |

Panels A and B also each get **2 diagonal corner braces** up top, which recover some of the racking rigidity they lost when their own tops were deleted.

### Panel A

<figure class="lego-figure">
<img src="renders/steps/pab-s1a-assembly.png" alt="Panel A frame assembly">
<figcaption>Panel A, frame step: 2 side rails (B, 29") + 2 end rails (A, 46") with corner brackets and 2" screws, then the 4 legs (C) cut to <strong>15.25"</strong> and bored, then the 2 END-face bottom rails (K, 46") and the 2 diagonal corner braces.</figcaption>
</figure>

<figure class="floorplan-figure">
<img src="renders/panel-a-detail.png" alt="Panel A detail">
<figcaption>Panel A exploded — item <strong>2</strong> is the legs, item <strong>8</strong> the END-face bottom rails.</figcaption>
</figure>

### Panel B

<figure class="lego-figure">
<img src="renders/steps/pab-s1b-assembly.png" alt="Panel B frame assembly">
<figcaption>Panel B, frame step — identical to Panel A's except the bottom rails close <strong>all four</strong> faces (2 × 46" + 2 × 26"). Same 15.25" legs, same 3.5" inset. That is the entire panel: no divider, no drawers.</figcaption>
</figure>

### Panel C

<figure class="lego-figure">
<img src="renders/steps/pc-s1-assembly.png" alt="Panel C frame assembly">
<figcaption>Panel C, frame step: 35.75" side rails (B) + 46" end rails (A), 4 legs (C) cut to <strong>16"</strong> — <strong>front pair inset 3.5", rear pair at the TRUE corners</strong> — and the FRONT-face bottom rail only (46").</figcaption>
</figure>

<figure class="floorplan-figure">
<img src="renders/panel-c-detail.png" alt="Panel C detail">
<figcaption>Panel C exploded — item <strong>2</strong> is the legs, item <strong>7</strong> the single front-face bottom rail. Note the rear legs standing at the true corners so the appliance slide paths stay clear.</figcaption>
</figure>

## 9. Leveling the finished boxes

The interior feet are a **one-time set**, not a per-site chore. Per-site leveling happens at the **wheels**, with leveling blocks driven by the Block Calculator (Appendix E of the full plan). The feet exist to take out the van's own floor irregularities, once.

To set them:

1. Put all three panels in the van, in position, with the bed platform resting on Panels A and B.
2. Put a level on the platform. The build's two stick-on bar levels read the same thing permanently: **pitch** on the platform's driver-side rail edge, **roll** on the rear-pantry deck edge.
3. Kneel at the side door, **tip that corner of the box slightly**, and spin that leg's star knob. Every foot is exposed at floor level — nothing boxes it in.
4. Work around the corners until both bubbles centre. Re-check with the van parked on ground you know is level.
5. After that first setup you should not need to touch a knob again.

If you would rather delete the feet entirely, fixed shims set once will do the same job and let the wheel blocks handle all site leveling — it saves ~$72 and loses the fine-trim option.

## 10. Load check

Worst case for the whole build is roughly **700 lb** — two people, mattress, platform, boxes and cargo — spread over 12 feet, so about **58 lb per foot** before dynamic factors.

<div class="callout">
<strong>Two ratings appear in the full plan, and they are not the same part.</strong>
The BOM line specifies a generic 3/8-16 furniture-leveler kit rated <strong>330 lb per foot</strong>. The parts actually purchased in July 2026 are <strong>Anwenk levelers, rated 1,320 lb per foot</strong>. Both clear the load by a wide margin — 5.7× on the generic kit, 22× on the Anwenk — so this does not change how you build. It is flagged here only so you order the right thing: <strong>check what is actually on the shelf before buying more.</strong>
</div>

The feet are not the weak point of this build under any of those numbers. If you want still more margin, 1/2"-13 leveling mounts are a drop-in upgrade — the same install, just a 5/8" insert bore instead of 1/2".

## 11. Shopping list — legs only

| Item | Qty | Note |
|---|---|---|
| 2x2 pine, 8 ft | 2 boards | Of the 12 the full build buys. Aluminum 1"×1" L-channel is the documented alternative |
| Leg leveling feet, 3/8-16, with threaded-insert ("T-nut") kit | 12 | 3 × 4-packs. See the rating note in Section 10 before ordering |
| Star knobs, 3/8-16 thru-hole, ~2" dia | 12 | 3 × 4-packs — Peachtree PW6103 |
| **3/8-16 jam nuts** | **12** | **Bought separately — they are not in either kit.** Everbilt 6-packs, 2 packs |
| Steel corner brackets, 2"–3" | 12 | 4 per panel |
| 2" wood screws | — | 2 per frame joint, 2 per bottom-rail-to-leg joint |
| Wood glue | — | Every frame joint |

The jam nuts are the part this build has repeatedly nearly forgotten — they are not supplied with the levelers or the knobs, and without them the knob cannot lock. Count them before you start.

## 12. Where these numbers come from

Everything here is generated from or checked against the parametric model:

| Value | Source |
|---|---|
| Leg cut 16" / 15.25" | `params.scad` — `leg_cut_length`, `leg_cut_length_ab` |
| Effective 17" / 16.25" | `params.scad` — `leg_height`, `leg_height_ab` |
| Foot 1" nominal, ±1/2" travel | `params.scad` — `leveling_foot_nominal_h`, `leveling_foot_travel` |
| Bore 1/2" dia × 7/8" deep | `leveling_foot_assembly.scad` — `bore_d`, `bore_dp` |
| Pad 1.375" dia | `params.scad` — `leveling_foot_pad_dia` |
| Leg inset 3.5" | `params.scad` — `leg_inset` = `vent_intrusion_width`, MEASURED V4 (Aug 2026) |
| Bottom rail underside 1" | `params.scad` — `bottom_rail_z` |

**Corrections applied Sept 2026 while assembling this subset.** Three leg dimensions were stale in places in the full plan and in the panel-detail drawings, and are corrected in both:

- The **Panel A and Panel B parts lists** called for 16" legs. They are **15.25"** — `leg_cut_length_ab`. The panel-detail drawings inherited the same error (they read `leg_cut_length` for all three panels) and have been re-rendered.
- The **insert bore depth** was quoted as 3/4" in the Floor Panel Detail note and on the Panel A/B/C drawings. It is **7/8"** — the maker's spec, and what the leveling-foot engineering drawing has always shown.
- The **Hardware Sizing** row gave only Panel C's 16" cut; it now gives both.

**One thing left open, and it is not a leg dimension.** The full plan's frame-lumber table cuts the end-face bottom rails at **46"** — full deck width, matching the end rail above them — while `panel_detail.scad` draws them spanning only leg-to-leg, **39"**. Either length does the bottom rail's job, which is to tie the leg bottoms together with 2 × 2" screws and glue into each leg, and neither changes anything about the legs themselves. Settle it before you cut bottom rails; cutting them at 46" leaves you the option of trimming. The drawing above deliberately carries no length dimension on that rail.
