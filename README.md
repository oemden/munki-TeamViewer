# Manage TeamViewer with munki

## TeamViewer

**Scripts to Uninstall programmaticaly Team Viewer**

as There is NO way to uninstall TeamViewer via CLI...  as stated here:

https://community.teamviewer.com/t5/Knowledge-Base/How-do-I-uninstall-TeamViewer-on-my-Mac/ta-p/4165#toc-hId-649816028

## TeamViewerQS

Script to detect if specific version `15.2.2756` has been pushed to a ≤10.13.x macOs System for which it is NOT compatible.

Yeah  only  fools don't make mistakes ;) 

I accidently pushed a TeamviewerQS version without verifiy macOs compatibility.

*Who would have though version 15.3.xx would drop support below 10.14 ?* 

Anyway, the script will check :

- the current version of macOs is ≤ to macOs 10.13.x
- the current version of the TeamviewerQS.app installed

and

- do nothing if macOs is 10.14++
- do nothing if macOs is ≤10.13 and .app == version `15.2.2756`
- remove the .app if macOs is ≤10.13 and .app != version `15.2.2756`

#### Notes: 

in munki:

- Use as `precheck_script` for the teamViewerQS.app pkginfo version `15.2.2756`
- Use the Maximum OS Version `10.13.99` for this `15.2.2756` version
- Use the Minimum OS Version `10.14` for above versions

munki will do the rest