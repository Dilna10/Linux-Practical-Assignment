# Incident 2: Application Login Failure

## 1. Symptom

Users reported that they were unable to log in to the application. The support team suspected a database connectivity issue. As part of the initial investigation, I checked the application log file on the Ubuntu server to identify any errors related to the login failure.

## 2. Investigation

### a) Extracting and counting ERROR messages

I used `grep` to filter the application log and display all entries containing ERROR.

```bash
grep "ERROR" ~/application.log
```

The command returned five error entries:

```text
10:03:20 ERROR Invalid database credentials
10:04:30 ERROR Database connection refused
10:06:50 ERROR Database connection timeout
10:08:20 ERROR Connection pool exhausted
10:10:40 ERROR Database connection refused
```

To find the total number of errors, I used:

```bash
grep -c "ERROR" ~/application.log
```

Output:

```text
5
```

### b) Extracting timestamps and error messages

I used `grep` with `sed` to filter the ERROR entries and remove the ERROR label, keeping only the timestamps and error messages.

```bash
grep "ERROR" ~/application.log | sed 's/ ERROR / /'
```

This helped me view the timestamps and corresponding error messages clearly.

### c) Identifying the first and last errors

I used `head` and `tail` to identify the first and most recent error entries in the log.

```bash
grep "ERROR" ~/application.log | head -n 1
grep "ERROR" ~/application.log | tail -n 1
```

- First error: `10:03:20 ERROR Invalid database credentials`
- Last error: `10:10:40 ERROR Database connection refused`

## 3. Findings

The log contained five ERROR entries between 10:03:20 and 10:10:40.

The main issues recorded were:

- Invalid database credentials
- Database connection refused
- Database connection timeout
- Connection pool exhausted

These entries indicate possible database authentication and connectivity problems. The connection pool exhaustion message also suggests that the application may have reached its maximum permitted database connections.

However, the application log alone is not enough to confirm whether the database service was down. Further checks would be required to identify the root cause.

## 4. Action

### a) Generating a separate CRITICAL log report

I used `sed` to replace ERROR with CRITICAL and redirected the output to a separate file. This allowed me to create a modified report without changing the original application log.

```bash
sed 's/ERROR/CRITICAL/g' ~/application.log > ~/application_critical.log
```

I checked the generated file and confirmed that all five ERROR entries were replaced with CRITICAL.

### b) Creating an error monitoring script

I created a Bash script named `check_errors.sh` to monitor the number of ERROR entries in the application log.

The script checks the error count against a threshold of three and displays an alert if that threshold is exceeded.

```bash
#!/bin/bash

LOG_FILE="$HOME/application.log"

ERROR_COUNT=$(grep -c "ERROR" "$LOG_FILE")

echo "Total errors found: $ERROR_COUNT"

if [ "$ERROR_COUNT" -gt 3 ]; then
    echo "ALERT: Error count is greater than 3!"
else
    echo "Error count is within the limit."
fi
```

I assigned execute permission to the script and ran it:

```bash
chmod +x ~/check_errors.sh
~/check_errors.sh
```

Output:

```text
Total errors found: 5
ALERT: Error count is greater than 3!
```

The script worked as expected. Since the error count was five, which exceeded the configured threshold, it generated an alert.

### c) Further troubleshooting

As a Linux Administrator, I would carry out the following checks to investigate the root cause:

1. **Database service status:** Check whether the database service is active using `systemctl status` and review the database service logs for failures.
2. **Database credentials and configuration:** Verify that the application is using the correct database username, password, hostname and port.
3. **Network connectivity:** Test connectivity between the application server and database server. Check firewall rules, listening ports and AWS security group configurations.
4. **Database connections:** Check active database connections and connection pool limits to investigate the connection pool exhaustion error.

These checks would help narrow down whether the issue is related to the database service, authentication, network connectivity or connection limits.

## 5. Verification

I used the following command to verify that the original log, the generated CRITICAL report and the monitoring script were present.

```bash
ls -l ~/application.log ~/application_critical.log ~/check_errors.sh
```

All three files were present, and `check_errors.sh` had executable permissions.

I also executed the monitoring script again and confirmed that it returned the correct error count and generated an alert when the count exceeded three.

**Conclusion:** The log analysis identified five database-related errors that could be contributing to the application login failure. I generated a separate CRITICAL report and created a Bash script to monitor the error count. Further service, authentication and network checks would be needed to identify and confirm the root cause.
