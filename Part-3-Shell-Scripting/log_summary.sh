#!/bin/bash

read -p "Enter log file path: " logfile

if [ ! -f "$logfile" ]
then
    echo "Error: Log file does not exist"
    exit 1
fi

error=$(grep -c "ERROR" "$logfile")
warning=$(grep -c "WARNING" "$logfile")
info=$(grep -c "INFO" "$logfile")

echo "ERROR count: $error"
echo "WARNING count: $warning"
echo "INFO count: $info"

if [ "$error" -gt 3 ]
then
    echo "ALERT: Too many errors found!"
else
    echo "Log status: OK"
fi
