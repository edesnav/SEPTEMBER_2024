#SCRIPT EXTRAER DATOS DE NOMBRES COMPUTERS
#DEL COMPONENTE SMS_CLIENT_CONFIG_MANAGER
#Y EXPORTAR A CSV

$datosCsv = Import-Csv -Path "C:\exports\1week.csv"

# Patrón para identificar texto entre comillas
$patron = '"([^"]+)"'

# Lista para almacenar los datos extraídos
$datosExtraidos = @()

foreach ($fila in $datosCsv) {
    foreach ($propiedad in $fila.PSObject.Properties) {
        if ($propiedad.Value -match $patron) {
            # Agregar cada coincidencia a la lista de datos extraídos
            $datosExtraidos += $matches[1]
        }
    }
}
$datosExtraidos | ForEach-Object { Write-Host $_ }

# Eliminar duplicados y convertir en objetos para CSV
$objetosParaCsv = $datosExtraidos | Sort-Object -Unique | ForEach-Object { [PSCustomObject]@{Valor = $_} }

#--------------------------------------------------------------------------------
# Exportar a CSV
#$objetosParaCsv | Export-Csv -Path "C:\exports\datosExtraidosUnicos2.csv" -NoTypeInformation
#--------------------------------------------------------------------------------

#--------------------------------------------------------------------------------
#ESTA PARTE LA OMITO PARA LUEGO GENERAR UN HASTABLE
#COMPROBAR SI RESUELVE POR DNS

<# foreach ($nombreComputadora in $datosExtraidos) {
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

foreach ($nombreComputadora in $datosExtraidos) {
    # Inicializar variables para los nuevos datos
    $enDominio = $null
    $ultimoLogon = $null
    $nombreDominio = $null
    
    try {
        $resultado = Resolve-DnsName -Name $nombreComputadora -ErrorAction Stop
        $direccionIP = $resultado.IPAddress
        # Intentar hacer ping
        $pingResult = Test-Conne
        ction -ComputerName $direccionIP -Count 1 -Quiet -ErrorAction SilentlyContinue

        # Comprobar si la computadora está en el dominio y obtener la última fecha de logon
        try {
            $compInfo = Get-ADComputer -Identity $nombreComputadora -Properties LastLogonDate -ErrorAction Stop
            $enDominio = "Sí"
            $ultimoLogon = $compInfo.LastLogonDate
            $nombreDominio = $compInfo.DNSHostName.Split('.')[1] # Obtener el nombre del dominio
        } catch {
            $enDominio = "No"
            $ultimoLogon = "N/A"
            $nombreDominio = "N/A"
        }

        $resultadoDns = [PSCustomObject]@{
            "Nombre de Equipo" = $nombreComputadora
            "Resuelto DNS"     = "Sí"
            "DireccionIP"      = $direccionIP
            "En el Dominio"    = $enDominio
            "Último Logon"     = $ultimoLogon
            "Responde a Ping"  = if ($pingResult) { "Sí" } else { "No" }
            "Nombre del Dominio" = $nombreDominio # Nueva columna para el nombre del dominio
        }
    } catch {
        $resultadoDns = [PSCustomObject]@{
            "Nombre de Equipo" = $nombreComputadora
            "Resuelto DNS"     = "No"
            "DireccionIP"      = "Desconocido"
            "En el Dominio"    = "N/A"
            "Último Logon"     = "N/A"
            "Responde a Ping"  = "N/A"
            "Nombre del Dominio" = "N/A" # Nueva columna para el nombre del dominio
        }
    }
    $resultadosDns += $resultadoDns
}



#EXPORTSTART RESULTADOS DE HASTABLE RESULTADOS DNS A UN ARCHIVO CSV"

$resultadosDns | Export-Csv -Path "C:\EXPORTS\resultadosDns.csv" -NoTypeInformation

$resultadosDns | Format-Table -AutoSize





