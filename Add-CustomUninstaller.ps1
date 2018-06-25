#
# Place an uninstall mechanism on the computer so that users can use the usual
# "Uninstall or change a program" method in Windows to uninstall the program if they
# wish (as opposed to needing to uninstall via SCCM).
#
# For each install, files needed for a correct uninstall are placed in the directory C:\ProgramData\maco.uninstalls
#
# If the app that is installed already creates an entry, this entry is deleted and
# the local uninstaller takes its place.
#
# ProgramName => the name that shows up in Windows uninstall dialog
# Version => version number that shows up in the same
# OriginalUninstallRegistryKey => name of the uninstall key in the registry from the default installer
# Isx86 => indicates that the original uninstaller is to be found in the Wow6432Node
#
Function Add-CustomUninstaller ($ProgramName, $Version, $OriginalUninstallRegistryKey = "", $Isx86 = $false) {
  createLocalUninstallDirectory $ProgramName
  removeDefaultUninstallEntryFromRegistry $OriginalUninstallRegistryKey
  createUninstallEntryInRegistry $ProgramName $Version
}

#
# We want to store off the files needed for installs on the local machine in a common
# place.
#
Function createLocalUninstallDirectory ($ProgramName) {
  $UninstallDir = localUninstallDirectory $ProgramName

  New-Item $UninstallDir -type directory
  Copy-Item "..\uninstall.cmd" -Destination $UninstallDir -Force -Recurse
  Copy-Item "..\script-files" -Destination $UninstallDir -Force -Recurse
  Copy-Item "..\registry-files" -Destination $UninstallDir -Force -Recurse
}

#
# Strip out any whitespace in the uninstall dir name, 'cause it makes life easier
# when the uninstall.cmd command fires - if there are spaces involved, then we
# enter Quotation Hell.
#
Function localUninstallDirectory ($ProgramName) {
  $StrippedProgramName = $ProgramName.replace(" ", "")
  "$Env:ProgramData\maco.uninstalls\$StrippedProgramName"
}

#
# Kill off the default uninstaller entry in the Control Panel by killing its associated
# registry entries.
#
Function removeDefaultUninstallEntryFromRegistry ($OriginalUninstallRegistryKey) {
  If (-not [string]::IsNullOrEmpty($OriginalUninstallRegistryKey)) {
    If (Test-Path -Path "$global:UNINSTALL_REGISTRY_ROOT_X86\$OriginalUninstallRegistryKey") {
      Remove-Item -Path "$global:UNINSTALL_REGISTRY_ROOT_X86\$OriginalUninstallRegistryKey" -Force -Recurse
    }
    ElseIf (Test-Path -Path "$global:UNINSTALL_REGISTRY_ROOT_X64\$OriginalUninstallRegistryKey") {
      Remove-Item -Path "$global:UNINSTALL_REGISTRY_ROOT_X64\$OriginalUninstallRegistryKey" -Force -Recurse
    }
  }
}

#
# When you uninstall programs via the Control Panel, the entries you see there are thanks
# to some registry entries (typically in HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall).
# This method makes those entries.
#
Function createUninstallEntryInRegistry ($ProgramName, $Version) {
  # make the uninstaller key in the registry
  New-Item -Path $global:UNINSTALL_REGISTRY_ROOT_X64 -Name $ProgramName -Force

  $KeyPath = "$global:UNINSTALL_REGISTRY_ROOT_X64\$ProgramName"
  $UninstallDir = localUninstallDirectory $ProgramName

  # make the desired registry entries
  New-ItemProperty -Path $KeyPath -Name "DisplayName" -PropertyType "String" -Value $ProgramName -Force
  New-ItemProperty -Path $KeyPath -Name "DisplayVersion" -PropertyType "String" -Value $Version -Force
  New-ItemProperty -Path $KeyPath -Name "Publisher" -PropertyType "String" -Value "MACO Install" -Force
  New-ItemProperty -Path $KeyPath -Name "UninstallString" -PropertyType "String" -Value "$UninstallDir\uninstall.cmd" -Force
}