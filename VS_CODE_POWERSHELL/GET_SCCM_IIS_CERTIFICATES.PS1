# Lista de servidores
$servidores = @("S-SCCM2K12-I", "E-SCCM", "IETCMDPEIPRO", "IETCMDPHIPRO", "IETCMDPSCIPRO")

# ScriptBlock para ejecutar en cada servidor
$scriptBlock = {
    Import-Module WebAdministration
    $binding = Get-WebBinding -Name "Default Web Site" | Where-Object { $_.protocol -eq "https" }
    if ($binding -ne $null) {
        $certHash = $binding.certificateHash
        $certStore = $binding.certificateStoreName
        $cert = dir cert:\LocalMachine\$certStore | Where-Object { $_.Thumbprint -eq $certHash }
        return @{
            Servidor = $env:COMPUTERNAME
            Sitio = "Default Web Site"
            Certificado = $cert.Subject
            Caducidad = $cert.NotAfter
        }
    } else {
        return @{
            Servidor = $env:COMPUTERNAME
            Sitio = "Default Web Site"
            Certificado = "N/A"
            Caducidad = "N/A"
        }
    }
}

# Ejecutar el ScriptBlock en cada servidor y recopilar los resultados
$resultados = foreach ($servidor in $servidores) {
    Invoke-Command -ComputerName $servidor -ScriptBlock $scriptBlock -ErrorAction SilentlyContinue
}

# Mostrar los resultados
$resultados | Format-Table -AutoSize

Get-WmiObject -Query "SELECT * FROM Win32_Product" | Select-Object Name, IdentifyingNumber

