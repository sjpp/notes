---
tags:
    - raid
    - server
    - fs
---

## How To Resize RAID Partitions (Shrink & Grow) (Software RAID)

*Version 1.0 | Author: Falko Timme*

This article describes how you can shrink and grow existing software RAID partitions. I have tested this with non-LVM RAID1 partitions that use ext3 as the file system. I will describe this procedure for an intact RAID array and also a degraded RAID array.

If you use LVM on your RAID partitions, the procedure will be different, so do not use this tutorial in this case!

### Preliminary Note

A few days ago I found out that one of my servers had a degraded RAID1 array (/dev/md2, made up of /dev/sda3 and /dev/sdb3; /dev/sda3 had failed, /dev/sdb3 was still active):

    server1:~# cat /proc/mdstat
    Personalities : [raid1]
    md2 : active raid1 sdb3[1]
        4594496 blocks [2/1] [_U]

    md1 : active raid1 sda2[0] sdb2[1]

        497920 blocks [2/2] [UU]

    md0 : active raid1 sda1[0] sdb1[1]

        144448 blocks [2/2] [UU]

    unused devices: <none>

I tried to fix it (using this tutorial), but unfortunately at the end of the sync process (with 99.9% complete), the sync stopped and started over again. As I found out, this happened because there were some defect sectors at the end of the (working) partition /dev/sdb3 - this was in /var/log/kern.log:

    Nov 22 18:51:06 server1 kernel: sdb: Current: sense key: Aborted Command
    Nov 22 18:51:06 server1 kernel: end_request: I/O error, dev sdb, sector 1465142856

So this was the worst case that could happen - /dev/sda dead and /dev/sdb about to die. To fix this, I imagined I could shrink /dev/md2 so that it leaves out the broken sectors at the end of /dev/sdb3, then add the new /dev/sda3 (from the replaced hard drive) to /dev/md2, let the sync finish, remove /dev/sdb3 from the array and replace /dev/sdb with a new hard drive, add the new /dev/sdb3 to /dev/md2, and grow /dev/md2 again.

This is one of the use cases for the following procedures (I will describe the process for an intact array and a degraded array).

Please note that /dev/md2 is my system partition (mount point /), so I had to use a rescue system (e.g. Knoppix Live-CD) to resize the array. If the array you want to resize is not your system partition, you probably don't need to boot into a rescue system; but in either case, make sure that the array is unmounted!

### Intact Array

I will describe how to resize the array /dev/md2, made up of /dev/sda3 and /dev/sdb3.

#### Shrinking An Intact Array

Boot into your rescue system and activate all needed modules:

    modprobe md
    modprobe linear
    modprobe multipath
    modprobe raid0
    modprobe raid1
    modprobe raid5
    modprobe raid6
    modprobe raid10

Then activate your RAID arrays:

    cp /etc/mdadm/mdadm.conf /etc/mdadm/mdadm.conf_orig
    mdadm --examine --scan >> /etc/mdadm/mdadm.conf

    mdadm -A --scan

Run

    e2fsck -f /dev/md2

to check the file system.

/dev/md2 has a size of 40GB; I want to shrink it to 30GB. First we have to shrink the file system with resize2fs; to make sure that the file system fits into the 30GB, we make it a little bit smaller (25GB) so we have a little security margin, shrink /dev/md2 to 30GB, and the resize the file system (again with resize2fs) to the max. possible value:

    resize2fs /dev/md2 25G

Now we shrink /dev/md2 to 30GB. The --size value must be in KiBytes (30 x 1024 x 1024 = 31457280); make sure it can be divided by 64:

    mdadm --grow /dev/md2 --size=31457280

Next we grow the file system to the largest possible value (if you don't specify a size, resize2fs will use the largest possible value)...

    resize2fs /dev/md2

... and run a file system check again:

    e2fsck -f /dev/md2

That's it - you can now boot into the normal system again.

#### Growing An Intact Array

Boot into your rescue system and activate all needed modules:

    modprobe md
    modprobe linear
    modprobe multipath
    modprobe raid0
    modprobe raid1
    modprobe raid5
    modprobe raid6
    modprobe raid10

Then activate your RAID arrays:

    cp /etc/mdadm/mdadm.conf /etc/mdadm/mdadm.conf_orig
    mdadm --examine --scan >> /etc/mdadm/mdadm.conf

    mdadm -A --scan

Now we can grow /dev/md2 as follows:

    mdadm --grow /dev/md2 --size=max

--size=max means the largest possible value. You can as well specify a size in KiBytes (see previous chapter).

Then we run a file system check...

    e2fsck -f /dev/md2

..., resize the file system...

    resize2fs /dev/md2

... and check the file system again:

    e2fsck -f /dev/md2

Afterwards you can boot back into your normal system.

## Procédure courte pour resize un RAID1

1. Booter sur un live CD, style Linux Mint que j'ai utilisé
1. installer mdadm : apt-get install mdadm
1. charger les modules nécessaires : modprobe {mdio, md, raid0, raid1, raid5, raid6, raid10, linear, mulipath}
1. examiner l'état des RAID : mdadm --examine --scan
1. activer les volumes RAID trouvés : mdadm -A --scan
1. monter la partition : mount /dev/mdX /mnt
1. redimensionner le système de fichiers : btrfs filesystem resize -10G /mnt
1. umount /mnt
1. mettre un disque en faulty : mdadm /dev/md/RAID --fail /dev/sdaX
1. le retirer du RAID : mdadm /dev/md/RAID --remove /dev/sdaX
1. redimensionner la partition un poil plus grand que le fs : parted /dev/sda → resizepart X → end → Yes → quit
1. vérifier le système de fichier : btrfs check /dev/sdaX → echo $? pour être s^ur qu'il sort bien à 0 malgré les messages
1. réduire le RAID : mdadm --grow /dev/md/RAID --size=xxxx  (xxGB * 1024 * 1024) mais environ 500 Mo de moins que les partitions qui le composent !
1. rajouter le disque au RAID : mdadm /dev/md/RAID --add /dev/sdaX
1. attendre la reconstruction de la grappe : cat /proc/mdstat
1. faire pareil avec l'autre disque (étapes 8 à  14 mais pas la 13 !)
1. agrandir le RAID au max : mdadm --grow /dev/mdXXX --size max
1. reboot

