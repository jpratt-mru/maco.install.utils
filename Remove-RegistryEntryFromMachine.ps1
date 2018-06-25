. "$PSScriptRoot\global-maco-constants.ps1"
. "$PSScriptRoot\shared-helpers.ps1"


#
# Remove a registry key or a registry value in a given registry key for
# the system.
#
Function Remove-RegistryEntryFromMachine ($RegRoot, $RegEntry) {
  $RegPath = "Registry::HKLM\$RegRoot"

  If (Test-Path -Path $RegPath) {
    If (Test-Path -Path $RegPath\$RegEntry) {
      Remove-Item -Path "$RegPath\$RegEntry" -Force -Recurse
    }
    Else {
      Remove-ItemProperty -Path $RegPath -Name $RegEntry -Force
    }
  }
}