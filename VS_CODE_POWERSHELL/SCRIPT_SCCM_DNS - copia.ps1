#SCRIPT EXTRAER DATOS DE NOMBRES COMPUTERS
#DEL COMPONENTE SMS_CLIENT_CONFIG_MANAGER
#Y EXPORTAR A CSV

$datosCsv = Import-Csv -Path "C:\exports\1week.csv"

# Patrón para identificar texto entre comillas
$patron = '"([^"]+)"'

# Lista para almacenar los datos extraídos
$datos2 = @()

foreach ($fila in $datosCsv) {
    foreach ($propiedad in $fila.PSObject.Properties) {
        if ($propiedad.Value -match $patron) {
            # Agregar cada coincidencia a la lista de datos extraídos
            $datos2 += $matches[1]
        }
    }
}
$datos2 | ForEach-Object { Write-Host $_ }

# Eliminar duplicados y convertir en objetos para CSV
$objetosParaCsv = $datos2 | Sort-Object -Unique | ForEach-Object { [PSCustomObject]@{Valor = $_} }

#--------------------------------------------------------------------------------
# Exportar a CSV
#$objetosParaCsv | Export-Csv -Path "C:\exports\datosExtraidosUnicos2.csv" -NoTypeInformation
#--------------------------------------------------------------------------------

#--------------------------------------------------------------------------------
#ESTA PARTE LA OMITO PARA LUEGO GENERAR UN HASTABLE
#COMPROBAR SI RESUELVE POR DNS

<# foreach ($nombreComputadora in $datos2) {
    try {
        # Intenta resolver el nombre de la computadora por DNS
        $resultado = Resolve-DnsName -Name $nombreComputadora -ErrorAction Stop
        Write-Host "El nombre de computadora '$nombreComputadora' se resuelve a $($resultado.IPAddress)."
    } catch {
        # Maneja el caso en que la resolución de DNS falle
        Write-Host "El nombre de computadora '$nombreComputadora' no se pudo resolver por DNS."
    }
}

#>
#--------------------------------------------------------------------------------


#CREAR UN HASH TABLE PARA ALMACENAR LOS RESULTADOS
$resultadosDns = @()

foreach ($nombreComputadora in $datos2) {
    try {
        $resultado = Resolve-DnsName -Name $nombreComputadora -ErrorAction Stop
        $resultadoDns = [PSCustomObject]@{
            NombreComputadora = $nombreComputadora
            Resuelto          = "Sí"
            DireccionIP       = $resultado.IPAddress
        }
    } catch {
        $resultadoDns = [PSCustomObject]@{
            NombreComputadora = $nombreComputadora
            Resuelto          = "No"
            DireccionIP       = "N/A"
        }
    }
    $resultadosDns += $resultadoDns
}


#EXPORTSTART RESULTADOS DE HASTABLE RESULTADOS DNS A UN ARCHIVO CSV"

$resultadosDns | Export-Csv -Path "C:\EXPORTS\resultadosDns.csv" -NoTypeInformation

