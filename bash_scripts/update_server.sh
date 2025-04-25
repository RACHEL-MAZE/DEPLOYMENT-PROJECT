#!/bin/bash

# Log file
LOG_FILE="/var/log/update.log"
echo "==========================" | sudo tee -a "$LOG_FILE"
echo "Server Update - $(date)" | sudo tee -a "$LOG_FILE"
echo "==========================" | sudo tee -a "$LOG_FILE"

# Colors for messages
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"

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

# Pull latest code from CS-421-Assignment repo
echo -e "${YELLOW}📂 Navigating to project directory...${RESET}"
cd /home/ubuntu/backends/CS-421-Assignment || {
    echo -e "${RED}❌ Project directory not found. Exiting.${RESET}"
    echo "Directory not found!" | sudo tee -a "$LOG_FILE"
    exit 1
}

# Ensure proper permissions for git operations
echo -e "${YELLOW}🔑 Setting up Git environment...${RESET}"
sudo chown -R ubuntu:ubuntu /home/ubuntu/backends/CS-421-Assignment/.git
sudo -Hu ubuntu git config --global --add safe.directory /home/ubuntu/backends/CS-421-Assignment

# Pull the latest code from GitHub using SSH
echo -e "${YELLOW}🔄 Pulling latest code from GitHub...${RESET}"
sudo -Hu ubuntu git pull 2>&1 | sudo tee -a "$LOG_FILE"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Code successfully updated from repository.${RESET}"
else
    echo -e "${RED}❌ Failed to pull code. Check $LOG_FILE for details.${RESET}"
    echo "Debug info:" | sudo tee -a "$LOG_FILE"
    sudo -Hu ubuntu ssh -T git@github.com 2>&1 | sudo tee -a "$LOG_FILE"
    exit 1
fi

# Restart web server
echo -e "${YELLOW}🔄 Restarting web server...${RESET}"
sudo systemctl restart nginx | sudo tee -a "$LOG_FILE"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Web server restarted successfully.${RESET}"
else
    echo -e "${RED}❌ Failed to restart web server. Check $LOG_FILE for details.${RESET}"
    exit 1
fi

# Final message
echo -e "${GREEN}🎉 Server update process completed at $(date)!${RESET}"
echo "Update completed at $(date)" | sudo tee -a "$LOG_FILE"
echo "==========================" | sudo tee -a "$LOG_FILE"
echo "" | sudo tee -a "$LOG_FILE"
