
# Reset all variables
#Clear-Variable -Name archivoOrigen, directorioBase, fechaHoy, directorioDestino, archivoDestino, usuariosSTD, usuariosPRO, borrarusuario, contenidoArchivo, contenidoModificado, form, textBox, archivoStd, archivoPro, archivoBorrar, resultados, contenidoOriginal, contenidoSinUsuario, archivoResultados, usuariosSTDTexto, command, output, resultado, filePath, currentDate, fileDate, subfolderName, subfolderPath, newFilePath

# Add your code below this line
# Define las rutas de origen y destino base
$archivoOrigen = "C:\Program Files\ZWSOFT\ZWSOFT Network License Manager\zwflex.opt"
$directorioBase = "C:\TASKS\ZWCAD\BACKUPS"


# Obtén la fecha actual en formato año-mes-día
$fechaHoy = (Get-Date).ToString("dd-MM-yyyy")

# Construye la ruta del directorio destino con la fecha actual
$directorioDestino = Join-Path -Path $directorioBase -ChildPath $fechaHoy

# Comprueba si la carpeta con la fecha actual ya existe
if (-not (Test-Path -Path $directorioDestino)) {
    # Si no existe, crea la carpeta
    New-Item -ItemType Directory -Path $directorioDestino
}

# Copia el archivo al directorio destino
$archivoDestino = Join-Path -Path $directorioDestino -ChildPath "zwflex.opt"
Copy-Item -Path $archivoOrigen -Destination $archivoDestino



# 2 ----------------------------------------------------------


# Carga de datos desde archivos CSV
$usuariosSTD = @(Get-Content -Path "C:\TASKS\ZWCAD\REPORTS\IMPORT_USERS\std.csv")
$usuariosPRO = @(Get-Content -Path "C:\TASKS\ZWCAD\REPORTS\IMPORT_USERS\pro.csv")
$borrarusuario = @(Get-Content -Path "C:\TASKS\ZWCAD\REPORTS\IMPORT_USERS\borrar_usuarios.csv")

# Busca y elimina el contenido de las variables en el archivo de origen
$usuariosSTD | ForEach-Object {
    $contenidoArchivo = Get-Content -Path $archivoOrigen
    $contenidoArchivo = $contenidoArchivo -replace ("(?<!\S)" + [regex]::Escape($_) + "(?!\S)"), ""
    $contenidoArchivo = $contenidoArchivo -replace '\s+', ' ' # Remove multiple spaces
    $contenidoArchivo | Set-Content -Path $archivoOrigen
}

$usuariosPRO | ForEach-Object {
    $contenidoArchivo = Get-Content -Path $archivoOrigen
    $contenidoArchivo = $contenidoArchivo -replace ("(?<!\S)" + [regex]::Escape($_) + "(?!\S)"), ""
    $contenidoArchivo = $contenidoArchivo -replace '\s+', ' ' # Remove multiple spaces
    $contenidoArchivo | Set-Content -Path $archivoOrigen
}

$borrarusuario | ForEach-Object {
    $contenidoArchivo = Get-Content -Path $archivoOrigen
    $contenidoArchivo = $contenidoArchivo -replace ("(?<!\S)" + [regex]::Escape($_) + "(?!\S)"), ""
    $contenidoArchivo = $contenidoArchivo -replace '\s+', ' ' # Remove multiple spaces
    $contenidoArchivo | Set-Content -Path $archivoOrigen
}


#-----------insertar datos de $usuariosSTD y $usuariosPRO en el archivo origen------------

# Lee el contenido del archivo origen
$contenidoArchivo = Get-Content -Path $archivoOrigen

# Inicializa una lista para almacenar el contenido modificado
$contenidoModificado = @()

foreach ($linea in $contenidoArchivo) {
    # Busca "roberto.vela" y añade los usuarios STD delante
    if ($linea -match "roberto.vela") {
        foreach ($usuarioSTD in $usuariosSTD) {
            $linea = $linea -replace "roberto.vela", "$usuarioSTD roberto.vela" -replace '\s+', ' '
        }
    }
    
    # Busca "montaje" y añade los usuarios PRO delante
    if ($linea -match "montaje") {
        foreach ($usuarioPRO in $usuariosPRO) {
            $linea = $linea -replace "montaje", "$usuarioPRO montaje" -replace '\s+', ' '
        }
    }
    
    # Agrega la línea modificada al contenido modificado
    $contenidoModificado += $linea
}

