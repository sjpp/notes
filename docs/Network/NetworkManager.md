---
tags:
    - reseau
    - cli
    - gnome
---

# Start shell script on Network Manager successful connection
*by Marko*

The other day I was writing a script that needed to do its job only when specific network interface is triggered (wireless broadband ppp0 in my case). Pinging Google every 10 seconds to detect Internet access was out of the question. There is a more elegant way to do this. If you are interested please proceed.

Do you know that authors of Network Manager built option to trigger scripts right into this great application. To use this option you need to write bash script with some specific bash variables and put it to "/etc/NetworkManager/dispatcher.d/" directory. Specific variables are necessary to receive instructions from Network Manager about network interface that triggers execution of your script and should it be executed on "up" or "down" operation on that interface.

The following example script starts *command1* after **ppp0** goes "up", "command2" just before ppp0 goes "down", "command3" just before ppp0 is "up", and "command4" just after ppp0 goes "down". Replace commands with what you want to accomplish, you can leave some of the command "fields" blank if you're not interested in some use cases like "pre-up" or "post-down".

    #!/bin/bash
    
    IF=$1
    STATUS=$2
    
    if [ "$IF" == "ppp0" ]
    then
        case "$2" in
            up)
            logger -s "NM Script up triggered"
            command1
            ;;
            down)
            logger -s "NM Script down triggered"
            command2
            ;;
            pre-up)
            logger -s "NM Script pre-up triggered"
            command3
            ;;
            post-down)
            logger -s "NM Script post-down triggered"
            command4
            ;;
            *)
            ;;
        esac
    fi

This "90" in the name of the script means that this script will be executed in the last 10% of all scripts if you have a bunch of scripts to execute when your interface starts. You probably don't have any other scrips in "/etc/NetworkManager/dispatcher.d/" directory but this option is here if you need it. Now we should give permission to execute by doing "chmod +x" on our script and copy it in place.

    chmod +x /home/$USER/Desktop/90myscriptname.sh
    sudo cp /home/$USER/Desktop/90myscriptname.sh /etc/NetworkManager/dispatcher.d/90myscriptname.sh
    
Finally we will monitor `/var/log/syslog` as it changes to make sure that everything is in order:

    sudo tail -f /var/log/syslog

If everything is OK you will see "NM Script action triggered" when you connect or disconnect network interface in question. If not, retrace your steps and double check everything.