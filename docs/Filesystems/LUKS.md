---
tags:
    - cli
    - linux
    - fs
---

## Comment changer le mot de passe qui permet de le déverrouiller.

Tout d’abord, une fois la partition chiffrée montée, vous pouvez l’identifier avec cette commande :

    blkid | grep "crypto_LUKS"
    /dev/sda5: UUID="7a805bed-e309-44e0-8dfa-6994a13d29a1" TYPE="crypto_LUKS" PARTUUID="0001c467-05"
    /dev/sde1: UUID="1862f1c7-b546-4109-8a2d-03ce47baca6e" TYPE="crypto_LUKS" PARTUUID="8f60cf56-7a68-484d-83c4-2caf8aad230f"

Ensuite pour changer le mot de passe :

    cryptsetup luksChangeKey /dev/sde1

