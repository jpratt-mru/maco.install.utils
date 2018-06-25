. "$PSScriptRoot\global-maco-constants.ps1"
. "$PSScriptRoot\shared-helpers.ps1"
#
# Add/Change a registry value/value data pair in a given registry key for every user (including Default)
# on the system.
#
Function Add-RegistryEntryForEveryUser ($RegKey, $RegKeyValueName, $RegKeyValueData, $RegKeyValueType = "String") {
  $ThingToDo = "addRegistryValue $RegKey $RegKeyValueName $RegKeyValueData $RegKeyValueType"
  # Users who are currently logged in
  doToAllLoggedInUsers $ThingToDo

  # Users who are not logged in, but who do have a profile on the machine
  doToAllUsersWithProfileNotLoggedIn $ThingToDo

  # for the Default User
  doToDefaultUser $ThingToDo
}


#
# Add/Change a registry value/value data pair in a given registry key for a given user $SID
# on the system.
#
Function addRegistryValue ($RegKey, $RegKeyValueName, $RegKeyValueData, $RegKeyValueType, $SID) {
  $RegPath = "Registry::HKEY_USERS\$SID\$RegKey"

  # make the key if it doesn't exist
  If (-Not (Test-Path -Path $RegPath)) {
    New-Item -Path $RegPath -Force
  }


  # populate key with value/data pair
  New-ItemProperty -Path $RegPath -Name $RegKeyValueName -PropertyType $RegKeyValueType -Value $RegKeyValueData -Force
}