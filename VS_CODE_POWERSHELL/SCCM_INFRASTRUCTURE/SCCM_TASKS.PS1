$SiteCode = "012" # Replace with your actual site code
Import-Module "$($Env:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"
Set-Location "$SiteCode`:"

#____________________________

#GET COLLECTIONS
Get-CMCollection | Where-Object { $_.CollectionVariables -match 'PACKAGES' }


Get-CMCollection | Where-Object { $_.CollectionVariables -match 'PACKAGES' } | ForEach-Object {
    $collection = $_
    $collectionName = $collection.Name
    $collectionID = $collection.CollectionID
    $collectionVariables = $collection.CollectionVariables

    Write-Host "Collection Name: $collectionName (ID: $collectionID)"
    Write-Host "Collection Variables: $collectionVariables"
    Write-Host "---------------------"
}

Get-CMCollection |GET-MEMBER



#COLLECCIONES QUE CONTENGAN EL NOMBRE "PRUEBAS"
$collections = Get-CMDeviceCollection | Where-Object { $_.Variables.Count -gt 0 -and $_.Name -like "*PRUEBAS*" }


#COMPUTER NAME MEMBER OF COLLECTION



# First, get the Resource ID of the computer
$ComputerName = "PF2YYNYB" # Replace this with the actual name of the computer
$Device = Get-CMDevice -Name $ComputerName

if ($Device) {
    $ResourceId = $Device.ResourceId

    # Now, get all collections where this computer is a member
    $AllCollections = Get-CMDeviceCollection
    $MemberCollections = $AllCollections | Where-Object {
        $CollectionId = $_.CollectionID
        $CollectionMembers = Get-CMCollectionMember -CollectionId $CollectionId
        $CollectionMembers.ResourceId -contains $ResourceId
    }

    # Output the names of the collections
    $MemberCollections | Select-Object Name, CollectionID
} else {
    Write-Host "No device found with the name $ComputerName"
}


#FIND MAAINTENANCE WINDOWS COLECTION
# Find all SCCM collections with Windows Maintenance Windows
$Collections = Get-CMDeviceCollection | Where-Object { $_.MaintenanceWindows.Count -gt 0 }
