---
tags:
    - server
    - linux
    - fs
---

## Fix LVM errors

**Exemple:**

    #Errors:
    /dev/sdk: read failed after 0 of 4096 at 6442442752: Input/output error
    /dev/sdk: read failed after 0 of 4096 at 4096: Input/output error

### Solution :

1) Check which Volume Group have the issue , run “vgscan” command .

2) Find out the Logical Volumes attached with that Volume Group .

3) Inactive the logical volumes as :

    lvchange -an <lv-name>

4) Inactive Volume group as :

    vgchange -an <vg-name>

5) Again Scan Volume group using “vgscan” .

6) Now activate the Volume Group :

    vgchange -ay <volume-group-name>

7) Run command “lvscan” , the error should be gone now .

8) Now activate the Logical Volume Name :

    lvchange -ay <lv-name>

## Resize filesystem with LVM

- resize disk in virtual machine manager (Proxmox or KVM)
- resize partition with `fdisk` or `parted`
- resize *pv*
    pvresize /dev/vdaX
- resize *lv* to full available size
    lvresize -l +100%FREE /dev/mapper/lv-xxx
- resize filesystem
    resize2fs /dev/mapper/lv-xxx
