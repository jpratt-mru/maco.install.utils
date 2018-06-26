. "$PSScriptRoot\global-maco-constants.ps1"
. "$PSScriptRoot\shared-helpers.ps1"
#
# Add something to every User's (including Default's) PATH variable.
#
Function Add-ToEveryUserPath ($ThingToAdd) {
  $ThingToDo = "addToUserPath $ThingToAdd"
  # Users who are currently logged in
  DoToAllLoggedInUsers $ThingToDo

  # Users who are not logged in, but who do have a profile on the machine
  DoToAllUsersWithProfileNotLoggedIn $ThingToDo

  # for the Default User
  DoToDefaultUser $ThingToDo
}

#
# Adds $ThingToAdd to User $SID's PATH by adding $ThingToAdd to the
# end of the current value of PATH in $SID's Environment registry key.
# If their currently is no PATH, it is created.
#
Function addToUserPath ($ThingToAdd, $SID) {
  $EnvPath = getEnvironmentLocation $SID
  $OldPath = (Get-ItemProperty -Path $EnvPath -Name "PATH").PATH

  # add new thing to end of path and then clean things up (if other programs
  # add things to PATH and leave trailing semicolons, or we're entering the
  # first PATH entry, we may be doubling up on semicolons or getting leading/trailing
  # ones)
  $NewPath = "$OldPath;$ThingToAdd".replace(";;", ";").Trim(";")

  New-ItemProperty -Path $EnvPath -Name "PATH" -PropertyType ExpandString -Value $NewPath -Force
}