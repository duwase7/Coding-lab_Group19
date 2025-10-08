#!/usr/bin/env bash
#
# analyze_logs.sh
# Interactive log analyzer: counts devices and records first/last timestamps.
#
# Usage:
#   ./analyze_logs.sh
#

set -euo pipefail

# Colors for terminal
CSI="\033["
RESET="${CSI}0m"
RED="${CSI}1;31m"
GREEN="${CSI}1;32m"
YELLOW="${CSI}1;33m"
CYAN="${CSI}1;36m"

# Directories and files
ROOT_DIR="hospital_data"
ACTIVE_DIR="${ROOT_DIR}/active_logs"
REPORTS_DIR="${ROOT_DIR}/reports"
REPORT_FILE="${REPORTS_DIR}/analysis_report.txt"

# Map menu choices to active log files
declare -A FILE_MAP=(
  [1]="heart_rate_log.log"
  [2]="temperature_log.log"
  [3]="water_usage_log.log"
)

print_header() {
  echo -e "${CYAN}Hospital Log Analysis Utility${RESET}"
  echo
}

ensure_dirs() {
  mkdir -p "${ACTIVE_DIR}"
  mkdir -p "${REPORTS_DIR}"
  # ensure report file exists
  if [[ ! -f "${REPORT_FILE}" ]]; then
    touch "${REPORT_FILE}"
  fi
}

prompt_menu() {
  echo "Select log file to analyze:"
  echo "1) Heart Rate (${FILE_MAP[1]})"
  echo "2) Temperature (${FILE_MAP[2]})"
  echo "3) Water Usage (${FILE_MAP[3]})"
  echo -n "Enter choice (1-3): "
  read -r choice
  echo
  echo "${choice}"
}

validate_choice() {
  local c="$1"
  if [[ ! "${c}" =~ ^[1-3]$ ]]; then
    echo -e "${RED}Invalid choice: ${c}. Enter 1, 2, or 3.${RESET}" >&2
    return 1
  fi
  return 0
}

analyze() {
  local choice="$1"
  local fname="${FILE_MAP[$choice]}"
  local fpath="${ACTIVE_DIR}/${fname}"

  if [[ ! -f "${fpath}" ]]; then
    echo -e "${RED}Log file not found: ${fpath}${RESET}" >&2
    return 2
  fi

  echo -e "${YELLOW}Analyzing ${fpath}...${RESET}"

  # Count occurrences per device
  local counts
  counts="$(awk '{ if (NF>=2) print $2 }' "${fpath}" | sort | uniq -c | sort -rn || true)"

  # List of unique devices
  local devices
  devices="$(awk '{ if (NF>=2) print $2 }' "${fpath}" | sort -u || true)"

  # Current timestamp for report
  local now
  now="$(date +'%F %T')"

  {
    echo "=============================================="
    echo "Analysis run: ${now}"
    echo "Log file: ${fpath}"
    echo

    echo "Device counts:"
    if [[ -z "${counts}" ]]; then
      echo "  (no device entries found)"
    else
      echo "${counts}" | awk '{printf "  %s: %s\n", $2, $1}'
    fi
    echo

    # First and last timestamps per device
    if [[ -z "${devices}" ]]; then
      echo "No devices to analyze for timestamps."
    else
      echo "Device first/last timestamps:"
      while IFS= read -r dev; do
        first_ts="$(awk -v d="${dev}" '$2==d {print $1; exit}' "${fpath}" || true)"
        last_ts="$(awk -v d="${dev}" '$2==d {ts=$1} END{ if (ts) print ts }' "${fpath}" || true)"

        if [[ -z "${first_ts}" ]]; then
          echo "  ${dev}: (no timestamps found)"
        else
          echo "  ${dev}: first=${first_ts}  last=${last_ts}"
        fi
      done <<<"${devices}"
    fi

    echo
    echo "Report appended to ${REPORT_FILE}"
    echo "=============================================="
    echo
  } >>"${REPORT_FILE}"

  echo -e "${GREEN}Analysis complete. Results appended to ${REPORT_FILE}.${RESET}"
  return 0
}

main() {
  print_header
  ensure_dirs

  choice="$(prompt_menu)"
  if ! validate_choice "${choice}"; then
    exit 1
  fi

  if ! analyze "${choice}"; then
    exit 2
  fi
}

main "$@"
