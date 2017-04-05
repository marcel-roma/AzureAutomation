Write-Host "Script execution begins here...";

$Conn = Get-AutomationConnection -Name AzureRunAsConnection;

Add-AzureRMAccount `
                -ServicePrincipal `
                -Tenant $Conn.TenantID `
                -ApplicationId $Conn.ApplicationID `
                -CertificateThumbprint $Conn.CertificateThumbprint;

$resourceGroups = Get-AzureRmResourceGroup;

Write-Host "Output:";
Write-Host $resourceGroups;