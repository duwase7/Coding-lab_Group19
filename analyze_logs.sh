#!/bin/bash

# Directories
ACTIVE_DIR="hospital_data/active_logs"
REPORT_DIR="hospital_data/reports"
mkdir -p "$REPORT_DIR"
REPORT_FILE="$REPORT_DIR/analysis_report.txt"

# Display menu
echo "Select log file to analyze:"
echo "1) Heart Rate (heart_rate.log)"
echo "2) Temperature (temperature.log)"
echo "3) Water Usage (water_usage.log)"
read -p "Enter choice (1-3): " choice

# Validate input
if [[ ! "$choice" =~ ^[1-3]$ ]]; then
    echo "Invalid choice. Exiting."
    exit 1
fi

# Map choice to log file
case $choice in
    1) LOG_FILE="heart_rate.log" ;;
    2) LOG_FILE="temperature.log" ;;
    3) LOG_FILE="water_usage.log" ;;
esac

LOG_PATH="$ACTIVE_DIR/$LOG_FILE"

# Check log file existence
if [ ! -f "$LOG_PATH" ]; then
    echo "Error: $LOG_FILE not found."
    exit 1
fi

# Analysis
echo "Analyzing $LOG_FILE..."

# Count occurrences per device
echo "=== Analysis Report: $(date) ===" >> "$REPORT_FILE"
echo "Log file: $LOG_FILE" >> "$REPORT_FILE"

awk '{print $2}' "$LOG_PATH" | sort | uniq -c >> "$REPORT_FILE"

# Bonus: first and last timestamp
FIRST_TS=$(head -n1 "$LOG_PATH" | awk '{print $1}')
LAST_TS=$(tail -n1 "$LOG_PATH" | awk '{print $1}')
echo "First entry: $FIRST_TS" >> "$REPORT_FILE"
echo "Last entry: $LAST_TS" >> "$REPORT_FILE"
echo "-----------------------------------" >> "$REPORT_FILE"

echo "Analysis completed. Results appended to $REPORT_FILE"

