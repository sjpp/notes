# Cockpit

## Configure 2 factor authentication

* Install requierments

        dnf install google-authenticator

* Configuration

  As user, initialize package configuration with the following command:

      google-authenticator

  It will ask you a set of questions, once answered, check the given code and copy the *recovery codes* (keep them in a safe place).

  To avoid issue with SELinux preventing Cockpit's access to this file and to others to be created temporary files, create a dedicated directory and set the rigth SELinux context (see below).

        mkdir ~/.secrets
        mv .google_authenticator* .secrets/

* Configure `pam`

  Edit `/etc/pam.d/cockpit` and add the following:

      auth       required     pam_google_authenticator.so secret=/home/${USER}/.secrets/.google_authenticator

### Configure SELinux for Cockpit

* Set the rigth context

        semanage fcontext -a -t cockpit_tmp_t "/home/$USER/.secrets(/.*)?"
        restorecon -R -v /home/$USER/.secrets
