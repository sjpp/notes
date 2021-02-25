---
tags:
    - virt
    - system
    - qemu
    - filesystem
---

# Mounting a QEMU Image

In order to mount a QUMU / KVM disk image you need to use **qemu-nbd**, which lets you use the NBD protocol to share the disk image on the network.

First you need the module loaded:

    sudo modprobe nbd max_part=8

Then you can share the disk on the network and create the device entries:

    sudo qemu-nbd --connect=/dev/nbd0 file.qcow2

Then you mount it:

    sudo mount /dev/nbd0p1 /mnt/kvm

When done, unmount and unshare it:

    sudo umount /mnt/kvm
    sudo nbd-client -d /dev/nbd0