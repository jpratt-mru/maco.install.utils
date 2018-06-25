#
# Used to do one of those installs that's really just "copy a
# folder over to Program Files and toss a shortcut to it
# in the Start Menu" deals.
#
Function Invoke-PortableInstaller ($AppName, $AppExeName, $ShortcutArgs = "", $InstallLocation = "C:\Progra~1") {
  Copy-Item "..\installation-files\$AppName" -Destination "$InstallLocation\$AppName" -Force -Recurse
  Add-ShortcutToStartMenu "$InstallLocation\$AppName\$AppExeName" $AppName 0 $ShortcutArgs
}