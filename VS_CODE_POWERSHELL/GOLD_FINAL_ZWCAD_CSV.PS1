# Define las rutas de origen y destino base
$archivoOrigen = "C:\licencia_opt\zwflex.opt"
$directorioBase = "C:\RESPALDOS\"


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
$usuariosSTD = Get-Content -Path "C:\IMPORTAR_USUARIOS\std.csv"
$usuariosPRO = Get-Content -Path "C:\IMPORTAR_USUARIOS\pro.csv"
$borrarusuario = Get-Content -Path "C:\IMPORTAR_USUARIOS\borrar_usuarios.csv"

# Busca y elimina el contenido de las variables en el archivo de origen
$usuariosSTD | ForEach-Object {
    $contenidoArchivo = Get-Content -Path $archivoOrigen
    $contenidoArchivo = $contenidoArchivo -replace $_, ""
    $contenidoArchivo = $contenidoArchivo -replace '\s+', ' ' # Remove multiple spaces
    $contenidoArchivo | Set-Content -Path $archivoOrigen
}

$usuariosPRO | ForEach-Object {
    $contenidoArchivo = Get-Content -Path $archivoOrigen
    $contenidoArchivo = $contenidoArchivo -replace $_, ""
    $contenidoArchivo = $contenidoArchivo -replace '\s+', ' ' # Remove multiple spaces
    $contenidoArchivo | Set-Content -Path $archivoOrigen
}

$borrarusuario | ForEach-Object {
    $contenidoArchivo = Get-Content -Path $archivoOrigen
    $contenidoArchivo = $contenidoArchivo -replace $_, ""
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
            $linea = $linea -replace "roberto.vela", "$usuarioSTD roberto.vela"
        }
    }
    
    # Busca "montaje" y añade los usuarios PRO delante
    if ($linea -match "montaje") {
        foreach ($usuarioPRO in $usuariosPRO) {
            $linea = $linea -replace "montaje", "$usuarioPRO montaje"
        }
    }
    
    # Agrega la línea modificada al contenido modificado
    $contenidoModificado += $linea
}

# Guarda el contenido modificado de vuelta al archivo origen o a un nuevo archivo
$contenidoModificado | Set-Content -Path $archivoOrigen


#-------------------------------------

# Cargar el ensamblado de .NET para Windows Forms
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



#--------------BORRAR CONTENIDO DE LOS ARCHIVOS .CSV----------------


# Ruta de los archivos
$archivoStd = "C:\IMPORTAR_USUARIOS\std.csv"
$archivoPro = "C:\IMPORTAR_USUARIOS\pro.csv"
$archivoBorrar = "C:\IMPORTAR_USUARIOS\borrar_usuarios.csv"

# Borra el contenido de los archivos
Set-Content -Path $archivoStd -Value ""
Set-Content -Path $archivoPro -Value ""
set-Content -Path $archivoBorrar -Value ""


#-------PREPARA LOS RESULTADOS PARA EXPORTAR A UN ARCHIVO DE TEXTO-------

# Obtener la fecha actual
$fechaActual = (Get-Date).ToString("yyyy-MM-dd")

# Preparar un array para guardar los objetos que representan cada fila
$filas = @()

# Calcular el número máximo de filas basado en el tamaño de los arrays más grandes
$numFilas = [Math]::Max($usuariosSTD.Length, $usuariosPRO.Length)

for ($i = 0; $i -lt $numFilas; $i++) {
    # Crear un hash table para cada fila
    $fila = @{
        "Usuario STD" = if ($i -lt $usuariosSTD.Length) { $usuariosSTD[$i] } else { $null }
        "Usuario PRO" = if ($i -lt $usuariosPRO.Length) { $usuariosPRO[$i] } else { $null }
        "Fecha Actual" = $fechaActual
    }

    # Convertir el hash table a un objeto PSCustomObject y agregarlo al array de filas
    $filas += [PSCustomObject]$fila
}

# Imprimir los datos en formato de tabla
$filas | Format-Table -AutoSize

# Exporta el resultado en un archivo de texto
$reporte = $filas | Format-Table -AutoSize | Out-String
$reporte | Out-File -FilePath "C:\IMPORTAR_USUARIOS\REPORTE.TXT" -Append

# Copia el archivo de licencias a "c:\importar_usuarios"
$destino = "c:\importar_usuarios"
Copy-Item -Path $archivoOrigen -Destination $destino

#--------------PRUEBAS CAMBIO DE FECHAS----------------

#PRUEBA CAMBIO FECHA
# Set-Date -Date '18 March 2024 9:00 AM'

# RESTAURAR EL SERIVIO DE TIEMPO
# Restart-Service -Name w32time

#--------------COMANDO EJECUCION REMOTA----------------
# $cred = Get-Credential
# Invoke-Command -ComputerName pc-wizard -ScriptBlock { Invoke-Expression -Command "C:\1\ZWCAD_STD_PRO.ps1" } -Credential $cred


# Invoke-Command -ComputerName ietvirlic28ipro -ScriptBlock { Invoke-Expression -Command "notepad.exe" } -Credential $cred

#Test-NetConnection -ComputerName ietvirlic33ipro -Port 27000

