# Incident 1: Disk Space Critical

## Incident Report

The monitoring system reported that the production server's disk usage had reached 95%, and users were unable to upload files. The purpose of this investigation was to check the filesystem usage, identify directories and files consuming storage, inspect old log files and carry out a safe simulated cleanup.

I used my Ubuntu AWS EC2 instance to perform the investigation.

## 1. Symptom

The incident report stated that the server's disk utilization had reached 95%, causing users to experience problems when uploading files.

When a filesystem becomes nearly full, applications may not have enough available space to save files or temporary data. This can affect normal server operations.

I started by checking the disk usage on my Ubuntu server to see whether the same issue was present in my lab environment.

## 2. Investigation

### 2.1 Check filesystem usage

**Commands used:**

```bash
df -h
df -h /
```

I used `df -h` to check the total, used and available disk space for each mounted filesystem. I also used `df -h /` to check the root filesystem separately.

**Results from my server:**

| Filesystem | Total size | Used | Available | Usage |
|---|---:|---:|---:|---:|
| `/dev/root` | 6.7 GB | 2.3 GB | 4.4 GB | 35% |
| `/boot` | 989 MB | 98 MB | 824 MB | 11% |
| `/boot/efi` | 105 MB | 6.3 MB | 99 MB | 7% |

The root filesystem (`/`) was using 35% of its capacity, with approximately 4.4 GB available.

This showed that my AWS server was not running out of disk space, even though the incident report described a 95% utilization problem.

### 2.2 Identify directories consuming the most space

**Command used:**

```bash
sudo du -sh /* 2>/dev/null
```

I used this command to check the disk space used by the main directories under the root directory.

**Results from my server:**

| Directory | Approximate size |
|---|---:|
| `/usr` | 1.8 GB |
| `/snap` | 567 MB |
| `/var` | 538 MB |
| `/boot` | 104 MB |
| `/root` | 44 KB |
| `/home` | 180 KB |

The `/usr` directory was using the most space, followed by `/snap` and `/var`.

I decided to investigate `/usr` further.

**Commands used:**

```bash
sudo du -sh /usr/*
sudo du -sh /usr/lib/*
```

The `/usr/lib` directory was using approximately 1.1 GB. Some of its larger directories were:

- `/usr/lib/x86_64-linux-gnu` – 452 MB
- `/usr/lib/python3` – 256 MB
- `/usr/lib/modules` – 151 MB

These directories contain system libraries, Python components and kernel modules. I did not remove anything from these locations because they are required by the operating system and installed applications.

### 2.3 Find files larger than 500 MB

**Command used:**

```bash
sudo find / -type f -size +500M 2>/dev/null
```

I used this command to search the filesystem for files larger than 500 MB.

**Output:**

```text
/proc/kcore
```

The search returned `/proc/kcore`. This is a virtual file associated with kernel memory, not an ordinary stored file occupying disk space like a large log or application file.

No ordinary files larger than 500 MB requiring cleanup were identified.

### 2.4 Identify old log files

**Command used:**

```bash
sudo ls -lh /var/log/
```

I used this command to list the log files and check their sizes.

Some of the larger log files in my results were:

| Log file | Size |
|---|---:|
| `syslog` | 855 KB |
| `cloud-init.log` | 670 KB |
| `kern.log` | 309 KB |
| `lastlog` | 286 KB |

I then checked for log files that had not been modified for more than 30 days.

**Command used:**

```bash
sudo find /var/log -type f -mtime +30 -print
```

**Output:** No files were returned.

This meant that no regular log files matched the search condition in my server.

**Safe approach to cleaning up old logs:**

I would not delete log files without checking whether they are still needed. Before removing any data on a production server, I would:

1. Confirm with the application owner which logs and files belong to the application and whether they are still required.
2. Check the organisation's log retention policy.
3. Confirm that the files are not needed for troubleshooting, audits or security investigations.
4. Check whether backups are available and archive important logs before removing them.
5. Use `logrotate` to manage log rotation and prevent log files from growing too large in the future.

I did not delete any existing system logs during this investigation.

## 3. Findings

After completing the investigation, I identified the following:

- The root filesystem was using 35% of its capacity, with approximately 4.4 GB available.
- `/usr` was the largest directory, using approximately 1.8 GB.
- Most of the space inside `/usr` was being used by system libraries and other operating system components.
- The search for files larger than 500 MB returned `/proc/kcore`, which is a virtual kernel file rather than an ordinary stored file.
- The log files were relatively small.
- No regular log files older than 30 days were found.

The 95% disk utilization mentioned in the incident report was not present on my AWS server. Therefore, I could not reproduce the original disk space problem in my lab environment.

## 4. Action – Simulated Remediation

Since my server was not actually running low on disk space, I decided to simulate a cleanup using a temporary test file instead of deleting system files or existing logs.

**Step 1: Create a test directory**

```bash
mkdir -p ~/disk-incident-lab
```

This created a directory named `disk-incident-lab` inside my home directory.

**Step 2: Create a 100 MB test file**

```bash
dd if=/dev/zero of=~/disk-incident-lab/testfile.img bs=1M count=100
```

**Output:**

```text
100+0 records in
100+0 records out
104857600 bytes (105 MB, 100 MiB) copied
```

The command successfully created the test file.

**Step 3: Check the file size**

```bash
du -sh ~/disk-incident-lab
```

**Output:**

```text
101M    /home/ubuntu/disk-incident-lab
```

This confirmed that the test file was using approximately 101 MB.

**Step 4: Remove the test file**

```bash
rm ~/disk-incident-lab/testfile.img
```

I removed only the temporary file created for this exercise. No existing system files or logs were affected.

## 5. Verification

After removing the temporary test file, I checked the filesystem usage again.

**Command used:**

```bash
df -h
```

**Final results:**

| Filesystem | Before | After |
|---|---:|---:|
| Root (`/`) | 35% | 35% |
| `/boot` | 11% | 11% |
| `/boot/efi` | 7% | 7% |

The root filesystem usage remained at 35%, with approximately 4.4 GB available.

The percentage remained the same because `df -h` displays rounded usage values, and the amount of space recovered was not enough to change the displayed percentage.

The final check confirmed that the temporary test file had been removed and the server still had sufficient available storage.

## Conclusion

I completed the disk space investigation using Linux commands on my AWS Ubuntu server. I checked filesystem usage, identified the directories using the most space, searched for files larger than 500 MB and inspected old log files.

I also created and removed a temporary 100 MB test file to practise a safe cleanup.

Although the incident report described 95% disk utilization, my actual server was using only 35%. Therefore, I could not reproduce the reported disk space problem in my lab.

I avoided deleting system files or existing logs and verified the filesystem usage again after the simulated cleanup.
