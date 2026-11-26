
#!/bin/bash

# Server log file
LOG_FILE="${1:-$HOME/server.log}"

# 1. Display all ERROR lines
grep "ERROR" "$LOG_FILE"

# 2. Count the ERROR lines
grep -c "ERROR" "$LOG_FILE"

# 3. Display all WARNING lines
grep "WARNING" "$LOG_FILE"

# 4. Find lines containing Database
grep "Database" "$LOG_FILE"

# 5. Display the first five lines
head -n 5 "$LOG_FILE"

# Display the last three lines
tail -n 3 "$LOG_FILE"

# 6. Search for error regardless of letter case
grep -i "error" "$LOG_FILE"
