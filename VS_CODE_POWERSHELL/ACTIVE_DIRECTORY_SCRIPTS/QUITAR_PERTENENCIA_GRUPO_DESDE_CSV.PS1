# Ruta del archivo CSV
$csvPath = "C:\IMPORT\usuarios.csv" # Cambia esta ruta a la ubicación de tu archivo CSV

# Nombre del grupo de seguridad
$securityGroupName = "GS_SCCM_PRUEBAS"

# Lee los datos del archivo CSV
$users = Import-Csv -Path $csvPath

# Itera sobre cada usuario en el archivo CSV
foreach ($user in $users) {
    $userName = $user.Usuario # Cambia 'Usuario' por el nombre de la columna en tu CSV
    
    # Verifica si el usuario pertenece al grupo de seguridad
    $isMember = Get-ADUser -Identity $userName -Property MemberOf | Select-Object -ExpandProperty MemberOf | Where-Object { $_ -eq "CN=$securityGroupName,OU=sccm_pruebas,DC=ineco,DC=es" }

    if ($isMember) {
        # Quita al usuario del grupo de seguridad
        Remove-ADGroupMember -Identity $securityGroupName -Members $userName -Confirm:$false
        Write-Host "Usuario $userName eliminado del grupo $securityGroupName"
    } else {
        Write-Host "Usuario $userName no pertenece al grupo $securityGroupName"
    }
}



