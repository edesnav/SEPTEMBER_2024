# Define el path al archivo CSV
$filePath = "C:\excel\export.csv"

# Lee el archivo CSV
$lineas = Get-Content -Path $filePath

# Define la expresión regular para encontrar texto entre comillas
$patron = '"([^"]+)"'

# Utiliza un HashSet para almacenar valores únicos
$datosExtraidos = [System.Collections.Generic.HashSet[string]]::new()

foreach ($linea in $lineas) {
    # Encuentra todas las coincidencias de la expresión regular en la línea actual
    [regex]::Matches($linea, $patron) | ForEach-Object {
        # Intenta agregar cada coincidencia al HashSet para asegurar la unicidad
        $null = $datosExtraidos.Add($_.Groups[1].Value)
    }
}

# Si deseas convertir el HashSet de nuevo a un array para manipulación adicional en PowerShell
$datosUnicos = @($datosExtraidos)

# Imprime los datos extraídos y únicos
$datosUnicos | ForEach-Object { Write-Host $_ }

