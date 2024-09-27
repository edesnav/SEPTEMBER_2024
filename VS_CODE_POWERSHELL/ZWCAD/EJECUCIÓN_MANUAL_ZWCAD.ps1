# Load the necessary assembly for Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Create a new form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Execute License Task'
$form.Size = New-Object System.Drawing.Size(300, 200)  # Width x Height
$form.StartPosition = 'CenterScreen'

# Create a button
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(75, 50) # X, Y coordinates
$button.Size = New-Object System.Drawing.Size(150, 40) # Width, Height
$button.Text = 'EJECUTAR CARGA LICENCIAS'

# Add an event handler for the button click
$button.Add_Click({
    $taskName = "ALTAS_ZWCAD"
    $serverName = "ietvirlic28ipro"

    # Remote command execution using Invoke-Command
    try {
        Invoke-Command -ComputerName $serverName -ScriptBlock {
            param($taskName)
            Start-ScheduledTask -TaskName $taskName
        } -ArgumentList $taskName

        [System.Windows.Forms.MessageBox]::Show("La tarea se ejecutó en $serverName", "Éxito")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("La Tarea falló: $($_.Exception.Message)", "Error")
    }
})

# Add the button to the form
$form.Controls.Add($button)

# Show the form
$form.ShowDialog()








#Enable-PSRemoting -Force
