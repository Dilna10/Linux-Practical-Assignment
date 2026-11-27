#!/bin/bash

read -p "Enter directory path: " dir

if [ ! -d "$dir" ]
then
    echo "Error: Directory does not exist"
    exit 1
fi

timestamp=$(date +%Y%m%d_%H%M%S)

backup="backup_$timestamp.tar.gz"

tar -czf "$backup" "$dir"

if [ $? -eq 0 ]
then
    echo "Backup created successfully: $backup"
else
    echo "Backup failed"
    exit 1
fi
