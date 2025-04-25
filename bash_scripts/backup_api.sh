#!/bin/bash

# Define log file and backup directory
LOG_FILE="/var/log/backup.log"
BACKUP_DIR="/home/ubuntu/backups"
TIMESTAMP=$(date +'%Y%m%d_%H%M%S')
API_DIR="/home/ubuntu/backends/CS-421-Assignment"
DB_NAME="cs421assignment"
DB_USER="postgres"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Log start
echo "===========================" | sudo tee -a "$LOG_FILE"
echo "🗂️ Backup started at $TIMESTAMP" | sudo tee -a "$LOG_FILE"

# Backup API directory
echo -e "🔄 Backing up API files..." | sudo tee -a "$LOG_FILE"
if tar -czf "$BACKUP_DIR/api_backup_$TIMESTAMP.tar.gz" "$API_DIR" >> "$LOG_FILE" 2>&1; then
    echo "✅ API files backed up successfully." | sudo tee -a "$LOG_FILE"
else
    echo "❌ Failed to back up API files." | sudo tee -a "$LOG_FILE"
    exit 1
fi

# PostgreSQL database dump (needs sudo)
echo -e "💾 Backing up PostgreSQL database..." | sudo tee -a "$LOG_FILE"
if sudo PGPASSWORD='root' pg_dump -U "$DB_USER" -h localhost "$DB_NAME" > "$BACKUP_DIR/db_backup_$TIMESTAMP.sql" 2>> "$LOG_FILE"; then
    echo "✅ Database backup completed successfully." | sudo tee -a "$LOG_FILE"
else
    echo "❌ Database backup failed." | sudo tee -a "$LOG_FILE"
    exit 1
fi

# Deleting old backups (older than 7 days)
echo -e "🗑️ Deleting old backups..." | sudo tee -a "$LOG_FILE"
if find "$BACKUP_DIR" -type f -mtime +7 -exec rm {} \; >> "$LOG_FILE" 2>&1; then
    echo "✅ Old backups removed successfully." | sudo tee -a "$LOG_FILE"
else
    echo "❌ Failed to delete old backups." | sudo tee -a "$LOG_FILE"
fi

# Log end
echo "Backup completed at $(date)" | sudo tee -a "$LOG_FILE"
echo "===========================" | sudo tee -a "$LOG_FILE"
echo "" | sudo tee -a "$LOG_FILE"

# Print final message to user
echo -e "✅ Backup completed successfully! Check the log file at $LOG_FILE for detailed information."

# Transfer section using rsync with proper sudo handling
echo -e "🔒 Syncing backups to backup server..." | sudo tee -a "$LOG_FILE"

# Use sudo with -H to preserve home directory and -u to run as ubuntu
if sudo -Hu ubuntu rsync -avz -e "ssh -i /home/ubuntu/.ssh/backup_key" \
    --include="api_backup_$TIMESTAMP.*" \
    --include="db_backup_$TIMESTAMP.*" \
    --exclude="*" \
    "/home/ubuntu/backups/" \
    ubuntu@172.31.25.186:/backups/ >> "$LOG_FILE" 2>&1; then
    echo "✅ Backups synced successfully." | sudo tee -a "$LOG_FILE"
else
    echo "❌ Backup sync failed." | sudo tee -a "$LOG_FILE"
    # Add error details to log
    echo "Last error code: $?" | sudo tee -a "$LOG_FILE"
    exit 1
fi
