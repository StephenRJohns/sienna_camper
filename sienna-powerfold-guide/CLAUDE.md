# Sienna Power-Folding Mirror Install Guide

A personal reference document: a print-ready PDF install guide for the aftermarket
power-fold mirror retrofit on a 2021-2026 Toyota Sienna. The PDF is generated from
source; it is not hand-edited.

## Build

```bash
pip install -r requirements.txt
python src/make_assets.py     # crops + diagrams -> src/assets/  (only when sources change)
python build_guide.py         # -> output/Sienna_PowerFold_Mirror_Install_Guide.pdf
```

`make_assets.py` is idempotent and safe to re-run. `build_guide.py` is the only file
that decides what goes in the document.

## Layout

| Path | What it is |
|---|---|
| `build_guide.py` | The whole document. Content, styles, page order. Edit this. |
| `src/images/` | Original photos and forum screenshots. **Treat as read-only.** |
| `src/assets/` | Generated crops and diagrams. Disposable — regenerate, don't edit. |
| `src/make_assets.py` | Crop table + contact-sheet check. |
| `src/make_diagrams.py` | The two vector diagrams, drawn in ReportLab. |
| `output/` | Build output. Disposable. |
| `docs/sources.md` | Where each claim came from. |

## Conventions

- **Never edit anything in `src/images/`.** Those are the only copies of the originals.
- **Never hand-edit files in `src/assets/`** — they are regenerated and your edits will
  be lost. Change the crop box in `make_assets.py` instead.
- After changing a crop box, open `src/assets/_contact_sheet.png` to verify it before
  rebuilding the PDF.
- Content style: paraphrase the forum, never quote it at length. Photos are the owner's
  own or were shared publicly in the thread; the two figures are the kit maker's.
- Callout styles are `note` (amber, context), `tip` (green, do-this), `warn` (red,
  damage/safety). They all need `spaceBefore` set or their padded background overlaps
  the element above — this was a real bug, don't remove it.
- Images referenced by `photo()`/`pair()`/`trio()` are looked up in `src/assets/` first,
  then `src/images/`, so bare filenames work for both.

## Domain facts worth not re-deriving

These were expensive to establish. Don't contradict them without a source.

- **The spring tool ships with the kit.** There is no aftermarket equivalent; the drive-lug
  pattern is specific to this pivot. If it strips, the seller is the only route.
- **Two different drives, two sizes.** A 13 mm nut on the threaded rod does the
  compressing; a 19 mm hex on the tool body rotates the lock collar. They are not two nuts.
- **Technique, not force.** Snug the 13 mm, try the 19 mm, and if it won't turn give the
  13 mm one more full turn and retry. People strip these by cranking down first.
  The 19 mm only ever turns about 90 degrees.
- **You are not really fighting the spring.** You are compressing the cylinder until its
  ears clear a pocket in the housing.
- **The mirror selector knob must be centred for folding to work.** Turned to L or R,
  folding is disabled by design. This explains most "it stopped working" reports.
- **Wiring is piggyback.** Nothing is cut for the basic fold function. Only the optional
  extra-features wire taps a factory circuit — that step is genuinely optional and is the
  riskiest part of the job.
- Mirror glass comes off by hand, not with a pry bar. The heater spade terminals pull off
  easily and are hard to reconnect blind.

## Open items

- [ ] Add per-step video links (Steps 1, 2, 3) — see `docs/sources.md`.
- [ ] Add thread page-7 to the source list; it has the clearest cylinder-release account.
- [ ] Find Fly-to-the-sky part 2+ (the part 1 video only covers door removal).
- [ ] Consider inline source links at each step rather than only on the last page.
