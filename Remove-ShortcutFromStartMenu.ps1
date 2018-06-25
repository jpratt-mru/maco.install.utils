. "$PSScriptRoot\global-maco-constants.ps1"
. "$PSScriptRoot\shared-helpers.ps1"
#
# Kill a shortcut (or shortcut directory) from the Start Menu for every User,
# plus AllUsers, plus the Default User
#
Function Remove-ShortcutFromStartMenu ($Shortcut) {
  removeShortcutFromEachUsersStartMenu $Shortcut
  removeShortcutFromDefault $Shortcut
  removeShortcutFromAllUsersStartMenu $Shortcut
}

Function removeShortcutFromEachUsersStartMenu($Shortcut) {
  Foreach ($User in $(getUserNames)) {
    $Path = "$(userStartMenuLocation $User)\$Shortcut"
    removeFolderOrLink $Path  
  }
}


Function removeShortcutFromDefault($Shortcut) {
  $Path = "$(defaultUserStartMenuLocation)\$Shortcut"
  removeFolderOrLink $Path 
}


Function  removeShortcutFromAllUsersStartMenu($Shortcut) {
  $Path = "$global:ALL_USERS_START_MENU_LOCATION\$Shortcut"
  removeFolderOrLink $Path 
}

Function removeFolderOrLink($Path) {
  If (Test-Path $Path) {
    Remove-Item $Path -Force -Recurse
  }
  Else {
    $Path += ".lnk"
    If (Test-Path $Path) {
      Remove-Item $Path -Force
    }
  }
}