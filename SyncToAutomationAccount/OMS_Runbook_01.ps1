Write-Output "Script execution begins here...";

$Conn = Get-AutomationConnection -Name AzureRunAsConnection;

$null = Add-AzureRMAccount `
                -ServicePrincipal `
                -Tenant $Conn.TenantID `
                -ApplicationId $Conn.ApplicationID `
                -CertificateThumbprint $Conn.CertificateThumbprint;

$resourceGroups = Get-AzureRmResourceGroup;

Write-Output "Output:";
Write-Output $resourceGroups;