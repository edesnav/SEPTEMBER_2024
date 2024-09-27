## 1 ---BUSQUEDA PROPIEDADES OBJETOS AD CON FILTROS--


Get-ADUser -Identity "eduardo.espartosa" -Properties *
Get-ADUser -Identity "usuario.prueba1" -Properties * |Get-Member
Get-ADUser -Identity "usuario.prueba4" -Properties DisplayName, EmailAddress, Department, Title | Select-Object DisplayName, EmailAddress, Department, Title
Get-ADUser -Identity "usuario.prueba4" -Properties * | Select-Object DisplayName, EmailAddress, Department, Title,mail

# Obtener todos los usuarios y filtrar por sAMAccountName usando Where-Object
Get-ADUser -Filter * -Properties DisplayName, EmailAddress, Department, Title | Where-Object { $_.sAMAccountName -eq "usuario.prueba4" } | Select-Object DisplayName, EmailAddress, Department, Title
Get-ADUser -Filter * -Properties * | Where-Object { $_.sAMAccountName -eq "usuario.prueba4" } | Select-Object DisplayName, EmailAddress, Department, Title,COMPANY


## 2 ---BUSQUEDA USUARIOS PERTENECIENTES A UN GRUPO DE SEGURIDAD

# USUARIOS PERTENECIENTES AZ UN GRUPO DE SEGURIDAD
Get-ADGroupMember -Identity "GS_SEGURIDAD1" | Where-Object { $_.objectClass -eq 'user' } | Select-Object Name, SamAccountName, EmailAddress



#----------------- MAS DETALLADO Y EN FORMATO LISTA DEL ANTERIOR---------------------
#1 - SCRIPT 2: EXPORTAR DETALLES DE USUARIOS DE UN GRUPO DE SEGURIDAD A UN ARCHIVO CSV

# Importar el módulo de Active Directory
Import-Module ActiveDirectory

# Obtener los miembros del grupo de seguridad 'GS_SEGURIDAD1'
$groupMembers = Get-ADGroupMember -Identity "SCCM_AdobeAcrobatProDC" | Where-Object { $_.objectClass -eq "user" }

# Crear una lista para almacenar los detalles de los usuarios
$userDetails = @()

# Iterar sobre cada miembro y obtener sus propiedades
foreach ($member in $groupMembers) {
    $user = Get-ADUser -Identity $member.SamAccountName -Properties DisplayName, EmailAddress, Department, Title
    $userDetails += [PSCustomObject]@{
        DisplayName = $user.DisplayName
        EmailAddress = $user.EmailAddress
        Department = $user.Department
        Title = $user.Title
        SamAccountName = $user.SamAccountName
    }
}

# Mostrar los detalles de los usuarios en columnas
$userDetails | Format-Table -AutoSize

# Opcional: Guardar en un archivo CSV
$userDetails | Export-Csv -Path "C:\IMPORT\SCCM_AdobeAcrobatProDC_Users_23_07.csv" -NoTypeInformation


#------------------------------------------------------------------------------------------------

# Importar el módulo de Active Directory
Import-Module ActiveDirectory

# Obtener los miembros del grupo de seguridad 'GS_SEGURIDAD1'
$groupMembers = Get-ADGroupMember -Identity "SCCM_AdobeAcrobatProDC" | Where-Object { $_.objectClass -eq "user" }

# Crear una lista para almacenar los detalles de los usuarios
$userDetails = @()

# Iterar sobre cada miembro y obtener sus propiedades
foreach ($member in $groupMembers) {
    $user = Get-ADUser -Identity $member.SamAccountName -Properties DisplayName, EmailAddress, Department, Title
    $userDetails += [PSCustomObject]@{
        DisplayName = $user.DisplayName
        EmailAddress = $user.EmailAddress
        Department = $user.Department
        Title = $user.Title
        SamAccountName = $user.SamAccountName
    }
}

# Mostrar los detalles de los usuarios en columnas
$userDetails | Format-Table -AutoSize

# Convertir a CSV
$csvContent = $userDetails | ConvertTo-Csv -NoTypeInformation

# Guardar en un archivo CSV con codificación UTF-8 BOM
$csvContent | Out-File -FilePath "C:\IMPORT\SCCM_AdobeAcrobatProDC_Users.csv" -Encoding UTF8BOM











