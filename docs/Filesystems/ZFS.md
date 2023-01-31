---
tags:
    - fs
    - server
    - linux
---

## ZFS tips and tricks

### Create pool with raid

    zpool create raidz2 <pool name> <disk1> ... <diskN>

Create pool with RAID 5 double parity

### ZFS caches

* ARC: RAM cache
* L2ARC: *Level 2 ARC*, on SSD, no need for redundancy
* ZIL (ZFS Intent Log) SLOG (Separate intent Log): persistent write cache, redundancy needed

#### Add L2ARC cache to existing pool

    zpool add <pool name> cache <disk>

#### Add SLOG disk cache to existing pool

    zpool add <pool name> log mirror <disk ssd1> <disk ssd2>

### Stats

#### View iostat

**Since boot**

    zpool iostat

**Dynamic view with 1sec interval**

    zpool iostat 1

**including virtual drives**

    zpool iostat 1 -v

### Quotas

    zfs set quota=XXG <pool name>

### Manage cache file

**Re-generate the `zpool.cache` configuration file**

    zpool set cachefile=/etc/zfs/zpool.cache <pool name>