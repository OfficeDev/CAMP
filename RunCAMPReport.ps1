Remove-Module MCCAPreview -ErrorAction SilentlyContinue
Remove-Module ExchangeOnlineManagement -ErrorAction SilentlyContinue
Unblock-File ".\*"
Unblock-File ".\Checks\*"
Unblock-File ".\Outputs\*"
Unblock-File ".\Remediation\*"
Unblock-File ".\Utilities\*"

Import-Module .\CAMP.psm1


#Get-CAMPReport -Geo @("nam") -Solution @("num")

#Get-CAMPReport -ExchangeEnvironmentName O365USGovGCCHigh




