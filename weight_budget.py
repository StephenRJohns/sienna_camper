#!/usr/bin/env python3
"""Compute the Sienna camper weight budget from real material dimensions,
emit a CSV spreadsheet + a markdown table + distribution stats."""
import csv, pathlib

# --- material densities ---
PINE = 28.0            # lb/ft^3, kiln-dried pine/SPF
BIRCH = 42.5           # lb/ft^3, Baltic birch plywood
def ply(area_in2, thick_in): return area_in2/144.0 * BIRCH * (thick_in/12.0)
def pine_len(len_in, w=1.5, h=1.5): return len_in * (w*h)/1728.0 * PINE   # 2x2 default
def pine_1x4(len_in): return pine_len(len_in, 3.5, 0.75)

# Each row: name, category, weight(lb), y (in from front seatbacks 0..94),
# x (lateral in; -=driver, +=passenger), note
R = []
def add(name, cat, wt, y, x, note): R.append([name, cat, round(wt,1), y, x, note])

# ---- STRUCTURE ----
add("Panel A frame (2x2 pine)", "Structure", pine_len(332), 14.5, 0, "rails+legs+divider+bottom rails")
add("Panel A drawer box + slides (3/8\" birch, 1/2\" bottom)", "Structure", ply(500,0.5)+ply(1305,0.375)+4, 14.5, 11, "holds the DELTA 3 stack")
add("Panel B frame (2x2 pine, full cube)", "Structure", pine_len(358), 43.5, 0, "bare-frame deep-storage box")
add("Panel C frame (2x2 pine)", "Structure", pine_len(274), 76, 0, "rails+legs+front bottom rail")
add("Panel C deck (3/4\" birch, 36x46)", "Structure", ply(36*46,0.75), 76, 0, "fixed top over fridge/kitchen")
add("Panel C front wall (3/8\" birch)", "Structure", ply(46*17,0.375), 60, 0, "intake fan + grommets")
add("Fridge tray (3/8\" birch + edge frame)", "Structure", ply(17.72*28.74,0.375), 80, -12, "on the fridge slide")
add("Kitchen drawer + cheeks (1/2\" birch)", "Structure", ply(744,0.5)+ply(322,0.5), 80, 13, "hung over the kitchen unit")
add("Headboard/pantry (1/2\" birch shelving, 3/4\" cleats)", "Structure", ply(2*14*22,0.5)+ply(2*46*14,0.5)+ply(2*46*3,0.75)+ply(46*14,0.5)+ply(46*4.25,0.5)+3, 87, 0, "2 side panels + 3 shelves + cleats + trim")
add("Bed platform (1x4 pine, 2 rails + 8 slats)", "Structure", pine_1x4(2*58+8*45), 29, 0, "flush slat deck over A+B")

# ---- APPLIANCES ----
add("Fridge (BougeRV Rocky 40, empty)", "Appliances", 40.6, 80, -12, "manual spec; +20-40 lb loaded")
add("Kitchen unit (JAGAHAHA)", "Appliances", 45.0, 80, 13, "listing spec")

# ---- POWER / CLIMATE ----
add("EcoFlow DELTA 3 Plus + Extra Battery", "Power/climate", 48.0, 14.5, 11, "Panel A passenger drawer")
add("EcoFlow WAVE 3 A/C", "Power/climate", 33.7, 14.5, -11, "Panel A driver bay")

# ---- BEDDING ----
add("Mattress (HEST Dually Long)", "Bedding", 35.0, 40, 0, "ESTIMATE - solid foam + cover")

