USE CM_012 


--LISTADO DE EQUIPOS- SELECCIONAR SOFTWARE INSTALADO USUARIO, USUARIO DOMINIO Y COMPUTERNAME

SELECT DISTINCT 
  v_R_System.Name0 as [Computer Name],
  v_R_System.User_Name0 as [Usuario de Dominio],
  v_R_User.Full_User_Name0 as [User Name],
  v_Add_Remove_Programs.DisplayName0 as [Product Name]
FROM 
  v_R_System 
  INNER JOIN v_Add_Remove_Programs ON v_R_System.ResourceID = v_Add_Remove_Programs.ResourceID
  INNER JOIN v_R_User ON v_R_System.User_Name0 = v_R_User.User_Name0
WHERE 
  v_Add_Remove_Programs.DisplayName0 LIKE '%figma%'
   
   --------------------------------
  -- LISTADO DE EQUIPOS--  -PARA  SABER EQUIPO POR EQUIPO SOFTWARE ESPECIFICO INSTALADO INCLUYENDO SU FECHA de INSTALACION--

  SELECT DISTINCT 
  v_R_System.Name0 as [Computer Name],
  v_R_System.User_Name0 as [Usuario de Dominio],
  v_R_User.Full_User_Name0 as [User Name],
  v_Add_Remove_Programs.DisplayName0 as [Product Name],
  v_Add_Remove_Programs.TimeStamp as[fecha de Instalación]
FROM 
  v_R_System 
  INNER JOIN v_Add_Remove_Programs ON v_R_System.ResourceID = v_Add_Remove_Programs.ResourceID
  INNER JOIN v_R_User ON v_R_System.User_Name0 = v_R_User.User_Name0
WHERE 
  v_Add_Remove_Programs.DisplayName0 LIKE '%*%'
  and v_R_System.Name0 like 'PF4VZ9KY'

  order by TimeStamp desc


    -- PARA SABER EQUIPO POR EQUIPO UN PROGRAMA INSTALADO CON SUS FECHAS DE INSTALACION SE PUEDE MODIFICAR LINEA PARA ESTABLECER RANGO FECHAS DETERMINADAS--

  SELECT DISTINCT 
  v_R_System.Name0 AS [Computer Name],
  v_R_System.User_Name0 AS [Usuario de Dominio],
  v_R_User.Full_User_Name0 AS [User Name],
  v_Add_Remove_Programs.DisplayName0 AS [Product Name],
  v_Add_Remove_Programs.TimeStamp AS [fecha de Instalación]
FROM 
  v_R_System 
  INNER JOIN v_Add_Remove_Programs ON v_R_System.ResourceID = v_Add_Remove_Programs.ResourceID
  INNER JOIN v_R_User ON v_R_System.User_Name0 = v_R_User.User_Name0
WHERE 
  v_Add_Remove_Programs.DisplayName0 LIKE '%Ivanti Secure Access Client 22.7%'
  --AND v_Add_Remove_Programs.TimeStamp BETWEEN '2024-06-18' AND '2024-06-28'
ORDER BY 
  v_Add_Remove_Programs.TimeStamp DESC;

 --- IGUAL QUE EL ANTERIOR PERO CON FORMATO FECHAS DIA-MES-AÑO" 

  SELECT 
  v_R_System.Name0 AS [Computer Name],
  v_R_System.User_Name0 AS [Usuario de Dominio],
  v_R_User.Full_User_Name0 AS [User Name],
  v_Add_Remove_Programs.DisplayName0 AS [Product Name],
  FORMAT(v_Add_Remove_Programs.TimeStamp, 'dd-MM-yyyy') AS [Fecha de Instalación]
FROM 
  v_R_System 
  INNER JOIN v_Add_Remove_Programs ON v_R_System.ResourceID = v_Add_Remove_Programs.ResourceID
  INNER JOIN v_R_User ON v_R_System.User_Name0 = v_R_User.User_Name0
