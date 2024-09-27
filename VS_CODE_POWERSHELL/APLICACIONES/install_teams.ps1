# Ruta al ejecutable TeamsBootstrapper
#cd C:\16
$bootstrapperPath = ".\teamsbootstrapper.exe"  # Cambia esto a la ruta real

# Ruta al directorio de destino para copiar archivos
$destinationPath = "C:\temp\teams"

# Crear el directorio de destino si no existe
if (-Not (Test-Path -Path $destinationPath)) {
    New-Item -ItemType Directory -Path $destinationPath
}

# Copiar el contenido actual al directorio de destino
Write-Host "Copiando archivos al directorio: $destinationPath"
Copy-Item -Path ".\*" -Destination $destinationPath -Recurse -force

# Verificar si la copia fue exitosa
if (-Not (Test-Path -Path $destinationPath)) {
    Write-Error "Error al copiar archivos al directorio: $destinationPath"
    exit 1
}

Start-Sleep -Seconds 10
Stop-Process -Name ms-teams -Force
# Ejecutar el comando de desinstalación
Write-Host "Ejecutando comando de desinstalaciÃ³n: $bootstrapperPath -u"
& $bootstrapperPath -u

# Esperar unos segundos para asegurarse de que la desinstalación se complete
Start-Sleep -Seconds 10

# Ejecutar el comando de limpieza o preparación
Write-Host "Ejecutando comando de limpieza/preparaciÃ³n: $bootstrapperPath -x"
& $bootstrapperPath -x

# Esperar unos segundos para asegurarse de que la limpieza/preparación se complete
Start-Sleep -Seconds 10

# Ejecutar el comando de instalación
Write-Host "Ejecutando comando de instalaciÃ³n: $bootstrapperPath -p -o 'C:\TEMP\TEAMS\MSTeams-x64.msix'"
& $bootstrapperPath -p -o "C:\TEMP\TEAMS\MSTeams-x64.msix"

Write-Host "Microsoft Teams ha sido desinstalado, limpiado e instalado correctamente"


