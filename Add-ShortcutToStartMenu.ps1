. "$PSScriptRoot\global-maco-constants.ps1"
. "$PSScriptRoot\shared-helpers.ps1"

#
# Makes a shortcut (*not* shortcut folder) called $ShortcutName connected to $ExecLocation
# with an icon from $IconIndex in that exe for every user with a
# profile on the machine, including the Default User. $Arguments holds
# optional arguments to the shortcut (like '-load INS' for our KiTTy install).
#
# Why not just push to All User's Start Menu? Because I hate it when
# I can't delete things in *my* Start Menu, so why foist such pain
# on others?
#
Function Add-ShortcutToStartMenu ($ExecLocation, $ShortcutName, $IconIndex = 0, $Arguments = "") {
  addShortcutToExistingUsers $ExecLocation $ShortcutName $IconIndex $Arguments
  addShortcutToDefault $ExecLocation $ShortcutName $IconIndex $Arguments
}

Function addShortcutToExistingUsers($ExecLocation, $ShortcutName, $IconIndex = 0, $Arguments = "") {
  Foreach ($User in $(getUserNames)) {
    makeShortcut $User $ExecLocation $ShortcutName $IconIndex $Arguments
  }
}

Function addShortcutToDefault($ExecLocation, $ShortcutName, $IconIndex = 0, $Arguments = "") {
  makeShortcut "Default" $ExecLocation $ShortcutName $IconIndex $Arguments
}

#
# Create a shortcut called $ShortcutName hooked up to an exe
# called $ExecLocation with an icon pulled from the exe at
# index $IconIndex in $User's Start Menu
#
Function makeShortcut($User, $ExecLocation, $ShortcutName, $IconIndex = 0, $Arguments = "") {
  $ShortcutFile = "$(userStartMenuLocation $User)\$ShortcutName.lnk"

  $Shortcut = $global:WSCRIPT_SHELL.CreateShortcut($ShortcutFile)
  $Shortcut.Arguments = $Arguments
  $Shortcut.TargetPath = $ExecLocation
  $Shortcut.IconLocation = "$ExecLocation, $IconIndex"
  $Shortcut.Save()
}