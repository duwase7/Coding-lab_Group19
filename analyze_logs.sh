#!/bin/bash

ACTIVE_LOGS_DIR="hospital_data/active_logs"
REPORTS_DIR="hospital_data/reports"
REPORT_FILE="$REPORTS_DIR/analysis_report.txt"

# Function to display menu and get user choice
display_menu() {
    echo "Select log file to analyze:"
    echo "1) Heart Rate (heart_rate_log.log)"
    echo "2) Temperature (temperature_log.log)"
    echo "3) Water Usage (water_usage_log.log)"
    echo ""
    read -p "Enter choice (1-3): " choice
}

# Function to validate user input
validate_choice() {
    case $choice in
        1|2|3)
            return 0
            ;;
        *)
            echo "Error: Invalid choice. Please enter 1, 2, or 3."
            return 1
            ;;
    esac
}

# Function to check if log file exists
check_log_file() {
    local log_file="$1"
    if [ ! -f "$log_file" ]; then
        echo "Error: Log file '$log_file' does not exist."
        echo "Make sure the monitoring services are running."
        exit 1
    fi
}

# Function to ensure reports directory exists
ensure_reports_dir() {
    if [ ! -d "$REPORTS_DIR" ]; then
        mkdir -p "$REPORTS_DIR"
        if [ $? -ne 0 ]; then
            echo "Error: Failed to create reports directory '$REPORTS_DIR'"
            exit 1
        fi
    fi
}

# Function to analyze heart rate logs
analyze_heart_rate() {
    local log_file="$ACTIVE_LOGS_DIR/heart_rate_log.log"

    check_log_file "$log_file"

    echo "Analyzing Heart Rate logs..."

    # Generate timestamp for report entry
    local report_timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    # Count occurrences of each device
    local device_a_count=$(grep -c "HeartRate_Monitor_A" "$log_file")
    local device_b_count=$(grep -c "HeartRate_Monitor_B" "$log_file")

    # Get first and last timestamps for each device
    local device_a_first=$(grep "HeartRate_Monitor_A" "$log_file" | head -n 1 | awk '{print $1, $2}')
    local device_a_last=$(grep "HeartRate_Monitor_A" "$log_file" | tail -n 1 | awk '{print $1, $2}')
    local device_b_first=$(grep "HeartRate_Monitor_B" "$log_file" | head -n 1 | awk '{print $1, $2}')
    local device_b_last=$(grep "HeartRate_Monitor_B" "$log_file" | tail -n 1 | awk '{print $1, $2}')

    # Calculate total entries
    local total_entries=$(wc -l < "$log_file")

    # Write analysis to report file
    echo "" >> "$REPORT_FILE"
    echo "HOSPITAL DATA ANALYSIS REPORT" >> "$REPORT_FILE"
    echo "Generated: $report_timestamp" >> "$REPORT_FILE"
    echo "============================================" >> "$REPORT_FILE"
    echo "LOG FILE: Heart Rate Monitoring (heart_rate_log.log)" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "WHAT IS BEING RECORDED:" >> "$REPORT_FILE"
    echo "Heart rate monitors track patients' pulse rates in beats per minute (BPM)." >> "$REPORT_FILE"
    echo "Normal adult heart rate: 60-100 BPM at rest." >> "$REPORT_FILE"
    echo "Critical values: <60 BPM (bradycardia) or >100 BPM (tachycardia)." >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "DATA SUMMARY:" >> "$REPORT_FILE"
    echo "Total log entries: $total_entries" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "Device Statistics:" >> "$REPORT_FILE"
    echo "------------------" >> "$REPORT_FILE"
    echo "HeartRate_Monitor_A (Patient Room A):" >> "$REPORT_FILE"
    echo "  - Total readings: $device_a_count" >> "$REPORT_FILE"
    echo "  - First reading: $device_a_first" >> "$REPORT_FILE"
    echo "  - Last reading:  $device_a_last" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "HeartRate_Monitor_B (Patient Room B):" >> "$REPORT_FILE"
    echo "  - Total readings: $device_b_count" >> "$REPORT_FILE"
    echo "  - First reading: $device_b_first" >> "$REPORT_FILE"
    echo "  - Last reading:  $device_b_last" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "Analysis completed successfully." >> "$REPORT_FILE"
    echo "============================================" >> "$REPORT_FILE"

    echo "Analysis complete! Results appended to analysis_report.txt"
}

