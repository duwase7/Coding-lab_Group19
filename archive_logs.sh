#!/bin/bash

#ARCHIVAL SCRIPT FOR HOSPITAL DATA

# create path variables
LOG_PATH="hospital_data/active_logs/"
HEART_ARCHIVE="hospital_data/archived_logs/heart_data_archive/"
TEMP_ARCHIVE="hospital_data/archived_logs/temperature_data_archive/"
WATER_ARCHIVE="hospital_data/archived_logs/water_usage_data_archive/"

#ensuring that the directories exist and initializing a menu option for the user input

if ! mkdir -p "$HEART_ARCHIVE" "$TEMP_ARCHIVE" "$WATER_ARCHIVE"; then
	echo "Error: Failed to create archive directories"
	exit 1
fi

echo "Select log to archive"
echo "1) Heart Rate"
echo "2) Temperature"
echo "3) Water Usage"
read -p "Enter choice (1-3): " choice

#initiate a condition to update the archival details

case $choice in
	1)
		LOG_FILE="${LOG_PATH}heart_rate_log.log"
		ARCHIVE_DIR="$HEART_ARCHIVE"
		BASE_NAME="heart_rate"
		;;

	2)
		LOG_FILE="${LOG_PATH}temperature_log.log"
		ARCHIVE_DIR="$TEMP_ARCHIVE"
		BASE_NAME="temperature"
		;;

	3)
		LOG_FILE="${LOG_PATH}water_usage_log.log"
                ARCHIVE_DIR="$WATER_ARCHIVE"
                BASE_NAME="water_usage"
                ;;
	*)
		echo "Error: Invalid choice, please enter 1,2, or 3"
		exit 1
		;;
esac
#check if the files exist

if [ ! -f "$LOG_FILE" ]; then
	echo "Error! File '$LOG_FILE' does not exist"
	exit 1 
fi

#update the naming and create timestamp variables

TIMESTAMP=$(date +%Y-%m-%d_%H:%M:%S)
ARCHIVAL_FILENAME="${BASE_NAME}_${TIMESTAMP}.log"
ARCHIVAL_PATH="${ARCHIVE_DIR}${ARCHIVAL_FILENAME}"

#move to the designated archive folder and create an new empty log file

echo "Archiving $LOG_FILE..."

if mv "$LOG_FILE" "$ARCHIVAL_PATH"; then
	if touch "$LOG_FILE"; then
		echo "Successfully archived to $ARCHIVAL_PATH and created a new empty log file $LOG_FILE"
	else
		echo "Error: Failed to create new empty log file $LOG_FILE"
		exit 1
	fi
else
	echo "Error: Failed to move the $LOG_FILE to $ARCHIVAL_PATH."
	exit 1
fi

echo "Mission Successful!!"
