#!/bin/bash
# |----------------------------------------------------------------------------
# | Nom         : centos8_desktop_setup.sh
# | Description : Configuration d'un desktop CentOS 8
# |             :
# | Dépendances : dnf pip3 sudo
# | Mise à jour : 06/2020
# | Licence     : GNU GLPv3 ou ultérieure
# |----------------------------------------------------------------------------

# |----------------------------------------------------------------------------
# | Usage :
# | Configurer la variable USER puis lancer le script.
# | L'utilisateur qui le lance doit avoir les droits sudo, ce script ne doit pas
# | être lancé en tant que root
# |----------------------------------------------------------------------------

# |----------------------------------------------------------------------------
# | Définition des variables :
# |----------------------------------------------------------------------------

MYDIR=$(dirname "$0")       # dossier d'exec du script
VERSION="0.1.0"             # version de ce script
USER="sebastien"

# |----------------------------------------------------------------------------
# | Fonctions :
# |----------------------------------------------------------------------------

Annonce () {
    if [[ $# -ne 2 ]]
    then
        echo -e "\t\033[1;31mCette fonction prend 2 paramètres: <couleur> <message>\033[0;00m"
        exit 1
    fi

    case $1 in
        red     ) echo -e "\n\033[1;31m"$2"\033[0;00m\n" ;;
        green   ) echo -e "\n\033[1;32m"$2"\033[0;00m\n" ;;
        yellow  ) echo -e "\n\033[1;33m"$2"\033[0;00m\n" ;;
        magenta ) echo -e "\n\033[1;35m"$2"\033[0;00m\n" ;;
        cyan    ) echo -e "\n\033[1;36m"$2"\033[0;00m\n" ;;
        gras    ) echo -e "\033[1;37m"$2"\033[0;00m" ;;
        norm    ) echo -e "\033[37m"$2"\033[0;00m" ;;
        *       ) echo -e "\n\t\033[1;31m/!\ : Couleur non prise en charge\033[0;00m\n" ;;
    esac
}

AmIRoot () {
    if [[ $EUID -eq 0 ]]; then
        Annonce red "ERREUR : Ce script NE doit PAS être lancé en tant que root mais par un utilisateur avec droit sudo."
        exit 1
    fi
}

IsUSERdefined () {
    if [[ -z "$USER" ]]; then
        Annonce red "ERREUR : La variable USER n'est pas définie."
        exit 1
    fi
}

DoInstall () {
    Annonce yellow "Purge des paquets indésirables"
    sudo dnf -y remove rhythmbox

    Annonce cyan "Ajout des dépôts complémentaires"
    sudo dnf -y install epel-release elrepo-release dnf-plugins-core
    sudo dnf -y install https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm
    sudo dnf -y config-manager --set-enabled PowerTools

    #Annonce cyan "Ajout du dépôt personnel"
    #cd /etc/yum.repos.d/
    #wget https://download.opensuse.org/repositories/home:sogal:tilix-centos8/CentOS_8/home#:sogal:tilix-centos8.repo
    #sudo dnf -y update
    #cd
    sudo dnf -y distro-sync

    Annonce green "Ajout des paquets complémentaires"
    sudo dnf -y install htop gnome-tweaks gnome-shell-extension-drive-menu git ansible keepassxc rsync mc zsh htop python3-pip tlp-rdw neovim tlp libreoffice-core libreoffice-calc libreoffice-writer flatpak NetworkManager-openvpn-gnome iftop tigervnc chromium make

    Annonce green "Installation des paquets nécessaires via PIP"
    sudo pip3 install pynvim ranger-fm mitogen diceware

    Annonce yellow "Installation de password-store via Git"
    cd /tmp
    git clone https://git.zx2c4.com/password-store
    cd password-store/
    sudo make install

    Annonce magenta "Configuration des groupes de l'utilisateur"
    sudo usermod -aG systemd-journal

    Annonce green "Installation des paquets via Flatpak"
    sudo flatpak -y remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    #sudo flatpak -y install flathub org.nextcloud.Nextcloud
    #sudo flatpak -y install https://www.linphone.org/releases/flatpak-repo/linphone.flatpakref
    sudo flatpak -y install com.spotify.Client
    sudo flatpak -y install org.gnome.Lollypop

    Annonce green "Configuration des dossiers Gnome"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Sundry/ apps "['vncviewer.desktop', 'setroubleshoot.desktop']"
    gsettings set org.gnome.desktop.app-folders folder-children "['Utilities', 'Sundry', 'YaST', 'Console']"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Console/ apps "['nvim.desktop', 'htop.desktop', 'ranger.desktop']"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Console/ name 'Console'
}


# |----------------------------------------------------------------------------
# | Exécution du script :
# |----------------------------------------------------------------------------

AmIRoot
IsUSERdefined

read -p "Démarrer l'installation ? [y/n] "
case $REPLY in
    'y' ) DoInstall ;;
    'n' ) Annonce yellow "Abandon" ; exit 1 ;;
    *   ) Annonce red "Réponse incorrecte" ; exit 1 ;;
esac

exit $?

