Install-Module -Name ImportExcel -Scope CurrentUser
$contenido = Get-Content -Path "C:\excel\export.csv"

$patron = '"([^"]+)"'
$datosExtraidos = foreach ($linea in $contenido) {
    if ($linea -match $patron) {
        $coincidencias = [regex]::Matches($linea, $patron)
        foreach ($coincidencia in $coincidencias) {
            $coincidencia.Groups[1].Value
        }
    }
}


$datosExtraidos | ForEach-Object { Write-Host $_ }










Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability –Online