#!/bin/bash

# Directories
ACTIVE_DIR="hospital_data/active_logs"
ARCHIVE_DIR_HEART="hospital_data/archives/heart_data_archive"
ARCHIVE_DIR_TEMP="hospital_data/archives/temp_data_archive"
ARCHIVE_DIR_WATER="hospital_data/archives/water_data_archive"

echo "Select log to archive:"
echo "1) Heart Rate"
echo "2) Temperature"
echo "3) Water Usage"
read -p "Enter choice (1-3): " choice

timestamp=$(date +"%Y-%m-%d_%H:%M:%S")

# Determine log file and archive directory
case $choice in
  1)
    log_file="$ACTIVE_DIR/heart_rate.log"
    archive_dir="$ARCHIVE_DIR_HEART"
    ;;
  2)
    log_file="$ACTIVE_DIR/temperature.log"
    archive_dir="$ARCHIVE_DIR_TEMP"
    ;;
  3)
    log_file="$ACTIVE_DIR/water_usage.log"
    archive_dir="$ARCHIVE_DIR_WATER"
    ;;
  *)
    echo "Invalid choice. Please enter 1, 2, or 3."
    exit 1
    ;;
esac

if [ ! -f "$log_file" ]; then
    echo "Error: Log file $log_file does not exist!"
    exit 1
fi

mkdir -p "$archive_dir"

mv "$log_file" "$archive_dir/$(basename ${log_file%.*})_$timestamp.log"

touch "$log_file"

echo "Successfully archived to $archive_dir/$(basename ${log_file%.*})_$timestamp.log"

