---
tags:
    - apache
    - linux
---

## Apache Mod_proxy '[Error] (13)Permission Denied' Error on RHEL

Had an interesting issue today working on a mod_proxy setup of Apache forwarding requests in a reverse proxy setup to a backend Tomcat server. No matter what I did, I kept getting this in Apache’s error log:

    [error] (13)Permission denied: proxy: AJP: attempt to connect to 10.x.x.x:7009 (virtualhost.virtualdomain.com) failed

I thought for sure it was proxy permissions, but nothing I did fixed the issue. Then it hit me: SELinux! Why I always think of SELinux last when it’s responsible for 90% of my problems, I’ll never know. SELinux on RHEL/CentOS by default ships so that httpd processes cannot initiate outbound connections, which is just what mod_proxy attempts to do. If this is your problem, you’ll see something like this in /var/log/audit/audit.log:

    type=AVC msg=audit(1265039669.305:14): avc:  denied  { name_connect } for  pid=4343 comm="httpd" dest=7009 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:port_t:s0 tclass=tcp_socket

To fix this, first test by setting the boolean dynamically (not permanent yet):

    /usr/sbin/setsebool httpd_can_network_connect 1

If that works, you can set it so that the default policy is changed and this setting will persist across reboots:

    /usr/sbin/setsebool -P httpd_can_network_connect 1