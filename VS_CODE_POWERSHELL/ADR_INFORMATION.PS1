# Cargar el módulo de SCCM si no está ya cargado
Import-Module ($Env:SMS_ADMIN_UI_PATH.Substring(0,$Env:SMS_ADMIN_UI_PATH.Length-5) + '\ConfigurationManager.psd1')

# Cambiar al directorio del sitio de SCCM
CD "SCCM:\"

# Obtener todas las ADR y filtrar por las activas
$ADRsActivas = Get-CMSoftwareUpdateAutoDeploymentRule | Where-Object { $_.Enabled -eq $True }

# Mostrar las ADR activas
$ADRsActivas | Format-Table -Property Name, Enabled
Get-CMSoftwareUpdateAutoDeploymentRule -Name "*SecureConnector*"