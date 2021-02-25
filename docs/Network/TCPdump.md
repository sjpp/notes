---
tags:
    - network
    - cli
---

## Pipe tcpdump into Wireshark

    ssh root@server.tld tcpdump -i any -s0 -v -w - port not ssh | wireshark -k -i -