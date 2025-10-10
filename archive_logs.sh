#!/bin/bash

# Directories
ACTIVE_DIR="hospital_data/active_logs"
ARCHIVE_DIR="hospital_data/archived_logs"

mkdir -p "$ARCHIVE_DIR"

echo "Select log to archive:"
echo "1) Heart Rate"
echo "2) Temperature"
echo "3) Water Usage"
read -p "Enter choice (1-3): " choice

case $choice in
    1) LOG_FILE="heart_rate.log" ;;
    2) LOG_FILE="temperature.log" ;;
    3) LOG_FILE="water_usage.log" ;;
    *) echo "Invalid choice. Exiting."; exit 1 ;;
esac

ACTIVE_PATH="$ACTIVE_DIR/$LOG_FILE"

if [ ! -f "$ACTIVE_PATH" ]; then
    echo "Error: $LOG_FILE not found in $ACTIVE_DIR"
    exit 1
fi

TIMESTAMP=$(date +"%Y-%m-%d_%H:%M:%S")
ARCHIVE_NAME="${LOG_FILE%.*}_$TIMESTAMP.log"
ARCHIVE_PATH="$ARCHIVE_DIR/$ARCHIVE_NAME"

mv "$ACTIVE_PATH" "$ARCHIVE_PATH" || { echo "Error: Failed to archive $LOG_FILE"; exit 1; }
touch "$ACTIVE_PATH" || { echo "Error: Failed to create new $LOG_FILE"; exit 1; }

echo "Successfully archived to $ARCHIVE_PATH"

