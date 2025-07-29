#!/bin/bash

# these values will be updated
MODS_DIR="/home/ultimateshedic/mods"
OUTPUT_FILE="/tmp/modlist.txt"
BUCKET_NAME="gs://mc-modlist-bucket"
DEST_PATH="$BUCKET_NAME/modlist.txt"

# > overwrites stuff while >> appends
ls "$MODS_DIR"/*.jar > "$OUTPUT_FILE"

gsutil cp "$OUTPUT_FILE" "$DEST_PATH"
rm "$OUTPUT_FILE"