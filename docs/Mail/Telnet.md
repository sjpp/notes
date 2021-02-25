---
tags:
    - cli
    - linux
    - network
---

# Use Telnet to send mail

    telnet mail.server.tld 25
    EHLO my.host.name
    MAIL FROM: <me@address.com>
    RCPT TO: <you@other.net>
    DATA
    Subject: Test
    
    Blabla

    .
    250 2.0.0 Ok: queued as XXXXXXX

