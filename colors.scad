// ============================================================
// Shared part color palette — one color per part/material type,
// reused across every diagram that part appears in.
// ============================================================
// Formalizes the ad hoc conventions that already existed across
// the detail files (SaddleBrown wood, DimGray hinges/hardware,
// SteelBlue for the WAVE 3, Tan drawers) so the step-by-step
// manual and the technical detail renders stay visually
// consistent. include <colors.scad> (or <../colors.scad> from
// steps/) and use these names instead of string literals.
//
// Convention in step diagrams (Lego-manual style): parts already
// installed in previous steps render in COL_MUTED so the step's
// NEW part — drawn in its real palette color — is the only thing
// that pops. Insertion arrows are always COL_ARROW.

// Distinct HUES per part type, not shades of the same material
// color — three browns (rails/legs/divider) proved indistinguishable
// at print size, so only the two big plywood/pine "wood" families
// keep wood tones and everything else gets its own hue.
// Numbered-marker palette: every marker keeps its NUMBER for
// pairing with its list row, and additionally gets an easily-
// differentiated hue by number. All 10 are dark enough for the
// white numeral to stay readable. Past 10 the palette wraps —
// the number still disambiguates.
MARKER_COLS = ["Crimson", "RoyalBlue", "ForestGreen", "DarkOrange", "MediumOrchid",
               "Teal", "SaddleBrown", "DeepPink", "DarkSlateGray", "OliveDrab"];
function marker_col(n) = MARKER_COLS[(n - 1) % len(MARKER_COLS)];
// list-row helper: first digit of a label like "2/3" picks the color
function marker_col_s(s) = marker_col(ord(s[0]) - 48);

COL_PLY_TOP   = "BurlyWood";    // 3/4" plywood deck tops (tan)
COL_FRAME     = "Peru";         // 2x2 pine perimeter rails (warm brown)
COL_LEG       = "SteelBlue";    // 2x2 pine legs (blue)
COL_DIVIDER   = "SeaGreen";     // center divider rail (green)
COL_DRAWER    = "Goldenrod";    // 1/2" ply drawer boxes (yellow)
COL_HARDWARE  = "DimGray";      // slides, piano hinge, anchors, small metal hardware
COL_LATCH     = "DarkOrange";   // lid latches (orange — arrows keep red to themselves)
COL_STRUT     = "MediumOrchid"; // gas prop struts (purple)
COL_ARROW     = "Crimson";      // insertion-direction arrows (step diagrams only)
COL_MUTED     = "Gainsboro";    // already-installed parts from previous steps
COL_EDGE      = [0.25, 0.25, 0.25]; // projected wireframe edge lines
COL_TEXT      = "Black";        // labels, qty callouts, dimensions
