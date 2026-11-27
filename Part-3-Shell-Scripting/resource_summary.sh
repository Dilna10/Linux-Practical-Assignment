#!/bin/bash

echo "===== SYSTEM RESOURCE SUMMARY ====="

echo "Hostname:"
hostname

echo "Uptime:"
uptime

echo "Memory Usage:"
free -h

echo "Top 5 CPU-consuming processes:"
ps aux --sort=-%cpu | head -n 6
