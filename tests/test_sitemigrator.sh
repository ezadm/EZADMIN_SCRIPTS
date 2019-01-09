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

test_validate_input()
{
    # possibilities:
    ## SRCUSER not set
    unset -v SRCUSER
    export SRCHOST="127.0.0.1"
    export SRCPORT="22"
    export DOMAIN="www.test.com"

    EXPECTED="Missing user"
    RESULT=$(validate_input testmode)
    assertEquals "Expected '$EXPECTED' when validating user not set but got '$RESULT'" "Missing user" $RESULT

    export SRCUSER="test"

    ## SRCHOST not set
    unset -v SRCHOST

    EXPECTED="Missing host"
    RESULT=$(validate_input testmode)
    assertEquals "Expected '$EXPECTED' when validating host not set but got '$RESULT'" "Missing host" $RESULT

    export SRCHOST="127.0.0.1"

    ## SRCPORT not set
    unset -v SRCPORT

    EXPECTED="Missing port"
    RESULT=$(validate_input testmode)
    assertEquals "Expected '$EXPECTED' when validating port not set but got '$RESULT'" "Missing port" $RESULT

    export SRCPORT="22"

    ## DOMAIN not set
    unset -v DOMAIN

    EXPECTED="Missing port"
    RESULT=$(validate_input testmode)
    assertEquals "Expected '$EXPECTED' when validating domain not set but got '$RESULT'" "Missing domain" $RESULT
}

test_generate_ctrlpanel_username()
{
    fail "generate_ctrlpanel_username is untested"
}

test_generate_ctrlpanel_password()
{
    fail "generate_ctrlpanel_password is untested"
}

test_create_hosting_account()
{
    fail "create_hosting_account is untested"
}

test_init_variables()
{
    fail "init_variables is untested"
}

test_migrate_files()
{
    fail "migrate_files is untested"
}

test_fix_site_file_permissions()
{
    fail "fix_site_file_permissions is untested"
}

test_identify_site_cms()
{
    fail "identify_site_cms is untested"
}

test_parse_site_cms_config()
{
    fail "parse_site_cms_config is untested"
}

test_verify_db_credentials()
{
    fail "verify_db_credentials is untested"
}

test_escape_database_details()
{
    fail "escape_database_details is untested"
}

test_create_site_database()
{
    fail "create_site_database is untested"
}

test_create_site_database_user()
{
    fail "create_site_database_user is untested"
}

test_grant_database_permissions()
{
    fail "grant_database_permissions is untested"
}

test_migrate_database()
{
    fail "migrate_database is untested"
}

test_update_cms_config()
{
    fail "update_cms_config is untested"
}

test_sitemigrator_options()
{
    fail "sitemigrator_options is untested"
}

# load shunit2
source ../shunit2/src/shunit2