# Guarda el contenido modificado de vuelta al archivo origen o a un nuevo archivo
$contenidoModificado | Set-Content -Path $archivoOrigen # AÑADE LOS DATOS MODIFICADOS Y LOS GUARDA EN EL CONTENIDO ARCHIVO ORIGINAL DE LICENCIAS .OPT
$contenidomodificado_opt= Get-Content -Path $archivoOrigen #BUSCA CONTENIDO DEL ARCHIVO YA MODIFICADO CON ALTAS Y BAJAS DE USUARIO EN EL ARCHIVO DE LICNECIAS FINAL .OPT


#-------------------------------------

<# Cargar el ensamblado de .NET para Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Preparar la ventana y el TextBox
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Vista de Archivo'
$form.Size = New-Object System.Drawing.Size(700,500)
$form.StartPosition = 'CenterScreen'

$textBox = New-Object System.Windows.Forms.RichTextBox
$textBox.Dock = 'Fill'
$textBox.Multiline = $true
$textBox.ReadOnly = $true
$textBox.Font = New-Object System.Drawing.Font('Consolas', 10)

$form.Controls.Add($textBox)

# Suponiendo que $archivoOrigen contiene la ruta del archivo
$contenidoArchivo = Get-Content -Path $archivoOrigen
$textBox.Text = $contenidoArchivo -join "`r`n"

# Mostrar la ventana
$form.ShowDialog()

#>

#--------------BORRAR CONTENIDO DE LOS ARCHIVOS .CSV----------------


# Ruta de los archivos
$archivoStd = "C:\TASKS\ZWCAD\REPORTS\IMPORT_USERS\std.csv"
$archivoPro = "C:\TASKS\ZWCAD\REPORTS\IMPORT_USERS\pro.csv"
$archivoBorrar = "C:\TASKS\ZWCAD\REPORTS\IMPORT_USERS\borrar_usuarios.csv"

# Borra el contenido de los archivos
Set-Content -Path $archivoStd -Value ""
Set-Content -Path $archivoPro -Value ""
set-Content -Path $archivoBorrar -Value ""

#

#-------PREPARA LOS RESULTADOS PARA EXPORTAR A UN ARCHIVO DE TEXTO-------
$fechaEjecucion = Get-Date
$resultados = @()
$resultados += "-----------------------------------------"
$resultados += "`nFECHA DE EJECUCION: $fechaEjecucion"

# Filtrar arrays para incluir solo elementos con más de un carácter
$usuariosSTD = $usuariosSTD | Where-Object { $_.Length -gt 1 }
$usuariosPRO = $usuariosPRO | Where-Object { $_.Length -gt 1 }
$borrarUsuario = $borrarUsuario | Where-Object { $_.Length -gt 1  }

# Comprobar y procesar usuarios STD
$resultados += "`nRESULTADOS USUARIOS STANDARD:"
if ($usuariosSTD.Count -eq 0) {
    $resultados += "Sin carga de datos para Usuarios Standard."
} else {
    foreach ($usuarioSTD in $usuariosSTD) {
        if ($contenidomodificado_opt -match $usuarioSTD) {
            $resultados += "El usuario con Licencia STD '$usuarioSTD' se ha agregado al archivo de licencias .OPT"
        } else {
            $resultados += "ERROR: El usuario con Licencia STD '$usuarioSTD' no se ha agregado al archivo de licencias .OPT"
        }
    }
}

# Comprobar y procesar usuarios PRO
$resultados += "`nRESULTADOS USUARIOS PRO:"
if ($usuariosPRO.Count -eq 0) {
    $resultados += "Sin carga de datos para  Usuarios Pro."
} else {
    foreach ($usuarioPRO in $usuariosPRO) {
        if ($contenidomodificado_opt -match $usuarioPRO) {
            $resultados += "El usuario con Licencia PRO '$usuarioPRO' se ha agregado al archivo de licencias .OPT"
        } else {
            $resultados += "ERROR: El usuario con Licencia PRO '$usuarioPRO' no se ha agregado al archivo de licencias .OPT"
        }
    }
}

# Comprobar y procesar usuarios a borrar
$resultados += "`nRESULTADOS USUARIOS BORRADOS:"
if ($borrarUsuario.Count -eq 0) {
    $resultados += "No hay datos cargados para Usuarios Borrados."
} else {
    foreach ($usuarioBorrar in $borrarUsuario) {
        $contenidoOriginal = Get-Content -Path $archivoOrigen
        $contenidoSinUsuario = $contenidoOriginal -replace ("(?<!\S)" + [regex]::Escape($usuarioBorrar) + "(?!\S)"), ""
        
        if ($contenidoOriginal -eq $contenidoSinUsuario) {
            # Si el contenido no cambió después del reemplazo, el usuario no estaba en el archivo
            $resultados += "El usuario '$usuarioBorrar' no figura en el archivo de licencias .OPT. y se considera borrado"
        } else {
            # Si el contenido cambió, asumimos que el usuario estaba y fue "borrado"
            $resultados += "El usuario '$usuarioBorrar' no figura en el archivo de licencias .OPT. y se considera borrado"
            # Actualizar el contenido del archivo para reflejar el borrado
            $contenidoSinUsuario = $contenidoSinUsuario -replace '\s+', ' ' # Limpiar espacios múltiples
            $contenidoSinUsuario | Set-Content -Path $archivoOrigen
        }
    }
}

