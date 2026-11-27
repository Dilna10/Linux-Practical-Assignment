#!/bin/bash

usage=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

echo "Root filesystem usage: $usage%"

if [ "$usage" -gt 80 ]
then
    echo "WARNING: Disk usage is above 80%"
else
    echo "OK: Disk usage is normal"
fi
