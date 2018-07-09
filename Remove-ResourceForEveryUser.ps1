. "$PSScriptRoot\global-maco-constants.ps1"
. "$PSScriptRoot\shared-helpers.ps1"

#
# Get rid of some resource (file, folder) for every user on
# the machine (including Default). $RelativePathToResource should
# be relative to C:\Users.
#
Function Remove-ResourceForEveryUser ($RelativePathToResource) {
  Foreach ($User in $(getUserNames)) {
    Write-Host "remove resource is removing C:\Users\$User\$RelativePathToResource"
    If (Test-Path C:\Users\$User\$RelativePathToResource) {
      Remove-Item C:\Users\$User\$RelativePathToResource -Force -Recurse
      Write-Host "removed"
    }
    Else {
      Write-Host "resource not found"
    }
    
  }

  Write-Host "remove resource is removing C:\Users\Default\$RelativePathToResource"
  If (Test-Path C:\Users\Default\$RelativePathToResource) {
    Remove-Item C:\Users\Default\$RelativePathToResource -Force -Recurse
    Write-Host "removed"
  }
  Else {
    Write-Host "resource not found"
  }
}