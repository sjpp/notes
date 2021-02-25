---
tags:
    - ldap
    - server
---

https://ltb-project.org/documentation/nagios-plugins

## Nombre de connexions en court

    perl check_ldap_monitor.pl -vvv -H localhost -D cn=monitor,dc=server,dc=tld -P password  -T currentconnections -w 250 -c 300 -m greater -f

## Vérifier la présence d'un enregistrement

    perl check_ldap_dn.pl -H localhost -p 389 -D cn=monitor,dc=server,dc=tld -W password -b cn=Active,cn=Threads,cn=monitor

## Compter le nombre d'entrées retournées

    perl check_ldap_query.pl -H localhost -p 389 -D cn=monitor,dc=server,dc=tld -P password -b cn=Open,cn=Threads,cn=monitor -w 200 -c 250 -m greater -v

## Monitorer certaines métriques

https://www.openldap.org/doc/admin24/monitoringslapd.html

* Exemple

        ldapsearch -h localhost -D cn=monitor,dc=server,dc=tld -b cn=Tasklist,cn=Threads,cn=monitor -w password -s sub '(objectClass=\*)' '*' '+'

* Reporter seulement la métrique souhaitée:

        ldapsearch -h localhost -D cn=monitor,dc=server,dc=tld -b cn=Read,cn=Waiters,cn=monitor -w password -LL -s sub '(objectClass=*)' monitorCounter | grep monitorCounter | cut -d" " -f2