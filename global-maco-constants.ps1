$global:PROFILE_LIST_LOCATION = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\ProfileList"
$global:WSCRIPT_SHELL = New-Object -ComObject WScript.Shell
$global:MACO_CUSTOM_KEY_LOCATION = "HKLM:\Software\MACOCustomInstalls"
$global:ALL_USERS_START_MENU_LOCATION = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"
$global:UNINSTALL_REGISTRY_ROOT_X64 = "Registry::HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall"
$global:UNINSTALL_REGISTRY_ROOT_X86 = "Registry::HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"