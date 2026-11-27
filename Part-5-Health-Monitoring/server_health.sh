#!/bin/bash

APP_NAME="$1"
REPORT_FILE="$(dirname "$0")/server_report.txt"

{
    echo "SERVER HEALTH REPORT"
    echo "Date and Time: $(date)"
    echo "Hostname: $(hostname)"

    echo ""
    echo "Root Filesystem Usage:"
    df -h /

    DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

    if [ "$DISK_USAGE" -gt 80 ]; then
        echo "WARNING: Disk usage is above 80%!"
    fi

    echo ""
    echo "Memory Information:"
    free -h
    echo "Available Memory: $(free -h | awk '/^Mem:/ {print $7}')"

    echo ""
    echo "System Uptime:"
    uptime

    echo ""
    echo "Top 5 CPU-Consuming Processes:"
    ps aux --sort=-%cpu | head -n 6

    echo ""
    echo "Application Status:"
    if [ -z "$APP_NAME" ]; then
        echo "Please provide an application process name."
    elif pgrep -x "$APP_NAME" > /dev/null; then
        echo "Application $APP_NAME is running."
    else
        echo "ALERT: Application $APP_NAME is not running!"
    fi

} | tee "$REPORT_FILE"
