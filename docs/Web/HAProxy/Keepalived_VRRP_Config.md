---
tags:
    - haproxy
    - server
---

## Config for VRPP between 2 HAProxies with keepalived

### Assumptions

- This works on *Ubuntu 14.04*
- haproxy-primary IP: 198.51.100.10
- haproxy-secondary IP: 198.51.100.20
- shared IP: 198.51.100.50
- Any DNS rules should point to the shared IP (198.51.100.50)

### Steps

- Add a firewall rule for keepalived # 224.0.0.18 is the keepalived multicast address

        sudo ufw allow in from 198.51.100.20 to 224.0.0.18 # on 198.51.100.10
        sudo ufw allow in from 198.51.100.10 to 224.0.0.18 # on 198.51.100.20

- Allow access to a shared IP address

        edit /etc/sysctl.conf
        set net.ipv4.ip_nonlocal_bind=1
        sudo sysctl -p # reload config change

- Install keepalived

        sudo apt-get install keepalived

- Configure keepalived on both servers

        Edit/create /etc/keepalived/keepalived.conf
        See example file below # the priority MUST be different on the primary and secondary servers!

- Restart keepalived

        sudo service keepalived restart

- Listen on the shared IP address

        Edit /etc/haproxy/haproxy.cfg
        bind 198.51.100.50:80

- Restart haproxy (on both haproxy servers)

        sudo service haproxy restart

- Verify proper failover

        primary: sudo ip addr show | grep eth0 # should list the shared IP
        secondary: sudo ip addr show | grep eth0 # should NOT list the shared IP
        primary: sudo service haproxy stop
        primary: sudo ip addr show | grep eth0 # should NOT list the shared IP
        secondary: sudo ip addr show | grep eth0 # should list the shared IP
        primary: sudo service haproxy start
        primary: sudo ip addr show | grep eth0 # should list the shared IP
        secondary: sudo ip addr show | grep eth0 # should NOT list the shared IP

---

    /etc/keepalived/keepalived.conf

    vrrp_script chk_haproxy {      # Requires keepalived-1.1.13
    script "killall -0 haproxy"  # cheaper than pidof
    interval 2 # check every 2 seconds
    weight 2 # add 2 points of priority if OK
    }
    vrrp_instance VI_1 {
    interface eth0
    state MASTER
    virtual_router_id 51
    priority 101 # 101 on primary, 100 on secondary
    virtual_ipaddress {
        198.51.100.50
    }
    track_script {
        chk_haproxy
    }
    }



