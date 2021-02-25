---
tags:
    - cli
    - linux
---

## How to fix a broken GRUB

* Démarrer sur un live

* Monter partition racine

    mount /dev/sda1 /mnt
    cd /mnt

* Monter les systèmes volatils

    mount -t proc proc proc/
    mount --rbind /sys sys/
    mount --rbind /dev dev/

* Chroot

    chroot /mnt

* MàJ du path

    export PATH=/bin:/sbin:/usr/sbin:/usr/bin

* Installer Grub (commande dépend de l'OS

    grub2-install /dev/sda
    update-grub || grub2-mkconfig -o /boot/grub/grub.cfg
    update-initramfs -u
