---
tags:
    - reseau
    - cli
---

## Shows how many packets are matched by each rule (iptables -Z to zero the counters)
    iptables -nvL 

## pour voir la table ARP

    arp 
    ip neigh 

## Voir le cheminement
    mtr traceroute tracepath

    socat -d -d -d - TCP4:www.server.tld:80

## dump the full iptables tables

    iptables-save

## Monitorer la BP sur iface

    iftop -nNpP -i <iface>