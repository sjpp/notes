---
tags:
    - server
    - virt
---

## Virt-Manager tricks

### USB Redirection

* ACL Error :

    chmod u+s /usr/bin/spice-client-glib-usb-acl-helper

* No root password asked :

    /usr/share/polkit-1/actions/org.spice-spice.lowlevelusbaccess.policy.

Before changes I had follow

    <allow_any>auth_admin</allow_any>
    <allow_inactive>no</allow_inactive>
    <allow_active>auth_admin</allow_active>

After I have

    <allow_any>yes</allow_any>
    <allow_inactive>no</allow_inactive>
    <allow_active>yes</allow_active>

