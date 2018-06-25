#
# I like storing custom installs into the registry, so that
# SCCM software detection can just look for that key.
#
# Does that make me a bad person?
#
Function Add-DetectionKeyToRegistry ($Key) {
  New-Item -Path $global:MACO_CUSTOM_KEY_LOCATION -Name $Key -Force
}