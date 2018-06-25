Function Remove-PortableInstallation ($AppName, $InstallLocation = "C:\Progra~1") {
  Remove-Item "$InstallLocation\$AppName" -Force -Recurse
  Remove-ShortcutFromStartMenu "$AppName"
}