#!/bin/bash

# Log file
LOG_FILE="/var/log/server_health.log"
echo "==========================" >> $LOG_FILE
echo "Server Health Check - $(date)" >> $LOG_FILE
echo "==========================" >> $LOG_FILE

# CPU Load
echo -e "\n🔋 Checking CPU Load..." >> $LOG_FILE
uptime >> $LOG_FILE
echo -e "${GREEN}✅ CPU Load check completed.${RESET}"

# Memory usage
echo -e "\n💻 Checking Memory Usage..." >> $LOG_FILE
free -h >> $LOG_FILE
echo -e "${GREEN}✅ Memory Usage check completed.${RESET}"

# Disk usage
echo -e "\n💾 Checking Disk Usage..." >> $LOG_FILE
df -h >> $LOG_FILE
echo -e "${GREEN}✅ Disk Usage check completed.${RESET}"

# Check Nginx Web Server status
echo -e "\n🌐 Checking Web Server Status..." >> $LOG_FILE
if systemctl is-active --quiet nginx; then
  echo "Nginx Web Server: RUNNING" >> $LOG_FILE
  echo -e "${GREEN}✅ Web server is running.${RESET}"
else
  echo "WARNING: Nginx Web Server: NOT RUNNING" >> $LOG_FILE
  echo -e "${RED}❌ Web server is not running!${RESET}"
fi

# API Endpoints Health Check
echo -e "\n🔌 Checking API Endpoints Status..." >> $LOG_FILE

# Students endpoint
students_response=$(curl -s http://13.60.250.126:4300/api/students/get-all-students)
students_status=$(echo "$students_response" | grep -o '"success":true')
if [ "$students_status" == '"success":true' ]; then
  echo "GET /students: SUCCESS" >> $LOG_FILE
  echo -e "${GREEN}✅ GET /students is working fine.${RESET}"
else
  echo "WARNING: GET /students failed" >> $LOG_FILE
  echo -e "${RED}❌ GET /students failed!${RESET}"
fi

# Subjects endpoint
subjects_response=$(curl -s "http://13.60.250.126:4300/api/subjects/get-subjects-by-program?program=Software+Engineering")
subjects_status=$(echo "$subjects_response" | grep -o '"success":true')

if [ "$subjects_status" == '"success":true' ]; then
  echo "GET /subjects: SUCCESS" >> $LOG_FILE
  echo -e "${GREEN}✅ GET /subjects is working fine.${RESET}"
else
  echo "WARNING: GET /subjects failed" >> $LOG_FILE
  echo -e "${RED}❌ GET /subjects failed!${RESET}"
fi

echo -e "\n📝 Health Check completed. See $LOG_FILE for detailed report.\n" >> $LOG_FILE
