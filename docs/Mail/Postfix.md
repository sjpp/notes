---
tags:
    - server
    - linux
    - mail
---

## Various notes

For system admins who are using postfix as their mail server :

As my routine system administration I usually use some of the following commands frequently.

### View the postfix version

    postconf  mail_version
    mail_version = 2.3.3

### Check the postfix installation  

    postfix check

### Show default postfix values

    postconf -d

### To show non default postfix values

    postconf -n

### To restart postfix mail server  

    postfix reload

### Flush the mail queue

    postfix  flush

###  Or you can use

    postfix  -f

### To see mail queue :

    mailq

### ( in send mail sendmail -bp )

    mailq | wc -l

(will give the total no of mails in queue )

### To remove all mail from the queue

    postsuper -d ALL

### To remove all mails in the deferred queue

    postsuper -d ALL deferred

### To see the mails in a tree structure

    qshape

### View the mail content

    postcat -q  AFD4A228 37C

You will get the above id from mailq or you can view the mails from postfix mail spool.
Usually postfix will store the mails in `/var/spool/postfix/active/` from this location also you can view the mails.
We can change the queue directory from the postfix conf.

## Sort by from address

    mailq | awk '/^[0-9,A-F]/ {print $7}' | sort | uniq -c | sort -n
    
### To remove all mails sent by [email protected] from the queue

    mailq| grep '^[A-Z0-9]'|grep [email protected]|cut -f1 -d' ' |tr -d \*|postsuper -d -
### To remove all mails being sent using the From address “[email protected]”

    mailq | awk '/^[0-9,A-F].*[email protected] / {print $1}' | cut -d '!' -f 1 | postsuper -d -
    
### To remove all mails sent by the domain adminlogs.info from the queue

    mailq| grep '^[A-Z0-9]'|grep @adminlogs.info|cut -f1 -d' ' |tr -d \*|postsuper -d

### Test your own Mailserver against attacks

    telnet mail-abuse.org

### Fix For Postfix Error: `postdrop: Warning: Unable To Look Up Public/pickup: No Such File Or Directory`

Après installation de *postfix*, lors de l'envoi du premier mail, il y a cette erreur :

	postdrop: warning: unable to look up public/pickup: No such file or directory.

Cela se produit car *sendmail* est installé et entre en conflit avec *postfix*
Pour corriger il faut l'arrêter et créer un dossier manquant:

```
sudo systemctl disable --now sendmail
sudo dnf remove sendmail

mkfifo /var/spool/postfix/public/pickup

sudo systemctl restart postfix
```

*source: https://westonganger.com/posts/fix-for-postfix-error-postdrop-warning-unable-to-look-up-public-pickup-no-such-file-or-directory*
