#!/usr/bin/env bash

# Usage:
#   ./latex-diff.sh [old-version.zip] [new-version.zip]
#
# Examples:
#   ./latex-diff.sh
#   ./latex-diff.sh aletheia-osdi26-v1.zip aletheia-osdi26-v2.zip

set -euo pipefail

OLD_ZIP="${1:-aletheia-osdi26-v1.zip}"
NEW_ZIP="${2:-aletheia-osdi26-v2.zip}"

OLD_DIR="${OLD_ZIP%.zip}"
NEW_DIR="${NEW_ZIP%.zip}"

MAIN_TEX="main.tex"

OUT_DIR="latexdiff-output"
OUT_NAME="aletheia-osdi26-diff"

mkdir -p "$OUT_DIR"

command -v unzip >/dev/null || { echo "Missing unzip"; exit 1; }
command -v latexpand >/dev/null || { echo "Missing latexpand"; exit 1; }
command -v latexdiff >/dev/null || { echo "Missing latexdiff"; exit 1; }
command -v latexmk >/dev/null || { echo "Missing latexmk"; exit 1; }

echo "Cleaning old files..."
rm -rf "$OLD_DIR" "$NEW_DIR" "$OUT_DIR"

echo "Unzipping versions..."
mkdir -p "$OLD_DIR" "$NEW_DIR"
unzip -q "$OLD_ZIP" -d "$OLD_DIR"
unzip -q "$NEW_ZIP" -d "$NEW_DIR"

mkdir -p "$OUT_DIR"

echo "Expanding old version..."
cd $OLD_DIR
latexpand "$MAIN_TEX" > "../$OUT_DIR/v1-expand.tex"
cd ..

echo "Expanding new version..."
cd $NEW_DIR
latexpand "$MAIN_TEX" > "../$OUT_DIR/v2-expand.tex"
cd ..

echo "Generating diff..."
# --graphics-markup=none      --> discard diffs for moved plots (since they are not actually changed)
# --exclude-textcmd="caption" --> discard diffs for caption changes (when moving a figure the caption position changes)
latexdiff \
  --graphics-markup=none \
  "$OUT_DIR/v1-expand.tex" \
  "$OUT_DIR/v2-expand.tex" \
  > "$OUT_DIR/diff.tex"

echo "Cleaning Un-1 diff..."

python3 - <<'PY'
from pathlib import Path
import re

path = Path("latexdiff-output/diff.tex")
text = path.read_text()

# ------------ regex pattern for any equation (in case diff is too complex) ------------
# pattern = re.compile(
#   r"(\\begin\{eqbox\}.*?\\tag\*\{\\textbf\{Un-1\}\}.*?\\end\{eqbox\})",
#   re.DOTALL,
# )

# ------------ regex pattern for Un-1 (in case diff is too complex) ------------
# pattern = re.compile(
# r"(\\begin\{eqbox\}"
#  r"(?:(?!\\begin\{eqbox\}).)*?"
#  r"\\tag\*\{\\textbf\{Un-1\}\}"
#  r".*?"
#  r"\\end\{eqbox\})",
#  re.DOTALL,
#)

# ------------ clean Un-1 ------------
# def clean_un1(block: str) -> str:
#  block = re.sub(r"\\DIFdelbegin.*?\\DIFdelend", "", block, flags=re.DOTALL)
#  block = re.sub(r"\\DIFdel\{[^{}]*\}", "", block)
#  block = re.sub(r"%DIFDELCMD <.*?\n", "", block)
#  return block
#
# text = pattern.sub(lambda m: clean_un1(m.group(1)), text)

# remove deleted text inside figure captions only
figure_pattern = re.compile(
  r"(\\begin\{figure\*?\}.*?\\end\{figure\*?\})",
  re.DOTALL,
)
def clean_deleted_caption_text(block: str) -> str:
  def clean_caption(m):
    cap = m.group(0)
    # remove deleted blocks inside caption
    cap = re.sub(r"\\DIFdelbegin(?:FL)?", "", cap)
    cap = re.sub(r"\\DIFdelend(?:FL)?", "", cap)
    cap = re.sub(r"\\DIFdel(?:FL)?\{([^{}]*)\}", "", cap)
    # remove latexdiff deleted-command comments
    cap = re.sub(r"%DIFDELCMD <.*?\n", "", cap)
    return cap

  return re.sub(
    r"\\caption(?:\[[^\]]*\])?\{.*?\}",
    clean_caption,
    block,
    flags=re.DOTALL,
  )
text = figure_pattern.sub(lambda m: clean_deleted_caption_text(m.group(1)), text)

path.write_text(text)
PY

echo "Copying diff into new folder for compilation..."
cp "$OUT_DIR/diff.tex" "$NEW_DIR/diff.tex"

echo "Compiling diff..."
(
  cd "$NEW_DIR"
  latexmk -pdf -interaction=nonstopmode -file-line-error diff.tex
)

echo "Moving PDF to output folder..."
cp "$NEW_DIR/diff.pdf" "$OUT_DIR/$OUT_NAME.pdf"

echo "Done: $OUT_DIR/$OUT_NAME.pdf"
