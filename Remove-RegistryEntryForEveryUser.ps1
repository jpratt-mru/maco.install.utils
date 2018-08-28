. "$PSScriptRoot\global-maco-constants.ps1"
. "$PSScriptRoot\shared-helpers.ps1"
Function Remove-RegistryEntryForEveryUser ($RegRoot, $RegEntry) {
  $ThingToDo = "removeRegistryEntry $RegRoot $RegEntry"
  # Users who are currently logged in
  doToAllLoggedInUsers $ThingToDo

  # Users who are not logged in, but who do have a profile on the machine
  doToAllUsersWithProfileNotLoggedIn $ThingToDo

  # for the Default User
  doToDefaultUser $ThingToDo
}

Function removeRegistryEntry ($RegRoot, $RegEntry, $SID) {

  $RegPath = "Registry::HKEY_USERS\$SID\$RegRoot\$RegEntry"

  If (Test-Path -Path $RegPath) {
    Remove-Item -Path "$RegPath" -Force -Recurse
  }
}