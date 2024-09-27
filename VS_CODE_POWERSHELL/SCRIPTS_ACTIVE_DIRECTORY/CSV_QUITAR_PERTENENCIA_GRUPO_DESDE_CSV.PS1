#1 - SCRIPT 1: script eliminar usuarios de grupos desde un csv sin exportar resultados a fichero

# Ruta del archivo CSV
$csvPath = "C:\IMPORT\usuarios.csv" # Cambia esta ruta a la ubicación de tu archivo CSV

# Nombre del grupo de seguridad
$securityGroupName = "SCCM_AdobeAcrobatProDC"

# Lee los datos del archivo CSV
$users = Import-Csv -Path $csvPath

# Itera sobre cada usuario en el archivo CSV
foreach ($user in $users) {
    $userName = $user.Usuario # Cambia 'Usuario' por el nombre de la columna en tu CSV
    
    # Verifica si el usuario pertenece al grupo de seguridad
    $isMember = Get-ADUser -Identity $userName -Property MemberOf | Select-Object -ExpandProperty MemberOf | Where-Object { $_ -eq "CN=$securityGroupName,OU=Grupos Aplicaciones,OU=Configuration Manager,OU=Grupos de Seguridad,OU=INECO - EXTRAS,DC=ineco,DC=es" }
#INECO - EXTRAS/Grupos de Seguridad/Configuration Manager/Grupos Aplicaciones
    if ($isMember) {
        # Quita al usuario del grupo de seguridad
        Remove-ADGroupMember -Identity $securityGroupName -Members $userName -Confirm:$false
        Write-Host "Usuario $userName eliminado del grupo $securityGroupName"
    } else {
        Write-Host "Usuario $userName no pertenece al grupo $securityGroupName"
    }
}

##el mismo script pero exportando a archivo los resultados"

#--------------------------------------------------------------
#1 - SCRIPT 2:script eliminar usuarios de grupos EXPORTANDO RESULTADOS A CSV 

# Ruta del archivo CSV de entrada
$csvPath = "C:\IMPORT\usuarios.csv" # Cambia esta ruta a la ubicación de tu archivo CSV

# Nombre del grupo de seguridad
$securityGroupName = "SCCM_AdobeAcrobatProDC"

# Ruta y nombre del archivo CSV de salida
$date = Get-Date -Format "dd-MMMM-yyyy_HH-mm-ss"
$outputCsvPath = "C:\EXPORT\Lista_usuarios-eliminados_de-$date.csv"

# Crear una lista para almacenar los usuarios eliminados
$deletedUsers = @()

# Lee los datos del archivo CSV de entrada
$users = Import-Csv -Path $csvPath

# Itera sobre cada usuario en el archivo CSV de entrada
foreach ($user in $users) {
    $userName = $user.Usuario # Cambia 'Usuario' por el nombre de la columna en tu CSV
    
    # Verifica si el usuario pertenece al grupo de seguridad
    $isMember = Get-ADUser -Identity $userName -Property MemberOf | Select-Object -ExpandProperty MemberOf | Where-Object { $_ -eq "CN=$securityGroupName,OU=Grupos Aplicaciones,OU=Configuration Manager,OU=Grupos de Seguridad,OU=INECO - EXTRAS,DC=ineco,DC=es" }

    if ($isMember) {
        # Quita al usuario del grupo de seguridad
        Remove-ADGroupMember -Identity $securityGroupName -Members $userName -Confirm:$false
        Write-Host "Usuario $userName eliminado del grupo $securityGroupName"

        # Añade el usuario eliminado a la lista
        $deletedUsers += [PSCustomObject]@{
            Usuario = $userName
            Grupo_al_que_pertenecía = $securityGroupName
            fecha_eliminación_Pertenencia_a_rupo = (Get-Date)
        }
    } else {
        Write-Host "Usuario $userName no pertenece al grupo $securityGroupName"
    }
}

# Exporta la lista de usuarios eliminados a un archivo CSV
if ($deletedUsers.Count -gt 0) {
    $deletedUsers | Export-Csv -Path $outputCsvPath -NoTypeInformation
    Write-Host "Lista de usuarios eliminados exportada a $outputCsvPath"
} else {
    Write-Host "No se eliminaron usuarios del grupo $securityGroupName"
}






<#
$user.Usuario

# Crear un objeto personalizado con propiedades
$person = [PSCustomObject]@{
    Name    = "John Doe"
    Email   = "john.doe@example.com"
    Department = "IT"
    Title   = "Administrator"
}

# Mostrar el objeto
$person |Get-Member

#>
