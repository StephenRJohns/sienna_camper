# Sienna Power-Folding Mirror Install Guide

Generates a 24-page print-ready PDF install guide for the aftermarket power-fold
mirror retrofit on a 2021-2026 Toyota Sienna.

## Quick start

```bash
python -m venv .venv && source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt

python src/make_assets.py     # crop source images + draw diagrams
python build_guide.py         # build the PDF
open output/Sienna_PowerFold_Mirror_Install_Guide.pdf
```

`make_assets.py` only needs re-running when the source images or crop boxes change.
Day to day you will edit `build_guide.py` and re-run just that.

## With Claude Code

```bash
claude
```

`CLAUDE.md` carries the project conventions and the domain facts, so Claude Code
picks up the context automatically. Things it can do well here:

- "add a video link callout to Step 1"
- "the crop on f_ldoor_b is cutting off the connector, shift the box down 20px and rebuild"
- "add a torque spec table to Step 6"
- "regenerate the diagrams with larger label text"

## Notes

- Everything in `src/images/` is an original. Nothing else is backed up — do not edit
  or delete those files.
- `src/assets/` and `output/` are generated and gitignored. Delete them freely.
