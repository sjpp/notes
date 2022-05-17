---
tags:
    - network
    - cli
    - ssh
---

## Start graphical app via SSH

You have to set DISPLAY and XAUTHORITY properly, e.g.:

    ssh host

on host:

    export DISPLAY=:0.0
    export XAUTHORITY=$HOME/.local/share/sddm/.Xauthority
    start_graphical_application

## Pipe between 2 servers

    ssh server1 'cat /root/file' | ssh server2 'cat > destfile'

## Reverse SSH

### Connexion directe

#### Création d'un utilisateur dédié sur le poste local

Créez un nouvel utilisateur spécialement pour cette connexion afin que l'utilisateur userD du poste distant ne puisse pas avoir un accès complet au poste local. Ce nouvel utilisateur créé pourra cependant avoir des droits personnalisés.
Saisissez dans un terminal sur local la commande suivante :

	sudo adduser --no-create-home userL

où :

* –no-create-home est l'option spécifiée pour ne pas créer de dossier /home/userL sur le poste local.
* userL est à remplacer par le nom de votre choix mais suffisamment explicite pour savoir sur quelle machine vous êtes. Le mot de passe créé servira pour se connecter lors de l'étape suivante.


#### Connexion au poste local depuis le poste distant

Initiez une connexion à local en saisissant sur le poste distant:

	ssh -NR 12345:localhost:22 userL@local

où

* 12345 est à remplacer par un numéro de port aléatoire (entre 1024 et 65535 qui sont réservés pour des applications utilisateurs) et non utilisé de votre choix
* userL et le mot de passe de connexion sont ceux défini précédemment.
* local est l'adresse IP publique de la machine locale (au besoin avec une règle NAT dans la box locale pour être joignable de l'extérieur)

#### Connexion au poste distant depuis le poste local

La connexion étant désormais activée depuis distant vers local, le pare-feu va donc laisser rentrer la connexion reverse, à savoir depuis local vers distant.
Pour cela taper dans un terminal sur local:

	ssh -p 12345 userD@localhost

où


* 12345 est le port choisi auparavant
* userD est à remplacer par le nom d'utilisateur permettant de se connecter au serveur ssh sur distant

Cette configuration est pratique quand le poste local est lui-même derrière un pare-feu et/ou ne dispose pas d'un serveur ssh. Prenez l'exemple de configuration suivant:

### Connexion par serveur tiers

userD@distant et userL@local ne sont pas accessibles depuis l'extérieur

Ici

* userD@distant correspond à l'utilisateur userD, sur le poste appelé distant qui a les ports entrants bloqués et donc inaccessible depuis l'extérieur
* userS@serveur correspond à l'utilisateur userS, sur le poste appelé serveur qui dispose d'un accès libre à son serveur ssh.
* userL@local correspond à l'utilisateur userL, sur le poste appelé local qui va accéder à la machine serveur pour atteindre distant

Pour résumé le principe, il s'agira de:

* connecter distant sur serveur
* connecter local sur serveur
* depuis le terminal qui a initié la connexion local sur serveur pour atteindre distant

#### Création d'un utilisateur dédié sur le poste serveur

Cette partie est facultative si la machine serveur dispose déjà d'un utilisateur public

Taper dans un terminal :

	sudo adduser --no-create-home userS

#### Connexion sur le poste serveur depuis le poste distant

Initiez une connexion sur serveur en tapant dans un terminal de la machine distant :

	ssh -R 12345:localhost:22 userS@serveur

où


* 12345 est à remplacer par un numéro de port aléatoire de votre choix,
* le port 22 est le port d'écoute ssh sur la machine distant,
* userS et le mot de passe de connexion sont ceux défini précédemment
* serveur est l'adresse ip ou le nom de domaine du serveur tiers


!!! note
    L'option -N peut également être ajoutée pour ne pas faire apparaitre d'invite de terminal sur distant

#### Connexion sur le poste serveur depuis le poste local

Créer un pont entre serveur et local en tapant dans un terminal de ce dernier

	ssh userS@serveur

#### Accès à la machine distante depuis la machine locale

Vous pouvez désormais atteindre le poste distant en saisissant dans le terminal du poste local connecté précédemment sur serveur

    ssh -p 12345 userD@localhost

#### Obtenir les clés de la machine locale

    ssh-keyscan -t ecdsa-sha2-nistp256 localhost | ssh-keygen -lf -
