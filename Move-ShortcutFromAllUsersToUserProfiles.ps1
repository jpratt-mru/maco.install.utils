. "$PSScriptRoot\global-maco-constants.ps1"
. "$PSScriptRoot\shared-helpers.ps1"

#
# Move a shortcut (or shortcut folder) from All Users Start Menu to the Default User's
# profile and then into every User's profile.
#
Function Move-ShortcutFromAllUsersToUserProfiles ($ShortcutName) {
  copyFolderOrLink $ShortcutName $global:ALL_USERS_START_MENU_LOCATION $(defaultUserStartMenuLocation)
  copyShortcutFromDefaultToEveryUser $ShortcutName
}


Function copyShortcutFromDefaultToEveryUser ($Shortcut) {
  $Source = $(defaultUserStartMenuLocation)
  Foreach ($User in $(getUserNames)) {
    $Destination = "$(userStartMenuLocation $User)"
    copyFolderOrLink $ShortcutName $Source $Destination
  }
} 


Function copyFolderOrLink($Item, $RootDir, $DestDir) {
  $Path = Join-Path $RootDir $Item
  If (Test-Path $Path) {
    Copy-Item -Path $Path -Destination $DestDir -Recurse -Force
  }
  Else {
    $Path += ".lnk"
    If (Test-Path $Path) {
      Copy-Item -Path $Path -Destination $DestDir -Force
    }
  }
}