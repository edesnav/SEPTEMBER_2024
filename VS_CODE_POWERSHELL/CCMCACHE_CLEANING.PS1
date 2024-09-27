# Ruta predeterminada de la caché de SCCM
$rutaCache = "$($env:windir)\ccmcache"

# Comprobar si la carpeta de caché existe
if (Test-Path -Path $rutaCache) {
    try {
        # Eliminar todo el contenido de la carpeta de caché
        Get-ChildItem -Path $rutaCache -Recurse | Remove-Item -Force -Recurse -ErrorAction Stop
        Write-Host "La cache de SCCM (ccmcache) ha sido limpiada con exito." -ForegroundColor Green
    } catch {
        Write-Error "Error al intentar limpiar la cache de SCCM: $_"
    }
} else {
    Write-Host "La carpeta de cache de SCCM ($rutaCache) no existe o no fue encontrada." -ForegroundColor Yellow
}
