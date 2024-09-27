Import-Module NetTCPIP

# Obtener todas las direcciones IP IPv4 del equipo
$ipAddresses = (Get-NetIPAddress -AddressFamily IPv4).IPAddress

# Convertir dirección IP a entero
function ConvertTo-UInt32 {
    param ([string]$ipAddress)
    [uint32]$ip = 0
    $ipParts = $ipAddress.Split('.')
    for ($i = 0; $i -lt 4; $i++) {
        $ip = $ip -bor ([uint32]$ipParts[$i] -shl (24 - 8 * $i))
    }
    return $ip
}

# Lista de rangos de IP
$ranges = @(
    @{ Start = "172.17.10.0"; End = "172.17.19.255" }, #EGEO subnet
    @{ Start = "172.17.50.0"; End = "172.17.56.255" }, #EGEO subnet 
    @{ Start = "172.17.69.255"; End = "172.17.69.255" }, #EGEO subnet
    @{ Start = "172.19.0.0"; End = "172.19.7.255" }, #EGEO subnet
    @{ Start = "172.0.0.0"; End = "172.17.6.255" }, #HABANA subnet
    @{ Start = "172.16.100.0"; End = "172.17.100.255" }, #HABANA subnet
    @{ Start = "172.17.200.0"; End = "172.17.200.255" }, #HABANA subnet
    @{ Start = "172.19.16.0"; End = "172.19.23.255" } #HABANA subnet
)

# Verificar si una IP está dentro de algún rango
function IsIpInRange {
    param ([string]$ipAddress, [array]$ranges)
    $ip = ConvertTo-UInt32 $ipAddress
    foreach ($range in $ranges) {
        $start = ConvertTo-UInt32 $range.Start
        $end = ConvertTo-UInt32 $range.End
        if ($ip -ge $start -and $ip -le $end) {
            return $true
        }
    }
    return $false
}

# Verificar si alguna de las direcciones IP está dentro de algún rango
$ipInRange = $false
foreach ($ip in $ipAddresses) {
    if (IsIpInRange $ip $ranges) {
        $ipInRange = $true
        break
    }
}

if (-not $ipInRange) {
    Write-Host "NO ESTÁ EN LA SUBRED PARA EJECUTAR EL PROGRAMA" -ForegroundColor Red
    exit 4545
} else {
    Write-Host "La dirección IP está en el rango. Continuando con el script..."
   
    Copy-Item .\INECO.pulsepreconfig C:\WINDOWS\Temp -Force

Start-Process -FilePath .\ps-pulse-win-22.7r1.0-b28369-64bit-installer.msi -ArgumentList 'CONFIGFILE=C:\WINDOWS\Temp\INECO.pulsepreconfig /qn /norestart' -Wait

Start-Sleep 3

Restart-Service PulseSecureService -Force

if ( Test-Path 'C:\Program Files (x86)\Common Files\Pulse Secure\JamUI\jamCommand.exe' )
{
    cd "${env:CommonProgramFiles(x86)}\Pulse Secure\JamUI"
    .\jamCommand.exe -importfile C:\WINDOWS\Temp\INECO.pulsepreconfig    
    New-ItemProperty Registry::"HKEY_LOCAL_MACHINE\SOFTWARE\Pulse Secure" -Name ConfigVersionINECO -Value "28" -PropertyType String -Force
}

}