---
tags:
    - server
    - network
    - pxe
---

## Mise en place d'un serveur Clonezilla via PXE

### Pré-requis et notions préliminaires

Le serveur PXE utilise Debian GNU/Linux en tant que système d'exploitation.
Le serveur PXE (Preboot eXecution Environment, environnement de démarrage d'ordinateurs en réseau) aura ici pour but de fournir aux postes clients connectés une image ISO bootable de Clonezilla en vue du déploiement d'images openSUSE adaptées aux spécificités d'Éveha.

Des paquets doivent être installés, le serveur doit donc avoir une connexion Internet lors de sa mise en place.
Par la suite, le serveur peut n'avoir qu'une seule interface réseau configurée comme suit:

    adresse IP : 192.168.1.1
    netmask    : 255.255.255.0
    broadcast  : 192.168.1.255
    network    : 192.168.1.0 (réseau privée entre serveur et clients)
    gateway    : 192.168.1.1 (le serveur lui-même, aucune importance dans ce cadre)
    nameserver : 127.0.0.1   (le serveur lui-même, aucune importance dans ce cadre)

Le serveur va fournir un service DHCP au sein du réseau privé, il est donc important qu'il ne soit pas relié au réseau extérieur afin d'éviter tout conflit dans la fourniture du service DHCP.

### Installation des paquets nécessaires

    apt-get install isc-dhcp-server tftpd-hpa syslinux pxe nfs-kernel-server

### Configuration du service DHCP sur le serveur

Ce paquet fournit le daemon dhcpd et le service isc-dhcp-server.

Il se configure via le fichier /etc/dhcp/dhcpd.conf, il faut ajouter ce qui suit:

    # Début de configuration du service DHCP
    #
    # Déclaration des leases et plages de service du serveur PXE:

    subnet 192.168.1.0 netmask 255.255.255.0 {
        range 192.168.1.10 192.168.1.20; # à adapter aux nombres de postes clients
        option broadcast-address 192.168.1.255;
        option routers 192.168.1.1;      # IP du serveur PXE si on veut faire du routage
        option domain-name-servers 192.168.1.1; # idem
        filename "pxelinux.0";
    }

    group {
        next-server 192.168.1.1; # si nécessaire
        host tftpclient {
            filename "pxelinux.0";
        }
    }

    #
    # Fin de configuration du service DHCP

Puis redémarrer le service:

    service isc-dhcp-server restart

Il est possible que l'on obtienne un fail si aucun client n'est connecté ou que la connexion est inactive.

### Configuration du service TFTP sur le serveur

Ce service se configure comme suit via le fichier /etc/default/tftpd-hpa:

    # Début de configuration du service TFTP:
    # 

    TFTP_USERNAME="tftp"
    TFTP_DIRECTORY="/srv/tftp"
    TFTP_ADDRESS="0.0.0.0:69"
    TFTP_OPTIONS="--secure"

    #
    # Fin de configuration du service TFTP

Puis redémarrer le service:

    service tftpd-hpa restart

Ceci peut échouer dans le cas où le dossier /srv/tftp/ n'est pas présent (il est normalement créé automatiquement à l'installation du paquet), il suffit alors de le créer.

### Préparation et mise en place de l'image Clonezilla

Télécharger une image .iso live de Clonezilla:

    wget http://heanet.dl.sourceforge.net/project/clonezilla/clonezilla_live_stable/2.2.3-25/clonezilla-live-2.2.3-25-amd64.iso

Monter l'image dans /mnt:

    mount -o loop -t iso9660 /root/clonezilla-live-2.2.3-25-amd64.iso /mnt

Copier tous les fichiers dans le dossier réservé du serveur tftp:

    cp -ar /mnt/* /srv/tftp/clonezilla

### Configuration du serveur NFS

Les images des systèmes que nous souhaitons booter à distance vont être servis aux clients via un partage NFS.

#### Mise en place des exports NFS

Création du dossier contenant l'image live de Clonezilla:

    mkdir /srv/tftp/clonezilla
    emacs (ou vi) /etc/exports

et ajout des lignes correspondantes:

    /srv/tftp/clonezilla 192.168.1.0/24(async,no_root_squash,no_subtree_check,ro)

Note: l'IP et le masque CIDR sont à adapter au réseau et l'image doit être de préférence en read-only.

Puis on active les partages NFS:

    service nfs-kernel-server restart

Et on les vérifie:

    exportfs -v

Cette commande doit renvoyer la liste des partages actifs.

### Mise en place d'une image de boot

Le paquet syslinux fournit une collection de bootloader dont certains nous seront nécessaires pour démarrer en PXE et afficher le menu qui va bien.

#### Copie des éléments nécessaires

    cd /usr/lib/syslinux
    cp chain.c32 mboot.c32 menu.c32 pxelinux.0 reboot.c32 vesamenu.c32 -t /srv/tftp/

#### Configuration du service PXE

    emacs (ou vi) /etc/pxe.conf

    # Début de configuration du service PXE:
    # 
    # which interface to use:
    interface=eth0
    default_address=192.168.1.1

    # tftpd base dir:
    tftpdbase=/srv/tftp

    # domain name:
    domain=domain.fr
    #
    # Fin de configuration du service PXE

#### Mise en place du dossier et fichier menu PXE

    mkdir /srv/tftp/pxelinux.cfg
    emacs (ou vi) /srv/tftp/pxelinux.cfg/default

Ce fichier va contenir les instructions pour le menu de boot via PXE

    # Début de configuration du menu PXE:
    # 

    # Interface visuelle:
    DEFAULT vesamenu.c32
    MENU TITLE Bienvenue sur le serveur Clonezilla
    prompt 0
    kbdmap french.kbd

    # Entrée du menu Clonezilla
    LABEL Demarrer Clonezilla
        KERNEL clonezilla/live/vmlinuz
        APPEND boot=live rootfstype=nfs netboot=nfs nfsroot=192.168.1.1:/srv/tftp/clonezilla initrd=clonezilla/live/initrd.img config --

    # Entrée du menu de redémarrage
    LABEL Reboot
        MENU LABEL Redemarrer
        KERNEL reboot.c32

    #
    # Fin de configuration du menu PXE

Un chmod -R 775 dans ce même dossier peut être nécessaire pour que le daemon TFTPD puisse les lire.

### Spécificités de Clonezilla

L'idée étant de booter sur un live Clonezilla pour créer et déployer des images disques, nous allons adapter notre environnement à ce but:

(/partimag est le dossier par défaut de Clonezilla, on peut mettre autre chose mais cela implique de le spécifier manuellement à chaque clonage/copie.)

Ces images vont transiter par un partage NFS sur un NAS:

    IP du NAS: 192.168.87.21
    Nom du NAS: nfsclone
    Version de NFS: NFSv4
    Emplacement du dossier partagé: /volume1/partimag

### Utilisation du serveur

Il ne reste plus qu'à connecter les clients, les démarrer via PXE, sélectionner l'entrée de menu 'Clonezilla'.
Le reste est une utilisation classique de Clonezilla à ceci près que les images vont être écrites/lues vers/depuis un partage NFS.
