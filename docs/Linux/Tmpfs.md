# Add userland tmpfs

1. Create dir

    mkdir $HOME/tmp

2. Add entry in `/etc/fstab`

    tmpfs                                   /home/sebastien/tmp     tmpfs   user,exec,rw,size=2G                0 0
