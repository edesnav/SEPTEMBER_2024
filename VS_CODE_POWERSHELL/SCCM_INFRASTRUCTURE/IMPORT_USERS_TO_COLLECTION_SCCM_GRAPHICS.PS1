#
# Presiona 'F5' para ejecutar este script. Al ejecutarlo, se cargará el módulo ConfigurationManager
# para Windows PowerShell y se conectará al sitio.
#
# Este script fue generado automáticamente el '11/03/2024 9:18:07'.

# Configuración del sitio
$SiteCode = "012" # Código del sitio
$ProviderMachineName = "S-SCCM2K12-I.INECO.ES" # Nombre del proveedor SMS

# Personalizaciones
$initParams = @{}
#$initParams.Add("Verbose", $true) # Descomenta esta línea para habilitar el registro detallado
#$initParams.Add("ErrorAction", "Stop") # Descomenta esta línea para detener el script ante cualquier error

# No cambies nada debajo de esta línea

# Importar el módulo ConfigurationManager.psd1
if ((Get-Module ConfigurationManager) -eq $null) {
    Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" @initParams
}

# Conectar a la unidad del sitio si aún no está presente
if ((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null) {
    New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName @initParams
}

# Establecer la ubicación actual al código del sitio
Set-Location "$($SiteCode):\" @initParams

# Cargar ensamblados necesarios para elementos GUI
Add-Type -AssemblyName System.Windows.Forms

# Crear la forma (ventana) principal
$form = New-Object System.Windows.Forms.Form
$form.Text = "Agregar Usuarios a Colección SCCM"
$form.Size = New-Object System.Drawing.Size(500,250)
$form.StartPosition = "CenterScreen"

# Etiqueta y cuadro de texto para el archivo de entrada
$labelArchivo = New-Object System.Windows.Forms.Label
$labelArchivo.Text = "Archivo de entrada (.txt):"
$labelArchivo.Location = New-Object System.Drawing.Point(10,20)
$labelArchivo.Size = New-Object System.Drawing.Size(150,20)
$form.Controls.Add($labelArchivo)

$textBoxArchivo = New-Object System.Windows.Forms.TextBox
$textBoxArchivo.Location = New-Object System.Drawing.Point(170,20)
$textBoxArchivo.Size = New-Object System.Drawing.Size(250,20)
$form.Controls.Add($textBoxArchivo)

$buttonBuscarArchivo = New-Object System.Windows.Forms.Button
$buttonBuscarArchivo.Text = "Buscar..."
$buttonBuscarArchivo.Location = New-Object System.Drawing.Point(430,18)
$buttonBuscarArchivo.Size = New-Object System.Drawing.Size(50,24)
$form.Controls.Add($buttonBuscarArchivo)

# Etiqueta y cuadro de texto para el nombre de la colección
$labelColeccion = New-Object System.Windows.Forms.Label
$labelColeccion.Text = "Nombre de la colección SCCM:"
$labelColeccion.Location = New-Object System.Drawing.Point(10,60)
$labelColeccion.Size = New-Object System.Drawing.Size(150,20)
$form.Controls.Add($labelColeccion)

$textBoxColeccion = New-Object System.Windows.Forms.TextBox
$textBoxColeccion.Location = New-Object System.Drawing.Point(170,60)
$textBoxColeccion.Size = New-Object System.Drawing.Size(250,20)
$textBoxColeccion.Text = "Formación Anaconda" # Valor predeterminado
$form.Controls.Add($textBoxColeccion)

# Botón para iniciar el proceso
$buttonIniciar = New-Object System.Windows.Forms.Button
$buttonIniciar.Text = "Iniciar Proceso"
$buttonIniciar.Location = New-Object System.Drawing.Point(200,100)
$buttonIniciar.Size = New-Object System.Drawing.Size(100,30)
$form.Controls.Add($buttonIniciar)

# Evento para el botón de buscar archivo
$buttonBuscarArchivo.Add_Click({
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Filter = "Archivos de texto (*.txt)|*.txt|Todos los archivos (*.*)|*.*"
    $OpenFileDialog.InitialDirectory = "C:\SCCM_DATOS_COLECCIONES\"
    $OpenFileDialog.Title = "Selecciona el archivo de entrada (.txt)"

    if ($OpenFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $textBoxArchivo.Text = $OpenFileDialog.FileName
    }
})

# Evento para el botón de iniciar proceso
$buttonIniciar.Add_Click({
    # Validar que se haya ingresado el archivo y el nombre de la colección
    if ([string]::IsNullOrWhiteSpace($textBoxArchivo.Text)) {
        [System.Windows.Forms.MessageBox]::Show("Por favor, selecciona un archivo de entrada.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    if (-not (Test-Path $textBoxArchivo.Text)) {
        [System.Windows.Forms.MessageBox]::Show("El archivo de entrada no existe. Por favor, verifica la ruta.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    if ([string]::IsNullOrWhiteSpace($textBoxColeccion.Text)) {
        [System.Windows.Forms.MessageBox]::Show("Por favor, ingresa el nombre de la colección SCCM.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    # Ocultar la forma mientras se ejecuta el proceso
    $form.Hide()

    # Definir rutas de archivos
    $archivoEntrada = $textBoxArchivo.Text
    $archivoSalida = "C:\SCCM_DATOS_COLECCIONES\usuario.txt"
    $archivoLog = "C:\SCCM_DATOS_COLECCIONES\log.csv"
    $CollectionName = $textBoxColeccion.Text

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

            # Agregar el prefijo 'OWLEYES\' al nombre de usuario
            $usuarioConPrefijo = "OWLEYES\" + $usuario

            # Agregar el nombre de usuario con prefijo a la lista
            $usuarios += $usuarioConPrefijo
        }
    }

    # Guardar los nombres de usuario en el archivo de salida
    $usuarios | Out-File -FilePath $archivoSalida -Encoding UTF8

    Escribir-LogCSV -Action "Success" -Message "Proceso completado. Los nombres de usuario se han guardado en $archivoSalida."

    # Verificar que la colección existe
    $Coleccion = Get-CMUserCollection -Name $CollectionName
    if (!$Coleccion) {
        Escribir-LogCSV -Action "Error" -Message "La colección '$CollectionName' no existe en SCCM."
        [System.Windows.Forms.MessageBox]::Show("La colección '$CollectionName' no existe en SCCM.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        $form.Show()
        return
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
    [System.Windows.Forms.MessageBox]::Show("Proceso completado. Revisa el archivo de log en $archivoLog.", "Información", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

    # Mostrar nuevamente la forma
    $form.Show()
})

# Mostrar la forma
$form.Add_Shown({$form.Activate()})
[void]$form.ShowDialog()
