# Incident 4: Permission Denied

## 1. Symptom

A developer was unable to execute the deployment script and received a `Permission denied` error. I investigated the file permissions and ownership to identify the cause.

## 2. Investigation

I used `ls -l` and `stat` to check the file permissions and ownership.

**Initial permissions:**

```text
-rw-rw-r-- 1 ubuntu ubuntu 60 /home/ubuntu/incident4/deploy.sh
```

The file was owned by the `ubuntu` user and belonged to the `ubuntu` group. Its permission value was `664`, which meant that the file did not have execute permission.

## 3. Findings

The permission format `rwxr-xr-x` represents permission value `755`.

It means:

- **Owner (`rwx`):** Can read, write and execute the file.
- **Group (`r-x`):** Can read and execute the file.
- **Others (`r-x`):** Can read and execute the file.

The issue in my investigation was that the deployment script did not initially have execute permission.

## 4. Action

I added execute permission for the file owner only using `chmod`.

```bash
chmod u+x ~/incident4/deploy.sh
```

Here, `u` refers to the owner and `+x` adds execute permission.

I avoided using `chmod 777` because it would give everyone read, write and execute permissions, which is unnecessary and a security risk.

**Difference between chmod and chown:**

- `chmod` is used to change file permissions, such as read, write and execute.
- `chown` is used to change the file owner or group ownership.

## 5. Verification

After adding execute permission, I checked the file again using `ls -l`.

**Updated permissions:**

```text
-rwxrw-r-- 1 ubuntu ubuntu 60 /home/ubuntu/incident4/deploy.sh
```

The permission value changed from `664` to `764`. Execute permission was added for the owner.

I then ran the deployment script:

```bash
/home/ubuntu/incident4/deploy.sh
```

Output:

```text
Deployment script executed successfully
```

The script executed successfully after the permission change.

If the issue continued, I would also check the parent directory permissions, file ownership, script interpreter and whether the filesystem was mounted with the `noexec` option.

**Conclusion:** The issue was related to missing execute permission. Adding execute permission for the file owner resolved the problem, and I confirmed the change by running the script successfully.
