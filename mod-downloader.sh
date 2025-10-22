#!/bin/bash

LOG_FILE="/tmp/download_log_$(date +%Y%m%d_%H%M%S).log"
DOWNLOAD_DIR="./downloads"
TARGET_DIR="/home/ultimateshedic/mods/"

echo "[$(date)] Script started." | tee -a "$LOG_FILE"

if [ $# -ne 1 ]; then
    echo "Usage: $0 <url_list.txt>" | tee -a "$LOG_FILE"
    exit 1
fi

URL_FILE="$1"

if [ ! -f "$URL_FILE" ]; then
    echo "Error: File '$URL_FILE' not found." | tee -a "$LOG_FILE"
    exit 1
fi

mkdir -p "$DOWNLOAD_DIR"
echo "[$(date)] Reading URLs from $URL_FILE" | tee -a "$LOG_FILE"

while IFS= read -r URL; do
    if [ -z "$URL" ]; then
        continue
    fi

    echo "[$(date)] Downloading: $URL" | tee -a "$LOG_FILE"
    wget -q --show-progress -P "$DOWNLOAD_DIR" "$URL"

    if [ $? -eq 0 ]; then
        echo "[$(date)] Successfully downloaded: $URL" | tee -a "$LOG_FILE"
    else
        echo "[$(date)] Failed to download: $URL" | tee -a "$LOG_FILE"
    fi
done < "$URL_FILE"

echo ""
echo "All downloads completed. Files are in '$DOWNLOAD_DIR'."
echo "Do you want to move them to '$TARGET_DIR'? (y/n): "
read -r CONFIRMATION

if [[ "$CONFIRMATION" =~ ^[Yy]$ ]]; then
    echo "[$(date)] Moving files to $TARGET_DIR" | tee -a "$LOG_FILE"

    mkdir -p "$TARGET_DIR"
    mv "$DOWNLOAD_DIR"/* "$TARGET_DIR"/ 2>>"$LOG_FILE"

    if [ $? -eq 0 ]; then
        echo "[$(date)] Files moved successfully." | tee -a "$LOG_FILE"
    else
        echo "[$(date)] Error occurred while moving files." | tee -a "$LOG_FILE"
    fi
else
    echo "[$(date)] Operation aborted by user. Files remain in '$DOWNLOAD_DIR'." | tee -a "$LOG_FILE"
    exit 0
fi

echo "[$(date)] Script completed." | tee -a "$LOG_FILE"
