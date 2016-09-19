#!/bin/bash

# ubuntu
UBUNTU_VERSIONS=( 12.04.5 14.04.5 16.04 16.10 )
for ubuntuversion in ${UBUNTU_VERSIONS[@]}; do
    docker run -at --rm --name $CUR_DISTRIB_ezadmin --volume=.:/ezadmin:ro bash /ezadmin/run_os_detect.sh
done

# arch
# debian
# centos
# rhel
# alpine
# gentoo
# manjaro
# coreos

