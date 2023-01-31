---
tags:
    - server
    - various
---
# Centreon

## Config SNMPv3 pour les serveurs

- Arreter le service snmpd
    service snmpd stop

- Création de l'utilisateur

Il existe 2 méthodes pour la création d'utilisateur SNMP V3 Une avec une commande et une autre manuelle

### 1 ère méthode (avec le script)

    net-snmp-config --create-snmpv3-user -a SHA -x AES

    #####################################################
    Enter a SNMPv3 user name to create:
    snmpuser
    Enter authentication pass-phrase:
    sfjslkfjslkgjsm
    Enter encryption pass-phrase:
    RTRGrbtyyb4566UUJ
    #####################################################

ceci rajoute 1 entrée dans le fichier `/usr/share/snmp/snmpd.conf` et `/var/lib/net-snmp/snmpd.conf`

    /usr/share/snmp/snmpd.conf

    ##########################
    rwuser snmpuser

    /var/lib/net-snmp/snmpd.conf
    ##########################

    createUser snmpuser SHA "sfjslkfjslkgjsm" AES "RTRGrbtyyb4566UUJ"

- Modifier les droits de l'utilisateur snmpuser en lecture seule
    vi /usr/share/snmp/snmpd.conf
##########################
rouser snmpuser


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SNMPUSERNAME     : snmpuser
SNMPPASSWORD     : sfjslkfjslkgjsm
SNMPAUTHPROTOCOL : SHA
SNMPPRIVPASSWORD : RTRGrbtyyb4566UUJ
SNMPPRIVPROTOCOL : AES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




---- 2 ème méthode ---- (manuelle)

Ajouter l'utilisateur SNMP V3 avec les droits en lecture seule
##########################
vi /usr/share/snmp/snmpd.conf
##########################
rouser snmpuser

Rajouter votre utilisateur avec les paramètres requis (Nom d'utilisateur, algorithme de hachage, mot de passe, algorithme de chiffrement, clef de chiffrement) 
/var/lib/net-snmp/snmpd.conf
##########################
createUser snmpuser SHA "VuldpGEQTI4o2p" AES "aRtz0OqaIcbHKs"


Démarrage du service snmpd
##########################
Le démarrage du service aura pour effet de modifier l'entrée dans le fichier /var/lib/net-snmp/snmpd.conf et cacher les clefs d'authentification et de chiffrement
#############
service snmpd start
#############

/var/lib/net-snmp/snmpd.conf
##########################
usmUser 1 3 0x80001f8880d03ab707afecd75700000000 "snmpuser" "snmpuser" NULL .1.3.6.1.6.3.10.1.1.3 0xc6910771242151aca36878ce38cda60d50b86d4a .1.3.6.1.6.3.10.1.2.4 0xb1248618de541a5995ea635aab1fb5b6 ""

Pour tester la connexion snmp en local
##########################
snmpwalk -v 3 -u snmpuser -a SHA -A 'VuldpGEQTI4o2p' -x AES -X 'aRtz0OqaIcbHKs' -l authPriv localhost

pour tester la connexion à partir du serveur Centreon
##########################
/usr/lib/nagios/plugins/check_centreon_snmp_remote_storage -H bareos -n -d /backup-01 -w 80 -c 90 -v 3 -u snmpuser -p 'VuldpGEQTI4o2p' --authprotocol SHA --privpassword 'aRtz0OqaIcbHKs' --privprotocol AES


Pour finir ne pas oublier de désactiver les accès SNMP v1 et v2 en commentant les lignes suivantes
###########################################
#rocommunity public 127.0.0.1
# rwcommunity mysecret 127.0.0.1
#com2sec local     localhost           public
#com2sec mynetwork 192.168.87.65      public
# com2sec mynetwork 192.168.87.65      public


Pare-Feu des équipements à monitorer
###########################################
UDP : 161 et 162


Config SNMPv3 pour les PDU


User Name : snmpuser
Authentication Passphrase : VuldpGEQTI4o24ffrl845fGtfb8
Privacy Passphrase : aRtz0OqaIcbHKsQTI485dhJHt8s



Config SNMPv3 sur les Synology
##################################################################################################
Nom d'utilisateur : snmpuser
Mot de passe : VuldpGEQTI4o2p
Protocole d'authentification : MD5 (pour info)

Installer module Perl manquan pour la crypto
##################################################################################################

yum install -y epel-release.noarch

yum install -y perl-Crypt-Rijndael

Config commune des commandes
#########################

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-v 3 -u $_SERVICESNMPUSERNAME$ -p $_SERVICESNMPPASSWORD$ --authprotocol $_SERVICESNMPAUTHPROTOCOL$ --privpassword $_SERVICESNMPPRIVPASSWORD$ --privprotocol $_SERVICESNMPPRIVPROTOCOL$ --snmp-timeout 60
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




