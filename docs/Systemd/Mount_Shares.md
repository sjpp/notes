# Mount via Systemd Units

Si vous connectez des partages réseau NFS ou CIFS (Samba) via une connexion Wi-Fi gérée par Network-Manager, vous avez peut-être constaté qu'à l'extinction de votre machine, le démontage du partage ne se fait pas correctement et bloque l'arrêt durant un certain laps de temps (généralement 1min30).
Ceci est dû au fait que l'accès au réseau Wi-Fi est stoppé avant le démontage propre du partage.

C'est un problème qui m'a embêté de temps en temps à la maison, voici une parade simple. Elle consiste à créer un service systemd qui ne fait rien en démarrant mais force le démontage des partages lorsque vous fermez votre session (déconnexion ou arrêt/redémarrage de la machine).

Il faut créer le fichier `/etc/systemd/system/umount-shares.service` avec le contenu suivant :

    # /etc/systemd/system/umount_nfs.servic e
    [Unit]
    Description=Force umount NFS shares
    Before=network.target graphical.target

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    ExecStart=/bin/true
    ExecStop=/usr/bin/umount -a -f -t nfs,nfs4,cifs

    [Install]
    WantedBy=default.target

    Puis l'activer et le démarrer :

    systemctl enable umount-shares.service
    systemctl start umount-shares.service

Ainsi plus d'arrêt qui attend dans le vide un *stop job for xxx* parce qu'un partage réseau ne peut se démonter.