WHERE 
  v_Add_Remove_Programs.DisplayName0 LIKE '%Ivanti Secure Access Client 22.7%'
  AND v_Add_Remove_Programs.TimeStamp BETWEEN '2024-09-1' AND '2024-10-1'
  --and v_R_System.Name0 like 'PC29DD8M'
ORDER BY 
  v_Add_Remove_Programs.TimeStamp DESC;

  
--- PARA SABER UN PROGRAMA INSTALADO Y AGRUPAR por fechas LA CANTIDAD DE EQUIPOS ESTABLECIENDO FECHA DETERMINADA DE INICIO Y FECHA FIN 
 
SELECT 
  v_Add_Remove_Programs.DisplayName0 AS [Product Name],
  CONVERT(DATE, v_Add_Remove_Programs.TimeStamp) AS [Fecha de Instalación],
  COUNT(DISTINCT v_R_System.Name0) AS [Número de Computadoras],
  COUNT(DISTINCT v_R_System.User_Name0) AS [Número de Usuarios]
FROM 
  v_R_System 
  INNER JOIN v_Add_Remove_Programs ON v_R_System.ResourceID = v_Add_Remove_Programs.ResourceID
  INNER JOIN v_R_User ON v_R_System.User_Name0 = v_R_User.User_Name0
WHERE 
  v_Add_Remove_Programs.DisplayName0 LIKE '%Ivanti Secure Access Client 22.7%'
  --AND v_Add_Remove_Programs.TimeStamp BETWEEN '2024-01-01' AND '2024-10-1'
GROUP BY 
  v_Add_Remove_Programs.DisplayName0,
  CONVERT(DATE, v_Add_Remove_Programs.TimeStamp)
ORDER BY 
  [Fecha de Instalación] DESC;


  -- PRUEBAS

select *
FROM v_Add_Remove_Programs

select * from  v_Add_Remove_Programs

select * from v_GS_INSTALLED_SOFTWARE 




-----Software instalado con usuariode dominio y con ruta de instalación---


SELECT DISTINCT 
    v_R_System.Name0 AS [Equipo],
    v_R_System.User_Name0 AS [Usuario de Dominio],
	    v_R_User.Full_User_Name0 AS [Nombre y Apellidos],
    v_Add_Remove_Programs.DisplayName0 AS [Producto],
	v_Add_Remove_Programs.Version0 as [version],
    v_GS_INSTALLED_SOFTWARE.InstalledLocation0 AS [Ruta de instalación]
FROM 
    v_R_System 
    INNER JOIN v_Add_Remove_Programs 
        ON v_R_System.ResourceID = v_Add_Remove_Programs.ResourceID
    INNER JOIN v_R_User 
        ON v_R_System.User_Name0 = v_R_User.User_Name0
    INNER JOIN v_GS_INSTALLED_SOFTWARE 
        ON v_R_System.ResourceID = v_GS_INSTALLED_SOFTWARE.ResourceID
        AND v_Add_Remove_Programs.DisplayName0 = v_GS_INSTALLED_SOFTWARE.ProductName0
WHERE 
    v_Add_Remove_Programs.DisplayName0 LIKE '%ivanti%'  --and v_R_System.User_Name0 like 'DIEGO.SANFELIPE'
	--and v_R_System.Name0 like 'PC2J2H9B'



	---software instalación y versión
select 
    sys.ResourceID, 
    sys.Name0 as 'Name', 
    arp.DisplayName0 as 'DisplayName', 
    arp.Version0 as 'Version'
from 
    v_R_System sys
inner join 
    v_Add_Remove_Programs arp 
    on sys.ResourceID = arp.ResourceID
where 
    arp.DisplayName0 like '%Adobe Acrobat%' 
  ----

  --QUERY EQUIPO CONCRETO CON SOFTWARE CONCRETO--

  select 
    sys.ResourceID, 
    sys.Name0 as 'Name', 
    arp.DisplayName0 as 'DisplayName', 
    arp.Version0 as 'Version'
