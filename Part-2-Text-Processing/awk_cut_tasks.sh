
#!/bin/bash

# Employee file location
EMPLOYEES_FILE="${1:-$HOME/employees.txt}"

# Question 8: Display employee names and departments
awk -F',' '{print $2, $3}' "$EMPLOYEES_FILE"

# Question 9: Display employees working in DevOps
grep "DevOps" "$EMPLOYEES_FILE"

# Question 10: Display employees earning more than 40000
awk -F',' '$4 > 40000 {print $0}' "$EMPLOYEES_FILE"

# Question 11: Display employees based in Bangalore
grep "Bangalore" "$EMPLOYEES_FILE"

# Question 12: Count employees in each department
awk -F',' '{print $3}' "$EMPLOYEES_FILE" | sort | uniq -c

# Question 13: Display the employee record with the highest salary
sort -t',' -k4,4nr "$EMPLOYEES_FILE" | head -n 1

# Question 14: Sort employee records by salary (ascending)
sort -t',' -k4,4n "$EMPLOYEES_FILE"

# Question 14: Sort employee records by salary (descending)
sort -t',' -k4,4nr "$EMPLOYEES_FILE"
