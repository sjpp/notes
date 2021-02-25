---
tags:
    - server
    - linux
    - fs
---

## SFDISK

### Background:

Each drive has 1 partition table.
A partition table can have a maximum of 4 primary partitions. If the drive is called sdc, the the primary partitions are called sdc1, sdc2, sdc3, sdc4.
A partition table can have at most 1 extended partition. The extended partition must also have a name whose numerical part is between 1 and 4: that is, the extended partition must be named sdc1 or sdc2 or sdc3 or sdc4.
Logical partitions always have device names whose numerical part is greater than or equal to 5. (e.g. sdc5, sdc6, etc.)
The partition table is located at sectors 447--512 on the drive.
A sector = 512 bytes.
You can save the partition table in its native binary format with the command

    sudo dd if=/dev/sdc of=PT_sdc.img bs=1 count=66 skip=446

and you can restore the partition table with the command

    sudo dd of=/dev/sdc if=PT_sdc.img bs=1 count=66 skip=446

I mention this so you can have a picture in your mind about where the partition table is located. We won't be using dd to manipulate the partition table, however. We'll use sfdisk instead.

## The sfdisk commands

You can save the partition table in an ascii format with the command

    sudo sfdisk -d /dev/sdc > PT.txt

This saves the partition table on /dev/sdc to a file called PT.txt.
What's particularly lovely is that is file is in ASCII format.

You can edit it in a normal text editor, then tell sfdisk to write a new partition table based on our edited PT.txt:

    sudo sfdisk --no-reread -f /dev/sdc -O PT.save < PT.txt

"--no-reread" means don't check if disk is unmounted
-f force
"-O PT.save" means save a backup of original partition table in PT.save. PT.save is in binary format.

### To restore the partition table using PT.save

    sudo sfdisk --force -I PT.save /dev/sdc

#### Transfer part table

    sfdisk -d /dev/sda | sfdisk --force /dev/sdb

#### GPT part table

    apt-get install gdisk

#### clone GPT table from /dev/sda to /dev/sdb

    sgdisk -R=/dev/sdb /dev/sda

#### make unique its GUID as it was cloned and is identical with /dev/sda

    sgdisk -G /dev/sdb