$resultados += "`n"

# Guarda los resultados en un archivo de texto
$archivoResultados = Join-Path -Path "C:\TASKS\ZWCAD\REPORTS" -ChildPath "RESULTADO_SCRIPT.txt"
$resultados | Out-File -FilePath $archivoResultados -Append


# Para añadir la lista de usuariosSTD al archivo, considera convertir la lista en una cadena
#$usuariosSTDTexto = $usuariosSTD -join "`r`n"
#$usuariosSTDTexto | Out-File -FilePath $archivoResultados -Append


#--------------copiar archivo -OPT ORIGINAL A C:\IMPORTAR_USUARIOS-------------

Copy-Item -Path $archivoOrigen -Destination "C:\TASKS\ZWCAD\REPORTS"


#________________________________________________________________#
# 4. pasos para cargar alas licencias en el servidor de licencias

# Add the directory containing lmutil to the system's PATH variable
$env:Path += ";C:\Program Files\ZWSOFT\ZWSOFT Network License Manager"

# Ejecutar el comando lmutil lmreread
$command = "lmutil lmreread -c `"C:\Program Files\ZWSOFT\ZWSOFT Network License Manager\LicenseFile.lic`" -vendor zwflex"
Invoke-Expression -Command $command

# Ejecutar el comando lmutil lmreread y capturar la salida
$command = "lmutil lmreread -c `"C:\Program Files\ZWSOFT\ZWSOFT Network License Manager\LicenseFile.lic`" -vendor zwflex"
$output = Invoke-Expression -Command $command

# Verificar si se produjo un error
if ($output -match "lmreread successful") {
    $resultado = "SERVICIO DE LICENCIAS: Los cambios en las licencias se cargaron correctamente."
} else {
    $resultado = "SERVICIO DE LICENCIAS: Se ha producido un error en la carga de licencias."
}

#$resultado | Out-File -FilePath "C:\IMPORTAR_USUARIOS\RESULTADO_SCRIPT.txt" -Append
#Write-Host $resultado


#----------------------

# Write results to the file and display them
$resultado | Out-File -FilePath "C:\TASKS\ZWCAD\REPORTS\RESULTADO_SCRIPT.txt" -Append
Write-Host $resultado

# Define the file path
$filePath = "C:\TASKS\ZWCAD\REPORTS\RESULTADO_SCRIPT.txt"

# Get the current date and the creation date of the file
$currentDate = Get-Date
$fileDate = (Get-Item $filePath).CreationTime

# Compare the month of the current date to the month of the file creation date
if ($currentDate.Month -ne $fileDate.Month) {
    # Create a subfolder named after the month the file was created in the 'Historicos' directory
    $subfolderName = $fileDate.ToString("MMMM_yyyy", [System.Globalization.CultureInfo]::InvariantCulture)
    $subfolderPath = Join-Path -Path "C:\TASKS\ZWCAD\REPORTS\HISTORICO_REPORTS" -ChildPath $subfolderName

    # Ensure the subfolder exists
    if (-not (Test-Path -Path $subfolderPath)) {
        New-Item -ItemType Directory -Path $subfolderPath
    }

    # Define the new file path in the subfolder
    $newFilePath = Join-Path -Path $subfolderPath -ChildPath "RESULTADO_SCRIPT.txt"

    # Move the file to the subfolder
    Move-Item -Path $filePath -Destination $newFilePath -ErrorAction Continue
    Write-Host "File moved to $newFilePath."
} else {
    Write-Host "File creation month is the same as the current month. No move needed."
}



#PRUEBAS MODIFICACIONES DE FECHAS EN SISTEMA

#Set-Date -Date '18 June 2025 9:00 AM'
#Restart-Service -Name w32time

#--------------COMANDO EJECUCION REMOTA----------------
# $cred = Get-Credential
# Invoke-Command -ComputerName pc-wizard -ScriptBlock { Invoke-Expression -Command "C:\1\ZWCAD_STD_PRO.ps1" } -Credential $cred
#Copy-Item -Path $archivoOrigen -Destination "C:\IMPORTAR_USUARIOS"