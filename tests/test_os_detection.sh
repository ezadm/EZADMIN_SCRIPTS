#!/bin/bash

# ubuntu all ubuntu version since 12.04.5 support it
UBUNTU_VERSIONS=( 12.04.5 14.04.5 16.04 16.10 )
for ubuntuversion in ${UBUNTU_VERSIONS[@]}; do
    docker run -a --rm --name $CUR_DISTRIB_ezadmin --volume=$PWD:/ezadmin:ro bash /ezadmin/run_os_detect.sh
done

# arch no os-release file, only /etc/arch-release
# debian
## jessie osrelease exists
## sid osrelease exists
## stretch osrelease exists
## wheezy osrelease exists

# centos
## 7 osrelease exists
## 6 osrelease does not exist !!!!
## 5 osrelease does not exist !!!!

# rhel -- not supporting as no docker image to test with
# alpine
## 3.1 osrelease exists
## 3.2 osrelease exists
## 3.3 osrelease exists
## 3.4 osrelease exists
## edge osrelease exists

# gentoo
## stage3-amd64-hardened  osrelease exists

# manjaro
## jonathonf/manjaro

