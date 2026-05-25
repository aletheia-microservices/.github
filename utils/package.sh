#!/usr/bin/env bash

set -e

REPO_URL="https://github.com/aletheia-microservices/aletheia-artifact-osdi26.git"

TARGET_DIR="aletheia-artifact-osdi26"

ZIP_NAME="aletheia-artifact-osdi26.zip"

UNWANTED_FILES=(
    ".DS_Store"
    ".gitignore"
    ".gitmodules"
)

UNWANTED_DIRS=(
    ".git"
)

echo
echo "[1/5] cloning repository..."
echo "repository: $REPO_URL"

if [ -d "$TARGET_DIR" ]; then
    echo "target directory already exists: $TARGET_DIR"
    echo "skipping clone"
else
    git clone --quiet --recurse-submodules "$REPO_URL" "$TARGET_DIR"
fi

echo
echo "[2/5] copying root README..."

if [ -f "$TARGET_DIR/README.md" ]; then
    cp "$TARGET_DIR/README.md" .
    echo "copied: $TARGET_DIR/README.md -> ./README.md"
else
    echo "warning: README.md not found in $TARGET_DIR"
fi

echo
echo "[3/5] removing unwanted files..."

for file in "${UNWANTED_FILES[@]}"; do
    echo "searching for file: $file"

    matches=$(find "$TARGET_DIR" -type f -name "$file")

    if [ -z "$matches" ]; then
        echo "  no matches found"
        continue
    fi

    while IFS= read -r path; do
        echo "  removing: $path"
        rm -f "$path"
    done <<< "$matches"
done

echo
echo "[4/5] removing unwanted directories..."

for dir in "${UNWANTED_DIRS[@]}"; do
    echo "searching for directory: $dir"

    matches=$(find "$TARGET_DIR" -type d -name "$dir")

    if [ -z "$matches" ]; then
        echo "  no matches found"
        continue
    fi

    while IFS= read -r path; do
        echo "  removing: $path"
        rm -rf "$path"
    done <<< "$matches"
done

echo
echo "[5/5] creating zip archive..."

parent_dir="$(dirname "$TARGET_DIR")"
folder_name="$(basename "$TARGET_DIR")"

cd "$parent_dir"

echo "zipping folder: $folder_name"
echo "output zip: $ZIP_NAME"

zip -r --quiet "$ZIP_NAME" "$folder_name"

echo
echo "done!"
