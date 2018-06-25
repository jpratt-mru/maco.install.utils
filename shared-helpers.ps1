. "$PSScriptRoot\global-maco-constants.ps1"

#
# Does $ThingToDo to all users that are currently logged into the machine. ($ThingToDo is a string that
# is executed as-is by Invoke-Expression. Bargain basement dynamic programming at its finest.
#
Function doToAllLoggedInUsers ($ThingToDo) {
  $LoggedInSIDs = getLoggedInSIDs
  Foreach ($SID in $LoggedInSIDs) {
    Invoke-Expression "$ThingToDo $SID"
  }
}

#
# Does $ThingToDo to all users that have a profile on the machine but who are not currently logged in.
#
Function doToAllUsersWithProfileNotLoggedIn ($ThingToDo) {
  $ProfileListInRegistry = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\ProfileList'
  $LoggedInSIDs = getLoggedInSIDs
  $SidsOfNonLoggedInProfiles = Get-ChildItem $ProfileListInRegistry -Recurse | Where-Object { ($_.Name -match "S-\d-\d+-(\d+-){1,14}\d+$") -and (-not($LoggedInSIDs -contains $_.pschildname)) }
  foreach ($SID in $SidsOfNonLoggedInProfiles) {
    if ($SID) {
      $UserRegistryHiveFilePath = "$($SID.GetValue('ProfileImagePath'))\NTUser.dat"
      if (Test-Path $UserRegistryHiveFilePath) {
        loadHive "HKU\TempUserLoad" $UserRegistryHiveFilePath
        Invoke-Expression "$ThingToDo TempUserLoad"
        [gc]::Collect()
        unloadHive "HKU\TempUserLoad"
      }
    }
  }
}

#
# Does $ThingToDo to Default User.
#
Function doToDefaultUser ($ThingToDo) {
  loadHive "HKU\TempUserLoad" "C:\Users\Default\ntuser.dat"
  Invoke-Expression "$ThingToDo TempUserLoad"
  [gc]::Collect()
  unloadHive "HKU\TempUserLoad"
}

#
# Gets the SIDs of all folks currently logged in.
#
Function getLoggedInSIDs {
  New-PSDrive -Name HKU -PSProvider Registry -Root Registry::HKEY_USERS | Out-Null

  # exclude SIDs for System, All Users, and the like which are shorter
  # this grabs all SIDs of folks who are logged into the machine
  Get-ChildItem HKU: | Where-Object { $_.Name -match "S-\d-\d+-(\d+-){1,14}\d+$" } | Select-Object -ExpandProperty PsChildName
}

#
# Wrapper for Window's REG LOAD command.
#
Function loadHive($KeyName, $FileName) {
  Start-Process -FilePath reg.exe -NoNewWindow -ArgumentList @("load", "$KeyName", "$FileName") -Wait | Out-Null
}

#
# Wrapper for Window's REG UNLOAD command.
#
Function unloadHive($KeyName) {
  Start-Process -FilePath reg.exe -NoNewWindow -ArgumentList @("unload", "$KeyName") -Wait | Out-Null
}


#
# Get a list of names of all user names with profile directories (except Public) on
# a given machine.
#
Function getUserNames {
  $UserProfilesRoot = (Get-ItemProperty $global:PROFILE_LIST_LOCATION).ProfilesDirectory

  Get-ChildItem $UserProfilesRoot | % { $_.Name } | Where-Object { $_ -ne 'Public' }
}


Function defaultUserStartMenuLocation {
  userStartMenuLocation "Default"
}


#
# Location on Windows for a $User's Start Menu\Programs
#
Function userStartMenuLocation($User) {
  "C:\Users\$User\AppData\Roaming\Microsoft\Windows\Start Menu\Programs"
}
