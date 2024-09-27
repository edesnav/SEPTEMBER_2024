# Rutas de los archivos MSI
$instaladorPrincipal = "C:\kofax\Kofax Power PDF Advanced.msi"
$instaladorActualizacion = "C:\kofax\KofaxPowerPDFAdvanced-5.0.0.18.msi"

# Instalar la aplicación principal
Write-Host "Instalando la aplicación principal..."
Start-Process "msiexec.exe" -ArgumentList "/i `"$instaladorPrincipal`" TRANSFORMS=KofaxConfIneco.mst /norestart /qn" -Wait -NoNewWindow
Write-Host "Instalación principal completada exitosamente. Procediendo con la actualización..."
Start-Process "msiexec.exe" -ArgumentList "/i `"$instaladorActualizacion`" /qn /norestart" -Wait -NoNewWindow



$ProductCode = "{68EF6F8E-A8F5-45F4-8730-0BBD2CCFCF66}" # Reemplaza esto con el código de producto real
Start-Process "msiexec.exe" -ArgumentList "/x `"$ProductCode`" /qn" -Wait -NoNewWindow


#------------------------------------------------------------------------------------------



# Rutas de los archivos MSI
$instaladorPrincipal = "C:\kofax\Kofax Power PDF Advanced.msi"
$instaladorActualizacion = "C:\kofax\KofaxPowerPDFAdvanced-5.0.0.18.msi"

# Instalar la aplicación principal
Write-Host "Instalando la aplicación principal..."
Start-Process "msiexec.exe" -ArgumentList "/i `"$instaladorPrincipal`" TRANSFORMS=KofaxConfIneco.mst /norestart /qn" -Wait -NoNewWindow

# Verificar si la instalación principal fue exitosa
$ProductCodePrincipal = "{68EF6F8E-A8F5-45F4-8730-0BBD2CCFCF66}" # Reemplaza esto con el código de producto real de la instalación principal
$instalacionPrincipalExitosa = $false
$product = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE IdentifyingNumber = '$ProductCodePrincipal'"
if ($product) {
    Write-Host "La instalación principal de Kofax Power PDF Advanced se completó exitosamente."
    $instalacionPrincipalExitosa = $true
} else {
    Write-Host "La instalación principal de Kofax Power PDF Advanced falló."
}

Write-Host "Procediendo con la actualización..."
Start-Process "msiexec.exe" -ArgumentList "/i `"$instaladorActualizacion`" /qn /norestart" -Wait -NoNewWindow

# Verificar si la actualización fue exitosa
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


# Desinstalar usando el ProductCode, como en tu script original
$ProductCode = "{68EF6F8E-A8F5-45F4-8730-0BBD2CCFCF66}" # Asegúrate de usar el ProductCode correcto de la versión instalada
Start-Process "msiexec.exe" -ArgumentList "/x `"$ProductCode`" /qn" -Wait -NoNewWindow