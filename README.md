#Script Repo for https://www.ezadm.in

At EZADMIN our aim is to make the daily lives of all System Admin’s easier, by providing a one stop shop of BASH, Python and Perl scripts that can take care of any simple or even complex tasks.

## Information
* [Twitter](https://twitter.com/ezadm) for status updates
* [Website](https://www.ezadm.in/) for general introduction
* [Github Issues](https://github.com/ezadm/EZADMIN_SCRIPTS/issues) for reporting any issues with ezadmin scripts.

## Usage

For instructions on how to setup and run the scripts, please refer to the specific script [documentation](https://pgm.readthedocs.io/en/develop/)

## Contributions

Please submit all pull requests to the [master](https://github.com/ezadm/EZADMIN_SCRIPTS/master) branch.
Please ensure that your pull request follows our boilerplate layout or it will not be accepted.

# Using the boilerplate

## Getting started

The boiler plate is required to create EZADMIN scripts. The boilerplate provides a variety of functions and variables to make creating cross distribution and cross platform scripts easier.

To use the boilerplate all you need to do is include the code below at the top of your new EZADMIN script:

```bash
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
    rm /tmp/ezadmin_include.sh
} #}}}
ezadmin_include 'https://raw.githubusercontent.com/demon012/EZADMIN_SCRIPTS/master/boilerplate.sh'
###### END BOILERPLATE ########}}}
```

This code will automatically download the latest version of the EZADMIN boilerplate code from the github repository and then execute it. This will then populate all of the variables and provide access to the boilerplate functions as listed below.

## Boilerplate variables and functions (API)

### Functions
#### General functions
##### Downloading files (ezadmin_download)

ezadmin_download is used for downloading files from provided urls. The reason for this function is to remove the assumption that the user has a specific tool for downloading files installed such as curl or wget.

ezadmin_download requires *either* wget or curl, it will first check to see if curl is installed and if not will fall back to using wget to download.

This function will definitely work by the point that you attempt to use it as the boilerplate ensures that either wget or curl is installed before the rest of the script is ran.

###### Usage

ezadmin_download takes 2 arguments, the first is the URL to download from and the second is the file path to download to.

For example:

```bash
ezadmin_download "https://svrqc.com/api/1.0/ip/my" /tmp/myip
```

Would download a file containing the IP address of the server to a file called /tmp/myip

#### Package management functions

##### Installing packages (ezadmin_packageman_install)

ezadmin_packageman_install installs a package using the distribution's package manager. You will need to ensure that you have a list of the package names for the various different distributions in your script as a piece of software's package can be different between distributions.

###### Usage

ezadmin_packageman_install takes 1 argument which is the name of the package to install.

For example:

```bash
ezadmin_packageman_install htop
```

However as mentioned above you will need to provide a distribution specific package name this can be done using several methods.

The first and recommended way is to define a list of package names for the different distrubtions as a associative array as shown here for MySQL:

```bash
declare -A MYSQL_PACKAGE=( ["centos"]="mysql-server" ["ubuntu"]="mysql-server" ["debian"]="mysql-server" )

# Check if there is a package for the current distro.
if [ ! "${MYSQL_PACKAGE[$EZADMIN_ID]}" ]; then
    echo "$EZADMIN_PRETTY_NAME is currently not supported by this script. Please request support for it."
fi
```

The second is to just have a if statement chain specifying the different distributions that you script current has been tested to support and set the package name variable within each section of that if statement.

##### Removing packages (ezadmin_packageman_remove)

ezadmin_packageman_remove removes a package using the distribution's package manager. You will need to ensure that you have a list of the package names for the various different distributions in your script as a piece of software's package can be different between distributions.

###### Usage

ezadmin_packageman_remove takes 1 argument which is the name of the package to remove.

For example:

```bash
ezadmin_packageman_remove htop
```

However as mentioned above you will need to provide a distribution specific package name this can be done using several methods.

The first and recommended way is to define a list of package names for the different distrubtions as a associative array. An example of this can be found in the documentation for ezadmin_packageman_install above.

##### Checking packages are installed (ezadmin_packageman_checkinstalled)

ezadmin_packageman_checkinstalled can be used to check to see if a package is installed. You will need to ensure that the package name is correct for the distribution in use so please use the associative array method as documented in the ezadmin_packageman_install section.

###### Usage

ezadmin_packageman_checkinstalled takes 1 argument which is the name of the package to check is installed. ezadmin_packageman_checkinstalled then returns true if the package is installed and false if the package is not installed and can be used in various ways as shown below:

```bash
if [ ezadmin_packageman_checkinstalled mysql-server ]; then
    echo "MySQL is installed!"
fi

MYSQL_PACKAGE_INSTALLED=ezadmin_packageman_checkinstalled mysql-server
```

#### Message functions (Script status messages)

##### Normal Status Message (ezadmin_message)

ezadmin_message should be used for the normal messages notifying the user of key points in the script. The output is coloured to ensure that it can be seen amongst the output of the programs that your script may run.

###### Usage

ezadmin_message takes 3 arguments which are the message it should present to the user and the colour of the message text and the colour of the message background.

The list of available colours is:

Foreground Colours:
```bash
COLOUR_FG_NC
COLOUR_FG_BLACK
COLOUR_FG_RED
COLOUR_FG_GREEN
COLOUR_FG_YELLOW
COLOUR_FG_BLUE
COLOUR_FG_MAGENTA
COLOUR_FG_CYAN
COLOUR_FG_LIGHTGRAY
COLOUR_FG_DARKGRAY
COLOUR_FG_LIGHTRED
COLOUR_FG_LIGHTGREEN
COLOUR_FG_LIGHTYELLOW
COLOUR_FG_LIGHTBLUE
COLOUR_FG_LIGHTMAGENTA
COLOUR_FG_LIGHTCYAN
COLOUR_FG_WHITE
```

Background Colours:
```bash
COLOUR_BG_NC
COLOUR_BG_BLACK
COLOUR_BG_RED
COLOUR_BG_GREEN
COLOUR_BG_YELLOW
COLOUR_BG_BLUE
COLOUR_BG_MAGENTA
COLOUR_BG_CYAN
COLOUR_BG_LIGHTGRAY
COLOUR_BG_DARKGRAY
COLOUR_BG_LIGHTRED
COLOUR_BG_LIGHTGREEN
COLOUR_BG_LIGHTYELLOW
COLOUR_BG_LIGHTBLUE
COLOUR_BG_LIGHTMAGENTA
COLOUR_BG_LIGHTCYAN
COLOUR_BG_WHITE
```

For example:

```bash
ezadmin_message "Installing MySQL" $COLOUR_FG_BLACK $COLOUR_BG_WHITE
```

Would result in a message with a black font on a white background.

##### Success Status Message (ezadmin_message_success)

ezadmin_message_success should be used for messages notifying the user of success in running a key part of the script. The output is coloured to ensure that it can be seen amongst the output of the programs that your script may run.

###### Usage

ezadmin_message_success takes one argument which is the message it should present to the user.

For example:

```bash
ezadmin_message_success "MySQL installed successfully"
```

##### Warning Status Message (ezadmin_message_warning)

ezadmin_message_warning should be used for messages warning the user that they need to perform an action or that something may have not ran correctly. The output is coloured to ensure that it can be seen amongst the output of the programs that your script may run.

###### Usage

ezadmin_message_warning takes one argument which is the message it should present to the user.

For example:

```bash
ezadmin_message_warning "Warning: EZADMIN discovered something in your logs that may indicate that you have a filesystem corruption issue, please run a manual fsck on your server's filesystem!"
```

##### Error Status Message (ezadmin_message_error)

ezadmin_message_error should be used for messages notifying the user of an error that occurred during the execution of the script. The output is coloured to ensure that it can be seen amongst the output of the programs that your script may run.

###### Usage

ezadmin_message_error takes one argument which is the message it should present to the user.

For example:

```bash
ezadmin_message_error "Error, you have no backups! You need a backup to be able to restore from it!"
```

### Variables

#### Operating System and Distribution variables

##### EZADMIN_OS

The EZADMIN_OS variable contains the Operating System that the script is running on.

This will likely be set to one of:

```
freebsd
hurd
linux
macos
netbsd
solaris
windows
```

##### EZADMIN_DISTRIB_ID



##### EZADMIN_DISTRIB_RELEASE

##### EZADMIN_DISTRIB_CODENAME

##### EZADMIN_DISTRIB_DESCRIPTION


