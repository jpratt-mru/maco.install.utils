Function Invoke-StandardInstaller ($InstallerName, $Flags) {
  $Extension = [System.IO.Path]::GetExtension($InstallerName)
  If ($Extension -like ".exe") {
    installExe $InstallerName $Flags
  }
  Elseif ($Extension -like ".msi") {
    installMSI $InstallerName $Flags
  }
}

Function installMSI ($MSIFileName, $Flags = "") {
  Invoke-CommandLine @"
    cd .. && msiexec /i "installation-files\${MSIFileName}" ${Flags} /qn
"@
}


Function installExe ($ExeName, $Flags = "") {
  Invoke-CommandLine @"
    "..\installation-files\${ExeName}" ${Flags}
"@
}

