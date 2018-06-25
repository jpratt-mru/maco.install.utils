. "$PSScriptRoot\global-maco-constants.ps1"
. "$PSScriptRoot\shared-helpers.ps1"

#
# Add some resource (file, folder) for every user on
# the machine (including Default). $RelativePathToResource should
# be relative to C:\Users.
#
Function Add-ResourceForEveryUser ($ResourceToAdd, $RelativePathToResource) {
  Foreach ($User in $(getUserNames)) {
    Copy-Item $ResourceToAdd -Destination C:\Users\$User\$RelativePathToResource -Force -Recurse
  }
  Copy-Item $ResourceToAdd -Destination C:\Users\Default\$RelativePathToResource -Force -Recurse
}

