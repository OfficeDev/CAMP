using module "..\CAMP.psm1"

class IG101 : CAMPCheck {
    <#
    

    #>

    IG101() {
        $this.Control = "IG-101"
        $this.ParentArea = "Microsoft Information Governance"
        $this.Area = "Information Governance"
        $this.Name = "Auto-Apply Retention Labels"
        $this.PassText = "Your organization is using auto-apply retention policies"
        $this.FailRecommendation = "Your organization should use auto-apply retention policies"
        $this.Importance = "Your organization should automatically apply retention labels to content when it matches specific conditions (such as containing specific keywords or types of sensitive information). Microsoft recommends that automatic labeling be implemented to decrease reliance on users for correct classification."
        $this.ExpandResults = $True
        $this.CheckType = [CheckType]::ObjectPropertyValue
        $this.ObjectType = "Retention Policies"
        $this.ItemName = "Labels"
        $this.DataType = "Remarks"
        if($this.ExchangeEnvironmentNameForCheck -ieq "O365USGovGCCHigh")
        {
            $this.Links = @{
                "Learn More Overview of retention labels"     = "https://aka.ms/mcca-ig-docs-learn-more"
                "Overview of retention policies"              = "https://aka.ms/mcca-ig-docs-retention-policies"
                "Compliance Center - Information Governance" = "https://aka.ms/mcca-gcch-ig-compliance-center"
                "Compliance Manager - IG Actions" = "https://aka.ms/mcca-gcch-ig-compliance-manager"
            }
        }elseif ($this.ExchangeEnvironmentNameForCheck -ieq "O365USGovDoD") 
        {
            $this.Links = @{
                "Learn More Overview of retention labels"     = "https://aka.ms/mcca-ig-docs-learn-more"
                "Overview of retention policies"              = "https://aka.ms/mcca-ig-docs-retention-policies"
                "Compliance Center - Information Governance" = "https://aka.ms/mcca-dod-ig-compliance-center"
                "Compliance Manager - IG Actions" = "https://aka.ms/mcca-dod-ig-compliance-manager"
            }
        }else
        {
        $this.Links = @{
            "Learn More Overview of retention labels"     = "https://aka.ms/mcca-ig-docs-learn-more"
            "Overview of retention policies"              = "https://aka.ms/mcca-ig-docs-retention-policies"
            "Compliance Center - Information Governance" = "https://aka.ms/mcca-ig-compliance-center"
            "Compliance Manager - IG Actions" = "https://aka.ms/mcca-ig-compliance-manager"
        }
        }
    }

    <#
    
        RESULTS CC Admin, CC Analyst, CC Investigator and CC Viewer
    #>

    GetResults($Config) {               
        if (($Config["GetRetentionComplianceRule"] -eq "Error") -or ($Config["GetRetentionCompliancePolicy"] -eq "Error")) {
            $this.Completed = $false
        }
        else {
            $UtilityFiles = Get-ChildItem "$PSScriptRoot\..\Utilities"

            ForEach ($UtilityFile in $UtilityFiles) {
        
                . $UtilityFile.FullName
                
            }
            
            $LogFile = $this.LogFile
            $Mode = "Auto"
            $ConfigObjectList = Get-RetentionPolicyValidation -LogFile $LogFile -Mode $Mode

            Foreach ($ConfigObject in $ConfigObjectList) {
                $this.AddConfig($ConfigObject)
            }

            
        
            $hasRemediation = $this.Config | Where-Object { $_.RemediationAction -ne ''}
            if ($($hasremediation.count) -gt 0)
            {
                $this.CAMPRemediationInfo = New-Object -TypeName CAMPRemediationInfo -Property @{
                    RemediationAvailable = $True
                    RemediationText      = "You need to connect to Security & Compliance Center PowerShell to execute the below commands. Please follow steps defined in <a href = 'https://docs.microsoft.com/en-us/powershell/exchange/connect-to-scc-powershell?view=exchange-ps'> Connect to Security & Compliance Center PowerShell</a>."
                }
            }
            $this.Completed = $True
        
        }
        
    }

}