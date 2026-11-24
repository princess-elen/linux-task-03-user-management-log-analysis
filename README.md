# Linux Task 03 — GitHub-Ready Workflow

A guided, reproducible workflow for the activity in **Linux Task 03.pdf**. It covers user creation, log generation and filtering, file permissions/ownership, temporary-user management, and submission evidence.

> **Target environment:** Ubuntu/Debian Linux with `sudo`, `useradd`, `usermod`, `passwd`, `chown`, `chmod`, and GNU core utilities.  
> **Important:** Run the scripts on a disposable Linux VM or lab machine. The workflow creates system users and changes file ownership. The final user-management step deletes `guest2` and its home directory, as required by the exercise.

## Repository layout

```text
linux-task-03-github-workflow/
├── README.md
├── LICENSE
├── .gitignore
├── docs/
│   ├── activity-checklist.md
│   ├── explanations.md
│   └── submission-guide.md
├── scripts/
│   ├── 00_preflight.sh
│   ├── 01_setup_forensic_user.sh
│   ├── 02_create_logs.sh
│   ├── 03_analyze_logs.sh
│   ├── 04_permissions_ownership.sh
│   ├── 05_manage_guest_users.sh
│   └── 06_collect_evidence.sh
├── logs/
│   └── .gitkeep
├── reports/
│   ├── error_report.txt
│   ├── activity_report.md
│   └── observations.md
├── evidence/
│   ├── README.md
│   ├── terminal-outputs/
│   │   └── .gitkeep
│   └── verification/
│       └── .gitkeep
├── screenshots/
│   ├── README.md
│   └── .gitkeep
└── submission/
    ├── commands_used.txt
    └── final_checklist.md
```

## 1. Prepare the Linux environment

Clone or copy this repository to an Ubuntu/Debian VM. Open a terminal in the repository directory.

```bash
chmod +x scripts/*.sh
./scripts/00_preflight.sh
```

The preflight script checks the operating system, required commands, sudo access, and whether the requested usernames already exist. It does not make system changes.

## 2. Create `forensic01`

Run:

```bash
sudo ./scripts/01_setup_forensic_user.sh
```

The script creates `forensic01` with `/home/forensic01` and `/bin/bash`, adds the user to `sudo`, and prompts you to set a password securely. It will not print or save the password.

Verify:

```bash
id forensic01
getent passwd forensic01
ls -ld /home/forensic01
```

Take a screenshot showing the verification output and save it as:

` screenshots/01-forensic-user-setup.png `

## 3. Log in as `forensic01` and create the log file

Switch user:

```bash
su - forensic01
```

From the repository, run the log creation script with the repository path:

```bash
/path/to/linux-task-03-github-workflow/scripts/02_create_logs.sh
```

Alternatively, use the manual commands below after switching to `forensic01`:

```bash
mkdir -p "$HOME/logs"
cat > "$HOME/logs/sys_events.log" <<'LOGS'
2026-11-24 08:00:01 INFO system boot completed
2026-11-24 08:02:14 INFO user01 logged in from console
2026-11-24 08:05:33 WARNING disk usage reached 75 percent
2026-11-24 08:07:10 ERROR failed authentication for user01
2026-11-24 08:09:42 INFO root started scheduled maintenance
2026-11-24 08:12:08 WARNING unusual process activity detected
2026-11-24 08:15:19 ERROR service database failed to start
2026-11-24 08:18:27 INFO user01 opened system dashboard
2026-11-24 08:21:44 INFO root updated package index
2026-11-24 08:24:03 WARNING memory usage reached 80 percent
2026-11-24 08:27:16 ERROR permission denied while accessing archive
2026-11-24 08:30:29 INFO backup process started by root
2026-11-24 08:33:51 INFO user01 saved a configuration file
2026-11-24 08:36:07 WARNING network latency above threshold
2026-11-24 08:39:22 ERROR failed to write application log
2026-11-24 08:42:35 INFO root checked filesystem integrity
2026-11-24 08:45:48 INFO user01 logged out
2026-11-24 08:48:02 WARNING repeated login attempts observed
2026-11-24 08:51:13 ERROR authentication service timeout
2026-11-24 08:54:26 INFO system monitoring completed
LOGS
```

