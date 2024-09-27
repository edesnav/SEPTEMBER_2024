# Connect to SCCM
$siteCode = "012"
$siteServer = "s-sccm2k12-i"
$connection = New-Object -ComObject "UIResource.UIResourceMgr"
$connection.Connect($siteServer)

# Get all packages
$packages = $connection.GetPackages($siteCode)

# Filter packages that start with "sql"
$sqlPackages = $packages | Where-Object { $_.PackageName -like "*sql*" }

# Output the package names
$sqlPackages | Select-Object -ExpandProperty PackageName








