Clear-Host;

$cred = Get-AzureRmAutomationCredential `
		-AutomationAccountName "dm-RomaM-OMS-AutomA-01" `
		-Name "drogeriemarktentwAsAdmin"> `
		-ResourceGroupName "mms-weu"

# Notwendige Module importieren
Import-Module MsOnline;
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking;

# Verbindung herstellen 
Connect-PnPOnline -Url https://dmdrogerieentw-admin.sharepoint.com -credential $cred
Connect-MsolService -Credential $cred


function GetODUsage($url)
{
    $sc = Get-PnPTenantSite $url -Detailed -ErrorAction SilentlyContinue | select url, storageusagecurrent, Owner
    $usage = $sc.StorageUsageCurrent / 1024
    return "$($sc.Owner), $($usage), $($url)"
}

foreach($usr in $(Get-MsolUser -All ))
{
    if ($usr.IsLicensed -eq $true)
    {
        $upn = $usr.UserPrincipalName.Replace(".","_")
        $od4bSC = "https://dmdrogerieentw-my.sharepoint.com/personal/$($upn.Replace("@","_"))"
        $od4bSC
        foreach($lic in $usr.licenses)
        {
            if ($lic.AccountSkuID -eq "dmdrogerieentw:ENTERPRISEPACK") 
            {
                Write-Host "$(GetODUsage($od4bSC)), E3"
            }
            elseif ($lic.AccountSkuID -eq "dmdrogerieentw:WACONEDRIVESTANDARD") 
            {
                Write-Host "$(GetODUsage($od4bSC)), OneDrive" 
            }
            elseif ($lic.AccountSkuId -eq "dmdrogerieentw:ENTERPRISEWITHSCAL")
            {
                Write-Host "$(GetODUsage($od4bSC)), E4" 
            }    
        }
    }
}