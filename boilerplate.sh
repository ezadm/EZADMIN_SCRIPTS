#!/bin/bash
init_colours() { #{{{
    # Use colors, but only if connected to a terminal, and that terminal
    # supports them.
    if which tput >/dev/null 2>&1; then
        ncolors=$(tput colors)
    fi
    if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
        RED="$(tput setaf 1)"
        GREEN="$(tput setaf 2)"
        YELLOW="$(tput setaf 3)"
        BLUE="$(tput setaf 4)"
        BOLD="$(tput bold)"
        NORMAL="$(tput sgr0)"
    else
        RED=""
        GREEN=""
        YELLOW=""
        BLUE=""
        BOLD=""
        NORMAL=""
    fi

    # Only enable exit-on-error after the non-critical colorization stuff,
    # which may fail on systems lacking tput or terminfo
    set -e
} #}}}
show_ezadmin_header() #{{{
{
  #Welcome Message
  printf "${GREEN}"
  echo '  _______  _______  _______  ______   _______    _________ _       '
  echo '(  ____ \/ ___   )(  ___  )(  __  \ (       )   \__   __/( (    /|'
  echo '| (    \/\/   )  || (   ) || (  \  )| () () |      ) (   |  \  ( |'
  echo '| (__        /   )| (___) || |   ) || || || |      | |   |   \ | |'
  echo '|  __)      /   / |  ___  || |   | || |(_)| |      | |   | (\ \) |'
  echo '| (        /   /  | (   ) || |   ) || |   | |      | |   | | \   |'
  echo '| (____/\ /   (_/\| )   ( || (__/  )| )   ( | _ ___) (___| )  \  |'
  echo '(_______/(_______/|/     \|(______/ |/     \|(_)\_______/|/    )_)'
  echo ''
  echo ''
  echo 'By using this script you agree to the EZADM TOS.'
  echo 'The Terms of Service can be found at https://www.exadm.in/tos'
  echo ''
  echo 'EZADMIN are not responsible for any loss of data, it is down to the end user to ensure they have the relevant backups!.'
  echo ''
  echo 'p.s. Please report any bugs to http://bugs.ezadm.in.'
  echo ''
  printf "${NORMAL}"
} #}}}

ezadmin_detect_distro() #{{{
{
        printf "${RED}"
        echo "=========== OS and Distribution Detected ==========="
        printf "${NORMAL}"
        export EZADMIN_OS='Unknown'
        export EZADMIN_DISTRIB_ID='Unknown'
        export EZADMIN_DISTRIB_RELEASE='Unknown'
        export EZADMIN_DISTRIB_CODENAME='Unknown'
        export EZADMIN_DISTRIB_DESCRIPTION='Unknown'

        if [ -e /etc/os-release ]; then
            export EZADMIN_OS='Linux'
            eval `cat /etc/os-release | sed 's/^/export EZADMIN_/g'`
        fi
} #}}}
ezadmin_display_distro() #{{{
{
        echo "Operating System: $EZADMIN_OS"
        echo "Distro: $EZADMIN_ID"
        echo "Distro version: $EZADMIN_VERSION_ID"
        echo "Distro human readable: $EZADMIN_NAME"
        echo "Distro version human readable: $EZADMIN_PRETTY_NAME"
        echo ""
        echo "Is this your OS and Distribution? (Type 'YES' or 'NO' if you want to quit)"
        read CORRECTOS

        if [ "$CORRECTOS" != "YES" ] && [ "$CORRECTOS" != "NO" ]; then
          echo "Please enter: 'YES' or 'NO' if you want to quit"
          ezadmin_display_distro
        elif [ "$CORRECTOS" == "NO" ]; then
          exit
        fi
} #}}}
ezadmin_init() #{{{
{
    init_colours
    show_ezadmin_header
    ezadmin_detect_distro

    if [ "$EZADMIN_ID" == "debian" ] || [ "$EZADMIN_ID" == "ubuntu" ]; then
        export EZADMIN_PKG_INSTALL="apt-get install -y"
    elif [ "$EZADMIN_ID" == "centos" ]; then
        export EZADMIN_PKG_INSTALL="yum install -y"
    elif [ "$EZADMIN_ID" == "arch" ]; then
        export EZADMIN_PKG_INSTALL="pacman -S --noconfirm"
    fi
} #}}}
ezadmin_user_check_backups() #{{{
{
    printf "${RED}"
    echo "=========== WARNING ==========="
    printf "${NORMAL}"
    echo "Before you use any script from ezadm.in you should ensure that you have a recent working backup of your server."
    echo "Do you have a working backup? (Type 'YES I HAVE A WORKING BACKUP' or 'Q' if you want to quit)"
    read WORKINGBACKUP

    if [ "$WORKINGBACKUP" != "YES I HAVE A WORKING BACKUP" ] && [ "$WORKINGBACKUP" != "Q" ]; then
        echo "Please enter: 'YES I HAVE A WORKING BACKUP' or 'Q' if you want to quit"
        ezadmin_user_check_backups
    elif [ "$WORKINGBACKUP" == "Q" ]; then
        exit
    fi
} #}}}

clear
ezadmin_init
ezadmin_display_distro

ezadmin_user_check_backups

###Start of Main Script###