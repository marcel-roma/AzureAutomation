Write-Output "Script is starting...";

$cred = Get-AutomationPSCredential -Name "drogeriemarktentwAsAdmin";
$crlf = "`n";

if($cred -eq $null)
{
    Write-Output "Get-AutomationPSCredential returned no credential.";
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
    $usage = $sc.StorageUsageCurrent;
    $owner = $sc.Owner;
    
    Write-Output $sc;

    if([String]::IsNullOrEmpty($owner)) { $owner = "<not set>" };

    return "Owner: $($owner),`nUsage: $($usage),`nUrl: $($url)"
}

Write-Output "Getting users...";
$allUsers = Get-MsolUser -All;

if($allUsers -eq $null)
{
    Write-Output "Get-MsolUser returned no user.";
    return;
}

# Write-Output $allUsers;



foreach($usr in $allUsers)
{
    if ($usr.IsLicensed -eq $true)
    {
        $upn = $usr.UserPrincipalName.Replace(".","_");
        $od4bSC = "https://dmdrogerieentw-my.sharepoint.com/personal/$($upn.Replace("@","_"))";
        # Write-Output $od4bSC;

        foreach($lic in $usr.licenses)
        {
            $usage = GetODUsage($od4bSC);
            $formattedUsage =  $crlf + $usage + " ";

            if ($lic.AccountSkuID -eq "dmdrogerieentw:ENTERPRISEPACK") 
            {
                Write-Output "$formattedUsage, E3";
            }
            elseif ($lic.AccountSkuID -eq "dmdrogerieentw:WACONEDRIVESTANDARD") 
            {
                Write-Output "$formattedUsage, OneDrive" ;
            }
            elseif ($lic.AccountSkuId -eq "dmdrogerieentw:ENTERPRISEWITHSCAL")
            {
                Write-Output "$formattedUsage, E4" ;
            }    
        }
    }
}

Write-Output "Script finished";