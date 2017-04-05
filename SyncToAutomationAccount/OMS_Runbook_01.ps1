Write-Output "Script execution begins here...";

Write-Output "Getting connection...";
$Conn = Get-AutomationConnection -Name AzureRunAsConnection;

Write-Output "Logging on...";
$null = Add-AzureRMAccount `
                -ServicePrincipal `
                -Tenant $Conn.TenantID `
                -ApplicationId $Conn.ApplicationID `
                -CertificateThumbprint $Conn.CertificateThumbprint;

Write-Output "Getting resource groups..."
$resourceGroups = Get-AzureRmResourceGroup;

Write-Output "Output:";
Write-Output $resourceGroups;

Write-Output "Script ends here.";