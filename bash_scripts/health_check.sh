#!/bin/bash

# Log file
LOG_FILE="/var/log/server_health.log"
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

echo "==========================" >> "$LOG_FILE"
echo "Server Health Check - $(date)" >> "$LOG_FILE"
echo "==========================" >> "$LOG_FILE"

# CPU Load
echo -e "\n🔋 Checking CPU Load..." >> "$LOG_FILE"
uptime >> "$LOG_FILE"
echo -e "${GREEN}✅ CPU Load check completed.${RESET}"

# Memory usage
echo -e "\n💻 Checking Memory Usage..." >> "$LOG_FILE"
free -h >> "$LOG_FILE"
echo -e "${GREEN}✅ Memory Usage check completed.${RESET}"

# Disk usage
echo -e "\n💾 Checking Disk Usage..." >> "$LOG_FILE"
df -h >> "$LOG_FILE"
echo -e "${GREEN}✅ Disk Usage check completed.${RESET}"

# Check if Gunicorn or Django server is running
echo -e "\n🌐 Checking Application Server Status..." >> "$LOG_FILE"
if pgrep gunicorn > /dev/null; then
  echo "Gunicorn: RUNNING" >> "$LOG_FILE"
  echo -e "${GREEN}✅ Application server is running.${RESET}"
else
  echo "WARNING: Gunicorn not running" >> "$LOG_FILE"
  echo -e "${RED}❌ Application server is not running!${RESET}"
fi

# API Endpoints Health Check
echo -e "\n🔌 Checking API Endpoints Status..." >> "$LOG_FILE"

# Students endpoint
students_response=$(curl -s http://3.85.238.66:8000/studentapi/students/)
students_status=$(echo "$students_response" | grep -o '"success":true')

if [ "$students_status" == '"success":true' ]; then
  echo "GET /students: SUCCESS" >> "$LOG_FILE"
  echo -e "${GREEN}✅ GET /students is working fine.${RESET}"
else
  echo "WARNING: GET /students failed" >> "$LOG_FILE"
  echo -e "${RED}❌ GET /students failed!${RESET}"
fi

# Subjects endpoint
subjects_response=$(curl -s http://3.85.238.66:8000/studentapi/subjects/)
subjects_status=$(echo "$subjects_response" | grep -o '"success":true')

if [ "$subjects_status" == '"success":true' ]; then
  echo "GET /subjects: SUCCESS" >> "$LOG_FILE"
  echo -e "${GREEN}✅ GET /subjects is working fine.${RESET}"
else
  echo "WARNING: GET /subjects failed" >> "$LOG_FILE"
  echo -e "${RED}❌ GET /subjects failed!${RESET}"
fi

echo -e "\n📝 Health Check completed. See $LOG_FILE for detailed report.\n" >> "$LOG_FILE"
