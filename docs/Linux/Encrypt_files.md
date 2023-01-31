---
tags:
    - cli
---

## Encrypt

    cat file | openssl aes-256-cbc -a -salt -out file_encrypted

## Decrypt

    cat file_encrypted | openssl aes-256-cbc -a -d -salt -out file_decrypted
