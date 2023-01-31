---
tags:
    - filesystem
---

## Step 1: Find inode number of any file using following command on terminal.

    ls -i /var/log/messages 13377 /var/log/messages 

## Step 2: Find File Creation Time (crtime)

    debugfs -R 'stat <inode_number>' /dev/sda1

## Clean an inconsistent NTFS volume

    ntfsfix /dev/sdX1
