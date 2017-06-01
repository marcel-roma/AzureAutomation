param(
    [Parameter(Mandatory=$true)]
    [string]$stage
)

Write-Output "Executing Configure-OneDrive on stage $stage..."

Import-Module Microsoft.Online.SharePoint.PowerShell;
Import-Module O365_Functions;

Connect-SharePointTenant -stage $stage;

Set-SPOTenantSyncClientRestriction -BlockMacSync:$false -DomainGuids "1126dc51-d9d5-4527-989b-635a682a134f; 2e37d61e-5442-446d-b45f-4e872bb21998; 9fe8c4c1-f64f-425f-bbf3-eed1fd4c96a5" -Enable;
Set-SPOTenantSyncClientRestriction -ExcludedFileExtensions "";
Set-SPOTenantSyncClientRestriction -DisableReportProblemDialog:$true;
Set-SPOTenantSyncClientRestriction -GrooveBlockOption "HardOptIn";
Set-SPOTenant –SharingCapability ExternalUserSharingOnly –ProvisionSharedWithEveryoneFolder $true ;
Set-SPOTenant -ShowEveryoneExceptExternalUsersClaim $true;
Set-SPOTenant -ShowEveryoneClaim $false;
Set-SPOTenant -ShowAllUsersClaim $false;

Write-Output "`nO365 TENANT INFORMATION:"
Write-Output (Get-SPOTenant);

Write-Output "`nSPO TENANT INFORMATION:"
Write-Output (Get-SPOTenantSyncClientRestriction);

Write-Output "`nConfigure-OneDrive finished."