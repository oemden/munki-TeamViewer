#!/bin/bash

## Oem  at oemden  dot com pour PR2i.
## 20200408 - Uninstall programmaticaly Team Viewer
# There is NO way to uninstall TeamViewer via CLI...  as stated here:
## https://community.teamviewer.com/t5/Knowledge-Base/How-do-I-uninstall-TeamViewer-on-my-Mac/ta-p/4165#toc-hId-649816028

version="0.1.1"

## TODOs
## Check version and/or TM app apth - Not needed
## Unload launchAgents and daemons + set to Disabled TRUE. just in case.
## Delete launchAgents and daemons
## Delete Host Preferences
## Delete loggedin User Preferences - Any User ??? maybe.
## Delete [...] see below (logs, Saved Application State)

## HOSTS files - DO a list of TeamViewer Versions, and a  loop with an array.
TeamViewer_launchagent="/Library/LaunchAgents/com.teamviewer.teamviewer.plist"
TeamViewer_launchagent_desktop="/Library/LaunchAgents/com.teamviewer.teamviewer_desktop.plist"
TeamViewer_launchdaemon_helper="/Library/LaunchDaemons/com.teamviewer.Helper.plist"
TeamViewer_launchdaemon_service="/Library/LaunchDaemons/com.teamviewer.teamviewer_service.plist"

TeamViewer9_Preferencesfile="/Library/Preferences/com.teamviewer.teamviewer9.plist"
TeamViewer10_Preferencesfile="/Library/Preferences/com.teamviewer.teamviewer10.plist"

# Users files - Try to remove it from Any user.
TeamViewer_UserPreferencesfile="~/Library/Preferences/com.teamviewer.Teamviewer.plist"
TeamViewer9_UserPreferencesfile="~/Library/Preferences/com.teamviewer.teamviewer9.plist"
TeamViewer10_UserPreferencesfile="~/Library/Preferences/com.teamviewer.teamviewer10.plist"

function get_launchagents {
 for launchagent in `ls /Library/LaunchAgents/ | grep "com.teamviewer" | sed 's/.plist//g'`
 do
  echo "launchagent: ${launchagent}"
  unload_launchdaemonsoragent "${launchagent}"
  delete_plist "${launchagent}"
 done
}

function get_launchdaemons {
 for launchdaemon in `ls /Library/LaunchDaemons/ | grep "com.teamviewer" | sed 's/.plist//g'`
 do
  echo "launchdaemon: ${launchdaemon}"
  unload_launchdaemonsoragent "${launchagent}"
  delete_plist "${launchagent}"
 done
}

function unload_launchdaemonsoragent() {
 ## $1 is the plist launchctl domain.
 echo "   - Unloading: ${1}"
 #launchctl unload -w "${1}"
}

function delete_plist() {
 ## $1 is the file to delete.
 echo "   - deleting file : ${1}"
 #rm -f "${1}"
}

function do_it {
get_launchagents
get_launchdaemons
}

do_it

exit 0

## to check in User(s) scope.
## /private/var/ladmin/Library/Logs/TeamViewer/TeamViewer10_Logfile.log
## /private/var/ladmin/Library/Saved Application State/com.teamviewer.TeamViewer.savedState/data.data
## /private/var/ladmin/Library/Saved Application State/com.teamviewer.TeamViewer.savedState/windows.plist
## /private/var/ladmin/Library/Saved Application State/com.teamviewer.TeamViewer.savedState/window_2.data

