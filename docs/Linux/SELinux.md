---
tags:
    - server
    - linux
---

## SELINUX tricks

### Changer le contexte des objets http

    chcon -R -v --type=httpd_sys_content_t /srv/repo/path/

### Rendre ce réglage persistent

    semanage fcontext -a -t httpd_sys_content_t "/srv/repo/path(/.*)?"

### désactier selinux temp

    setenforce 0

### voir status

    sestatus

### Preserving SELinux Contexts When Copying

Use the cp --preserve=context command to preserve contexts when copying:

    touch file1
    ls -Z file1
    -rw-rw-r--  user1 group1 unconfined_u:object_r:user_home_t:s0 file1
    ls -dZ /var/www/html/
    drwxr-xr-x  root root system_u:object_r:httpd_sys_content_t:s0 /var/www/html/
    cp --preserve=context file1 /var/www/html/
    ls -Z /var/www/html/file1
    -rw-r--r--  root root unconfined_u:object_r:user_home_t:s0 /var/www/html/file1

