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

ezadmin_include 'https://raw.githubusercontent.com/demon012/EZADMIN_SCRIPTS/master/includes/sitemigrator.sh'

WPCFG="false"
MAGENTOCFG="false"
JOOMLACFG="false"
DRUPALCFG="false"
OPENCARTCFG="false"

while true; do
  case "$1" in
    -h | --help ) export HELP=true ; shift ;;
    -F | --ftp ) export FTP=true ; shift ;;
    -u | --user ) export SRCUSER="$2"; shift; shift ;;
    -p | --password ) export SRCPASS="$2"; shift; shift ;;
    -H | --host ) export SRCHOST="$2"; shift; shift ;;
    -P | --port ) export SRCPORT="$2"; shift; shift ;;
    -d | --domain ) export DOMAIN="$2"; shift; shift ;;
    -b | --debug ) export DEBUG=true ; shift; shift ;;
    -a | --no-account-creation ) export ACCCREATION=false ; shift ;;
    -f | --no-file-migration ) export FILEMIG=false ; shift ;;
    -D | --no-database-migration ) export DBMIG=false ; shift ;;
    -w | --wordpress-config-path ) export WPCFG="$2" ; shift; shift ;;
    -m | --magento-config-path ) export MAGENTOCFG="$2" ; shift; shift ;;
    -j | --joomla-config-path ) export JOOMLACFG="$2" ; shift; shift ;;
    -r | --drupal-config-path ) export DRUPALCFG="$2" ; shift; shift ;;
    -o | --opencart-config-path ) export OPENCARTCFG="$2" ; shift; shift ;;
    -s | --import-sql-file ) export SQLFILE="$2" ; shift; shift ;;
    --mysql-db-host ) export DB_HOST="$2" ; shift; shift ;;
    --mysql-db-name ) export DB_NAME="$2" ; shift; shift ;;
    --mysql-db-user ) export DB_USER="$2" ; shift; shift ;;
    --mysql-db-pass ) export DB_PASSWORD="$2" ; shift; shift ;;
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

if [ "$ACCCREATION" == "true" ]; then
    create_hosting_account
fi

init_variables

if [ "$FILEMIG" == "true" ]; then
    migrate_files
    fix_site_file_permissions
fi

identify_site_cms

parse_site_cms_config

if [ "$DBMIG" == "true" ]; then
    escape_database_details

    verify_db_credentials

    create_site_database

    create_site_database_user

    grant_database_permissions

    migrate_database

    update_cms_config
fi

