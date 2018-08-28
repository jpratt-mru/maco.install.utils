. "$PSScriptRoot\global-maco-constants.ps1"
. "$PSScriptRoot\shared-helpers.ps1"

#
# Sometimes you just want to run a reg import that affects CurrentUser...and
# all users with profiles...and all future users.
#
Function Add-ToAllUsersSettingsViaRegfile ($RegfileName, $AnsiMode = $False) {
  $RegfileLocation = "..\registry-files\$RegfileName"
  If (Test-Path -Path "..\registry-files\user.reg") {
    Remove-Item -Path "..\registry-files\user.reg" -Force
  }
  If ($AnsiMode) {
    $(Get-Content -Encoding UTF8 $RegfileLocation) | foreach { $_ -replace 'HKEY_CURRENT_USER', 'HKEY_USERS\TempUserLoad' | Add-Content -Encoding UTF8 -Path "..\registry-files\user.reg" }
    removeUTF8Bom "..\registry-files\user.reg"
  }
  Else {
    $(Get-Content -Encoding Unicode $RegfileLocation) | foreach { $_ -replace 'HKEY_CURRENT_USER', 'HKEY_USERS\TempUserLoad' | Add-Content -Encoding Unicode -Path "..\registry-files\user.reg" }
  }

  copyRegfileSettingsToEveryone "..\registry-files\user.reg" $AnsiMode

  If (Test-Path -Path "..\registry-files\user.reg") {
    Remove-Item -Path "..\registry-files\user.reg" -Force
  }
}


#
# Copy the settings in the reg file $RegfileName and
# apply it to currently logged in users, users with profiles on the
# machine, and the Default User
#
Function copyRegfileSettingsToEveryone($RegfileName, $AnsiMode) {
  If (-not [string]::IsNullOrEmpty($RegfileName)) {
    copyRegfileSettingsToLoggedInUserProfiles $RegfileName $AnsiMode
    copyRegfileSettingsToLoggedOffUserProfiles $RegfileName $AnsiMode
    copyRegfileSettingsToDefaultUser $RegfileName $AnsiMode
  }
}

#
# Creates a copy of the reg settings file $RegfileName so that
# it is keyed to the SID of a given logged-in user. It then imports
# those settings into the registry.
#
Function copyRegfileSettingsToLoggedInUserProfiles($RegfileName, $AnsiMode) {
  doToAllLoggedInUsers "copySettingsForOneLoggedInUser $RegfileName `$$AnsiMode"
}


Function copySettingsForOneLoggedInUser ($RegfileName, $AnsiMode, $SID) {
  If (Test-Path -Path "..\registry-files\$SID.reg") {
    Remove-Item -Path "..\registry-files\$SID.reg" -Force
  }
  If ($AnsiMode) {
    $(Get-Content -Encoding UTF8 $RegfileName) | foreach { $_ -replace 'TempUserLoad', $SID | Add-Content -Encoding UTF8 -Path "..\registry-files\$SID.reg" }
    RemoveUTF8Bom "..\registry-files\$SID.reg"
  }
  Else {
    $(Get-Content -Encoding Unicode $RegfileName) | foreach { $_ -replace 'TempUserLoad', $SID | Add-Content -Encoding Unicode -Path "..\registry-files\$SID.reg" }
  }

  Import-RegistryFile "$SID.reg"
  Remove-Item -Path "..\registry-files\$SID.reg" -Force
}


Function copyRegfileSettingsToLoggedOffUserProfiles($RegfileName, $AnsiMode) {
  doToAllUsersWithProfileNotLoggedIn "copySettingsForOneLoggedInUser $RegfileName `$$AnsiMode"
}


Function copyRegfileSettingsToDefaultUser($RegfileName, $AnsiMode) {
  doToDefaultUser "copySettingsForOneLoggedInUser $RegfileName `$$AnsiMode"
}


Function removeUTF8Bom($File) {
  $Utf8NoBom = New-Object System.Text.UTF8Encoding($False)
  $MyContents = Get-Content $File
  $RegFilePath = (Get-Item -Path $File -Verbose).FullName
  [System.IO.File]::WriteAllLines($RegFilePath, $MyContents, $Utf8NoBom)
}