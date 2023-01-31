# Configuration APT

## Ne jamais utiliser les `recommends`

    cat > /etc/apt/apt.conf.d/01norecommend << EOF
    APT::Install-Recommends "0";
    APT::Install-Suggests "0";
    EOF
