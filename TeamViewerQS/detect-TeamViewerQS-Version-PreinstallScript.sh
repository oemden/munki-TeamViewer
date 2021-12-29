#!/bin/bash
##
## Fix teamViewer bad version. for 10.13.x
## Oem at oemden dot com - 20211201
## Magnificient os major minor dot version one liner from:
## Patrick Gallagher - https://twitter.com/patgmac | Original source is from MigrateUserHomeToDomainAcct.sh

## This script is intended to be run as a precheck script in munki
## An exit code of 0 indicates installation should occur.

version="1.0"

#TVQS01="/Applications/TeamViewerQS.app"
#TVQS02="/Applications/TeamViewer QuickSupport.app"

OLDIFS=$IFS

IFS='.' read osvers_major osvers_minor osvers_dot_version <<< "$(/usr/bin/sw_vers -productVersion)"

 if [[ -d "/Applications/TeamViewerQS.app" ]] ; then
		IFS='.' read appvers_Major appvers_Minor appvers_dot <<< "$(defaults read /Applications/TeamViewerQS.app/Contents/Info.plist CFBundleShortVersionString)"
 		echo " 01 TeamViewer version is ${appvers_Major}.${appvers_Minor}.${appvers_dot} "
 		TVQS="/Applications/TeamViewerQS.app"

 elif [[ -d "/Applications/TeamViewer QuickSupport.app" ]] ; then
		IFS='.' read appvers_Major appvers_Minor appvers_dot <<< "$(defaults read /Applications/TeamViewer\ QuickSupport.app/Contents/Info.plist CFBundleShortVersionString)"
		echo " 02 TeamViewer version is ${appvers_Major}.${appvers_Minor}.${appvers_dot} "
 		TVQS="/Applications/TeamViewer QuickSupport.app"
 fi

IFS=$OLDIFS



function echo_vars {
 echo "${osvers_major}"
 echo "${osvers_minor}"
 echo "${osvers_dot_version}"

 echo "${appvers_Major}"
 echo "${appvers_Minor}"
 echo "${appvers_dot}"
}

#echo_vars

if [[ "${osvers_minor}" == "13" ]] ; then
	echo " MacOs version is ${osvers_major}.${osvers_minor}.${osvers_dot_version} "

	if [[ ! -d "${TVQS}" ]] ; then
		## An exit code of 0 indicates installation should occur.
		echo "missing TeamViewer QS"
		exit 0
	elif [[ "${appvers_Major}.${appvers_Minor}.${appvers_dot}" == "15.2.2756" ]] ; then
		echo " TeamViewer version is ${appvers_Major}.${appvers_Minor}.${appvers_dot} "
		echo "All is OK"
		## An exit code of 0 indicates installation should occur.
		exit 1
	elif [[ "${appvers_Major}.${appvers_Minor}.${appvers_dot}" != "15.2.2756" ]] ; then
		echo "coucou ${osvers_major}.${osvers_minor}.${osvers_dot_version}"
		echo " TeamViewer version is ${appvers_Major}.${appvers_Minor}.${appvers_dot} "
		echo " Not compatible with macOs ; we need to remove the App and reinstall TeamViewer "
		rm -Rf "${TVQS}"
	    ## An exit code of 0 indicates installation should occur.
		exit 0
	fi

fi
