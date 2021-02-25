---
tags:
    - network
---

# CARP (openBSD)

## Si un FW master a basculé en backup

    ifconfig -g carp

## le compte le plus petit est Master, donc augmenter le compte de celui qui doit passer en Backup :

    ifconfig -g carp carpdemote 40

