---
tags:
    - web
    - proxy
    - config
---

```
global
  log           /dev/log local6
  pidfile       /var/run/haproxy.pid
  chroot        /var/lib/haproxy
  maxconn       8192
  user          haproxy
  group         haproxy
  daemon
  stats socket /var/lib/haproxy/stats.socket mode 660 level admin

  # Default SSL material locations
  ca-base /etc/ssl/certs
  crt-base /etc/ssl/private

  # Default ciphers to use on SSL-enabled listening sockets.
  # For more information, see ciphers(1SSL). This list is from:
  #  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
  ####ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS
  ####ssl-default-bind-options no-sslv3

  ####tune.ssl.default-dh-param 2048

# LDAP and LDAP/STARTTLS
frontend ldap_service_front
  mode                  tcp
  log                   global
  bind                  ldap.company.com:389
  description           LDAP Service
  option                tcplog
  option                logasap
  option                socket-stats
  option                tcpka
  timeout client        5s
  default_backend       ldap_service_back

backend ldap_service_back
  server                ldap-1 ad-dc01.company.com:389 check fall 1 rise 1 inter 2s
  server                ldap-2 ad-dc02.company.com:389 check fall 1 rise 1 inter 2s
  server                ldap-3 ad-dc03.company.com:389 check fall 1 rise 1 inter 2s
  mode                  tcp
  balance               leastconn
  timeout server        2s
  timeout connect       1s
  option                tcpka
  # https://www.mail-archive.com/haproxy@formilux.org/msg17371.html
  option                tcp-check
  tcp-check             connect port 389
  tcp-check             send-binary 300c0201            # LDAP bind request "<ROOT>" simple
  tcp-check             send-binary 01                  # message ID
  tcp-check             send-binary 6007                # protocol Op
  tcp-check             send-binary 0201                # bind request
  tcp-check             send-binary 03                  # LDAP v3
  tcp-check             send-binary 04008000            # name, simple authentication
  tcp-check             expect binary 0a0100            # bind response + result code: success
  tcp-check             send-binary 30050201034200      # unbind request

# LDAPS
frontend ldapS_service_front
  mode                  tcp
  log                   global
  bind                  ldap.company.com:636 ssl crt /etc/ssl/private/ldap_company_com.PEM
  description           LDAPS Service
  option                tcplog
  option                logasap
  option                socket-stats
  option                tcpka
  timeout client        5s
  default_backend       ldaps_service_back

backend ldaps_service_back
  server                ldapS-1 ad-dc01.company.com:636 check fall 1 rise 1 inter 2s verify none check check-ssl
  server                ldapS-2 ad-dc02.company.com:636 check fall 1 rise 1 inter 2s verify none check check-ssl
  server                ldapS-3 ad-dc03.company.com:636 check fall 1 rise 1 inter 2s verify none check check-ssl
  mode                  tcp
  balance               leastconn
  timeout server        2s
  timeout connect       1s
  option                tcpka
  #
  option                tcp-check
  tcp-check             connect port 636 ssl
  tcp-check             send-binary 300c0201            # LDAP bind request "<ROOT>" simple
  tcp-check             send-binary 01                  # message ID
  tcp-check             send-binary 6007                # protocol Op
  tcp-check             send-binary 0201                # bind request
  tcp-check             send-binary 03                  # LDAP v3
  tcp-check             send-binary 04008000            # name, simple authentication
  tcp-check             expect binary 0a0100            # bind response + result code: success
  tcp-check             send-binary 30050201034200      # unbind request
```