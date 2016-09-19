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

ezadmin_packageman_install installs a package using the distributions package manager. You will need to ensure that you have a list of the package names for the various different distributions in your script as a piece of software's package can be different between distributions.

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
