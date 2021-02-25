---
tags:
    - cli
    - network
---

## Piper du fifo via netcat (pour MPD)

* Mettre *nc* en écoute sur le port 1234

    nc -l 1234 

* Sur la machine distante :

    nc 192.168.11.90 1234 < /net/musique/mpd.fifo
