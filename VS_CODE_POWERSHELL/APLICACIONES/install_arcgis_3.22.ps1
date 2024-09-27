# Rutas de los archivos MSI
$instaladorPrincipal = "ArcGISPro.msi"
$instaladorActualizacion = "ArcGIS_Pro_322_188070.msp"

# Instalar la aplicación principal
Write-Host "Instalando la aplicación principal..."
Start-Process "msiexec.exe" -ArgumentList "/i `"$instaladorPrincipal`" ARCGIS_CONNECTION=TRUE PORTAL_LIST=`"https://gis.ineco.com`" ACCEPTEULA=YES ALLUSERS=1 AUTHORIZATION_TYPE=CONCURRENT_USE CHECKFORUPDATESATSTARTUP=0 ENABLEEUEI=0 ESRI_LICENSE_HOST=@IETVIRLIC26IPRO /qn /norestart" -Wait -NoNewWindow

# Verificar si la instalación principal fue exitosa
$ProductCodePrincipal = "{76DFAD3E-96C5-4544-A6B4-3774DBF88B4E}" # Reemplaza esto con el código de producto real de la instalación principal
$instalacionPrincipalExitosa = $false
$product = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE IdentifyingNumber = '$ProductCodePrincipal'"
if ($product) {
    Write-Host "La instalación principal de ArcGIS Pro 3.2 se instaló correctamente."
    $instalacionPrincipalExitosa = $true
} else {
    Write-Host "La instalación principal de ArcGIS Pro 3.2 falló."
}

Write-Host "Procediendo con la actualización..."
Start-Process "msiexec.exe" -ArgumentList "/p `"$instaladorActualizacion`" /qn /norestart" -Wait -NoNewWindow


# MODIFICAR RAMA DE REGISTRO DE ARCGHIS PRO PARA HABILITAR ACTUALIZACIONES

# Define the path to the registry key
$registryPath = "HKLM:\SOFTWARE\ESRI\ArcGISPro\Settings"

# Define the name of the DWORD value and the new value to assign
$valueName = "CheckForUpdatesAtStartup"
$newValueData = 1

# Check if the registry path exists
if (Test-Path $registryPath) {
    # Modify the existing DWORD value with the new data
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $newValueData
    Write-Output "The registry value has been modified successfully."
} else {
    Write-Output "The specified registry path does not exist."
}
<# Verificar si la actualización fue exitosa
$ProductCodeActualizacion = "{68EF6F8E-A8F5-45F4-8730-0BBD2CCFCF66}" # Asume el mismo ProductCode para simplificar
$actualizacionExitosa = $false
$productUpdate = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE IdentifyingNumber = '$ProductCodeActualizacion'"
if ($productUpdate) {
    Write-Host "La actualización de Kofax Power PDF Advanced se completó exitosamente."
    $actualizacionExitosa = $true
} else {
    Write-Host "La actualización de Kofax Power PDF Advanced falló."
}

# Evaluar si ambos procesos fueron exitosos y devolver un código de salida
if ($instalacionPrincipalExitosa -and $actualizacionExitosa) {
    Write-Host "Tanto la instalación principal como la actualización se completaron exitosamente."
    exit 0
} else {
    Write-Host "Uno o ambos procesos de instalación fallaron."
    exit 1
}
#>
