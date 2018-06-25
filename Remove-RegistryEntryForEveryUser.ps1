. "$PSScriptRoot\global-maco-constants.ps1"
. "$PSScriptRoot\shared-helpers.ps1"
Function Remove-RegistryEntryForEveryUser ($RegRoot, $RegEntry) {
  $ThingToDo = "removeRegistryEntry $RegRoot $RegEntry"
  # Users who are currently logged in
  DoToAllLoggedInUsers $ThingToDo

  # Users who are not logged in, but who do have a profile on the machine
  DoToAllUsersWithProfileNotLoggedIn $ThingToDo

  # for the Default User
  DoToDefaultUser $ThingToDo
}

Function removeRegistryEntry ($RegRoot, $RegEntry, $SID) {

  
  $RegPath = "Registry::HKEY_USERS\$SID\$RegRoot"

  If (Test-Path -Path $RegPath) {
    $value1 = (Get-ItemProperty $RegPath).$RegEntry -eq $null 
    If ($value1 -eq $False) {
      Remove-ItemProperty -Path $RegPath -Name $RegEntry -Force
    }
    else {
      Remove-Item -Path "$RegPath" -Force -Recurse
    }
  }
}