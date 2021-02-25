# Autoriser Polkit Pam avec SSSD

* Ajouter l'option suivante à la section `[pam]`:

        pam_p11_allowed_services = +polkit-1
        
puis redémarrer `sssd`.