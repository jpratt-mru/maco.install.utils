#
# Run a command and wait for it to finish. Best to call this with
# $Command fed via a Powershell here-string to avoid Quotation Hell.
#
Function Invoke-CommandLine ($Command) {
  Start-Process 'cmd' -ArgumentList "/c $Command" -Wait
}