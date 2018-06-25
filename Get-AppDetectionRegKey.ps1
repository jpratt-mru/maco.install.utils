Function Get-AppDetectionRegKey($AppName, $AppVersion) {
  $TweakedAppName = $AppName.Replace("-", "")
  $TweakedAppName = $TweakedAppName.Replace(" ", ".")
  $TweakedAppName = $TweakedAppName.ToLower()
  "$TweakedAppName.$AppVersion"
}