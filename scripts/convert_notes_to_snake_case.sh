#!/usr/bin/env bash
# convert_notes_to_snake_case.sh
# Converts all filenames in the notes directory to snake_case.
# Usage: bash scripts/convert_notes_to_snake_case.sh

set -euo pipefail

NOTES_DIR="$(dirname "$0")/../notes"

# Function to convert a string to snake_case
snake_case() {
    echo "$1" | \
        tr '[:upper:]' '[:lower:]' | \
        sed -E 's/[ -]+/_/g' | \
        sed -E 's/[^a-z0-9_]/_/g' | \
        sed -E 's/_+/_/g' | \
        sed -E 's/^_+|_+$//g'
}

cd "$NOTES_DIR"

for file in *; do
    if [[ -f "$file" ]]; then
        base="${file%.*}"
        ext="${file##*.}"
        # Only process .md files
        if [[ "$ext" == "md" ]]; then
            new_base="$(snake_case "$base")"
            new_name="${new_base}.md"
            if [[ "$file" != "$new_name" ]]; then
                if [[ -e "$new_name" ]]; then
                    echo "Skipping '$file': target '$new_name' already exists."
                else
                    mv "$file" "$new_name"
                    echo "Renamed '$file' -> '$new_name'"
                fi
            fi
        fi
    fi
done

echo "All applicable files in notes/ have been converted to snake_case."
