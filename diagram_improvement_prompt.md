# Prompt: Upgrade the Sienna camper build manual's diagrams to a Lego-style illustrated format

## Project context

This repo (`/home/stephen/sienna`) is a fully parametric OpenSCAD model of a DIY Toyota Sienna camper conversion — a modular sleeping platform (prefab rear pantry + 3 lift-out panels) with a fridge/kitchen install and EcoFlow power/AC stowage. Read these files first, in this order:

1. `params.scad` — every real-world dimension lives here (plywood sizes, frame lumber, drawer clearances, appliance dimensions, etc.), with `assert()` guards that fail loudly if a downstream constraint breaks.
2. `platform.scad` — the actual 3D geometry, built from `params.scad`'s values.
3. `sienna_camper_build_plan.md` — the full build plan in Markdown. **Section 6, "Illustrated Build Manual — By Component,"** is what you're improving. It's organized into 10 self-contained components (Headboard, Panel A, Panel B, Panel C, Bumpers/Alignment Pins, Cooktop Power Channel, Fridge & Kitchen Install, EcoFlow Stowage, Mattress Build, Final Assembly), each with a "Parts needed" list followed by numbered steps, some illustrated with images from `renders/`.
4. `steps/*.scad` — the individual per-step diagram source files (e.g. `step-02-build-frame.scad`, `step-05-build-drawers.scad`). These are the ones that most need improving.
5. `render.sh` — regenerates every SVG/PNG in `renders/` from the `.scad` sources. Run this after any `.scad` change.
6. `build_pdf.py` — converts the Markdown to styled HTML (inline CSS) and prints it to `sienna_camper_build_plan.pdf` via headless Chrome. This is where the page layout/CSS lives.

**How the current diagrams work:** every render is a flat 2D vector line drawing produced by OpenSCAD's `projection()` — wireframe outlines only (no shading, no fill, no depth cues beyond line weight), colored per-part *after* projection since `projection()` discards color otherwise. Labels are placed as numbered circular markers on the drawing with a separate text side-list (not inline labels — an earlier attempt at inline labels was abandoned because they collided badly in tight footprints). This produces technically accurate, dimensionally-correct line art, but it looks like a CAD drawing, not an instruction manual.

## The target style

I have a reference image of a "Simple & Powered Machines Building Instructions" manual page that has the visual quality I want. Its structure:

