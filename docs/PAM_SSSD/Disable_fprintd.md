# Disable fprintd

## Issue

Problem was found in CentOS, GDM was wainting for service to start before accepting password input.

**Log excerpt**

    juin 23 19:09:48 .net dbus-daemon[1338]: [system] Activating via systemd: service name='net.reactivated.Fprint' unit='fprintd.service' requested by ':1.218' (uid=1573400>
    juin 23 19:09:48 .net systemd[1]: Starting Fingerprint Authentication Daemon...
    juin 23 19:09:48 .net dbus-daemon[1338]: [system] Successfully activated service 'net.reactivated.Fprint'
    juin 23 19:09:48 .net systemd[1]: Started Fingerprint Authentication Daemon.


**Service status**

    [ root .net ~ ] systemctl status fprintd.service 
    ● fprintd.service - Fingerprint Authentication Daemon
    Loaded: loaded (/usr/lib/systemd/system/fprintd.service; static; vendor preset: disabled)
    Active: active (running) since Tue 2020-06-23 19:11:22 CEST; 24s ago
        Docs: man:fprintd(1)
    Main PID: 5801 (fprintd)
        Tasks: 3 (limit: 48352)
    Memory: 3.8M
    CGroup: /system.slice/fprintd.service
            └─5801 /usr/libexec/fprintd

    juin 23 19:11:22 .net systemd[1]: Starting Fingerprint Authentication Daemon...
    juin 23 19:11:22 .net systemd[1]: Started Fingerprint Authentication Daemon.

## Solution

    [ root .net ~ ] authconfig --disablefingerprint --update
    Running authconfig compatibility tool.
    The purpose of this tool is to enable authentication against chosen services with authselect and minimum configuration. It does not provide all capabilities of authconfig.

    IMPORTANT: authconfig is replaced by authselect, please update your scripts.
    See man authselect-migration(7) to help you with migration to authselect

    Executing: /usr/bin/authselect check
    Executing: /usr/bin/authselect select sssd --force

    dnf remove fprintd-pam fprintd
