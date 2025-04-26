#!/bin/bash

# Colors
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

# Configuration
API_BASE="http://3.85.238.66:8000"
STUDENTS_ENDPOINT="$API_BASE/studentapi/students/"
SUBJECTS_ENDPOINT="$API_BASE/studentapi/subjects/"
LOG_FILE="/var/log/server_health.log"

# Log header
echo -e "\n\n==========================" | sudo tee -a $LOG_FILE
echo "Health Check - $(date)" | sudo tee -a $LOG_FILE
echo "==========================" | sudo tee -a $LOG_FILE

# Basic checks
echo -e "\n🔧 System Status" | sudo tee -a $LOG_FILE
uptime | sudo tee -a $LOG_FILE
free -h | sudo tee -a $LOG_FILE
df -h | sudo tee -a $LOG_FILE

# Service checks
echo -e "\n🛎️ Service Status" | sudo tee -a $LOG_FILE
systemctl status nginx --no-pager | head -n 5 | sudo tee -a $LOG_FILE
pgrep -f "gunicorn|runserver" | sudo tee -a $LOG_FILE

# API Health Checks
echo -e "\n🔌 API Endpoint Checks" | sudo tee -a $LOG_FILE

check_endpoint() {
    local url=$1
    local name=$2
    
    echo -e "\nTesting $name ($url)" | sudo tee -a $LOG_FILE
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    full_response=$(curl -s "$url")
    
    echo "HTTP Status: $response" | sudo tee -a $LOG_FILE
    echo "Response snippet: ${full_response:0:100}..." | sudo tee -a $LOG_FILE
    
    if [[ "$response" == "200" ]]; then
        echo -e "${GREEN}✅ $name is working${RESET}" | sudo tee -a $LOG_FILE
        return 0
    else
        echo -e "${RED}❌ $name failed (Status: $response)${RESET}" | sudo tee -a $LOG_FILE
        return 1
    fi
}

check_endpoint "$STUDENTS_ENDPOINT" "Students Endpoint"
check_endpoint "$SUBJECTS_ENDPOINT" "Subjects Endpoint"

echo -e "\nHealth check completed at $(date)" | sudo tee -a $LOG_FILE
