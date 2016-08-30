# ezadm.in bash script boilerplate.

main() {

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

  clear
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

  printf "{$RED}"
  read -p "Are you sure you have backups and wish to install MySQL? [y/N] " response
  if [[ $response =~ ^[Yy]$ ]]; then
      echo 'Just detecting your OS, one moment please...'
      if [ -e /etc/redhat-release ]; then
        export distro="Redhat/CentOS"
        clear
         printf "{$GREEN}"
         echo 'Your OS is Redhat/CentOS'
      elif [ "$(uname -a | awk '{print $6}')" == "Debian" ]; then
        echo 'Your OS is Debian'
      elif [ "$(lsb_release -d | awk '{print $2}')" == "Ubuntu" ]; then
        export distro="Ubuntu"
        echo 'Your OS is Ubuntu'git
      elif uname == "Windows"; then
        echo 'cunt'
      else
        echo 'Sorry you are on an unsupported OS'
       fi
  else
      echo 'exiting EzAdmin Script. Remember to visit http://www.ezadm.in for more scripts'
  fi
  printf "${NORMAL}"

}
main