- A 2-column grid of components (e.g. "Lever," "Wheel and Axle," "Pulley," "Inclined Plane"), each in its own card with a light blue background and a "DOWNLOAD" link at the top.
- Inside each card, numbered steps (1, 2, 3...) running top to bottom.
- **Each step shows two things side by side**: first, a small isolated thumbnail of just the new part(s) being introduced in that step (like a Lego manual's "here's the piece you need right now" callout) — no assembly context, just the part(s) on their own. Second, a larger illustration of the assembly *after* that part is added, drawn as a shaded, slightly-3D isometric-style illustration (not flat line art) with small red arrows showing insertion direction/motion where a part is being inserted or fastened.
- Colors are used consistently: the same part is the same color everywhere it appears across steps.
- The overall effect reads as "here's the one new thing you need, here's exactly how it goes in" — one clear visual decision per step, not a dense technical drawing.

## What to build

Apply this pattern to Section 6's illustrated manual. Concretely:

1. **Per-step "parts needed" thumbnails.** For every numbered step in every component (starting with the ones that already have a diagram — Headboard/Panel frame build, fixed-top+divider, drawers, hand-holds, bumpers, power channel, Panel B lift-top, fridge install, DELTA3/WAVE3 stowage), add a small preview render showing *just the new part(s) introduced in that step*, isolated, before the "installed" view. Reuse the existing `part()`/similar helper modules in the `steps/*.scad` files where they already isolate individual pieces (e.g. `step-02-build-frame.scad`'s parts-as-a-kit view) — extend that pattern to every step, not just frame-building.

2. **True exploded-assembly views**, not schematic cross-sections. Where a step shows a part being installed (e.g. the center divider dropping into the frame, a drawer box sliding onto its slides, the Panel B lid hinging up), show the part offset from its final position along its actual installation axis, with a dashed guide line or arrow indicating the motion into place — a real "exploded diagram," not just a labeled top-down/elevation slice.

3. **More dimensional-looking rendering.** Decide whether to keep the `projection()`-based flat line-art approach (fast, crisp, print-friendly, matches the existing style) or move to OpenSCAD's real 3D rendering (`--render`, orthographic/isometric camera, actual shaded solids) for these step diagrams specifically. If you switch to shaded 3D renders for the step-by-step manual, keep the existing flat vector line art for the whole-vehicle/technical dimension diagrams (top-down, side profile, rear view, fridge install detail, etc.) — those need to stay precise technical drawings, not stylized illustrations. Only the step-by-step assembly diagrams need the Lego-manual treatment.

4. **Consistent part color-coding.** Establish one color per distinct part/material type (e.g. plywood tops, 2x2 pine frame rails, legs, hardware, specific appliances) and reuse it across every diagram it appears in, including the existing detail renders (fridge install, DELTA3/WAVE3 stowage, Panel B lift-top). Check `params.scad`/the `steps/*.scad` files for whatever ad hoc color conventions already exist (e.g. `SteelBlue` for the WAVE3 unit, `SaddleBrown` for wood/cleats, `DimGray` for hinges) and formalize them into a single shared color palette (probably worth factoring into a small include file, e.g. `colors.scad`, so every `.scad` file references the same names).

5. **Page layout.** Update `build_pdf.py`'s CSS so Section 6 reads more like the reference's card grid — light background per component, a clear numbered-step visual rhythm, the parts-thumbnail + assembled-view pairing side by side per step (a simple 2-column flex/grid row per step works well in print CSS). Don't break the existing page-break-per-`h2` behavior or the other sections' styling.

## Constraints — don't break these

- **Everything must stay parametric.** No hardcoded dimensions that duplicate a value already in `params.scad` — if a diagram needs a number, it must reference the same variable the rest of the model uses. The entire point of this project is that changing one value in `params.scad` and re-running `render.sh` keeps every diagram, cut list, and BOM total in sync.
- **Don't touch the `assert()` guards** in `params.scad` or weaken the validation they provide.
- Keep exporting SVG for print (PNG is fine as a secondary/preview format, same as today), and keep captions/labels legible when printed at the sizes `build_pdf.py`'s CSS already targets (Letter page, ~0.65in margins).
- Keep the marker + side-list labeling convention for anything with more than 2-3 callouts — inline labels have already been tried and rejected once for collision in tight footprints (see comments in `fridge_install_detail.scad`).
- Preserve the existing render.sh → build_pdf.py pipeline shape (regenerate renders, then regenerate the PDF) — extend it, don't replace it with a different toolchain, unless you have a strong reason and call it out explicitly.

## Suggested approach

Don't try to redo all 10 components at once. Pick **one component** (Panel B is a good candidate — it already has the most complete detail file, `panel_b_lift_top_detail.scad`, including an exploded-ish closed/open side elevation to build from) and produce a fully redesigned version of its step diagrams plus the corresponding Section 6 text/layout changes. Show that end-to-end before doing the rest, so the visual direction can be checked against the reference before investing in all 10.

## Deliverables

- New/updated `.scad` files for step diagrams (parts-needed thumbnails + exploded assembly views), wired into `render.sh`.
- A shared color-convention file/pattern used consistently across step diagrams and the existing detail renders.
- Updated `build_pdf.py` CSS/template for the new per-step layout in Section 6.
- Regenerated `renders/` and a rebuilt `sienna_camper_build_plan.pdf`.
- A short summary of what changed and any tradeoffs made (e.g., render time, file count, anything that couldn't stay parametric and why).
