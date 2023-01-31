---
tags:
    - linux
---

Start with busybox in Grub

    init=/bin/busybox

Use it:

    busybox-static ls # ou dmesg ou autre commande

Like it states in --help output: create some symlinks to it:

    mkdir xxx
    cd xxx
    for f in $(/usr/bin/busybox-static --list); do \
    ln -s /usr/bin/busybox-static $f; done
    ./uname
    Linux

FWIW: one could also build the 'coreutils' package to have an all-in-one program which acts the same:

    ./configure --help
    ...
    --enable-single-binary=shebangs|symlinks
                            Compile all the tools in a single binary, reducing
                            the overall size. When compiled this way, shebangs
                            (default when enabled) or symlinks are installed for
                            each tool that points to the single binary.
