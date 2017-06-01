param(
    [Parameter(Mandatory=$true)]
    [string]$stage
)

Write-Output "Executing Configure-OneDrive on stage $stage..."

Import-Module Microsoft.Online.SharePoint.PowerShell;
Import-Module O365_Functions;

Connect-SharePointTenant -stage $stage;

Set-SPOTenantSyncClientRestriction -BlockMacSync:$false -DomainGuids *DELETED* -Enable;
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
