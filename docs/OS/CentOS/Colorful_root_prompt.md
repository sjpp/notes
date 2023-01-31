# Colorized prompt for root

    # .bashrc

    # User specific aliases and functions

    alias rm='rm -i'
    alias cp='cp -i'
    alias mv='mv -i'

    # Source global definitions
    if [ -f /etc/bashrc ]; then
        . /etc/bashrc
    fi

    # Colorful prompt
    PS1='[ \[\033[01;31m\]\u@\H \w\[\033[02;00m\] ]\[\033[00m\] '

