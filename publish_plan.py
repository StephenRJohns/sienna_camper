#!/usr/bin/env python3
"""Publish the built PDF to the S'mores site.

The live plan at smoresoutdoors /project-smores is NOT served from this
repo — the site is a separate Next.js app (jjjjj-enterprises/smores-outdoors-portal,
deployed from its Dockerfile on Railway) that serves a COPY of this PDF out
of its own `public/` directory. So publishing is a file copy across two
repos, and for a long time it was a manual step somebody had to remember.

This script is that step. By default it rebuilds the PDF, copies it to the
portal, and stages it there, printing the hashes so you can see whether the
site was actually stale. It stops before committing unless asked, because
pushing the portal triggers a live Railway deploy.

    ./publish_plan.py                 # build, copy, stage
    ./publish_plan.py --no-build      # copy the existing PDF as-is
    ./publish_plan.py --commit        # ... and commit in the portal
    ./publish_plan.py --commit --push # ... and deploy it

Override the portal location with SMORES_PORTAL if it ever moves.
"""
import argparse
import hashlib
import os
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).parent
PDF_PATH = ROOT / "Project_Smores.pdf"

PORTAL = Path(os.environ.get("SMORES_PORTAL", Path.home() / "github" / "smores-outdoors-portal"))
# the name the site links: public/project-smores/index.html -> this file
PORTAL_PDF = PORTAL / "public" / "project-smores" / "project-smores-build-plan.pdf"


def md5(path):
    return hashlib.md5(path.read_bytes()).hexdigest() if path.exists() else None


def git(*args, check=True):
    return subprocess.run(["git", "-C", str(PORTAL), *args], check=check,
                          capture_output=True, text=True).stdout.strip()


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--no-build", action="store_true",
                    help="skip build_pdf.py and publish the PDF already on disk")
    ap.add_argument("--commit", action="store_true", help="commit the copy in the portal repo")
    ap.add_argument("--push", action="store_true",
                    help="push the portal (triggers a live Railway deploy); implies --commit")
    args = ap.parse_args()

    if not PORTAL_PDF.parent.is_dir():
        sys.exit(f"portal not found at {PORTAL}\n"
                 f"clone it or set SMORES_PORTAL to where it lives")

    if not args.no_build:
        print("building the PDF...")
        subprocess.run([sys.executable, str(ROOT / "build_pdf.py")], check=True, cwd=ROOT)

    if not PDF_PATH.exists():
        sys.exit(f"no PDF at {PDF_PATH} — run build_pdf.py first")

    live, new = md5(PORTAL_PDF), md5(PDF_PATH)
    if live == new:
        print(f"the site is already serving this exact PDF ({new[:8]}) — nothing to publish")
        return

    print(f"site has {live[:8] if live else 'nothing'} · publishing {new[:8]} "
          f"({PDF_PATH.stat().st_size / 1e6:.1f} MB)")
    shutil.copy2(PDF_PATH, PORTAL_PDF)
    git("add", str(PORTAL_PDF.relative_to(PORTAL)))

    if not (args.commit or args.push):
        print(f"staged in {PORTAL}. Commit and push there to deploy.")
        return

    git("commit", "-m", "Publish the current Project S'mores build plan")
    print("committed in the portal")

    if args.push:
        branch = git("rev-parse", "--abbrev-ref", "HEAD")
        git("push", "origin", branch)
        print(f"pushed {branch} — Railway will redeploy the site")
    else:
        print("not pushed — push the portal when you want the deploy")


if __name__ == "__main__":
    main()
