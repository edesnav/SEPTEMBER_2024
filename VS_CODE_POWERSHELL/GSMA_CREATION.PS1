
#PARTE1

#EJECUTAR ESTE SCRIPT EN EL SERVIDOR QUE TIENE ACCESO A ACTIVE DIRECTORY
#GMSA Managed Service Account, Group Managed Service Account, GRUPO UNA CUENTA DE SERVICIO GESTIONADA DE ACTIVE DIRECTORY LA CUAL LAS CONTRASEÑAS SE AUTOGENERAN MENSUALMENTE POR ACTIVE DIRECTORY
#GSMA PUEDE INCLUIR LOS EQUIPOS O SERVIDORES  LOS CUALES PERMITIRAN QUE SE EJECUTE LA CUENTA DE SERVICIO LOCALMENTE EN ESOS SERVIDORES

#AGREGAR GMSA GRUPO DE CUENTAS DE SERVICIO GESTIONADO A ACTIVE DIRECTORY
Add-KdsRootKey -EffectiveTime (Get-Date).AddHours(-10)


#2 FORMAS DE AGREGAR GMSA GRUPO DE CUENTAS DE SERVICIO GESTIONADO A ACTIVE DIRECTORY

#FORMA 1  CREANDO CUENTA Y AGREGANDO LOS SERVIDORES QUE PUEDEN EJECUTAR LA CUENTA DE SERVICIO
New-ADServiceAccount -Name gmsa_sccm -DNSHostName gmsa_sccm.ineco.es -PrincipalsAllowedToRetrieveManagedPassword ietvirlic28ipro$

#(TAREA OPCIONAL) modificar y poner lista de servidores que pertenecen al grupo gsma
Set-ADServiceAccount -Identity gmsa_sccm -PrincipalsAllowedToRetrieveManagedPassword ietvirlic28ipro$,mp0002$

#----------------------------------------------------------------------------------------

#FORMA 2 AGREGANDO EL GRUPO DE SEGURIDAD QUE CONTIENE LOS SERVIDORES QUE PUEDEN EJECUTAR LA CUENTA DE SERVICIO
New-ADServiceAccount -Name gmsa_licencing -DNSHostName gmsa_Licencing.ineco.es -PrincipalsAllowedToRetrieveManagedPassword "CN=SERVIDORES_LICENCIAS,OU=COMPANY_GROUPS,DC=ineco,DC=es"




#----------------------------------------------------------------------------------------

#PARTE 2
#EJECUTAR ESTE SCRIPT EN EL SERVIDOR QUE QUEREMOS REGISTRAR EL SERVICIO

#instalar cuenta GSMA GSMA_ZWCAD EN EL SERVIDOR ESPECIFICO
Install-ADServiceAccount gmsa_Licencing
Test-ADServiceAccount gmsa_licencing

#Install-ADServiceAccount gmsa_zwcad



#EJECUTAR ESTA PARTE DE SCRIPT EN EL SERVIDOR LOCAL QUE QUEREMOS MODIFICAR LA CUENTA DE EJECUCION EN TASK SCHEDULER
#PASOS PARA EJECUTAR CON LA CUENTA GMSA EN LA TAREA "ALTAS_ZWCAD"
Get-ScheduledTask
$taskName = "ALTAS_ZWCAD"
$task = Get-ScheduledTask -TaskName $taskName
$principal = New-ScheduledTaskPrincipal -UserId "ineco\gmsa_licencing$" -LogonType Password
Set-ScheduledTask -TaskName $taskName -Principal $principal
Get-ScheduledTask -TaskName $taskName | Select-Object -ExpandProperty Principal



#EJECUTAR ESTA PARTE DE SCRIPT PARA CONSULTAR SERVIDORES QUE PERTENECEN AL GRUPO GMSA (SE PUEDE EJECUTAR EN CUALQUIER EQUIPO QUE TENA ACCESO A ACTIVE DIRECTORY Y HACER CONSULTA )

#PARTE DE SCRIPT PARA SABER QUE SERVIDORES PERTENECEN AL "GMSA"
$gmsaName = "sccmadmin"
$gmsa = Get-ADServiceAccount -Identity $gmsaName -Properties PrincipalsAllowedToRetrieveManagedPassword
$gmsa.PrincipalsAllowedToRetrieveManagedPassword



#PARTE DE SCRIPT PARA AGREGAR UN NUEVO SERVIDOR AL "GMSA" 

# Obtener la cuenta gMSA y almacenar en una variable
$gmsaName = "gmsa_zwcad" #NOMBRE DE GMSA
$gmsa = Get-ADServiceAccount -Identity $gmsaName -Properties PrincipalsAllowedToRetrieveManagedPassword

# Añadir el nuevo servidor a la lista existente
$newServer = "mp0002$" #NOMBRE DE SERVIDOR A AGREGAR AL GRUPO GMSA
$currentPrincipals = $gmsa.PrincipalsAllowedToRetrieveManagedPassword

# Si no hay servidores previos (poco común), crea una nueva lista
if ($currentPrincipals -eq $null) {
    $currentPrincipals = @($newServer)
} else {
    $currentPrincipals += $newServer
}

# Actualizar la cuenta gMSA en Active Directory
Set-ADServiceAccount -Identity $gmsaName -PrincipalsAllowedToRetrieveManagedPassword $currentPrincipals


#ELIMINAR SERVIDOR DE GSMA

#TESTS DE PRUEBA CON GMSA

$gmsa = Get-ADServiceAccount -Identity gmsa_sccm -Properties PrincipalsAllowedToRetrieveManagedPassword
$gmsa.PrincipalsAllowedToRetrieveManagedPassword

ietvirlic28ipro
