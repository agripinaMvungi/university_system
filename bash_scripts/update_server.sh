#!/bin/bash

# Log file
LOG_FILE="/var/log/update.log"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"

echo "==========================" | sudo tee -a "$LOG_FILE"
echo "Server Update - $(date)" | sudo tee -a "$LOG_FILE"
echo "==========================" | sudo tee -a "$LOG_FILE"

echo -e "${YELLOW}🔄 Starting server update process...${RESET}"

# Update system packages
echo -e "${YELLOW}📦 Updating system packages...${RESET}"
sudo apt update && sudo apt upgrade -y | sudo tee -a "$LOG_FILE"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ System packages successfully updated.${RESET}"
else
    echo -e "${RED}❌ Failed to update system packages. Check $LOG_FILE for details.${RESET}"
    exit 1
fi

# Navigate to Django project directory
echo -e "${YELLOW}📂 Navigating to project directory...${RESET}"
cd /home/ubuntu/university_system || {
    echo -e "${RED}❌ Project directory not found. Exiting.${RESET}"
    echo "Directory not found!" | sudo tee -a "$LOG_FILE"
    exit 1
}

# Git pull (if you have git setup for your project)
echo -e "${YELLOW}🔄 Pulling latest code...${RESET}"
sudo -Hu ubuntu git pull 2>&1 | sudo tee -a "$LOG_FILE"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Code successfully updated.${RESET}"
else
    echo -e "${RED}❌ Failed to pull code. Check $LOG_FILE for details.${RESET}"
    exit 1
fi

# (Optional) Restart Django server (Gunicorn or manage.py runserver)
echo -e "${YELLOW}🔄 Restarting application server...${RESET}"
sudo systemctl restart gunicorn | sudo tee -a "$LOG_FILE"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Application server restarted successfully.${RESET}"
else
    echo -e "${RED}❌ Failed to restart application server. Check $LOG_FILE for details.${RESET}"
    exit 1
fi

# Final message
echo -e "${GREEN}🎉 Server update process completed at $(date)!${RESET}"
echo "Update completed at $(date)" | sudo tee -a "$LOG_FILE"
echo "==========================" | sudo tee -a "$LOG_FILE"
echo "" | sudo tee -a "$LOG_FILE"
