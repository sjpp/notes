---
tags:
    - fs
    - linux
    - various
---

## How to create an "img" disk

* The necessary commands to perform this task are as follows:

    dd if=/dev/zero of=floppy.img bs=1k count=1440

    sudo losetup /dev/loop0 floppy.img
    sudo mkfs -t vfat /dev/loop0

    sudo losetup -d /dev/loop0

    sudo mkdir /media/floppy

    sudo mount floppy.img /media/floppy

    sudo cp * /media/floppy

    sudo umount /media/floppy

    sudo rmdir /media/floppy
