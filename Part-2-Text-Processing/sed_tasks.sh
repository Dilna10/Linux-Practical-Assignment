#!/bin/bash

# Question 7: Replace ERROR with CRITICAL
sed 's/ERROR/CRITICAL/g' "$HOME/server.log" > output/server_critical.log

# Check the new file
cat output/server_critical.log

# Check both files
ls -l "$HOME/server.log" output/server_critical.log
