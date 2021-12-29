#!/bin/bash

## Oem  at oemden  dot com pour PR2i.
## 20200408 - Uninstall programmaticaly Team Viewer
# There is NO way to uninstall TeamViewer via CLI...  as stated here:
## https://community.teamviewer.com/t5/Knowledge-Base/How-do-I-uninstall-TeamViewer-on-my-Mac/ta-p/4165#toc-hId-649816028

## adding usefull sources:
## NOT TREND
## https://community.jamf.com/t5/jamf-pro/uninstall-trend-micro-security-script/td-p/199713
## https://apple.stackexchange.com/questions/350748/how-do-i-uninstall-trend-micro-security-agent

version="1.2.1"
clear
## TODOs
## Check version and/or TM app apth - Not needed
## Unload launchAgents and daemons + set to Disabled TRUE. just in case. DONE
## Delete launchAgents and daemons DONE
## delete the APP ! DONE
## Delete Host Preferences
## Delete loggedin User Preferences - Any User ??? maybe.
## Delete [...] see below (logs, Saved Application State)

## HOSTS files - DO a list of TeamViewer Versions, and a  loop with an array.
#TeamViewer_launchagent="/Library/LaunchAgents/com.teamviewer.teamviewer.plist"
#TeamViewer_launchagent_desktop="/Library/LaunchAgents/com.teamviewer.teamviewer_desktop.plist"
#TeamViewer_launchdaemon_helper="/Library/LaunchDaemons/com.teamviewer.Helper.plist"
#TeamViewer_launchdaemon_service="/Library/LaunchDaemons/com.teamviewer.teamviewer_service.plist"

#TeamViewer9_Preferencesfile="/Library/Preferences/com.teamviewer.teamviewer9.plist"
#TeamViewer10_Preferencesfile="/Library/Preferences/com.teamviewer.teamviewer10.plist"

# Users files - Try to remove it from Any user.
TeamViewer_UserPreferencesfile="~/Library/Preferences/com.teamviewer.Teamviewer.plist"
TeamViewer9_UserPreferencesfile="~/Library/Preferences/com.teamviewer.teamviewer9.plist"
TeamViewer10_UserPreferencesfile="~/Library/Preferences/com.teamviewer.teamviewer10.plist"

##########

function sudo_check {
	if [ `id -u` -ne 0 ] ; then
		printf "must be run as sudo, exiting"
		echo
		exit 1
	fi
}

function remove_launchagents {
 for launchagent in `ls /Library/LaunchAgents/ | grep "com.teamviewer" | sed 's/.plist//g'`
 do
  echo "01 launchagent: ${launchagent}"
  unload_launchdaemonsoragent "/Library/LaunchAgents/${launchagent}"
  delete_file "/Library/LaunchAgents/${launchagent}"
 done
}

function remove_launchdaemons {
 for launchdaemon in `ls /Library/LaunchDaemons/ | grep "com.teamviewer" | sed 's/.plist//g'`
 do
  echo "launchdaemon: ${launchdaemon}"
  unload_launchdaemonsoragent "/Library/LaunchDaemons/${launchagent}"
  delete_file "/Library/LaunchDaemons/${launchagent}"
 done
}

function remove_preferences {
 for preference in `ls /Library/Preferences/ | grep "com.teamviewer"`
 do
  echo "preference: ${preference}"
  delete_file "/Library/Preferences/${preference}"
 done
}

function remove_receipts {
 for receipt in `ls /var/db/receipts/ | grep "com.teamviewer" | grep "plist" | sed 's/.plist//g'`
 do
  echo "receipt: ${receipt}"
  delete_receipt "${receipt}"
 done
}

function unload_launchdaemonsoragent() {
 ## $1 is the plist launchctl domain.
 echo "   - Unloading: ${1}"
 launchctl unload -w "${1}"
}

function delete_file() {
 ## $1 is the file to delete.
 echo "   - deleting file : ${1}"
 rm -f "${1}"
 echo "00000"
}

function delete_receipt() {
 ## $1 is the file to delete.
 echo "   - deleting receipt : ${1}"
 pkgutil --forget "${1}"
}

function delete_app {
 echo "Deleting TeamViewer.app"
 rm -Rf "/Applications/TeamViewer.app"
}

function do_it {
sudo_check
remove_launchagents ; echo
remove_launchdaemons ; echo
remove_receipts ; echo
remove_preferences ; echo
delete_app
}

do_it

exit 0

## to check in User(s) scope.
## /private/var/ladmin/Library/Logs/TeamViewer/TeamViewer10_Logfile.log
## /private/var/ladmin/Library/Saved Application State/com.teamviewer.TeamViewer.savedState/data.data
## /private/var/ladmin/Library/Saved Application State/com.teamviewer.TeamViewer.savedState/windows.plist
## /private/var/ladmin/Library/Saved Application State/com.teamviewer.TeamViewer.savedState/window_2.data