from 
    v_R_System sys
inner join 
    v_Add_Remove_Programs arp 
    on sys.ResourceID = arp.ResourceID
where 
    arp.DisplayName0 like '%Acrobat%' and sys.Name0 like 'pf2xhgfs'

---TESTS-----

  select * 
  from v_Add_Remove_Programs


   ----- CONTEO GENERAL AGRUPACION -- QUERY  PRODUCTO Y CONTEO DE EQUIPOS POR CADA producto----

SELECT 
    v_Add_Remove_Programs.DisplayName0 AS [Producto],
    v_GS_INSTALLED_SOFTWARE.InstalledLocation0 AS [Ruta de instalación],
	COUNT(v_R_System.ResourceID) AS [Count]
FROM 
    v_R_System 
    INNER JOIN v_Add_Remove_Programs 
        ON v_R_System.ResourceID = v_Add_Remove_Programs.ResourceID
    INNER JOIN v_R_User 
        ON v_R_System.User_Name0 = v_R_User.User_Name0
    INNER JOIN v_GS_INSTALLED_SOFTWARE 
        ON v_R_System.ResourceID = v_GS_INSTALLED_SOFTWARE.ResourceID
        AND v_Add_Remove_Programs.DisplayName0 = v_GS_INSTALLED_SOFTWARE.ProductName0
WHERE 
    v_Add_Remove_Programs.DisplayName0 LIKE '%ivanti%'
	
	GROUP BY 
    v_Add_Remove_Programs.DisplayName0, 
    v_GS_INSTALLED_SOFTWARE.InstalledLocation0
ORDER BY 
    count desc;

	 ----- QUERY un PRODUCTO Y CONTEO DE EQUIPOS POR CADA producto y con rango de fechas determinada----

SELECT 
    v_Add_Remove_Programs.DisplayName0 AS [Producto],
    v_GS_INSTALLED_SOFTWARE.InstalledLocation0 AS [Ruta de instalación],
	COUNT(v_R_System.ResourceID) AS [Count]
FROM 
    v_R_System 
    INNER JOIN v_Add_Remove_Programs 
        ON v_R_System.ResourceID = v_Add_Remove_Programs.ResourceID
    INNER JOIN v_R_User 
        ON v_R_System.User_Name0 = v_R_User.User_Name0
    INNER JOIN v_GS_INSTALLED_SOFTWARE 
        ON v_R_System.ResourceID = v_GS_INSTALLED_SOFTWARE.ResourceID
        AND v_Add_Remove_Programs.DisplayName0 = v_GS_INSTALLED_SOFTWARE.ProductName0
WHERE 
    v_Add_Remove_Programs.DisplayName0 LIKE '%Ivanti Secure Access Client 22.7%'
	AND v_Add_Remove_Programs.TimeStamp BETWEEN '2024-06-18' AND '2024-08-07'
	-- AND v_Add_Remove_Programs.TimeStamp BETWEEN '2023-01-01' AND '2024-06-17'
GROUP BY 
    v_Add_Remove_Programs.DisplayName0, 
    v_GS_INSTALLED_SOFTWARE.InstalledLocation0
ORDER BY 
    count desc;

----- EL MISMO QUE LA ANTERIOR QUERY PERO CON CODIGO DESINSTALACION-----

SELECT 
    v_Add_Remove_Programs.DisplayName0 AS [Producto],
    v_GS_INSTALLED_SOFTWARE.UninstallString0 AS [MSI DESINSTALACION],
    v_GS_INSTALLED_SOFTWARE.InstalledLocation0 AS [Ruta de instalación],
    COUNT(v_R_System.ResourceID) AS [Count]
FROM 
    v_R_System 
    INNER JOIN v_Add_Remove_Programs 
        ON v_R_System.ResourceID = v_Add_Remove_Programs.ResourceID
    INNER JOIN v_GS_INSTALLED_SOFTWARE 
        ON v_R_System.ResourceID = v_GS_INSTALLED_SOFTWARE.ResourceID
        AND v_Add_Remove_Programs.DisplayName0 = v_GS_INSTALLED_SOFTWARE.ProductName0
