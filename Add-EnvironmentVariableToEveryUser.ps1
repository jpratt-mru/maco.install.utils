. "$PSScriptRoot\global-maco-constants.ps1"
. "$PSScriptRoot\shared-helpers.ps1"
#
# Add $VariableName with $VariableValue of $VariableType to every User (including Default)
# by tweaking their HKU\Environment registry key. This isn't really supported by Microsoft,
# but it seems to work. So yay for confidence.
#
# The possible $VariableType(s) are:
#
# Binary	Binary data
# DWord	A number that is a valid UInt32
# ExpandString	A string that can contain environment variables that are dynamically expanded
# MultiString	A multiline string
# String	Any string value
# QWord	8 bytes of binary data
#
Function Add-EnvironmentVariableToEveryUser ($VariableName, $VariableValue, $VariableType) {
  $ThingToDo = "addEnvironmentVariable $VariableName $VariableValue $VariableType"
  # Users who are currently logged in
  doToAllLoggedInUsers $ThingToDo

  # Users who are not logged in, but who do have a profile on the machine
  doToAllUsersWithProfileNotLoggedIn $ThingToDo

  # for the Default User
  doToDefaultUser $ThingToDo
}

#
# Adds a single environment variable for User $SID
#
Function addEnvironmentVariable ($VariableName, $VariableValue, $VariableType, $SID) {
  $EnvPath = GetEnvironmentLocation $SID
  New-ItemProperty -Path $EnvPath -Name $VariableName -PropertyType $VariableType -Value $VariableValue -Force
}