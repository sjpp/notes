---
tags:
    - linux
    - rpm
---

## Configuring with the command line

### See a list of all enabled repos

    sudo dnf repolist

### Change configuration for just one command. To enable or disable a repo just once, use a command option:

    sudo dnf --enablerepo=<reponame>...
    sudo dnf --disablerepo=<reponame>...

### For instance, to install the latest kernel from Fedora’s test repo:

    sudo dnf --enablerepo=updates-testing install kernel\*

### You can combine several enable and disable options together. For example:

    sudo dnf --enablerepo=repo1 --disablerepo=repo2,repo3 install <package>

### If you want to change the defaults permanently, use these commands:

    sudo dnf config-manager --set-enabled <reponame>
    sudo dnf config-manager --set-disabled <reponame>

Perhaps you install, update, or remove a lot of software using different setups. In this case, things may get confusing. You might not know which software is installed from what repos. If that happens, try this.

### First, disable extra repos such as those ending in –testing. Ideally, enable only fedora and updates repos. Run this command for each unwanted repo:

    sudo dnf config-manager --set-disabled <unwanted-repo>

### Then run this command to synchronize your system with just stable, updated packages:

    sudo dnf distro-sync

This ensures your Fedora system is only using the latest packages from specific repos.
