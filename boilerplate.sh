init_colours() {#{{{
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
}#}}}
show_ezadmin_header()#{{{
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
  echo 'Please ensure full backups have been taken prior to running this script.'
  echo ''
  echo 'EZADMIN are not responsible for any loss of data.'
  echo ''
  echo 'p.s. Please report any bugs to http://bugs.ezadm.in.'
  echo ''
  printf "${NORMAL}"
}#}}}
ezadmin_detect_distro()#{{{
{
        EZADMIN_OS="UNKNOWN"
        EZADMIN_DISTRO="UNKNOWN"
        EZADMIN_DISTRO_VERSION="UNKNOWN"

        echo 'Just detecting your OS and Distro, one moment please...'
        if [ -e /etc/centos-release ]; then
                export EZADMIN_OS='Linux'
                export EZADMIN_DISTRO='Centos'
                export EZADMIN_DISTRO_VERSION=`cat /etc/centos-release | sed 's/CentOS Linux release //g' | sed 's/(Core)//g'`
        elif [ -e /etc/debian-version ]; then
                export EZADMIN_OS='Linux'
                export EZADMIN_DISTRO='Debian'
                export EZADMIN_DISTRO_VERSION=`cat /etc/debian-version`
        elif [ "$(lsb_release -d | awk '{print $2}')" == "Ubuntu" ]; then
                export distro="Ubuntu"
                echo 'Your OS is Ubuntu'git
        elif uname == "Windows"; then
                echo 'cunt'
        else
                echo 'Sorry you are on an unsupported OS'
        fi
}#}}}
ezadmin_display_distro()#{{{
{
        echo "Operating System: $EZADMIN_OS"
        echo "Distro: $EZADMIN_DISTRO"
        echo "Distro version: $EZADMIN_DISTRO_VERSION"
}#}}}

clear
init_colours
show_ezadmin_header
ezadmin_detect_distro
ezadmin_display_distro