Check the file:

```bash
wc -l "$HOME/logs/sys_events.log"
ls -l "$HOME/logs/sys_events.log"
```

Expected line count: at least 20.

## 4. Filter and analyse the logs

Still as `forensic01`:

```bash
cd "$HOME/logs"
grep "ERROR" sys_events.log
grep -E "root|user01" sys_events.log
grep "ERROR" sys_events.log | less
grep "ERROR" sys_events.log > error_report.txt
head -n 5 sys_events.log
tail -n 5 sys_events.log
cat sys_events.log
```

If `less` is unavailable, install it using your system package manager or skip the interactive viewing step after demonstrating the pipe with an available pager. Press `q` to exit `less`.

Confirm the report:

```bash
cat error_report.txt
wc -l error_report.txt
```

Copy the generated report into the repository's `reports/` folder if you want to submit it with the repository:

```bash
cp "$HOME/logs/error_report.txt" /path/to/linux-task-03-github-workflow/reports/error_report.txt
```

## 5. Test permissions and ownership

As `forensic01`, create the file and set owner-only read/write permissions:

```bash
touch "$HOME/logs/confidential.txt"
chmod 600 "$HOME/logs/confidential.txt"
ls -l "$HOME/logs/confidential.txt"
```

Expected permission string: `-rw-------`.

Change its owner to root:

```bash
sudo chown root:root "$HOME/logs/confidential.txt"
ls -l "$HOME/logs/confidential.txt"
```

Test access as `forensic01`:

```bash
cat "$HOME/logs/confidential.txt"
echo "test entry" >> "$HOME/logs/confidential.txt"
```

The file is mode `600`, so only its owner (`root`) has read/write access. Since `forensic01` is no longer the owner, the read and write attempts should fail with “Permission denied” (unless the environment has unusual privileges or ACLs). Record what actually happens in `reports/observations.md`.

For a controlled demonstration, an administrator can inspect it:

```bash
sudo ls -l "$HOME/logs/confidential.txt"
sudo cat "$HOME/logs/confidential.txt"
```

## 6. Create and manage temporary users

Run from the repository directory as a sudo-capable administrator:

```bash
sudo ./scripts/05_manage_guest_users.sh
```

The script creates `guest1` and `guest2` if they do not exist, adds `guest1` to `sudo`, verifies membership, then removes `guest2` and its home directory. It asks for confirmation before deletion.

Verify:

```bash
id guest1
getent passwd guest2 || echo "guest2 has been removed"
```

## 7. Collect evidence and complete the report

Run:

```bash
./scripts/06_collect_evidence.sh
```

This saves verification text files under `evidence/verification/`. It does not fabricate screenshots. Capture real terminal screenshots and place them in `screenshots/` using the filenames in `screenshots/README.md`.

Complete:
- `submission/commands_used.txt` — record the exact commands you personally ran.
- `reports/activity_report.md` — summarize what you completed.
- `reports/observations.md` — record the actual result of the ownership/access test.
- `docs/explanations.md` — review the short explanations of `grep`, `chown`, and `usermod`.

## Submission checklist

See `submission/final_checklist.md`. Your final submission should contain:
1. `submission/commands_used.txt`
2. Screenshots of key terminal outputs
3. `reports/error_report.txt`
4. Short explanations of `grep`, `chown`, and `usermod`
5. Your observation after changing ownership of `confidential.txt`

## Safety and troubleshooting

- Do not run on a production server or a personal machine with important user accounts.
- Scripts are designed for Ubuntu/Debian-style systems. Other distributions may use a different administrative group (for example, `wheel` instead of `sudo`).
- If a username already exists, the setup scripts avoid recreating it. Inspect the account before proceeding.
- `guest2` deletion is intentionally destructive and removes its home directory. The script asks for confirmation.
- A sudo group membership change may require logging out and back in before it takes effect for a login session.
- If a command fails, save the error output in `evidence/terminal-outputs/` and explain it in your report.
