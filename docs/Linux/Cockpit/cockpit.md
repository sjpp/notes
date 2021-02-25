# Cockpit

## Configuration de l'authentification à double facteur

* Installation du paquet requis

        dnf install google-authenticator

* Première configuration

  En tant qu'utilisateur, lancer la commande suivante pour configuration le paquet:

      google-authenticator

  Répondre aux questions, vérifier le code et sauvegarder les *recovery codes*.

  Pour éviter un soucis avec SELinux qui interdit l'accès à Cockpit à ce fichier et aux fichiers temporaires créés, il faut créer un dossier dédié et y mettre le bon contexte SELinux (voir ci-après).

        mkdir ~/.secrets
        mv .google_authenticator* .secrets/

* Configurer `pam`

  Éditer `/etc/pam.d/cockpit`

      auth       required     pam_google_authenticator.so secret=/home/${USER}/.secrets/.google_authenticator

### Configurer SELinux pour Cockpit

* Mettre le bon contexte

        semanage fcontext -a -t cockpit_tmp_t "/home/$USER/.secrets(/.*)?"
        restorecon -R -v /home/$USER/.secrets