# Function to analyze temperature logs
analyze_temperature() {
    local log_file="$ACTIVE_LOGS_DIR/temperature_log.log"

    check_log_file "$log_file"

    echo "Analyzing Temperature logs..."

    # Generate timestamp for report entry
    local report_timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    # Count occurrences of each device
    local device_a_count=$(grep -c "Temp_Recorder_A" "$log_file")
    local device_b_count=$(grep -c "Temp_Recorder_B" "$log_file")

    # Get first and last timestamps for each device
    local device_a_first=$(grep "Temp_Recorder_A" "$log_file" | head -n 1 | awk '{print $1, $2}')
    local device_a_last=$(grep "Temp_Recorder_A" "$log_file" | tail -n 1 | awk '{print $1, $2}')
    local device_b_first=$(grep "Temp_Recorder_B" "$log_file" | head -n 1 | awk '{print $1, $2}')
    local device_b_last=$(grep "Temp_Recorder_B" "$log_file" | tail -n 1 | awk '{print $1, $2}') 

# Calculate total entries
    local total_entries=$(wc -l < "$log_file")
    
    # Write analysis to report file
    echo "" >> "$REPORT_FILE"
    echo "HOSPITAL DATA ANALYSIS REPORT" >> "$REPORT_FILE"
    echo "Generated: $report_timestamp" >> "$REPORT_FILE"
    echo "============================================" >> "$REPORT_FILE"
    echo "LOG FILE: Temperature Monitoring (temperature_log.log)" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "WHAT IS BEING RECORDED:" >> "$REPORT_FILE"
    echo "Temperature recorders monitor patients' body temperature in Celsius (°C)." >> "$REPORT_FILE"
    echo "Normal body temperature: 36.1-37.2°C (97-99°F)." >> "$REPORT_FILE"
    echo "Critical values: <36°C (hypothermia) or >38°C (fever)." >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "DATA SUMMARY:" >> "$REPORT_FILE"
    echo "Total log entries: $total_entries" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "Device Statistics:" >> "$REPORT_FILE"
    echo "------------------" >> "$REPORT_FILE"
    echo "Temp_Recorder_A (Patient Room A):" >> "$REPORT_FILE"
    echo "  - Total readings: $device_a_count" >> "$REPORT_FILE"
    echo "  - First reading: $device_a_first" >> "$REPORT_FILE"
    echo "  - Last reading:  $device_a_last" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "Temp_Recorder_B (Patient Room B):" >> "$REPORT_FILE"
    echo "  - Total readings: $device_b_count" >> "$REPORT_FILE"
    echo "  - First reading: $device_b_first" >> "$REPORT_FILE"
    echo "  - Last reading:  $device_b_last" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "Analysis completed successfully." >> "$REPORT_FILE"
    echo "============================================" >> "$REPORT_FILE"
    
    echo "Analysis complete! Results appended to analysis_report.txt"
}

# Function to analyze water usage logs
analyze_water_usage() {
    local log_file="$ACTIVE_LOGS_DIR/water_usage_log.log"
    
    check_log_file "$log_file"
    
    echo "Analyzing Water Usage logs..."
    
    # Generate timestamp for report entry"
    local report_timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    
    # Count occurrences of the device
    local device_count=$(grep -c "Water_Consumption_Meter" "$log_file")
    
    # Get first and last timestamps for the device
    local device_first=$(grep "Water_Consumption_Meter" "$log_file" | head -n 1 | awk '{print $1, $2}')
    local device_last=$(grep "Water_Consumption_Meter" "$log_file" | tail -n 1 | awk '{print $1, $2}')
    
    # Calculate total entries
    local total_entries=$(wc -l < "$log_file")
    
    # Calculate total water usage
    local total_usage=$(awk '{sum += $4} END {print sum}' "$log_file")
    
    # Write analysis to report file
    echo "" >> "$REPORT_FILE"
    echo "HOSPITAL DATA ANALYSIS REPORT" >> "$REPORT_FILE"
    echo "Generated: $report_timestamp" >> "$REPORT_FILE"
    echo "============================================" >> "$REPORT_FILE"
    echo "LOG FILE: Water Usage Monitoring (water_usage_log.log)" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "WHAT IS BEING RECORDED:" >> "$REPORT_FILE"
    echo "Water consumption meters track hospital water usage in gallons per hour." >> "$REPORT_FILE"
    echo "Typical hospital usage: 50-100 gallons per patient per day." >> "$REPORT_FILE"
    echo "High usage alerts: >150 gallons per patient per day (possible leak)." >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "DATA SUMMARY:" >> "$REPORT_FILE"
    echo "Total log entries: $total_entries" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "Device Statistics:" >> "$REPORT_FILE"
    echo "------------------" >> "$REPORT_FILE"
    echo "Water_Consumption_Meter (Hospital Main Supply):" >> "$REPORT_FILE"
    echo "  - Total readings: $device_count" >> "$REPORT_FILE"
    echo "  - First reading: $device_first" >> "$REPORT_FILE"
    echo "  - Last reading:  $device_last" >> "$REPORT_FILE"
    echo "  - Total consumption: $total_usage gallons" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "Analysis completed successfully." >> "$REPORT_FILE"
    echo "============================================" >> "$REPORT_FILE"
    
    echo "Analysis complete! Results appended to analysis_report.txt"
}


# Main execution
main() {
    echo "Hospital Data Analysis System"
    echo "============================"
    echo ""
    
    # Check if active logs directory exists
    if [ ! -d "$ACTIVE_LOGS_DIR" ]; then
        echo "Error: Active logs directory '$ACTIVE_LOGS_DIR' does not exist."
        echo "Please run the monitoring services first."
        exit 1
    fi
    
    # Ensure reports directory exists
    ensure_reports_dir
    
    # Display menu and get user choice
    while true; do
        display_menu
        
        if validate_choice; then
            break
        fi
    done
    
    # Analyze based on user choice
    case $choice in
        1)
            analyze_heart_rate
            ;;
        2)
            analyze_temperature
            ;;
        3)
            analyze_water_usage
            ;;
    esac
    
    echo ""
    echo "Analysis operation completed successfully!"
    echo "Report saved to: $REPORT_FILE"
}

# Run main function
main
