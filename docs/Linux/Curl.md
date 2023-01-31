---
tags:
    - web
    - curl
    - cli
    - mail
    - imap
---

## Basic example

    curl -v -s https://linuxfr.org

## Get a file

    curl -ROL https://fichier

## To tell curl to use a user and password for authentication:

    curl --user name:password http://www.example.com

##  Resolve on a different name

    curl --resolve www.server.com:443:213.162.53.103 https://www.server.com/

##  Mail

    curl -v imap://user:password@in.server.com/
    curl “imaps://user:password@in.example.com/”

##  In case you need to use “special” chars like @ you have to escape in according to  RFC 3986 | Example (password: p@ssword) @ is escaped using %40

    curl “imap://username:p%40ssword@in.example.com”

##  Check new email INBOX

    curl “imap://username:password@in.example.com/INBOX?NEW”
    curl “imap://username:password@in.example.com/<FOLDER>;UID=<UID_NUMBER>”
