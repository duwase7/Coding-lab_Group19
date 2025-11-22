#!/bin/bash

# Directories
ACTIVE_DIR="hospital_data/active_logs"
ARCHIVE_DIR_HEART="hospital_data/archived_logs/heart_data_archive"
ARCHIVE_DIR_TEMP="hospital_data/archived_logs/temperature_data_archive"
ARCHIVE_DIR_WATER="hospital_data/archived_logs/water_usage_data_archive"

# Display menu
echo "Select log to archive:"
echo "1) Heart Rate"
echo "2) Temperature"
echo "3) Water Usage"
read -p "Enter choice (1-3): " choice

# Validate input
if [[ ! "$choice" =~ ^[1-3]$ ]]; then
    echo "Invalid choice. Please enter 1, 2, or 3."
    exit 1
fi

# Generate timestamp
timestamp=$(date +"%Y-%m-%d_%H:%M:%S")

# Determine log file and archive directory
case $choice in
  1)
    log_file="$ACTIVE_DIR/heart_rate.log"
    archive_dir="$ARCHIVE_DIR_HEART"
    log_name="heart_rate"
    display_name="heart_rate.log"
    ;;
  2)
    log_file="$ACTIVE_DIR/temperature.log"
    archive_dir="$ARCHIVE_DIR_TEMP"
    log_name="temperature"
    display_name="temperature.log"
    ;;
  3)
    log_file="$ACTIVE_DIR/water_usage.log"
    archive_dir="$ARCHIVE_DIR_WATER"
    log_name="water_usage"
    display_name="water_usage.log"
    ;;
esac

# Error handling: Check if log file exists
if [ ! -f "$log_file" ]; then
    echo "Error: Log file $display_name does not exist!"
    exit 1
fi

# Create archive directory if it doesn't exist
mkdir -p "$archive_dir"
if [ $? -ne 0 ]; then
    echo "Error: Failed to create archive directory $archive_dir"
    exit 1
fi

# Archive the log file with timestamp
archived_name="${log_name}_${timestamp}.log"
mv "$log_file" "$archive_dir/$archived_name"

# Create new empty log file for continued monitoring
touch "$log_file"

echo "Archiving $display_name..."
echo "Successfully archived to $archive_dir/$archived_name"

