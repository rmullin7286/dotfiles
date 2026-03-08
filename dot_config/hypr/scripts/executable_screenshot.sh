#!/bin/bash

# Screenshot wrapper script for grim + slurp

SCREENSHOT_DIR="$HOME/Pictures/screenshots"
mkdir -p "$SCREENSHOT_DIR"

TIMESTAMP=$(date +'%Y%m%d_%H%M%S')
FILENAME="screenshot_${TIMESTAMP}.png"
FILEPATH="${SCREENSHOT_DIR}/${FILENAME}"

case $1 in
    region)
        # Region selection with slurp
        REGION=$(slurp 2>/dev/null)
        if [ -z "$REGION" ]; then
            # User cancelled selection
            exit 0
        fi
        grim -g "$REGION" "$FILEPATH"
        ;;
    fullscreen)
        # Full screen capture
        grim "$FILEPATH"
        ;;
    *)
        echo "Usage: $0 {region|fullscreen}"
        exit 1
        ;;
esac

# Check if screenshot was successful
if [ -f "$FILEPATH" ]; then
    # Copy to clipboard
    wl-copy < "$FILEPATH"

    # Send notification
    dunstify -a "Screenshot" -u low -i "$FILEPATH" "Screenshot saved" "$FILENAME"
else
    dunstify -a "Screenshot" -u critical "Screenshot failed" "Could not save screenshot"
    exit 1
fi
