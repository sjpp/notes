---
tags:
    - server
    - network
    - cli
---

## Voir l'état de fonctionnement du pare-feu :

    firewall-cmd --state

## Obtenir la liste des zones supportées :

    firewall-cmd --get-zones

## Obtenir la liste des services supportés :

    firewall-cmd --get-services

## Lister ce qui est activé sur toutes les zones :

    firewall-cmd --list-all-zones

## Voir ce qui est activé sur la zone 'public' :

    firewall-cmd --zone=public --list-all

## Lister les services actifs de la zone 'public' :

    firewall-cmd --zone=public --list-services

## Voir la zone par défaut pour les connexions réseau :

    firewall-cmd --get-default-zone

## Définir la zone par défaut à 'public' :

    firewall-cmd --set-default-zone=public

## Lister les zones actives :

    firewall-cmd --get-active-zones

## Ajouter (ouvrir) le port 8080 (protocole tcp) à la zone 'public' :

    firewall-cmd --zone=public --add-port=8080/tcp --permanent
    firewall-cmd --zone=public --add-port=7000-8000/tcp

## Supprimer (fermer) le port 8080 (protocole tcp) pour la zone 'public' :

    firewall-cmd --zone=public --remove-port=8080/tcp
    firewall-cmd --zone=public --remove-port=7000-8000/tcp

## Ajouter (ouvrir) le service http pour la zone 'public' :

    firewall-cmd --zone=public --add-service=http

## Supprimer (fermer) le service http pour la zone 'public' :

    firewall-cmd --zone=public --remove-service=http

## Vérifier si le service http est actif pour la zone 'public' :

    firewall-cmd --zone=public --query-service=http

## Recharger la configuration :

    firewall-cmd --reload

## Rich rules examples:

    firewall-cmd --permanent --zone=testing --add-rich-rule='rule family=ipv4 source address=10.0.0.0/24 destination address=192.168.0.10/32 port port=8080-8090 protocol=tcp accept'
    firewall-cmd --permanent --zone=public --add-rich-rule='rule family=ipv4 source address=92.154.6.35/32 destination address=2.56.156.11/32 port port=22 protocol=tcp accept'

## List rich rules :

    firewall-cmd --permanent --zone=testing --list-rich-rules

## Remove riche rule :

    firewall-cmd --permanent --zone=testing --remove-rich-rule='rule family=ipv4 source address=10.0.0.0/24 destination address=192.168.0.10/32 port port=8080-8090 protocol=tcp accept'
