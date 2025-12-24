#!/bin/bash

# this config entirely depends on you. u can keep this or use anything else.
MODS_DIR="/home/ultimateshedic/mods"
OUTPUT_FILE="/tmp/modlist.txt"
BUCKET_NAME="gs://bucket-name"
DEST_PATH="$BUCKET_NAME"
FILES_PATH="$DEST_PATH/files/"

sync() {
    echo "$(date): Changes detected. Starting sync..."

    shopt -s nullglob
    JARS=("$MODS_DIR"/*.jar)

    if [ ${#JARS[@]} -eq 0 ]; then
        echo "No jars found."
        return
    fi

    find "${JARS[@]}" -print0 | xargs -0 -n1 basename > "$OUTPUT_FILE"

    gsutil cp "$OUTPUT_FILE" "$DEST_PATH/modlist.txt".
    gcloud storage rsync "$MODS_DIR" "$FILES_PATH"

    echo "$(date): Sync complete."
}

echo "Watcher started on $MODS_DIR..."

# monitor for:
# close_write: file finished writing
# moved_to: file moved into folder
# delete: file deleted
# moved_from: file moved out
inotifywait -m -e close_write -e moved_to -e delete -e moved_from --format "%f" "$MODS_DIR" | \
while read FILENAME; do
    if [ -n "$PID" ]; then
        kill "$PID" 2>/dev/null
    fi

    # Start a background subshell that waits 5 seconds then runs sync
    ( sleep 5 && sync_mods ) &
    PID=$!
done