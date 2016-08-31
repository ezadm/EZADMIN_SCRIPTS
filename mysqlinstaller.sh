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
  echo 'Please ensure full backups have been taken prior to running this script.'
  echo ''
  echo 'EZADMIN are not responsible for any loss of data.'
  echo ''
  echo 'p.s. Please report any bugs to http://bugs.ezadm.in.'
  echo ''
  printf "${NORMAL}"
} #}}}
ezadmin_detect_distro() #{{{
{
        export EZADMIN_OS='Unknown'
        export EZADMIN_DISTRIB_ID='Unknown'
        export EZADMIN_DISTRIB_RELEASE='Unknown'
        export EZADMIN_DISTRIB_CODENAME='Unknown'
        export EZADMIN_DISTRIB_DESCRIPTION='Unknown'

        echo 'Just detecting your OS and Distro, one moment please...'
        if [ -e /etc/os-release ]; then
            export EZADMIN_OS='Linux'
            eval `cat /etc/os-release | sed 's/^/export EZADMIN_/g'`
        fi
#        if [ -e /etc/centos-release ]; then
#            export EZADMIN_OS='Linux'
#            export EZADMIN_DISTRIB_ID='Centos'
#            export EZADMIN_DISTRIB_RELEASE=`cat /etc/centos-release | sed 's/CentOS Linux release //g' | sed 's/(Core)//g'`
#            export EZADMIN_DISTRIB_CODENAME='Centos'
#            export EZADMIN_DISTRIB_DESCRIPTION="Linux - Centos $EZADMIN_DISTRIB_RELEASE"
#        elif [ -e /etc/lsb-release ]; then
#            eval `cat /etc/lsb-release | sed 's/^/export EZADMIN_/g'`
#        elif [ -e /etc/debian-version ]; then
#            export EZADMIN_OS='Linux'
#            export EZADMIN_DISTRIB_ID='Debian'
#            export EZADMIN_DISTRIB_RELEASE=`cat /etc/debian-version`
#            export EZADMIN_DISTRIB_CODENAME='Unknown'
#            export EZADMIN_DISTRIB_DESCRIPTION='Unknown'
#        elif uname == "Windows"; then
#            echo "Win"
#        else
#                echo 'Sorry you are on an unsupported OS'
#        fi
} #}}}
ezadmin_display_distro() #{{{
{
        echo "Operating System: $EZADMIN_OS"
        echo "Distro: $EZADMIN_ID"
        echo "Distro version: $EZADMIN_VERSION_ID"
        echo "Distro human readable: $EZADMIN_NAME"
        echo "Distro version human readable: $EZADMIN_PRETTY_NAME"
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
        export EZADMIN_LOCAL_PKG_INSTALL="rpm -Uvh "
    elif [ "$EZADMIN_ID" == "arch" ]; then
        export EZADMIN_PKG_INSTALL="pacman -S --noconfirm"
    fi
} #}}}
ezadmin_download() #{{{
{
    url="$1"
    dest="$2"

    if [ -x /usr/bin/curl ]; then
        DOWNLOADCOMMAND="curl -L $url -o $dest"
    elif [ -x /usr/bin/wget ]; then
        DOWNLOADCOMMAND="wget $url -O $dest"
    fi
    echo "$DOWNLOADCOMMAND"
    $DOWNLOADCOMMAND
} #}}}
ezadmin_user_check_backups() #{{{
{
    echo "=========== WARNING ==========="
    echo "Before you use any script from ezadm.in you should ensure that you have a recent working backup of your server."
    echo "Do you have a working backup? (Type 'YES I HAVE A WORKING BACKUP')"
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

# ezadmin_user_check_backups

###### END BOILERPLATE #######

declare -A MYSQL_PACKAGE=( ["centos"]="mysql-server" ["ubuntu"]="mysql-server" ["debian"]="mysql-server" )

if [ ! "${MYSQL_PACKAGE[$EZADMIN_ID]}" ]; then
    echo "$EZADMIN_PRETTY_NAME is currently not supported by this script. Please request support for it."
fi
### Install mysql community on Centos as mysql-server is not in the main repos
if [ "$EZADMIN_ID" == "centos" ]; then
    rpm -qa --quiet mysql-community-release

    if [ $? -ne 1 ]; then
        if [ "$EZADMIN_VERSION_ID" == "7" ]; then
            MYSQLCOMM_URL="https://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm"
        elif [ "$EZADMIN_VERSION_ID" == "6" ]; then
            MYSQLCOMM_URL="https://dev.mysql.com/get/mysql57-community-release-el6-8.noarch.rpm"
        elif [ "$EZADMIN_VERSION_ID" == "5" ]; then
            MYSQLCOMM_URL="https://dev.mysql.com/get/mysql57-community-release-el5-7.noarch.rpm"
        else
            echo "No mysql-community release repo for $EZADMIN_PRETTY_NAME"
            echo "Unable to continue due to no package being available. Aborting"
            exit
        fi
        ezadmin_download "$MYSQLCOMM_URL" /tmp/mysqlcomm.rpm
        $EZADMIN_LOCAL_PKG_INSTALL /tmp/mysqlcomm.rpm

        echo "Installing mysql-community-release"
        $EZADMIN_PKG_INSTALL epel-release
    else
        echo "epel release already installed"
    fi
fi
echo "Installing mysql with command: $EZADMIN_PKG_INSTALL ${MYSQL_PACKAGE[$EZADMIN_ID]}"
echo 4
$EZADMIN_PKG_INSTALL ${MYSQL_PACKAGE[$EZADMIN_ID]}
