#!/usr/bin/env python3
import random
import time
import sys
import os
import subprocess
import signal
from datetime import datetime

# Directory and file configuration
LOG_DIR = os.path.join("hospital_data", "active_logs")
LOG_FILE = os.path.join(LOG_DIR, "temperature.log")
PID_FILE = os.path.join(os.path.expanduser("~"), ".temperature_recorder.pid")
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
        time.sleep(1)

def start():
    if os.path.exists(PID_FILE):
        try:
            with open(PID_FILE, "r") as f:
                pid = int(f.read().strip())
            # Check if process is still running
            try:
                os.kill(pid, 0)  # Signal 0 just checks if process exists
                print("Process is already running.")
                return
            except (OSError, ProcessLookupError):
                # Process doesn't exist, remove stale PID file
                os.remove(PID_FILE)
        except (ValueError, FileNotFoundError):
            pass
    
    # Start the process in background
    if sys.platform == "win32":
        # Windows: use CREATE_NEW_PROCESS_GROUP to allow termination
        process = subprocess.Popen(
            [sys.executable, __file__, "--daemon"],
            creationflags=subprocess.CREATE_NEW_PROCESS_GROUP,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )
    else:
        # Unix: fork and detach
        process = subprocess.Popen(
            [sys.executable, __file__, "--daemon"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            start_new_session=True
        )
    
    with open(PID_FILE, "w") as f:
        f.write(str(process.pid))
    print(f"Started. PID: {process.pid}")

def stop():
    if os.path.exists(PID_FILE):
        try:
            with open(PID_FILE, "r") as f:
                pid = int(f.read().strip())
            
            if sys.platform == "win32":
                # Windows: use taskkill or terminate process
                try:
                    subprocess.run(["taskkill", "/F", "/PID", str(pid)], 
                                 capture_output=True, check=False)
                except FileNotFoundError:
                    # Fallback to signal if taskkill not available
                    os.kill(pid, signal.SIGTERM)
            else:
                os.kill(pid, signal.SIGTERM)
            
            os.remove(PID_FILE)
            print("Stopped.")
        except (ProcessLookupError, ValueError, OSError) as e:
            print(f"Error stopping process: {e}")
            if os.path.exists(PID_FILE):
                os.remove(PID_FILE)
    else:
        print("No running process found.")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 temperature_recorder.py [start|stop]")
        sys.exit(1)
    
    if sys.argv[1] == "--daemon":
        # Run as daemon process
        log_data()
    elif sys.argv[1] == "start":
        start()
    elif sys.argv[1] == "stop":
        stop()
    else:
        print("Invalid command. Use 'start' or 'stop'.")
