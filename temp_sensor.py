#!/usr/bin/env python3
import random
import time
import sys
import os
from datetime import datetime

LOG_DIR = "hospital_data/active_logs"
LOG_FILE = os.path.join(LOG_DIR, "temperature_log.log")
DEVICES = ["Temp_Recorder_A", "Temp_Recorder_B"]

def ensure_log_dir():
    if not os.path.exists(LOG_DIR):
        os.makedirs(LOG_DIR)

def log_data():
    ensure_log_dir()
    while True:
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        for device in DEVICES:
            temp = round(random.uniform(36.0, 39.5), 1)
            with open(LOG_FILE, "a") as f:
                f.write(f"{timestamp} {device} {temp}\n")
                f.flush()  # flush ensures tail sees it
        time.sleep(1)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 temperature_recorder.py start")
        sys.exit(1)

    if sys.argv[1] == "start":
        log_data()  
