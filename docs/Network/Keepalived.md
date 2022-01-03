# Set up Keepalived VIP on RockyLinux

## Install package

On both nodes:

    dnf install keepalived

## Base config

On both nodes:

    vim /etc/sysctl.d/99-sysctl.conf
    net.ipv4.ip_nonlocal_bind=1
    sysctl -p

    firewall-cmd --add-rich-rule='rule protocol value="vrrp" accept' --permanent
    firewall-cmd --reloa

## On master node

    vim /etc/keepalived/keepalived.conf


```
! Configuration File for keepalived

global_defs {
   notification_email {
     toto@toto.com
   }
   notification_email_from toto@toto.com
   smtp_server smtp.toto.com
   smtp_connect_timeout 30
   router_id VIP_TOTO
   vrrp_skip_check_adv_addr
   vrrp_strict
   vrrp_garp_interval 0
   vrrp_gna_interval 0
}

vrrp_instance VI_1 {
    state MASTER
    interface ens18
    virtual_router_id 51
    priority 101
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.1.1
    }
}
```

## On backup node

    vim /etc/keepalived/keepalived.conf

```
! Configuration File for keepalived

global_defs {
   notification_email {
     toto@toto.com
   }
   notification_email_from toto@toto.com
   smtp_server smtp.toto.com
   smtp_connect_timeout 30
   router_id VIP_TOTO
   vrrp_skip_check_adv_addr
   vrrp_strict
   vrrp_garp_interval 0
   vrrp_gna_interval 0
}

vrrp_instance VI_1 {
    state BACKUP
    interface ens18
    virtual_router_id 51
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.1.1
    }
}
```

## On both nodes

    systemctl enable --now keepalived

Then check ip addresses
