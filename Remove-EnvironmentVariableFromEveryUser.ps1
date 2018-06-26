. "$PSScriptRoot\global-maco-constants.ps1"
. "$PSScriptRoot\shared-helpers.ps1"
#
# Remove $VariableName from every User's (including Default's) HKU\Environment key.
#
Function Remove-EnvironmentVariableFromEveryUser ($VariableName) {
  $ThingToDo = "removeEnvironmentVariable $VariableName"

  # Users who are currently logged in
  DoToAllLoggedInUsers $ThingToDo

  # Users who are not logged in, but who do have a profile on the machine
  DoToAllUsersWithProfileNotLoggedIn $ThingToDo

  # for the Default User
  DoToDefaultUser $ThingToDo
}

Function removeEnvironmentVariable ($VariableName, $SID) {
  $EnvPath = getEnvironmentLocation $SID
  Remove-ItemProperty -Path $EnvPath -Name $VariableName -Force
}