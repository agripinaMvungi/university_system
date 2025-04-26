#!/bin/bash

# Define log file and backup directory
LOG_FILE="/var/log/backup.log"
BACKUP_DIR="/home/ubuntu/backups"
TIMESTAMP=$(date +'%Y%m%d_%H%M%S')
API_DIR="/home/ubuntu/university_system"
SQLITE_DB="/home/ubuntu/university_system/studentapi/db.sqlite3"

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

# Backup SQLite database
echo -e "💾 Backing up SQLite database..." | sudo tee -a "$LOG_FILE"
if cp "$SQLITE_DB" "$BACKUP_DIR/db_backup_$TIMESTAMP.sqlite3" >> "$LOG_FILE" 2>&1; then
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

# Final message
echo -e "✅ Backup completed successfully! Check the log file at $LOG_FILE for detailed information."

# Optional: Rsync to another backup server (if you have one configured)
# Uncomment below if you have a remote backup server ready
# echo -e "🔒 Syncing backups to backup server..." | sudo tee -a "$LOG_FILE"
# sudo -Hu ubuntu rsync -avz -e "ssh -i /home/ubuntu/.ssh/backup_key" "$BACKUP_DIR/" ubuntu@172.31.25.186:/backups/
