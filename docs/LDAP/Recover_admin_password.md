---
tags:
    - ldap
---

# Recover admin password lost

## Stop service
    service slapd stop

## Save ldap base
    slapcat -n 2 > /root/slapcat.txt

## Remove ldap base
    mkdir /tmp/ldap.bak
    mv /var/lib/ldap/* /tmp/ldap.bak/

## Edit file
    vim slapcat.txt
    ##=> change admin password

## Import base
    slapadd -l /root/slapcat.txt  -n 2

## Set rights
    chown -R openldap:openldap /var/lib/ldap/

## Restart service
    service slapd start