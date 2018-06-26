# Export functions that start with capital letter, others are private
# Include file names that start with capital letters, ignore others
$ScriptRoot = Split-Path $MyInvocation.MyCommand.Definition

$pre = Get-ChildItem Function:\*
Get-ChildItem "$ScriptRoot\*.ps1" | Where-Object { $_.Name -cmatch '^[A-Z]+' } | % { . $_  }
$post = Get-ChildItem Function:\*
$funcs = compare $pre $post | select -Expand InputObject | select -Expand Name
$funcs | Where-Object { $_ -cmatch '^[A-Z]+'} | % { Export-ModuleMember -Function $_ }