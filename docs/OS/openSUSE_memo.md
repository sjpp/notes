---
tags:
    - opensuse
    - linux
    - server
---

## Zypper tricks

To ensure old kernels are purged, check `/etc/zypp/zypp.conf` for the lines

    multiversion = provides:multiversion(kernel)

and

    multiversion.kernels = latest,latest-1,running

and ensure both are uncommented.
(Refer to https://lizards.opensuse.org/tag/kernel-update/)

You will possibly need to create an empty file in `/boot` named `do_purge_kernels`, then run (as root):

    systemctl enable purge-kernels

Check the status by running:

    systemctl status purge-kernels

If this shows *inactive (dead)* or *not enabled*, it may be simply because there are no kernels to purge.

## Sort RPM packages by size

    rpm -q -a --queryformat "%{SIZE}\t%{INSTALLTIME:day} \
    %{BUILDTIME:day}\t %{SIZE}\t  %{ARCHIVESIZE}\t %{FILESIZES}\t %{LONGARCHIVESIZE}\t %{LONGFILESIZES}\t %{LONGSIZE}\t
    %-30{NAME}\t%15{VERSION}-%-7{RELEASE}\t%{arch} \
    %25{VENDOR}%25{PACKAGER} == %{DISTRIBUTION} %{DISTTAG}\n"   | sort --numeric-sort | cut --fields="2-" | tee rpmlist | less -S

