import-module  'C:\Program Files (x86)\Microsoft Configuration Manager\bin\ConfigurationManager.psd1'
Set-Location "012:\"

Get-CMSoftwareUpdateAutoDeploymentRule -Name "windows Server"  | select-object name,lasterrorcode,contenet ,schedule,lastruntime

Get-CMSoftwareUpdateAutoDeploymentRule -Name "windows Server" 

# Get the deployment ID for the SecureConnector (64-bit) application
$autoDeploymentRule = Get-CMSoftwareUpdateAutoDeploymentRule -Name "Windows Server"
$deployments = Get-CMSoftwareUpdateDeployment -AssignmentUniqueID "{D341E03F-1BB1-46F9-BA72-FBF07799A3F9}"


# Get the deployment ID for the SecureConnector (64-bit) application

$appName = "SecureConnector (64-bit)"
Get-CMDeployment | Where-Object { $_.SoftwareName -like "*$appName*" } | Select-Object DeploymentID, CollectionName, DeploymentType, SoftwareName


