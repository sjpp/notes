---
tags:
    - ldap
    - server
---

## Réinitialiser l'état d'un consumer LDAP

Cette procédure est utile dans le cas d'un cluster provider-consumer LDAP où, pour X raison, le consumer est mal synchronisé avec le provider et où on souhaite réinitialiser complètement la synchronisation.

### Remettre le consumer à zéro

- Préparer un *.ldif* pour supprimer la synchro

        vim reset_syncrepl.ldif 

        dn: olcDatabase={1}mdb,cn=config
        changetype: modify
        delete:olcSyncrepl
        olcSyncrepl: {0}rid=001 
          provider=ldap://ldap.example.com
          type=refreshAndPersist
          retry="5 5 300 +" 
          searchbase="dc=example,dc=com"
          attrs="*,+"
          bindmethod=simple
          binddn="uid=user,ou=my_ou,dc=example,dc=com"
          credentials=my_password

- intégrer le *.ldif*

        ldapadd -vv -Y EXTERNAL -H ldapi:/// -f reset_syncrepl.ldif

- arrêter le service

        systemctl stop slapd

- déplacer la base

        mkdir save_ldap
        mv /var/lib/ldap/* save_ldap/

### Relancer la synchro

- préparer le *.ldif* de configuration de la synchro

        vim syncrepl.ldif

        dn: olcDatabase={1}mdb,cn=config
        changetype: modify
        add:olcSyncrepl
        olcSyncrepl: {0}rid=001 
          provider=ldap://ldap.example.com
          type=refreshAndPersist
          retry="5 5 300 +" 
          searchbase="dc=example,dc=com"
          attrs="*,+"
          bindmethod=simple
          binddn="uid=user,ou=my_ou,dc=example,dc=com"
          credentials=my_password

- démarrer le service

        systemctl start slapd

- intégrer le *.ldif*

        ldapadd -vv -Y EXTERNAL -H ldapi:/// -f syncrepl.ldif

- une fois fait, arrêter le service à nouveau

        systemctl stop slapd

- lancer le démon *slapd* à la main en forçant la remise à zéro du cookie de synchro

        slapd -c rid=001,csn=0 -F /etc/ldap/slapd.d

(Note: le *rid* correspond au numéro passé dans le *.ldif*. Le *csn* doit être 0.)

- surveiller que la synchro se fait bien en lançant par exemple un *tcpdump* sur le provider

        tcpdump host <ip du consumer> and port 389

- une fois la re-synchro finie, arrêter le processus *slapd* en cours et démarrer le service

        killall slapd
        pgrep slapd # ne doit rien renvoyer
        systemctl start slapd