WHERE 
    v_Add_Remove_Programs.DisplayName0 LIKE '%adobe acrobat%'
GROUP BY 
    v_Add_Remove_Programs.DisplayName0, 
    v_GS_INSTALLED_SOFTWARE.UninstallString0,
    v_GS_INSTALLED_SOFTWARE.InstalledLocation0
ORDER BY 
    [Count] DESC;

--------- QUERY POR VERSION DE PRODUCTO Y CONTEO DE EQUIPOS POR CADA UNO----
SELECT 
    v_Add_Remove_Programs.DisplayName0 AS [Producto],
    v_GS_INSTALLED_SOFTWARE.InstalledLocation0 AS [Ruta de instalación],
    v_Add_Remove_Programs.Version0 AS [Versión],
    COUNT(v_R_System.ResourceID) AS [Count]
FROM 
    v_R_System 
    INNER JOIN v_Add_Remove_Programs 
        ON v_R_System.ResourceID = v_Add_Remove_Programs.ResourceID
    INNER JOIN v_R_User 
        ON v_R_System.User_Name0 = v_R_User.User_Name0
    INNER JOIN v_GS_INSTALLED_SOFTWARE 
        ON v_R_System.ResourceID = v_GS_INSTALLED_SOFTWARE.ResourceID
        AND v_Add_Remove_Programs.DisplayName0 = v_GS_INSTALLED_SOFTWARE.ProductName0
WHERE 
    v_Add_Remove_Programs.DisplayName0 LIKE '%adobe acrobat%'
GROUP BY 
    v_Add_Remove_Programs.DisplayName0, 
    v_GS_INSTALLED_SOFTWARE.InstalledLocation0,
    v_Add_Remove_Programs.Version0
ORDER BY 
    count DESC;


	--------------asset inteligence and Software meeteting----

	SELECT SYS.Netbios_Name0, PFI.FileID, PFI.FileName, 
    PFI.FileVersion, MD.StartTime 
    FROM v_MeterData MD INNER JOIN v_ProductFileInfo PFI 
    ON MD.FileID = PFI.FileID INNER JOIN v_R_System SYS 
    ON MD.ResourceID = SYS.ResourceID 
    ORDER BY SYS.Netbios_Name0, PFI.FileName







	SELECT MU.Domain, MU.UserName, SF.FileName, SF.FileVersion, 
    MUS.UsageCount, MUS.UsageTime, MUS.LastUsage 
    FROM v_MeteredUser MU INNER JOIN v_MonthlyUsageSummary MUS 
    ON MU.MeteredUserID = MUS.MeteredUserID INNER JOIN 
    v_GS_SoftwareFile SF ON MUS.FileID = SF.FileID 
    ORDER BY MU.Domain, MU.UserName, SF.FileName




	SELECT Distinct(mu.FullName), MAX(mus.LastUsage) as Lastusage,SUM(mus.TSUsageCount) as TSUsageCount
FROM 
	v_MonthlyUsageSummary MUS
	INNER JOIN v_GS_SoftwareUsageData SUD ON(mus.ResourceID=sud.ResourceID)
	INNER JOIN v_MeteredUser MU ON(mu.MeteredUserID=mus.MeteredUserID)
WHERE 
	sud.FileName='visio.exe'
AND	TSUsageCount >0
AND MONTH(mus.LastUsage)=9
GROUP BY 
	mu.FullName;



	 SELECT MRT.ProductName,MAX(MUS.LastUsage) AS LastUsage, MUR.FullName, MFS.MeteredFileName,SUM(MUS.UsageCount)+SUM(MUS.TSUsageCount) AS UsageCount
 FROM V_MonthlyUsageSummary MUS
 JOIN v_MeteredUser MUR ON MUS.MeteredUserID = MUR.MeteredUserID
 JOIN v_MeteredFiles MFS ON MUS.FileID = MFS.MeteredFileID
 JOIN MeterRules MRT ON MRT.RuleID = MFS.RuleID
 WHERE MRT.ProductName = 'MS VISIO'
 AND	MUS.LastUsage > '2019-09-01'
 GROUP BY MRT.ProductName,MUR.FullName,MFS.MeteredFileName
 ORDER BY MRT.ProductName

 -- Run this query against the ConfigMgr database