# ---- HARDWARE / MISC ----
add("Fridge + kitchen-drawer slides (heavy)", "Hardware/misc", 8.0, 80, 0, "24\" heavy-duty pairs")
add("12 leveling feet + star knobs + inserts", "Hardware/misc", 5.0, 47, 0, "4 per panel")
add("E-track anchors (8) + ratchet straps", "Hardware/misc", 8.0, 76, 0, "floor tie-downs at Panel C")
add("Corner brackets, braces, screws, glue", "Hardware/misc", 6.0, 47, 0, "spread across all modules")
add("Seam draw-latches (4) + alignment pins + bumpers", "Hardware/misc", 1.5, 47, 0, "at the A/B + B/C seams")
add("Electrical (2 fans, controller, fuse, 2 strips, cords)", "Hardware/misc", 6.0, 55, 0, "cooling + power runs")
add("Cooktop + cookware (stowed)", "Hardware/misc", 12.0, 80, 13, "induction top + pots in the kitchen")

# ---- totals ----
build = sum(r[2] for r in R)
cats = {}
for r in R: cats[r[1]] = cats.get(r[1],0)+r[2]
ymom = sum(r[2]*r[3] for r in R); xmom = sum(r[2]*r[4] for r in R)
ycg = ymom/build; xcg = xmom/build
front = sum(r[2] for r in R if r[3] < 31)
mid   = sum(r[2] for r in R if 31 <= r[3] < 63)
rear  = sum(r[2] for r in R if r[3] >= 63)

# ---- seat-removal credit (2nd-row seats come OUT — Section 9) ----
# ~48-70 lb per seat (Sienna 60/40 bench = 48+70; captain's chairs similar),
# so the pair is roughly 110-130 lb. ESTIMATE — weigh yours to confirm.
SEATS_REMOVED = 120.0
net = build - SEATS_REMOVED   # net permanent weight the conversion adds vs. stock (seatless)

# ---- write CSV ----
out = pathlib.Path("/home/stephen/sienna/weight_budget.csv")
with out.open("w", newline="") as f:
    w = csv.writer(f)
    w.writerow(["Component","Category","Weight (lb)","Fore-aft y (in from front)","Lateral x (in, -driver/+pass)","Notes"])
    for r in R: w.writerow(r)
    w.writerow([])
    for c,v in cats.items(): w.writerow([c+" subtotal","","%.1f"%v,"","",""])
    w.writerow(["BUILD TOTAL (added)","","%.1f"%build,"","",""])
    w.writerow(["Removed: 2nd-row seats x2 (est.)","credit","-%.0f"%SEATS_REMOVED,"","","WEIGH to confirm; ~48-70 lb each"])
    w.writerow(["NET added vs stock (build - seats)","","%.1f"%net,"","",""])
print("wrote", out)

# ---- markdown table ----
print("\n=== MARKDOWN TABLE ===")
print("| Component | Category | Weight (lb) | Zone | Notes |")
print("|---|---|--:|:--:|---|")
def zone(y): return "front" if y<31 else ("mid" if y<63 else "rear")
for r in R:
    print(f"| {r[0]} | {r[1]} | {r[2]:.1f} | {zone(r[3])} | {r[5]} |")

print("\n=== SUBTOTALS ===")
for c,v in cats.items(): print(f"{c}: {v:.1f}")
print(f"BUILD TOTAL (added): {build:.1f}")
print(f"Removed: 2nd-row seats x2 (est.): -{SEATS_REMOVED:.0f}")
print(f"NET added vs stock (build - seats): {net:.1f}")
print(f"\nFore-aft CG: {ycg:.1f}\" from front seatbacks (build spans 0-94\")")
print(f"Lateral CG: {xcg:+.1f}\" ({'passenger' if xcg>0 else 'driver'} of centerline)")
print(f"Front third (0-31\"): {front:.1f} lb ({100*front/build:.0f}%)")
print(f"Mid third (31-63\"):  {mid:.1f} lb ({100*mid/build:.0f}%)")
print(f"Rear third (63-94\"): {rear:.1f} lb ({100*rear/build:.0f}%)")
print(f"\nLoaded scenarios (using NET, seats removed):")
prov=120; occ=340
print(f"  net build + provisions(~{prov}): {net+prov:.0f} lb")
print(f"  + 2 occupants(~{occ}, up front while driving): {net+prov+occ:.0f} lb")
print(f"  (gross build, seats still in, + provisions + occupants: {build+prov+occ:.0f} lb)")
