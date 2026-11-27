# Incident 3: High CPU and Memory Usage

## 1. Symptom

The incident report stated that the application server was running slowly, with CPU utilisation at 95% and memory utilisation at 90%. I checked the resource utilisation on my Ubuntu EC2 instance to investigate the system's performance.

## 2. Investigation

### a) Checking system resource usage

I used the following commands to check system uptime, memory utilisation and running processes.

```bash
uptime
free -h
top
```

The results showed:

- CPU idle: 99.8%
- Memory used: 353 MiB out of 908.6 MiB
- Available memory: 555.6 MiB
- Load average: 0.00, 0.00, 0.00
- Zombie processes: 0

The system had low load and sufficient available memory during the investigation.

### b) Identifying processes using the most CPU and memory

I used `ps` with sorting options to identify the processes with the highest CPU and memory usage.

To check CPU usage:

```bash
ps aux --sort=-%cpu | head -n 6
```

To check memory usage:

```bash
ps aux --sort=-%mem | head -n 6
```

The Amazon SSM agent worker (PID 950) appeared at the top of the CPU list, but its CPU usage was 0.0%.

The `fwupd` process (PID 1451) had the highest memory usage at 4.0%.

No process showed unusually high resource consumption during the checks.

### c) Inspecting a process using its PID

I used the following command to get more information about PID 1451.

```bash
ps -p 1451 -f
```

The output identified the process as `/usr/libexec/fwupd/fwupd`, running under the root user.

I could also monitor this specific process in real time using:

```bash
top -p 1451
```

This allows an administrator to monitor the CPU and memory usage of an individual process.

## 3. Findings

The high CPU and memory utilisation reported in the incident was not reproduced on my EC2 instance.

During my investigation:

- CPU idle time was 99.8%.
- Memory usage was 353 MiB, with 555.6 MiB available.
- System load average was 0.00, 0.00, 0.00.
- There were no zombie processes.
- No process showed unusually high CPU or memory consumption.

Based on these results, the server was operating normally during the checks. The actual cause of the reported production slowdown could not be identified from this test environment.

## 4. Action

Since resource utilisation was normal, I did not terminate any processes.

The two commands an administrator can use to terminate a process are `kill` and `kill -9`.

**Using kill:**

```bash
kill PID
```

This sends the SIGTERM signal (15) to the process. It requests the process to terminate normally, allowing it to perform cleanup before exiting.

**Using kill -9:**

```bash
kill -9 PID
```

This sends the SIGKILL signal (9), which forces the process to stop immediately without allowing it to perform normal cleanup.

I would normally use `kill` first and check whether the process has stopped. I would only use `kill -9` if the process does not respond and force termination is necessary.

Force termination should be avoided where possible, especially for processes handling database transactions, writing files or managing important connections. It can interrupt operations and potentially result in data loss or inconsistent application state.

## 5. Verification

I checked the system again using:

```bash
top
free -h
uptime
```

The results confirmed that CPU utilisation remained low, memory was available and system load was normal.

No processes were terminated because there was no indication of a resource-related problem on the test server.

**Conclusion:** The investigation did not reproduce the reported high CPU and memory usage. The EC2 instance was operating normally during the checks. Further monitoring and investigation on the affected production server would be required to identify the cause of the reported slowdown.
