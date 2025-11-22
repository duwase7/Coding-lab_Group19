# Hospital Data Monitoring & Archival System

## Project Overview

An automated log management system that:

- Collects real-time patient health metrics (heart rate, temperature) and resource usage (water) using Python simulators
- Provides an interactive shell script to archive logs with timestamps
- Generates analytical reports for device statistics and temporal patterns

---

## How It Works

### Monitoring Scripts

The system consists of three Python monitoring scripts that run as background daemon processes:

- **heart_rate_monitor.py**: Simulates two devices (HeartRate_Monitor_A, HeartRate_Monitor_B) generating heart rate values between 60-100 BPM
- **temperature_recorder.py**: Simulates two devices (Temp_Recorder_A, Temp_Recorder_B) generating temperature values between 36.0-39.5°C
- **water_consumption.py**: Simulates one device (Water_Consumption_Meter) generating water usage values between 1-10 units

Each script:
1. Creates log files in `hospital_data/active_logs/` if they don't exist
2. Continuously writes data entries every second with timestamp, device name, and measurement value
3. Stores process ID (PID) in the user's home directory for process management

**Log Format**: Each line contains:
```
YYYY-MM-DD HH:MM:SS DeviceName Value
```

Example:
```
2024-01-15 14:30:25 HeartRate_Monitor_A 75
2024-01-15 14:30:25 HeartRate_Monitor_B 82
```

### Archival Script (archive_logs.sh)

The archival script provides an interactive menu to archive log files:

1. Prompts user to select which log type to archive (Heart Rate, Temperature, or Water Usage)
2. Moves the selected active log file to its designated archive folder in `hospital_data/archived_logs/`
3. Renames the archived file with a timestamp: `logname_YYYY-MM-DD_HH:MM:SS.log`
4. Creates a new empty log file for continued monitoring

The script includes error handling for invalid user input, missing log files, and archive directory issues.

### Analysis Script (analyze_logs.sh)

The analysis script generates reports from log files:

1. Presents an interactive menu to select which log file to analyze
2. Counts occurrences of each device in the selected log file
3. Extracts the first and last timestamps from the log
4. Appends the analysis results to `hospital_data/reports/analysis_report.txt`

The report includes device statistics and temporal patterns from the log data.

---

## Usage

### Starting Monitoring Services

```bash
python3 heart_rate_monitor.py start
python3 temperature_recorder.py start
python3 water_consumption.py start
```

### Stopping Monitoring Services

```bash
python3 heart_rate_monitor.py stop
python3 temperature_recorder.py stop
python3 water_consumption.py stop
```

### Archiving Logs

```bash
bash archive_logs.sh
```

Follow the interactive prompts to select which log to archive.

### Analyzing Logs

```bash
bash analyze_logs.sh
```

Follow the interactive prompts to select which log to analyze. Results are appended to `hospital_data/reports/analysis_report.txt`.

