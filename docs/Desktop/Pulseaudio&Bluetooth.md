---
tags:
    - desktop
    - cli
---

In case of trouble with bluetooth devices and PA sound output

Edit the file:

    /etc/pulse/default.pa

and comment out (with an # at the beginning of the line) the following line:

    load-module module-bluetooth-discover

now edit the file:

    /usr/bin/start-pulseaudio-x11

and after the lines:

    if [ x”$SESSION_MANAGER” != x ] ; then
        /usr/bin/pactl load-module module-x11-xsmp “display=$DISPLAY session_manager=$SESSION_MANAGER” > /dev/null
    fi

add the following line:

    /usr/bin/pactl load-module module-bluetooth-discover

Dans le fichier :

    /etc/bluetooth/main.conf

Changer

    ControllerMode = dual

en :

    ControllerMode = bredr


Si problème avec gDM:

    /var/lib/gdm/.pulse/client.conf
    autospawn = no
    daemon-binary = /bin/true


