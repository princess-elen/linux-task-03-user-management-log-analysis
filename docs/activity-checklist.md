# Activity checklist

## Part 1 — New User Setup
- [ ] Create `forensic01` with home directory `/home/forensic01`.
- [ ] Set login shell to `/bin/bash`.
- [ ] Add `forensic01` to the `sudo` group.
- [ ] Set a password securely.
- [ ] Log in as `forensic01`.
- [ ] Create `/home/forensic01/logs/`.
- [ ] Create `sys_events.log` with at least 20 mock timestamped lines including `ERROR`, `WARNING`, `INFO`, `user01`, and `root`.

## Part 2 — Log Filtering & Analysis
- [ ] `grep "ERROR" sys_events.log`
- [ ] `grep -E "root|user01" sys_events.log`
- [ ] Pipe grep results to `less`.
- [ ] Redirect ERROR output to `error_report.txt`.
- [ ] Display first 5 lines with `head`.
- [ ] Display last 5 lines with `tail`.
- [ ] Display the full log with `cat`.

## Part 3 — Permissions and Ownership
- [ ] Create `confidential.txt`.
- [ ] Set permissions to owner read/write only (`chmod 600`).
- [ ] Change owner to root using `sudo chown`.
- [ ] Test reading/editing as `forensic01`.
- [ ] Record the observed result.

## Part 4 — User Management
- [ ] Create `guest1`.
- [ ] Create `guest2`.
- [ ] Add `guest1` to `sudo`.
- [ ] Delete `guest2`, including its home directory.

## Submission
- [ ] Complete `submission/commands_used.txt`.
- [ ] Save actual terminal screenshots in `screenshots/`.
- [ ] Include `reports/error_report.txt`.
- [ ] Complete `reports/activity_report.md`.
- [ ] Complete `reports/observations.md`.
- [ ] Review `docs/explanations.md`.
