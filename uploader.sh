#!/bin/bash

MODS_DIR="/home/ultimateshedic/mods"
OUTPUT_FILE="/tmp/modlist.txt"
CHECKSUM_FILE="/tmp/modchecksums.txt"
OLD_CHECKSUM_FILE="/tmp/modchecksums_old.txt"

BUCKET_NAME="gs://mc-modlist-bucket"
DEST_PATH="$BUCKET_NAME"
FILES_PATH="$DEST_PATH/files/"

# Enable nullglob so *.jar doesn't remain literal if no files
shopt -s nullglob

# Get list of all JAR files
JARS=("$MODS_DIR"/*.jar)

# Exit if no jars found
if [ ${#JARS[@]} -eq 0 ]; then
    echo "No .jar files found. Exiting."
    exit 0
fi

# Generate modlist.txt (just filenames)
find "${JARS[@]}" -print0 | xargs -0 -n1 basename > "$OUTPUT_FILE"

# Copy modlist.txt to GCS
gsutil cp "$OUTPUT_FILE" "$DEST_PATH/modlist.txt"

# Generate current checksums
> "$CHECKSUM_FILE"
for file in "${JARS[@]}"; do
    sha1sum "$file" >> "$CHECKSUM_FILE"
done

# Determine which files changed (new or modified)
FILES_TO_UPLOAD=()
if [ -f "$OLD_CHECKSUM_FILE" ]; then
    while IFS= read -r line; do
        FILE=$(echo "$line" | awk '{print $2}')
        if ! grep -q "$line" "$OLD_CHECKSUM_FILE"; then
            FILES_TO_UPLOAD+=("$MODS_DIR/$FILE")
        fi
    done < "$CHECKSUM_FILE"
else
    # First run — copy all
    FILES_TO_UPLOAD=("${JARS[@]}")
fi

# Upload changed/new .jar files
if [ ${#FILES_TO_UPLOAD[@]} -gt 0 ]; then
    echo "Uploading ${#FILES_TO_UPLOAD[@]} new/changed jars..."
    gsutil cp "${FILES_TO_UPLOAD[@]}" "$FILES_PATH"
else
    echo "No new or changed jars to upload."
fi

# Save current checksum as old for next run
cp "$CHECKSUM_FILE" "$OLD_CHECKSUM_FILE"

# Cleanup
rm "$OUTPUT_FILE"