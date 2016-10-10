#!/bin/bash
###### BEGIN BOILERPLATE ########{{{
ezadmin_include() #{{{
{
    INCLUDEURL="$1"

    if [ -x /usr/bin/curl ]; then
        curl $INCLUDEURL -so /tmp/ezadmin_include.sh
    elif [ -x /usr/bin/wget ]; then
        wget $INCLUDEURL -qO /tmp/ezadmin_include.sh
    else
        echo "Neither wget or curl found. Unable to continue, aborting EZADMIN."
        echo "Please install wget or curl and then try again."
    fi
    source /tmp/ezadmin_include.sh
    rm -f /tmp/ezadmin_include.sh
} #}}}
ezadmin_include 'https://raw.githubusercontent.com/demon012/EZADMIN_SCRIPTS/master/boilerplate.sh'
###### END BOILERPLATE ########}}}

validate_input() #{{{
{
    VALID=true

    VALID_USER=true
    VALID_HOST=true
    VALID_DOMAIN=true

    if [ "$SRCUSER" == "false" ]; then
        VALID_USER=false
        VALID=false
    fi
    # elif [ "$PASS" == "false" ]; then
    #     ezadmin_message_error "Missing password"
    #     VALID=false
    if [ "$SRCHOST" == "false" ]; then
        VALID_HOST=false
        VALID=false
    fi
    if [ "$DOMAIN" == "false" ]; then
        VALID_DOMAIN=false
        VALID=false
    fi

    if [ "$VALID" == false ]; then
        display_usage
        ezadmin_message_error "Unable to proceed as you failed to specify the mandatory options listed below:"
        if [ "$VALID_USER" == "false" ]; then
            ezadmin_message_error "Missing domain"
        fi
        if [ "$VALID_HOST" == "false" ]; then
            ezadmin_message_error "Missing host"
        fi
        if [ "$VALID_USER" == "false" ]; then
            ezadmin_message_error "Missing user"
        fi
        exit
    fi
} #}}}
display_usage() #{{{
{
    echo "Usage: $0 [OPTIONS]..."
    echo "Migrates sites using SSH or FTP to CPanel or Plesk servers."
    echo "Example:"
    echo -e "\t$0 -u sshuser -H sshhost.com -P 22 -d migrationdomain.com"
    echo -e ""
    echo -e "Options:"
    echo -e "\t-f | --ftp: specify ftp mode. Need to use the -p option with this to specify the FTP password."
    echo -e "\t-u <user> | --user <user>: the user to ssh or ftp with depending on wether --ftp is specified."
    echo -e "\t-p <password> | --password <password>: the password to FTP with. Not required for SSH as SSH password has to be specified interactively."
    echo -e "\t-H <host> | --host <host>: the host to SSH or FTP to."
    echo -e "\t-P <port> | --port <port>: the port to SSH or FTP to."
    echo -e "\t-d <domain> | --domain <domain>: the domain name of the domain we are migrating (Mandatory option)."
    echo -e "\t-D | --debug: Enable debug output."
} #}}}
generate_ctrlpanel_username() #{{{
{
    export CTRLPANEL_USERNAME=`echo "$DOMAIN" | tr -d '. ' | grep -Eo '^.{0,16}'`
    ezadmin_message "Using control panel username ${CTRLPANEL_USERNAME}"
} #}}}
generate_ctrlpanel_password() #{{{
{
    export CTRLPANEL_PASSWORD=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16};echo;`
    ezadmin_message "Using control panel password ${CTRLPANEL_PASSWORD}"
} #}}}

# create hosting account
create_hosting_account() #{{{
{
    generate_ctrlpanel_username
    generate_ctrlpanel_password
    if [ "$EZADMIN_CTRLPANEL" == "plesk" ]; then
        CREATE_ACCOUNT_CMD="plesk bin subscription --create ${DOMAIN} -owner admin -service-plan 'Unlimited' -ip $EZADMIN_SERVER_IPS -login $CTRLPANEL_USERNAME -passwd \"$CTRLPANEL_PASSWORD\""
        ezadmin_message "Creating Plesk account with command:"
        ezadmin_message "${CREATE_ACCOUNT_CMD}"
        $CREATE_ACCOUNT_CMD

        export ALLDEST=/var/www/vhosts/${DOMACCOUNT}_ALLFILES/
        export SITEDEST=/var/www/vhosts/${DOMACCOUNT}/httpdocs/
    elif [ "$EZADMIN_CTRLPANEL" == "cpanel" ]; then
        CREATE_ACCOUNT_CMD="/scripts/wwwacct ${DOMAIN} ${CTRLPANEL_USERNAME} ${CTRLPANEL_PASSWORD} x3 n n n 0 0 0 0 0 0"
        ezadmin_message "Creating CPanel account with command:"
        ezadmin_message "${CREATE_ACCOUNT_CMD}"
        ${CREATE_ACCOUNT_CMD}

        export DOMACCOUNT=`cat /etc/userdomains | grep "$DOMAIN" | cut -d' ' -f 2`
        export ALLDEST=/home/${DOMACCOUNT}_ALLFILES/
        export SITEDEST=/home/${DOMACCOUNT}/public_html/
    elif [ "$EZADMIN_CTRLPANEL" == "unknown" ]; then
        ezadmin_message_error "Could not detect control panel. Unable to migrate the site."
        exit
    fi
} #}}}

# migrate files
migrate_files() #{{{
{
    mkdir $ALLDEST
    cd $ALLDEST
    # check if rsync is available
    # ssh -p $SRC_SSHPORT $SRC_SSHUSER@$SRC_SSH "which rsync"
    # if rsync available use rsync
    # if [ $? -eq 0 ]; then
    #     rsync -avzp --progress $SRC_SSHPORT $SRC_SSHUSER@$SRC_SSH:
    # else
    # else fallback to tarsync

    ssh -p $SRCPORT $SRCUSER@$SRCHOST 'tar cvpj .' | tar xvpj
    cp -a $ALLDEST/htdocs/* $SITEDEST

    # fi
} #}}}

# identify site type
identify_site_cms() #{{{
{
    export CMS ="unknown"
	if [ -f $SITEDEST/wp-config.php ]; then
	    export CMS="wordpress"
    elif [ -f $SITEDEST/app/ ]; then
        export CMS="magento"
    fi
} #}}}

# parse site config file
parse_site_cms_config() #{{{
{
    cd $SITEDEST
    if [ "$CMS" == "wordpress" ]; then
		if [ -e "wp-config.php" ]; then
			export DB_HOST=`grep 'DB_HOST' wp-config.php  | cut -d"'" -f4`;
			export DB_NAME=`grep 'DB_NAME' wp-config.php  | cut -d"'" -f4`;
			export DB_USER=`grep 'DB_USER' wp-config.php  | cut -d"'" -f4`;
			export DB_PASSWORD=`grep 'DB_PASSWORD' wp-config.php  | cut -d"'" -f4`;
		fi
    fi
} #}}}

# create database
create_site_database() #{{{
{
    if [ "$EZADMIN_CTRLPANEL" == "plesk"]; then
        plesk bin database --create $DB_NAME -domain $DOMAIN -type mysql
    elif  [ "$EZADMIN_CTRLPANEL" == "cpanel" ]; then
        export MYSQLPASS=`cat /root/.my.cnf | grep 'password' | cut -d'"' -f 2`
        mysql -u root -p"${MYSQLPASS}" -e "CREATE DATABASE ${DB_NAME};"
    fi
} #}}}

# create database user
create_site_database_user() #{{{
{
    if [ "$EZADMIN_CTRLPANEL" == "plesk"]; then
        plesk bin database --create-dbuser $DB_USER -passwd $DB_PASSWORD -domain $DOMAIN -database $DB_NAME -type mysql
    elif [ "$EZADMIN_CTRLPANEL" == "cpanel" ]; then
        mysql -u root -p"${MYSQLPASS}" -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}'"
        /usr/local/cpanel/bin/dbmaptool ${DOMACCOUNT} --type 'mysql' --dbs "${DB_NAME}" --dbusers "${DB_USER}"
    fi
} #}}}

# grant database user permissions
grant_database_permissions() #{{{
{
    if [ "$EZADMIN_CTRLPANEL" == "cpanel" ]; then
        mysql -u root -p"${MYSQLPASS}" -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}'"
        mysql -u root -p"${MYSQLPASS}" -e "FLUSH PRIVILEGES"
    fi
} #}}}

# migrate database
migrate_database() #{{{
{
    mysqldump -h ${DB_HOST} -u $DB_USER -p${DB_PASSWORD} ${DB_NAME} | mysql -u "${DB_USER}" -p${DB_PASSWORD} ${DB_NAME}
} #}}}

# update site config file
update_cms_config() #{{{
{
    if [ "$CMS" == "wordpress" ]; then
        cd $SITEDEST
        if [ -e "wp-config.php" ]; then
            sed -i "s/${DB_HOST}/localhost/" wp-config.php
        fi
    fi
} #}}}

# fix site file permissions
fix_site_file_permissions() #{{{
{
    if [ "$EZADMIN_CTRLPANEL" == "cpanel" ]; then
        wget https://raw.githubusercontent.com/PeachFlame/cPanel-fixperms/master/fixperms.sh && bash fixperms.sh -a $DOMACCOUNT && rm -f fixperms.sh
    elif [ "$EZADMIN_CTRLPANEL" == "plesk" ]; then
        /usr/local/psa/bin/repair --restore-vhosts-permissions
    else
        ezadmin_message_error "Command to fix permissions is unknown."
    fi
} #}}}

# inputs needed:
#   src type (ssh or ftp)
#   src server hostname
#   src server port (default 22 if ssh default 21 if ftp)
#   src server user:
#   src server password:
#   domain name to migrate
OPTS=`getopt -o hfp:u:H:P:d:D --longoptions help,ftp,host:,port:,user:,password:,domain:,debug -n 'parse-options' -- "$@"`

if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi
eval set -- "$OPTS"

export FTP=false
export HELP=false
export SRCUSER=false
export SRCPASS=false
export SRCHOST=false
export SRCPORT=false
export DOMAIN=false
export DEBUG=false

while true; do
  case "$1" in
    -f | --ftp ) export FTP=true; shift ;;
    -h | --help ) export HELP=true; shift ;;
    -u | --user ) export SRCUSER="$2"; shift; shift ;;
    -p | --password ) export SRCPASS="$2"; shift; shift ;;
    -H | --host ) export SRCHOST="$2"; shift; shift ;;
    -P | --port ) export SRCPORT="$2"; shift; shift ;;
    -d | --domain ) export DOMAIN="$2"; shift; shift ;;
    -D | --debug ) export DEBUG=true; shift; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

if [ "$DEBUG" == "true" ]; then
    echo "FTP=$FTP"
    echo "HELP=$HELP"
    echo "SRCUSER=$SRCUSER"
    echo "SRCPASS=$SRCPASS"
    echo "SRCHOST=$SRCHOST"
    echo "SRCPORT=$SRCPORT"
    echo "DOMAIN=$DOMAIN"
    echo "DEBUG=$DEBUG"
fi

if [ "$HELP" == "true" ]; then
    display_usage
    exit
fi

validate_input
create_hosting_account
# migrate_files
# identify_site_cms
# parse_site_cms_config
# create_site_database
# create_site_user
# grant_database_permissions
# migrate_database
# update_cms_config
# fix_site_file_permissions
