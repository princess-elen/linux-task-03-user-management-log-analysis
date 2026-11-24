# Required command explanations

## `grep`
`grep` searches input text or files for lines matching a pattern and prints matching lines. In this activity, `grep "ERROR"` finds error entries, while `grep -E "root|user01"` uses an extended regular expression to match either `root` or `user01`.

## `chown`
`chown` changes the owner and optionally the group of a file or directory. In this activity, `sudo chown root:root confidential.txt` makes `root` the file owner and `root` the group.

## `usermod`
`usermod` modifies an existing user account. The `-aG` options append the user to supplementary groups without replacing existing supplementary group memberships; for example, `sudo usermod -aG sudo guest1` adds `guest1` to the `sudo` group.

## Observation after changing ownership
With permissions set to `600`, only the file owner has read and write access. After ownership is changed from `forensic01` to `root`, `forensic01` should normally be unable to read or edit the file. Record the actual terminal result, including any environment-specific differences.
