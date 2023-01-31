---
tags:
    - network
    - systemd
    - cli
---

## Launch an app in network jail

You may try network namespaces: https://lmddgtfy.net/?q=linux%20netns

You can create a new network namespace, without attaching any interfaces
to it, and run your application in it.

Example:

    sudo ip netns add isolated
    sudo ip netns exec isolated sudo -u my_username -i

This will start new shell session running as your user, but without any
access to network.

If you want to start graphical application in it, you need to execute

    export DISPLAY=unix:0

