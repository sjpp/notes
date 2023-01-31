---
tags:
    - cli
    - linux
    - fs
---

## Change LUKS passphrase

Mount the partition and use the following to identified it:

    blkid | grep "crypto_LUKS"
    /dev/sda5: UUID="7a805bed-e309-44e0-8dfa-6994a13d29a1" TYPE="crypto_LUKS" PARTUUID="0001c467-05"
    /dev/sde1: UUID="1862f1c7-b546-4109-8a2d-03ce47baca6e" TYPE="crypto_LUKS" PARTUUID="8f60cf56-7a68-484d-83c4-2caf8aad230f"

Then set the new passphrase:

    cryptsetup luksChangeKey /dev/sde1

