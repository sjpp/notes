# Manage Linux entropy

To check the status of your server’s entropy, just run the following:

	cat /proc/sys/kernel/random/entropy_avail

If it returns anything less than 100-200, you have a problem.
The `haveged` package and daemon can be installed to greatly increase the system entropy.
