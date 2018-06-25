Function Remove-DetectionKeyFromRegistry ($Key) {
  Remove-Item -Path "$global:MACO_CUSTOM_KEY_LOCATION\$Key" -Force
}