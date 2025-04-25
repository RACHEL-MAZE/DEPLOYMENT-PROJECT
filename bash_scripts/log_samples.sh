#!/bin/bash

# Define output file
OUTPUT_FILE="$HOME/logs_sample.txt"

# Clear any existing file
sudo rm -f "$OUTPUT_FILE"
sudo touch "$OUTPUT_FILE"
sudo chown ubuntu:ubuntu "$OUTPUT_FILE"

# Add header
echo "CS 421 Assignment 2 - Log Samples" | sudo tee -a "$OUTPUT_FILE"
echo "Generated on $(date)" | sudo tee -a "$OUTPUT_FILE"
echo "=================================" | sudo tee -a "$OUTPUT_FILE"

# Function to add log samples
add_log_samples() {
    local log_name=$1
    local log_path=$2
    
    echo -e "\n=== $log_name ===" | sudo tee -a "$OUTPUT_FILE"
    
    if sudo [ -f "$log_path" ]; then
        sudo tail -n 4 "$log_path" | sudo tee -a "$OUTPUT_FILE"
    else
        echo "Log file not found: $log_path" | sudo tee -a "$OUTPUT_FILE"
    fi
}

# Add samples from each log file
add_log_samples "server_health.log" "/var/log/server_health.log"
add_log_samples "backup.log" "/var/log/backup.log"
add_log_samples "update.log" "/var/log/update.log"

# Set final permissions
sudo chmod 644 "$OUTPUT_FILE"

echo -e "\nLog samples generated at: $OUTPUT_FILE"
