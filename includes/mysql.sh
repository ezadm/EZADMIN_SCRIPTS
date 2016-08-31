ezadmin_install_mysql() #{{{
{
    # Set package names per distro
    declare -A MYSQL_PACKAGE=( ["centos"]="mysql-server" ["ubuntu"]="mysql-server" ["debian"]="mysql-server" )

    # Check if there is a package for the current distro.
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

    # Install Mysql package
    echo "Installing mysql with command: $EZADMIN_PKG_INSTALL ${MYSQL_PACKAGE[$EZADMIN_ID]}"
    $EZADMIN_PKG_INSTALL ${MYSQL_PACKAGE[$EZADMIN_ID]}
    if [ $? -eq 0 ]; then
        ezadmin_message_success "MySQL is now installed."
    else
        ezadmin_message_error "MySQL failed to install."
        exit
    fi
} #}}}

ezadmin_configure_mysql() #{{{
{
    while true; do
        ezadmin_message "Do you want to install change your MySQL password? (y/n)"
        read CHANGEPASS

        if [ "${CHANGEPASS,,}" == "y" ]; then
            # centos
            # debian

            # ubuntu
            # if [ "$EZADMIN_DISTRIB_RELEASE" == "ubuntu" ]; then
            #     dpkg-reconfigure mysql-server
            # fi
            # arch
            break
        elif [ "${CHANGEPASS,,}" == "n" ]; then
            break
        else
            ezadmin_message "Unexpected input: \'$CHANGEPASS\' please enter (y or n)"
        fi
    done
} #}}}
