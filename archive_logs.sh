#!/bin/bash

# Directories
LOG_DIR="hospital_data/active_logs"
ARCHIVE_DIR_HR="hospital_data/heart_data_archive"
ARCHIVE_DIR_TEMP="hospital_data/temp_data_archive"
ARCHIVE_DIR_WATER="hospital_data/water_data_archive"

# Ensure archive directories exist
mkdir -p "$ARCHIVE_DIR_HR" "$ARCHIVE_DIR_TEMP" "$ARCHIVE_DIR_WATER"

# Menu
echo "Select log to archive:"
echo "1) Heart Rate"
echo "2) Temperature"
echo "3) Water Usage"
read -p "Enter choice (1-3): " choice

# Function to archive log
archive_log() {
    local logfile="$1"
    local archive_dir="$2"
    if [[ ! -f "$logfile" ]]; then
        echo "Error: Log file $logfile does not exist!"
        exit 1
    fi

    timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
    basename=$(basename "$logfile" .log)
    archived_file="$archive_dir/${basename}_${timestamp}.log"

    mv "$logfile" "$archived_file"
    touch "$logfile"

    echo "Successfully archived to $archived_file"
}

# Handle choice
case $choice in
    1)
        archive_log "$LOG_DIR/heart_rate_log.log" "$ARCHIVE_DIR_HR"
        ;;
    2)
        archive_log "$LOG_DIR/temperature_log.log" "$ARCHIVE_DIR_TEMP"
        ;;
    3)
        archive_log "$LOG_DIR/water_usage_log.log" "$ARCHIVE_DIR_WATER"
        ;;
    *)
        echo "Invalid choice. Enter 1, 2, or 3."
        exit 1
        ;;
esac`
