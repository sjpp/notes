---
tags:
    - ldap
    - server
---

https://ltb-project.org/documentation/nagios-plugins

## Get current connections number

    perl check_ldap_monitor.pl -vvv -H localhost -D cn=monitor,dc=server,dc=tld -P password  -T currentconnections -w 250 -c 300 -m greater -f

## Check that a record is present

    perl check_ldap_dn.pl -H localhost -p 389 -D cn=monitor,dc=server,dc=tld -W password -b cn=Active,cn=Threads,cn=monitor

## Count the number of returned records

    perl check_ldap_query.pl -H localhost -p 389 -D cn=monitor,dc=server,dc=tld -P password -b cn=Open,cn=Threads,cn=monitor -w 200 -c 250 -m greater -v

## Monitoring

https://www.openldap.org/doc/admin24/monitoringslapd.html

* Example

        ldapsearch -h localhost -D cn=monitor,dc=server,dc=tld -b cn=Tasklist,cn=Threads,cn=monitor -w password -s sub '(objectClass=\*)' '*' '+'

* Report only a specific metric

        ldapsearch -h localhost -D cn=monitor,dc=server,dc=tld -b cn=Read,cn=Waiters,cn=monitor -w password -LL -s sub '(objectClass=*)' monitorCounter | grep monitorCounter | cut -d" " -f2
