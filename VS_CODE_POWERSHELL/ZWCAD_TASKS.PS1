# Define las rutas de origen y destino base
$archivoOrigen = "C:\1\zwflex.opt"
$directorioBase = "C:\2\"

# Obtén la fecha actual en formato año-mes-día
$fechaHoy = (Get-Date).ToString("yyyy-MM-dd")

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

# Lee el contenido del archivo
$contenidoArchivo = Get-Content -Path $archivoDestino

# Inicializa una variable para almacenar el contenido modificado
$contenidoModificado = @()

# Itera a través de cada línea del contenido del archivo
foreach ($linea in $contenidoArchivo) {
    # Si encuentra "ROBERTO.VELA", inserta "eduardo.espartosa" antes
    if ($linea -match "ROBERTO.VELA") {
        $contenidoModificado += $linea -replace "ROBERTO.VELA", "eduardo.espartosa ROBERTO.VELA"
    } else {
        $contenidoModificado += $linea
    }
}

# Guarda los cambios en el archivo
$archivoOrigen = "C:\1\zwflex.opt"
$contenidoModificado | Set-Content -Path $archivoOrigen
# Solicitar al usuario el valor del nombre de usuario
$nombreUsuario = Read-Host "Ingrese su nombre de usuario:"

# Reemplazar el nombre de usuario en el contenido modificado
$contenidoModificado = foreach ($linea in $contenidoModificado) {
    if ($linea -match "ROBERTO.VELA") {
        $linea -replace "ROBERTO.VELA", "$nombreUsuario ROBERTO.VELA"
    } else {
        $linea
    }
}

# Guardar los cambios en el archivo
$contenidoModificado | Set-Content -Path $archivoOrigen

# Verificar si el nombre de usuario ya existe en el archivo
if ($contenidoModificado -contains "$nombreUsuario ROBERTO.VELA") {
    # Eliminar todas las entradas con el nombre de usuario
    $contenidoModificado = $contenidoModificado -notmatch "$nombreUsuario ROBERTO.VELA"
}

# Solicitar al usuario el valor del nombre de usuario
$nombreUsuario = Read-Host "Ingrese su nombre de usuario:"

# Reemplazar el nombre de usuario en el contenido modificado
$contenidoModificado = foreach ($linea in $contenidoModificado) {
    if ($linea -match "ROBERTO.VELA") {
        $linea -replace "ROBERTO.VELA", "$nombreUsuario ROBERTO.VELA"
    } else {
        $linea
    }
}

# Guardar los cambios en el archivo
$contenidoModificado | Set-Content -Path $archivoOrigen

C:\Program Files\ZWSOFT\ZWSOFT Network License Manager

C:\Users\Administrator\Desktop


