# Load the necessary assembly for Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Gestión de Usuarios ZWCAD'
$form.Size = New-Object System.Drawing.Size(350, 250)  # Width x Height
$form.StartPosition = 'CenterScreen'

# Create a label for instructions
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10, 20)  # X, Y coordinates
$label.Size = New-Object System.Drawing.Size(280, 20)  # Width, Height
$label.Text = 'Seleccione la acción y escriba el nombre del usuario:'
$form.Controls.Add($label)

# Create the ComboBox for selecting actions
$comboBox = New-Object System.Windows.Forms.ComboBox
$comboBox.Location = New-Object System.Drawing.Point(10, 45)
$comboBox.Size = New-Object System.Drawing.Size(260, 20)
$comboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$comboBox.Items.AddRange(@( '1. Registrar Usuario Pro', '2. Registrar Usuario Standard', '3. Borrar Usuario', '4. Abrir Carpeta de Reportes', '5. Terminar'))
$form.Controls.Add($comboBox)

# Create a text box for entering the user name
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10, 75)
$textBox.Size = New-Object System.Drawing.Size(260, 20)
$form.Controls.Add($textBox)

# Create a button for manual execution of the selected action
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(10, 105)
$button.Size = New-Object System.Drawing.Size(260, 30)
$button.Text = 'Ejecutar Acción'
$form.Controls.Add($button)

# Handle the button click event for manual action execution
$button.Add_Click({
    ExecuteAction $comboBox.SelectedItem
})

# Function to execute the selected action
function ExecuteAction($selectedItem) {
    switch ($selectedItem) {
        '1. Registrar Usuario Pro' { $rutaArchivo = "C:\TASKS\ZWCAD\REPORTS\IMPORT_USERS\pro.csv" }
        '2. Registrar Usuario Standard' { $rutaArchivo = "C:\TASKS\ZWCAD\REPORTS\IMPORT_USERS\std.csv" }
        '3. Borrar Usuario' { $rutaArchivo = "C:\TASKS\ZWCAD\REPORTS\IMPORT_USERS\borrar_usuarios.csv" }
        '4. Abrir Carpeta de Reportes' {
            Start-Process "explorer.exe" "C:\TASKS\ZWCAD\REPORTS"
            return
        }
        '5. Terminar' { $form.Close(); return }
    }

    if ($rutaArchivo) {
        try {
            $contenidoActual = Get-Content -Path $rutaArchivo
            $nuevoContenido = @($textBox.Text) + $contenidoActual
            $nuevoContenido | Set-Content -Path $rutaArchivo
            [System.Windows.Forms.MessageBox]::Show("Usuario añadido en la primera línea de: `n$rutaArchivo")
            $textBox.Clear()
        } catch {
            [System.Windows.Forms.MessageBox]::Show("An error occurred: `n$($_.Exception.Message)")
        }
    }
}

# Show the form
$form.ShowDialog()
