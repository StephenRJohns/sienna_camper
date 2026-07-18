#!/usr/bin/env bash
# ============================================================
# Regenerate all Sienna camper platform renders.
# Run after tweaking any value in params.scad.
# ============================================================
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

if ! command -v openscad >/dev/null 2>&1; then
    echo "openscad not found — install it first (e.g. sudo apt-get install openscad)" >&2
    exit 1
fi

mkdir -p renders/steps

# clean stale outputs (e.g. from a renamed/removed steps/*.scad file)
# so renders/ never drifts from what the current .scad sources produce
find renders -maxdepth 1 -type f \( -name '*.svg' -o -name '*.png' \) -delete
rm -f renders/steps/*.svg renders/steps/*.png

IMG="--imgsize=2900,2150"
FLAT_CAM="--camera=0,0,0,0,0,0,150 --projection=o --autocenter --viewall"

echo "Rendering top-down view..."
openscad -o renders/top-down.svg top_view.scad
openscad -o renders/top-down.png $IMG $FLAT_CAM top_view.scad

echo "Rendering whole-vehicle overview..."
openscad -o renders/vehicle-overview.svg vehicle_overview.scad
openscad -o renders/vehicle-overview.png $IMG $FLAT_CAM vehicle_overview.scad

echo "Rendering side profile..."
openscad -o renders/side-profile.svg side_view.scad
openscad -o renders/side-profile.png $IMG $FLAT_CAM side_view.scad

echo "Rendering rear view (stowed)..."
openscad -o renders/rear-view.svg rear_view.scad
openscad -o renders/rear-view.png $IMG $FLAT_CAM rear_view.scad

echo "Rendering rear view (deployed)..."
openscad -o renders/rear-view-deployed.svg rear_view_deployed.scad
openscad -o renders/rear-view-deployed.png $IMG $FLAT_CAM rear_view_deployed.scad

echo "Rendering side elevations (driver + passenger)..."
openscad -o renders/side-driver.svg -D 'side="driver"' view_side.scad
openscad -o renders/side-driver.png $IMG $FLAT_CAM -D 'side="driver"' view_side.scad
openscad -o renders/side-passenger.svg -D 'side="passenger"' view_side.scad
openscad -o renders/side-passenger.png $IMG $FLAT_CAM -D 'side="passenger"' view_side.scad

echo "Rendering headboard front (mattress-facing)..."
openscad -o renders/headboard-front.svg view_headboard_front.scad
openscad -o renders/headboard-front.png --imgsize=3000,2200 $FLAT_CAM view_headboard_front.scad

echo "Rendering fridge install detail (top-down)..."
openscad -o renders/fridge-install-detail.svg fridge_install_detail.scad
openscad -o renders/fridge-install-detail.png $IMG $FLAT_CAM fridge_install_detail.scad

echo "Rendering fridge wiring diagram..."
openscad -o renders/fridge-wiring.svg fridge_wiring.scad
openscad -o renders/fridge-wiring.png $IMG $FLAT_CAM fridge_wiring.scad

echo "Rendering fridge slide mechanism detail..."
openscad -o renders/fridge-slide-detail.svg fridge_slide_detail.scad
openscad -o renders/fridge-slide-detail.png $IMG $FLAT_CAM fridge_slide_detail.scad

echo "Rendering DELTA 3 / WAVE 3 stowage detail..."
openscad -o renders/delta3-wave3-detail.svg delta3_wave3_detail.scad
openscad -o renders/delta3-wave3-detail.png --imgsize=2500,4700 $FLAT_CAM delta3_wave3_detail.scad

echo "Rendering headboard storage detail..."
openscad -o renders/headboard-storage-detail.svg headboard_storage_detail.scad
openscad -o renders/headboard-storage-detail.png --imgsize=3250,2500 $FLAT_CAM headboard_storage_detail.scad

echo "Rendering floor panel details (A/B/C)..."
for p in A B C; do
    lp=$(echo "$p" | tr 'A-Z' 'a-z')
    openscad -o renders/panel-$lp-detail.svg -D "panel=\"$p\"" panel_detail.scad
    openscad -o renders/panel-$lp-detail.png --imgsize=3250,2500 $FLAT_CAM -D "panel=\"$p\"" panel_detail.scad
done

echo "Rendering headboard elevations (all 4 sides)..."
openscad -o renders/headboard-elevations.svg headboard_elevations.scad
openscad -o renders/headboard-elevations.png --imgsize=3400,2500 $FLAT_CAM headboard_elevations.scad

echo "Rendering cabinet door detail..."
openscad -o renders/cabinet-door-detail.svg cabinet_door_detail.scad
openscad -o renders/cabinet-door-detail.png --imgsize=3250,2150 $FLAT_CAM cabinet_door_detail.scad

echo "Rendering leveling foot detail..."
openscad -o renders/leveling-foot-detail.svg leveling_foot_detail.scad
openscad -o renders/leveling-foot-detail.png --imgsize=3250,2150 --camera=0,0,0,0,0,0,60 --projection=o --autocenter --viewall leveling_foot_detail.scad

echo "Rendering bed frame detail..."
openscad -o renders/bed-frame-detail.svg bed_frame_detail.scad
openscad -o renders/bed-frame-detail.png --imgsize=3250,2150 $FLAT_CAM bed_frame_detail.scad

echo "Rendering sway brace detail..."
openscad -o renders/sway-brace-detail.svg sway_brace_detail.scad
openscad -o renders/sway-brace-detail.png --imgsize=3250,2150 $FLAT_CAM sway_brace_detail.scad

echo "Rendering kitchen drawer detail..."
openscad -o renders/kitchen-drawer-detail.svg kitchen_drawer_detail.scad
openscad -o renders/kitchen-drawer-detail.png --imgsize=3250,1800 $FLAT_CAM kitchen_drawer_detail.scad

echo "Rendering Panel C front wall detail..."
openscad -o renders/panel-c-wall-detail.svg panel_c_wall_detail.scad
openscad -o renders/panel-c-wall-detail.png --imgsize=3250,1800 $FLAT_CAM panel_c_wall_detail.scad

echo "Rendering joinery & fastener guide..."
openscad -o renders/joinery-detail.svg joinery_detail.scad
openscad -o renders/joinery-detail.png --imgsize=3400,3400 $FLAT_CAM joinery_detail.scad

echo "Rendering electrical layout detail..."
openscad -o renders/electrical-layout.svg electrical_layout_detail.scad
openscad -o renders/electrical-layout.png --imgsize=2700,4850 $FLAT_CAM electrical_layout_detail.scad

echo "Rendering measurement guides..."
# these are much taller than wide (3 stacked sub-views) — a taller
# image frame keeps their effective resolution reasonable; viewall
# would still capture everything at the standard $IMG size, just at
# lower detail for content this narrow-and-tall.
TALL_IMG="--imgsize=2500,4700"
openscad -o renders/measurement-van.svg measurement_van.scad
openscad -o renders/measurement-van.png $TALL_IMG $FLAT_CAM measurement_van.scad
openscad -o renders/measurement-fridge-kitchen.svg measurement_fridge_kitchen.scad
openscad -o renders/measurement-fridge-kitchen.png $TALL_IMG $FLAT_CAM measurement_fridge_kitchen.scad

echo "Rendering step diagrams..."
for step in steps/step-*.scad; do
    name="$(basename "$step" .scad)"
    # hand-holds were removed from the plan (bare frames are gripped
    # by their exposed top rails) — the file stays on disk, unrendered
    [ "$name" = "step-06-install-handles" ] && continue
    openscad -o "renders/steps/${name}.svg" "$step"
    openscad -o "renders/steps/${name}.png" $IMG $FLAT_CAM "$step"
done

echo "Rendering Lego-style step diagrams (woodworking-plan line art)..."
# each file is driven by -D step=N -D view="parts"|"assembly" and
# renders one parts-kit + exploded-assembly pair per step (see
# steps/lego_lib.scad for the shared style).
lego_steps() { # file prefix step_count
    local file=$1 prefix=$2 count=$3
    for s in $(seq 1 "$count"); do
        for v in parts assembly; do
            openscad -o "renders/steps/${prefix}-s${s}-${v}.svg" \
                -D "step=${s}" -D "view=\"${v}\"" "steps/${file}"
            openscad -o "renders/steps/${prefix}-s${s}-${v}.png" \
                $IMG $FLAT_CAM -D "step=${s}" -D "view=\"${v}\"" "steps/${file}"
        done
    done
}
# Panel A/B lego steps: the frames DIVERGE at the cube-frame bottom
# rails (A: end faces only — the drawer/WAVE 3 exit its sides; B:
# all 4 faces, the full cube), so step 1 renders per panel as
# pab-s1a-*/pab-s1b-*. Step 2 (divider) and step 3 (drawer bay) are
# Panel A only now — Panel B is a bare frame.
for panel_letter in A B; do
    suffix=$( [ "$panel_letter" = "A" ] && echo "1a" || echo "1b" )
    for v in parts assembly; do
        openscad -o "renders/steps/pab-s${suffix}-${v}.svg" \
            -D "step=1" -D "view=\"${v}\"" -D "panel=\"${panel_letter}\"" steps/panel_ab_lego.scad
        openscad -o "renders/steps/pab-s${suffix}-${v}.png" \
            $IMG $FLAT_CAM -D "step=1" -D "view=\"${v}\"" -D "panel=\"${panel_letter}\"" steps/panel_ab_lego.scad
    done
done
for s in 2 3; do
    suffix=$( [ "$s" = "3" ] && echo "3a" || echo "2" )
    for v in parts assembly; do
        openscad -o "renders/steps/pab-s${suffix}-${v}.svg" \
            -D "step=${s}" -D "view=\"${v}\"" -D 'panel="A"' steps/panel_ab_lego.scad
        openscad -o "renders/steps/pab-s${suffix}-${v}.png" \
            $IMG $FLAT_CAM -D "step=${s}" -D "view=\"${v}\"" -D 'panel="A"' steps/panel_ab_lego.scad
    done
done
lego_steps headboard_lego.scad hb 4
lego_steps panel_c_lego.scad pc 2
lego_steps mattress_lego.scad mat 2

echo "Stripping default PNG background to transparent..."
python3 make_bg_transparent.py renders >/dev/null

echo "Done. Renders in ./renders/"
