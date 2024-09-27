# Importa el módulo ImportExcel
Import-Module ImportExcel

# Ruta del archivo Excel
$excelPath = "C:\ruta\al\archivo\usuarios.xlsx" # Cambia esta ruta a la ubicación de tu archivo

# Nombre de la hoja en el archivo Excel
$sheetName = "Sheet1" # Cambia esto si tu hoja tiene un nombre diferente

# Nombre del grupo de seguridad
$securityGroupName = "seguridad1"

# Lee los datos del archivo Excel
$users = Import-Excel -Path $excelPath -WorksheetName $sheetName

# Itera sobre cada usuario en el archivo Excel
foreach ($user in $users) {
    $userName = $user.Usuario # Cambia 'Usuario' por el nombre de la columna en tu Excel
    
    # Verifica si el usuario pertenece al grupo de seguridad
    $isMember = Get-ADUser -Identity $userName -Property MemberOf | Select-Object -ExpandProperty MemberOf | Where-Object { $_ -eq "CN=$securityGroupName,CN=Users,DC=ineco,DC=es" }

    if ($isMember) {
        # Quita al usuario del grupo de seguridad
        Remove-ADGroupMember -Identity $securityGroupName -Members $userName -Confirm:$false
        Write-Host "Usuario $userName eliminado del grupo $securityGroupName"
    } else {
        Write-Host "Usuario $userName no pertenece al grupo $securityGroupName"
    }
}
