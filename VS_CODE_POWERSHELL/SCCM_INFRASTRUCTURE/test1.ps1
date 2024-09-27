#Get SiteCode
$SiteCode = Get-PSDrive -PSProvider CMSITE
Set-location $SiteCode":"

$ErrorActionPreference= 'silentlycontinue'
#Collection must pre-exist
$CollectionName = "Formación Anaconda"
#List of names must pre-exist
$Users = get-content "C:\SCCM_DATOS_COLECCIONES\usuario.txt"
Foreach ($User in $Users)
{Add-CMUserCollectionDirectMembershipRule -collectionname $CollectionName -resourceid (Get-CMUser -name $User).ResourceID}
