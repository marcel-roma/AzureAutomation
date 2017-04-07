Write-Output "Script is starting...";

$cred = Get-AzureRmAutomationCredential `
		-AutomationAccountName "dm-RomaM-OMS-AutomA-01" `
		-Name "drogeriemarktentwAsAdmin"> `
		-ResourceGroupName "mms-weu";

if($cred -eq $null)
{
    Write-Output "GetAzureRmAutomationCredential returned no credential.";
}        

# Notwendige Module importieren
Write-Output "Importing necessary modules...";
Import-Module MsOnline;
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking;

# Verbindung herstellen
Write-Output "Connecting to SPO..."; 
Connect-PnPOnline -Url https://dmdrogerieentw-admin.sharepoint.com -credential $cred
Write-Output "Connecting to O365...";
Connect-MsolService -Credential $cred


function GetODUsage($url)
{
    $sc = Get-PnPTenantSite $url -Detailed -ErrorAction SilentlyContinue | select url, storageusagecurrent, Owner
    $usage = $sc.StorageUsageCurrent / 1024
    return "$($sc.Owner), $($usage), $($url)"
}

Write-Output "Getting users...";
$allUsers = Get-MsolUser -All;

if($allUsers -eq $null)
{
    Write-Output "Get-MsolUser returned no user.";
}

Write-Output $allUsers;

foreach($usr in $allUsers)
{
    Write-Output "Processing user $usr ...";

    if ($usr.IsLicensed -eq $true)
    {
        $upn = $usr.UserPrincipalName.Replace(".","_");
        $od4bSC = "https://dmdrogerieentw-my.sharepoint.com/personal/$($upn.Replace("@","_"))";
        Write-Output $od4bSC;

        foreach($lic in $usr.licenses)
        {
            $usage = GetODUsage($od4bSC);

            if ($lic.AccountSkuID -eq "dmdrogerieentw:ENTERPRISEPACK") 
            {
                Write-Output "$usage, E3";
            }
            elseif ($lic.AccountSkuID -eq "dmdrogerieentw:WACONEDRIVESTANDARD") 
            {
                Write-Output "$usage, OneDrive" ;
            }
            elseif ($lic.AccountSkuId -eq "dmdrogerieentw:ENTERPRISEWITHSCAL")
            {
                Write-Output "$usage, E4" ;
            }    
        }
    }
}

Write-Output "Script finished";