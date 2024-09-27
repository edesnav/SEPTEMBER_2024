#
# Press 'F5' to run this script. Running this script will load the ConfigurationManager
# module for Windows PowerShell and will connect to the site.
#
# This script was auto-generated at '11/03/2024 9:18:07'.

# Site configuration
$SiteCode = "012" # Site code 
$ProviderMachineName = "s-sccm2k12-i.ineco.es" # SMS Provider machine name

# Customizations
$initParams = @{}
#$initParams.Add("Verbose", $true) # Uncomment this line to enable verbose logging
#$initParams.Add("ErrorAction", "Stop") # Uncomment this line to stop the script on any errors

# Do not change anything below this line

# Import the ConfigurationManager.psd1 module 
if((Get-Module ConfigurationManager) -eq $null) {
    Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" @initParams 
}

# Connect to the site's drive if it is not already present
if((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null) {
    New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName @initParams
}

# Set the current location to be the site code.
Set-Location "$($SiteCode):\" @initParams

# Ruta al archivo de entrada y al archivo de salida
$archivoEntrada = "C:\SCCM_DATOS_COLECCIONES\email.txt"
$archivoSalida = "C:\SCCM_DATOS_COLECCIONES\usuario.txt"
$archivoLog = "C:\SCCM_DATOS_COLECCIONES\log.csv"

# Crear el archivo CSV de log si no existe
if (-not (Test-Path $archivoLog)) {
    "Action,Message" | Out-File -FilePath $archivoLog -Encoding UTF8
}

# Función para escribir en el archivo de log CSV y mostrar en pantalla
function Escribir-LogCSV {
    param (
        [string]$Action,
        [string]$Message
    )
    # Escribir en el archivo CSV
    "$Action,`"$Message`"" | Out-File -FilePath $archivoLog -Append -Encoding UTF8
    # Mostrar el mensaje en pantalla
    Write-Host "[$Action] $Message"
}

# Leer las direcciones de correo electrónico del archivo de entrada
$correos = Get-Content -Path $archivoEntrada

# Crear una lista para almacenar los nombres de usuario
$usuarios = @()

# Iterar sobre cada correo electrónico y extraer el nombre de usuario
foreach ($correo in $correos) {
    # Eliminar espacios en blanco y caracteres innecesarios
    $correo = $correo.Trim()

    # Verificar que la línea no esté vacía
    if (![string]::IsNullOrWhiteSpace($correo)) {
        # Extraer el nombre de usuario antes de la '@'
        $usuario = $correo.Split('@')[0]

        # Agregar el prefijo 'INECO\' al nombre de usuario
        $usuarioConPrefijo = "INECO\" + $usuario

        # Agregar el nombre de usuario con prefijo a la lista
        $usuarios += $usuarioConPrefijo
    }
}

# Guardar los nombres de usuario en el archivo de salida
$usuarios | Out-File -FilePath $archivoSalida -Encoding UTF8

Escribir-LogCSV -Action "Success" -Message "Proceso completado. Los nombres de usuario se han guardado en $archivoSalida."

# Nombre de la colección de SCCM
$CollectionName = "Formación Anaconda"

# Verificar que la colección existe
$Coleccion = Get-CMUserCollection -Name $CollectionName
if (!$Coleccion) {
    Escribir-LogCSV -Action "Error" -Message "La colección '$CollectionName' no existe en SCCM."
    exit
}

# Leer la lista de nombres de usuario desde el archivo de salida
$Users = Get-Content -Path $archivoSalida

# Obtener los miembros actuales de la colección
$MiembrosColeccion = Get-CMCollectionMember -CollectionName $CollectionName | Select-Object -ExpandProperty ResourceID

# Iterar sobre cada usuario y agregarlos a la colección si no están ya presentes
foreach ($User in $Users) {
    # Verificar que la línea no esté vacía
    if (![string]::IsNullOrWhiteSpace($User)) {
        # Obtener el usuario en SCCM utilizando el nombre de usuario
        $CMUser = Get-CMUser -Name $User

        if ($CMUser) {
            # Verificar si el usuario ya es miembro de la colección
            if ($MiembrosColeccion -contains $CMUser.ResourceID) {
                Escribir-LogCSV -Action "Info" -Message "El usuario '$User' ya es miembro de la colección '$CollectionName'."
            } else {
                # Agregar el usuario a la colección
                try {
                    Add-CMUserCollectionDirectMembershipRule -CollectionName $CollectionName -ResourceId $CMUser.ResourceID
                    Escribir-LogCSV -Action "Success" -Message "Usuario '$User' agregado a la colección '$CollectionName'."
                } catch {
                    Escribir-LogCSV -Action "Error" -Message "Error al agregar el usuario '$User' a la colección: $($_.Exception.Message)"
                }
            }
        } else {
            Escribir-LogCSV -Action "Error" -Message "No se encontró el usuario '$User' en SCCM."
        }
    } else {
        Escribir-LogCSV -Action "Warning" -Message "Entrada vacía en la lista de usuarios."
    }
}

Write-Host "Proceso completado. Revisa el archivo de log en $archivoLog."


