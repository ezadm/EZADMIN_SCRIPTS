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

# inputs needed:
#   src type (ssh or ftp)
#   src server hostname
#   src server port (default 22 if ssh default 21 if ftp)
#   src server user:
#   src server password:
#   domain name to migrate
OPTS=`getopt -o fhH:p:u:p:d: --longoptions ftp,help,host:,port:,user:,password:,domain: -n 'parse-options' -- "$@"`

if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi
echo "$OPTS"
eval set -- "$OPTS"

FTP=false
HELP=false
USER=false
PASS=false
HOST=false
PORT=false
DOMAIN=false

while true; do
  case "$1" in
    -f | --ftp ) FTP=true; shift ;;
    -h | --help ) HELP=true; shift ;;
    -u | --user ) USER="$2"; shift; shift ;;
    -p | --password ) USER="$2"; shift; shift ;;
    -H | --host ) HOST="$2" shift; shift ;;
    -P | --port ) PORT="$2"; shift; shift ;;
    -d | --domain ) DOMAIN="$2"; shift; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

echo "FTP=$FTP"
echo "HELP=$HELP"
echo "USER=$USER"
echo "PASS=$PASS"
echo "HOST=$HOST"
echo "PORT=$PORT"
echo "DOMAIN=$DOMAIN"

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
        CREATE_ACCOUNT_CMD="plesk bin subscription --create ${DOMAIN} -owner admin -service-plan 'Default Domain'"
        ezadmin_message "Creating Plesk account with command:"
        ezadmin_message "${CREATE_ACCOUNT_CMD}"

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

    ssh -p $SRC_SSHPORT $SRC_SSHUSER@$SRC_SSH 'tar cvpj .' | tar xvpj
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
    :
} #}}}

# create database
create_site_database() #{{{
{
    :
} #}}}

# create database user
create_site_database_user() #{{{
{
    :
} #}}}

# grant database user permissions
grant_database_permissions() #{{{
{
    :
} #}}}

# migrate database
migrate_database() #{{{
{
    :
} #}}}

# update site config file
update_cms_config() #{{{
{
    :
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
