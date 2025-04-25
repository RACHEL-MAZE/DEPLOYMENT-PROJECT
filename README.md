
# CS 421 - Application Deployment and Management## 
Assignments 1 & 2 Project Documentation
**Instructor:** Dr. Goodiel C. Moshi  **Course:** CS 421 - Application Deployment and Management  
**Student:** Rachel Mazeleng'we 
**Registration Number:** T21-03-00578 
**GitHub Repository:** [https://github.com/RACHEL-MAZE/DEPLOYMENT-PROJECT.git]
**Submission Email:** goodiel.moshi@udom.ac.tz  ---
## Table of Contents1. [Project Overview](#project-overview)
2. [System Architecture](#system-architecture)
3. [API Documentation](#api-documentation)
4. [Server Setup](#server-setup)
5. [Automation Scripts](#automation-scripts)
6. [Backup Strategies](#backup-strategies)
7. [Installation Guide](#installation-guide)
8. [Usage Instructions](#usage-instructions)
9. [Cron Job Configuration](#cron-job-configuration)
10. [Testing](#testing)
11. [Troubleshooting](#troubleshooting)
12. [References](#references)
---
## Project OverviewThe project demonstrates a complete deployment pipeline for a student information API on AWS infrastructure, including:
### Assignment 1: API Development
- RESTful API with two endpoints (`/students` and `/subjects`)
- PostgreSQL database backend
- Built with Node.js and Express.js
- Deployed on AWS EC2 Ubuntu server
### Assignment 2: Automation Implementation
- Three Bash scripts for server management
- Automated monitoring and maintenance
- Scheduled tasks via cron
---
## System Architecture
> (Include system diagram and code snippets as appropriate.)
---
## API Documentation
### Endpoints
#### `GET /students`
Returns: JSON array of student objects
```json
[
 {
    "id": 1,
    "name": "Dotto Ligima",
    "program": "Software Engineering"  
 }
]
```
#### `GET /subjects`
Returns: JSON object organized by academic year
```json
{
  "year_1": ["Principles of Programming Languages(CP 111)", "Development Perspectives(DS 102)"],
  "year_2": ["Computer Networking Protocols(CN 211)", "Introduction To Linux/Unix Systems(CP 211)"]
}
```
---
## Server Setup
### AWS EC2 Configuration
- **Instance Type:** t2.micro (Free Tier)
- **OS:** Ubuntu 22.04 LTS
- **Web Server:** Nginx (for reverse proxy)
- **App Stack:** Node.js + Express.js
- **Database:** PostgreSQL 14### Security Groups
- HTTP (80)
- HTTPS (443)
- SSH (22) 
- Restricted to specific IP
### Installation Steps
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install nginx -y
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
sudo apt install postgresql postgresql-
contrib -y
```
---
## Automation Scripts
### Health Check Script (`health_check.sh`)
```bash
#!/bin/bash
# Monitors server resources and API status
```
- Runs every 6 hours via cron
- Monitors CPU, memory, disk
- Checks API endpoints
- Logs to `/var/log/server_health.log`
### Backup Script (`backup_api.sh`)
```bash
#!/bin/bash
# Backs up API and database
```
- Runs daily at 2 AM via cron
- Uses TAR.GZ compression and `pg_dump`
- 7-day retention
- Remote copy supported
### Update Script (`update_server.sh`)
```bash
#!/bin/bash
# Updates system and app dependencies
```
- Runs every 3 days at 3 AM via cron
- Pulls latest code from Git
- Restarts Node.js service
---
## Backup Strategies
### Full Backup
```bash
tar -czf full_backup.tar.gz /var/www/node-api
```
- Complete, but storage heavy
### Incremental Backup
```bash
rsync -a --link-dest=previous_backup source new_backup
```
- Efficient, but more complex restore
### Database Dump
```bash
pg_dump -U user dbname > backup.sql
```
- Good for database only
---
## Installation Guide
### Prerequisites
- AWS account with EC2 access
- GitHub account
- SSH client
### Deployment Steps
```bash
git clone https://github.com/yourusername/CS-421-Assignment.gitcd CS-421-Assignment
npm install
npm start &  # Or use PM2
```
---
## Usage Instructions
### Manual Script Execution
```bash
# Health check
sudo ./health_check.sh
# Backup
sudo ./backup_api.sh
# Update
sudo ./update_server.sh
```
### Verify Logs
```bash
tail -f /var/log/server_health.log
tail -f /var/log/backup.log
tail -f /var/log/update.log
```
---
## Cron Job Configuration
```bash
crontab -e
# Add the following
0 */6 * * * /home/ubuntu/scripts/health_check.sh
0 2 * * * /home/ubuntu/scripts/backup_api.sh
0 3 */3 * * /home/ubuntu/scripts/update_server.sh
# Verify
crontab -l
```
---
## Testing
### API Tests
```bash
curl http://localhost/students
curl http://localhost/subjects
```
### Script Tests
```bash
bash -n script.sh   # Syntax check
bash -x script.sh   # Debug mode
```
---
## Troubleshooting
| Issue | Solution |
|-------|----------|
| API not responding | Check Node.js process or PM2 |
| Nginx errors | Check Nginx: `systemctl status nginx` |
| Backup failures | Verify disk space: `df -h` |
| Git pull errors | Check SSH keys: `ssh -T git@github.com` |
| Cron jobs not running | Check logs: `grep CRON /var/log/syslog` |
---
## References
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2)
- [Nginx Configuration Guide](https://nginx.org/en/docs/)
- [Node.js Documentation](https://nodejs.org/en/docs)- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Bash Scripting Guide](https://tldp.org/LDP/abs/html/)
---
## Submission Compliance Checklist
- Public GitHub repository with all scripts
- Functional deployed API endpoints
- Complete README documentation
- Log samples and cron screenshot included
- All scripts tested and operational