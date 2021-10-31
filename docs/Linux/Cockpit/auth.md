# Authentication

## Prevent root login

You can prevent `root` login into Cockpit Web UI by adding

	auth requisite pam_succeed_if.so uid >= 1000

to `/etc/pam.d/cockpit`
