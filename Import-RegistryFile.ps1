#
# Sometimes you just want to run a reg import. This is just a wrapper
# to the more complicated Powershell command.
#
Function Import-RegistryFile ($RegFileName) {
  Start-Process -FilePath reg.exe -NoNewWindow -ArgumentList @("import", "..\registry-files\$RegFileName") -Wait | Out-Null
}