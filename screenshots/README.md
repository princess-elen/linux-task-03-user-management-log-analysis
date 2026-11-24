# Screenshot checklist

Save genuine screenshots of your own terminal session here. Suggested filenames:

1. `01-forensic-user-setup.png` — `id forensic01`, `getent passwd forensic01`, and home directory.
2. `02-log-file-created.png` — `wc -l` and `ls -l` for `sys_events.log`.
3. `03-grep-error-results.png` — output of `grep "ERROR"`.
4. `04-grep-user-root-results.png` — output of `grep -E "root|user01"`.
5. `05-piping-redirection-report.png` — `grep` piped to `less` and report creation/content.
6. `06-head-tail-cat.png` — first five, last five, and full log output (multiple screenshots are fine).
7. `07-permissions-before-chown.png` — `ls -l` showing `-rw-------`.
8. `08-ownership-after-chown.png` — `ls -l` showing root ownership.
9. `09-access-denied-test.png` — actual read/write attempt as forensic01.
10. `10-guest-user-management.png` — `id guest1` and confirmation guest2 is absent.

Use PNG or JPG. Make sure command text and output are readable. Do not include passwords in screenshots.
