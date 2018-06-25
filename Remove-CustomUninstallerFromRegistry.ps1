#
# Takes an uninstall entry out of the registry so that the
# app no longer shows up in the Uninstall/Change Programs
# in Control Panel > Programs > Programs and Features
#
Function Remove-CustomUninstallerFromRegistry ($UninstallEntryToRemove) {
  Remove-Item -Path "$global:UNINSTALL_REGISTRY_ROOT_X64\$UninstallEntryToRemove" -Force
}