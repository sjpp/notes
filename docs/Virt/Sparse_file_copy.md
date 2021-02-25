---
tags:
    - qemu
    - server
    - linux
    - fs
---

# Copier un fichier sparse sur le réseau

Les fichiers dits « sparse » sont alloués avec une taille supérieur à la taille réellement occupée sur le disque dur. Cela permet de n’occuper l’espace disque que si le fichier fait face à un accroissement. On les rencontre couramment en virtualisation où l’on parle aussi de « thin provisioning ».

Le terme « sparse » se traduit par « clairsemé » en français et « thin provisionning » par « provisionnement allégé ».

Avec rsync et l’option -S ou –sparse permet de respecter le caractère « sparse » du fichier qui ne prendra pas plus de place disque sur la source que sur la cible. Cependant l’utilisation de cette option a un inconvénient : la taille d’allocation totale transite par le réseau, ce qui est peu efficient.

Pour éviter ce désagrément on peut faire appel à une archive tar en mode sparse (-S). Le fichier obtenu peut ainsi être transféré via n’importe quel protocole pour être dé-taré sur place.

    tar Scvf image.qcow2.tar image.qcow2
    rsync image.qcow2.tar serveur-cible:/chemin/
     
    tar Scvf image.qcow2.tar image.qcow2
    rsync image.qcow2.tar serveur-cible:/chemin/

Une variante consiste à utiliser tar en mode flux avec un pipe comme indiqué sur cette page « How to copy sparse files faster« .

    tar cvzSpf – image.qcow2 | ssh user@serveur-distant ‘(cd /tmp; tar xzSpf -)’
	
    tar cvzSpf – image.qcow2 | ssh user@serveur-distant ‘(cd /tmp; tar xzSpf -)’

L’utilisation de tar conjointement avec SSH est une bonne idée afin de bénéficier de l’option sparse, mais aussi pour remplir les trames réseau et accélérer les échanges par rapport à rsync, en particulier en cas de petits fichiers. Voir différent exemples ici ou encore celui qui suit.

    tar -cS /dossier | ssh serveur-distant 'tar -xvf - -C /destination/'
    tar -cS /dossier | ssh serveur-distant 'tar -xvf - -C /destination/'
