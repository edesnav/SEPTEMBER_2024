# Ruta del archivo CSV de entrada
$csvPath = "C:\IMPORT\usuarios.csv" # Cambia esta ruta a la ubicación de tu archivo CSV

# Nombre del grupo de seguridad
$securityGroupName = "GS_SCCM_PRUEBAS"

# Ruta y nombre del archivo CSV de salida
$date = Get-Date -Format "dd-MMMM-yyyy HH-mm-ss"
$outputCsvPath = "C:\EXPORT\Lista_usuarios_agregados_a_$securityGroupName-$date.csv"

# Crear una lista para almacenar los usuarios agregados
$addedUsers = @()

# Lee los datos del archivo CSV de entrada
$users = Import-Csv -Path $csvPath

# Itera sobre cada usuario en el archivo CSV de entrada
foreach ($user in $users) {
    $userName = $user.Usuario # Cambia 'Usuario' por el nombre de la columna en tu CSV
    
    # Agregar el usuario al grupo de seguridad
    Add-ADGroupMember -Identity $securityGroupName -Members $userName -ErrorAction SilentlyContinue
    
    if ($?) {
        Write-Host "Usuario $userName agregado al grupo $securityGroupName"

        # Añade el usuario agregado a la lista
        $addedUsers += [PSCustomObject]@{
            Usuario = $userName
            Grupo = $securityGroupName
            Fecha_Agregado = (Get-Date)
        }
    } else {
        Write-Host "Error al agregar el usuario $userName al grupo $securityGroupName"
    }
}

# Exporta la lista de usuarios agregados a un archivo CSV
if ($addedUsers.Count -gt 0) {
    $addedUsers | Export-Csv -Path $outputCsvPath -NoTypeInformation
    Write-Host "Lista de usuarios agregados exportada a $outputCsvPath"
} else {
    Write-Host "No se agregaron usuarios al grupo $securityGroupName"
}
