---
tags:
    - cli
    - linux
---

## List thread of a process

    ps -C firefox -L -o pid,tid,pcpu,state,nlwp,cmd 

## See used Resident Memory

    ps -eF --sort -rss

## Sort by process using SWAP

    (echo "COMM PID SWAP"; for file in /proc/*/status ; do awk '/^Pid|VmSwap|Name/{printf $2 " " $3}END{ print ""}' $file; done | grep kB | grep -wv "0 kB" | sort -k 3 -n -r) | column -t
