---
tags:
    - raid
    - server
    - fs
---

## How to rebuild an MDadm Raid

### Get disk serial

    udevadm info --query=all --name=/dev/sda | grep ID_SERIAL

### Replacing A Failed Hard Drive In A Software RAID1 Array

This guide shows how to remove a failed hard drive from a Linux RAID1 array (software RAID), and how to add a new hard disk to the RAID1 array without losing data.

NOTE: There is a new version of this tutorial available that uses gdisk instead of sfdisk to support GPT partitions.

### Context

In this example I have two hard drives, /dev/sda and /dev/sdb, with the partitions /dev/sda1 and /dev/sda2 as well as /dev/sdb1 and /dev/sdb2.

- /dev/sda1 and /dev/sdb1 make up the RAID1 array /dev/md0.
- /dev/sda2 and /dev/sdb2 make up the RAID1 array /dev/md1.
- /dev/sda1 + /dev/sdb1 = /dev/md0
- /dev/sda2 + /dev/sdb2 = /dev/md1
- /dev/sdb has failed, and we want to replace it.

### How Do I Tell If A Hard Disk Has Failed?

If a disk has failed, you will probably find a lot of error messages in the log files, e.g. /var/log/messages or /var/log/syslog.

You can also run

    cat /proc/mdstat

and instead of the string [UU] you will see [U_] if you have a degraded RAID1 array.

### Removing The Failed Disk

To remove /dev/sdb, we will mark /dev/sdb1 and /dev/sdb2 as failed and remove them from their respective RAID arrays (/dev/md0 and /dev/md1).

First we mark /dev/sdb1 as failed:

    mdadm --manage /dev/md0 --fail /dev/sdb1

The output of

    cat /proc/mdstat

should look like this:

    Personalities : [linear] [multipath] [raid0] [raid1] [raid5] [raid4] [raid6] [raid10]
    md0 : active raid1 sda1[0] sdb1[2](F)
        24418688 blocks [2/1] [U_]

    md1 : active raid1 sda2[0] sdb2[1]

        24418688 blocks [2/2] [UU]

    unused devices: <none>

Then we remove /dev/sdb1 from /dev/md0:

    mdadm --manage /dev/md0 --remove /dev/sdb1

The output should be like this:

    mdadm --manage /dev/md0 --remove /dev/sdb1
    mdadm: hot removed /dev/sdb1

And

    cat /proc/mdstat

should show this:

    Personalities : [linear] [multipath] [raid0] [raid1] [raid5] [raid4] [raid6] [raid10]
    md0 : active raid1 sda1[0]
        24418688 blocks [2/1] [U_]

    md1 : active raid1 sda2[0] sdb2[1]

        24418688 blocks [2/2] [UU]

    unused devices: <none>

Now we do the same steps again for /dev/sdb2 (which is part of /dev/md1):

    mdadm --manage /dev/md1 --fail /dev/sdb2

    cat /proc/mdstat

    Personalities : [linear] [multipath] [raid0] [raid1] [raid5] [raid4] [raid6] [raid10]
    md0 : active raid1 sda1[0]
        24418688 blocks [2/1] [U_]

    md1 : active raid1 sda2[0] sdb2[2](F)

        24418688 blocks [2/1] [U_]

    unused devices: <none>

    mdadm --manage /dev/md1 --remove /dev/sdb2

    mdadm: hot removed /dev/sdb2

    cat /proc/mdstat

    Personalities : [linear] [multipath] [raid0] [raid1] [raid5] [raid4] [raid6] [raid10]
    md0 : active raid1 sda1[0]
        24418688 blocks [2/1] [U_]

    md1 : active raid1 sda2[0]

        24418688 blocks [2/1] [U_]

    unused devices: <none>

Then power down the system:

    shutdown -h now

and replace the old /dev/sdb hard drive with a new one (it must have at least the same size as the old one - if it's only a few MB smaller than the old one then rebuilding the arrays will fail).

### Adding The New Hard Disk

After you have changed the hard disk /dev/sdb, boot the system.

The first thing we must do now is to create the exact same partitioning as on /dev/sda. We can do this with one simple command:

    sfdisk -d /dev/sda | sfdisk /dev/sdb

You can run

    fdisk -l

to check if both hard drives have the same partitioning now.

Next we add /dev/sdb1 to /dev/md0 and /dev/sdb2 to /dev/md1:

    mdadm --manage /dev/md0 --add /dev/sdb1

    mdadm: re-added /dev/sdb1

    mdadm --manage /dev/md1 --add /dev/sdb2

    mdadm: re-added /dev/sdb2

Now both arays (/dev/md0 and /dev/md1) will be synchronized. Run

    cat /proc/mdstat

to see when it's finished.

During the synchronization the output will look like this:

    server1:~# cat /proc/mdstat
    Personalities : [linear] [multipath] [raid0] [raid1] [raid5] [raid4] [raid6] [raid10]
    md0 : active raid1 sda1[0] sdb1[1]
        24418688 blocks [2/1] [U_]
        [=>...................]  recovery =  9.9% (2423168/24418688) finish=2.8min speed=127535K/sec

    md1 : active raid1 sda2[0] sdb2[1]

        24418688 blocks [2/1] [U_]
        [=>...................]  recovery =  6.4% (1572096/24418688) finish=1.9min speed=196512K/sec

    unused devices: <none>

When the synchronization is finished, the output will look like this:

    server1:~# cat /proc/mdstat
    Personalities : [linear] [multipath] [raid0] [raid1] [raid5] [raid4] [raid6] [raid10]
    md0 : active raid1 sda1[0] sdb1[1]
        24418688 blocks [2/2] [UU]

    md1 : active raid1 sda2[0] sdb2[1]

        24418688 blocks [2/2] [UU]

    unused devices: <none>

That's it, you have successfully replaced /dev/sdb!
