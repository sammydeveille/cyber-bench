#!/bin/bash
# Unified scan + import script
# Usage: ./scripts/scan.sh <tool> <target> <engagement_id>

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/.."
source "$ROOT_DIR/.env"

TOOL=${1:-}
TARGET=${2:-}
ENGAGEMENT_ID=${3:-}

if [ -z "$TOOL" ] || [ -z "$TARGET" ] || [ -z "$ENGAGEMENT_ID" ]; then
  echo "Usage: ./scripts/scan.sh <tool> <target> <engagement_id>"
  echo ""
  echo "Tools: nuclei, nmap, nikto, zap"
  echo ""
  echo "Examples:"
  echo "  ./scripts/scan.sh nuclei http://juice-shop:3000 1"
  echo "  ./scripts/scan.sh nmap juice-shop 1"
  echo "  ./scripts/scan.sh nikto http://juice-shop:3000 1"
  echo "  ./scripts/scan.sh zap http://juice-shop:3000 1"
  exit 1
fi

# --- Scan functions ---

scan_nuclei() {
  local report_path="data/nuclei/report.jsonl"
  docker exec nuclei nuclei -u "$TARGET" -jsonl -o /root/nuclei-templates/report.jsonl
  import_to_dd "Nuclei Scan" "$report_path"
}

scan_nmap() {
  local report_path="data/nmap/report.xml"
  docker exec nmap nmap -sV -oX /data/report.xml "$TARGET"
  import_to_dd "Nmap Scan" "$report_path"
}

scan_nikto() {
  local report_path="data/nikto/report.csv"
  docker exec nikto /usr/bin/nikto.pl -h "$TARGET" -Format csv -output /tmp/report.csv
  import_to_dd "Nikto Scan" "$report_path"
}

scan_zap() {
  local report_path="data/zap/report.xml"

  echo "Starting ZAP spider on $TARGET..."
  docker exec owasp-zap curl -s "http://localhost:8090/JSON/spider/action/scan/?url=$TARGET"
  echo "Waiting for spider to complete..."
  sleep 10

  echo "Starting ZAP active scan on $TARGET..."
  docker exec owasp-zap curl -s "http://localhost:8090/JSON/ascan/action/scan/?url=$TARGET"
  echo "Waiting for active scan to complete..."
  sleep 30

  docker exec owasp-zap curl -s "http://localhost:8090/OTHER/core/other/xmlreport/" -o /zap/wrk/report.xml
  import_to_dd "ZAP Scan" "$report_path"
}

# --- Shared import logic ---

import_to_dd() {
  local scan_type="$1"
  local report_path="$2"

  if [ ! -f "$report_path" ]; then
    echo "Error: Scan report not generated at $report_path"
    exit 1
  fi

  echo "Importing $scan_type to DefectDojo..."
  curl -X POST "http://localhost:8080/api/v2/import-scan/" \
    -H "Authorization: Token ${DD_API_TOKEN}" \
    -F "scan_type=$scan_type" \
    -F "file=@$report_path" \
    -F "engagement=$ENGAGEMENT_ID" \
    -F "active=true" \
    -F "verified=false"

  echo ""
  echo "$scan_type imported to DefectDojo"
}

# --- Dispatch ---

case "$TOOL" in
  nuclei) scan_nuclei ;;
  nmap)   scan_nmap ;;
  nikto)  scan_nikto ;;
  zap)    scan_zap ;;
  *)
    echo "Unknown tool: $TOOL"
    echo "Available: nuclei, nmap, nikto, zap"
    exit 1
    ;;
esac
