#SCRIPT EXTRAER DATOS DE NOMBRES COMPUTERS
#DEL COMPONENTE SMS_CLIENT_CONFIG_MANAGER
#Y EXPORTAR A CSV

#1 IMPORTACION CSV  CON FILTROS DEL COMPONENTE SMS_CLIENT_CONFIG_MANAGER
$datosCsv = Import-Csv -Path "C:\exports\DESCONOCIDO.csv"

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
#$objetosParaCsv | Export-Csv -Path "C:\exports\datosExtraidosUnicos3.csv" -NoTypeInformation
#--------------------------------------------------------------------------------

# Importar el archivo CSV exportado
#$datosExtraidos = Import-Csv -Path "C:\exports\datosExtraidosUnicos3.csv"

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


#--------------------------------------------------------------------------------
#PRUEBA DE VARIABLE $DATOSEXTRAIDOS PARA COMPROBAR QUE SE HAYAN EXTRAIDO LOS DATOS
$datosExtraidos = @("W0001", "W0002", "W0003", "GM08XJ6E", "GM08XKT0", "GM08XJ5R", "PC2J2GZ7", "PC2HZ39W", "GM08XJ68", "GM08XJ6K", "GM08XKQS", "GM08XJ64", "GM08XKTG", "GM08XKQD", "GM08XKT6", "GM08XKQY", "GM08XKQX", "GM08XKRM")
#--------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# 2. IMPORTACION CSV CON DATOS DE UNA COLUMNA SOLO DE NOMBRES DE EQUIPOS
#PARTE PARA IMPORTAR DEUN ARCHIVO CSV CON UNA COLUMNA CON EL NOMBRE DE LOS EQUIPOS E IMPORTAR LA PRIMERA COLUMNA
# Ruta al archivo CSV
$rutaArchivoCsv = "C:\exports\DESCONOCIDO.csv"

# Importar los datos de la primera columna del archivo CSV
# Suponiendo que el archivo no tiene encabezado
$datosImportados = Import-Csv -Path $rutaArchivoCsv -Header "ID" | Select-Object -ExpandProperty ID

# Imprimir los datos importados para verificar
$datosImportados | ForEach-Object { Write-Host $_ }
$datosExtraidos =$datosImportados
#---------------------------------------------------------------------------------







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
        $pingResult = Test-Connection -ComputerName $direccionIP -Count 1 -Quiet -ErrorAction SilentlyContinue

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





Add-WindowsCapability -Online -Name Rsat.DHCP.Tools~~~~0.0.1.0 -Source "D:\path\to\FOD\files" -LimitAccess