SELECT DISTINCT
    csd.Name00,
    csd.MachineID,
    sf.FileId,
    rua.ExplorerFileName0,
    rua.FileVersion0,
    rua.FileDescription0,
    rua.CompanyName0,
    rua.FileSize0,
    FileInstallationStatus = CASE WHEN si.ClientId IS NOT NULL THEN 'Installed' ELSE 'Not Installed' END,
    MsiDisplayName = ISNULL(NULLIF(msiDisplayName0, ''), ProductName0),
    MsiPublisher = ISNULL(NULLIF(msiPublisher0, ''), CompanyName0),
    MsiVersion = ISNULL(NULLIF(msiVersion0, ''), ProductVersion0),
    ProductCode = ISNULL(ProductCode0, ''),
    LastUserName0,
    rua.LastUsedTime0
FROM v_GS_CCM_RECENTLY_USED_APPS rua
    JOIN Computer_System_DATA csd
        ON csd.MachineID = rua.ResourceID
    JOIN SoftwareFile sf
        ON sf.FileName = rua.ExplorerFileName0 
        AND sf.FileVersion = rua.FileVersion0 
        AND sf.FileDescription = rua.FileDescription0 
        AND sf.FileSize = rua.FileSize0 
    LEFT OUTER JOIN SoftwareProduct sp
        ON sp.ProductId = sf.ProductId 
        AND sp.CompanyName = rua.CompanyName0 
    LEFT OUTER JOIN SoftwareInventory si
        ON si.ClientId = rua.ResourceID 
        AND si.FileId = sf.FileId 
        AND si.ProductId = sp.ProductId 
WHERE
    -- csd.Name00 = 'name of computer' AND
    rua.ExplorerFileName0 LIKE '%ACROBAT%' AND
    -- rua.CompanyName0 LIKE '%name of software publisher%' AND
    -- rua.LastUsedTime0 > GETDATE()-90 AND
    1=1



	-- Run this query against the ConfigMgr database
SELECT
    csd.Name00,
    csd.MachineID,
    ExternalFileID = m.FileID,
    sf.FileName,
    sf.FileVersion,
    sf.FileDescription,
    sp.CompanyName,
    sf.FileSize,
    FileInstallationStatus = CASE WHEN si.ClientId IS NOT NULL THEN 'Installed' ELSE 'Not Installed' END,
    mu.FullName,
    StartDate = LEFT(m.TimeKey, 4) + '/' + RIGHT(m.TimeKey, 2) + '/01',
    m.LastUsage,
    m.UsageTime,
    m.UsageCount,
    m.TSUsageCount
FROM dbo.MonthlyUsageSummary AS m
    JOIN Computer_System_DATA csd ON csd.MachineID = m.SystemItemKey
    JOIN dbo.v_metereduser AS mu ON mu.MeteredUserID = m.MeteredUserID
    JOIN SoftwareFile sf
        ON sf.FileId = m.FileID
    LEFT OUTER JOIN SoftwareProduct sp
        ON sp.ProductId = sf.ProductId 
    LEFT OUTER JOIN SoftwareInventory si
        ON si.ClientId = m.SystemItemKey
        AND si.FileId = sf.FileId 
        AND si.ProductId = sf.ProductId 
WHERE
    -- csd.Name00 = 'name of computer' AND
    -- sf.FileName LIKE '%name of executable%' AND
    -- sp.CompanyName LIKE '%name of software publisher%' AND
    -- m.LastUsage > GETDATE()-90 AND
    1=1