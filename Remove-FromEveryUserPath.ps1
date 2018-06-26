. "$PSScriptRoot\global-maco-constants.ps1"
. "$PSScriptRoot\shared-helpers.ps1"
#
# Remove something from every User's (including Default's) PATH variable.
#
Function Remove-FromEveryUserPath ($ThingToRemove) {
  $ThingToDo = "removeFromUserPath $ThingToRemove"
  # Users who are currently logged in
  DoToAllLoggedInUsers $ThingToDo

  # Users who are not logged in, but who do have a profile on the machine
  DoToAllUsersWithProfileNotLoggedIn $ThingToDo

  # for the Default User
  DoToDefaultUser $ThingToDo
}

#
# Removes $ThingToAdd from User $SID's PATH and leaves whatever is left over after
# the removal. If there is nothing left over, then PATH is removed from the Environment key,
# leaving the User with no PATH Environment variable.
#
Function removeFromUserPath ($ThingToRemove, $SID) {
  $EnvPath = getEnvironmentLocation $SID
  $OldPath = (Get-ItemProperty -Path $EnvPath -Name "PATH").PATH

  $NewPath = $OldPath.replace($ThingToRemove, "").replace(";;", ";").Trim(";")

  If (-not [string]::IsNullOrEmpty($NewPath)) {
    New-ItemProperty -Path $EnvPath -Name "PATH" -PropertyType ExpandString -Value $NewPath -Force
  }
  Else {
    Remove-ItemProperty -Path $EnvPath -Name "PATH" -Force
  }
}