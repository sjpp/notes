---
tags:
    - filesystem
---

# Step 1: Find inode number of any file using following command on terminal.

    ls -i /var/log/messages 13377 /var/log/messages 

# Step 2: Find File Creation Time (crtime)

    debugfs -R 'stat <inode_number>' /dev/sda1

# Nettoyage un NTFS inconsistent :

    ntfsfix /dev/sdX1