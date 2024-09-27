USE CM_012
-- Query to get all manufacturers and models
SELECT Manufacturer0, Model0, COUNT(Model0) AS 'Count'
FROM dbo.v_GS_COMPUTER_SYSTEM
GROUP BY Manufacturer0, Model0
ORDER BY COUNT DESC;



-- 
select *
from dbo.v_GS_COMPUTER_SYSTEM


-- buscar las columnas que contengan SKU
	SELECT Table_Name, 
    Column_Name
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE '%SOFTWARE%'

GO 


---- buscar las columnas que contengan model

	SELECT Table_Name, 
    Column_Name
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE '%SOFTWARE%'

GO 




-- CONSULTA CONTEO, CANTIDAD MODELOS HARDWARE EQUIPOS POR MODELO Y SKU MODELO ---

SELECT 
    VENDOR0 AS 'FABRICANTE', 
    NAME0 AS 'MODELO', 
    VERSION0 AS 'SKU MODELO', 
    COUNT(NAME0) AS 'CANTIDAD'
FROM 
    dbo.v_GS_COMPUTER_SYSTEM_PRODUCT
GROUP BY 
    VENDOR0, 
    NAME0, 
    VERSION0
ORDER BY 
    COUNT(NAME0) DESC;

	----QUERY SELECCIONAR EQUIPOS DE UN MODELO ESPECIFICO----
SELECT 
    sys.Name0 AS [Computer Name],
    prod.VENDOR0 AS [Fabricante], 
    prod.NAME0 AS [Modelo], 
    prod.VERSION0 AS [SKU Modelo]
FROM 
    dbo.v_GS_COMPUTER_SYSTEM_PRODUCT AS prod
INNER JOIN 
    dbo.v_R_System AS sys ON prod.ResourceID = sys.ResourceID
WHERE 
    prod.VERSION0 LIKE 'ThinkPad P16v Gen 1';


   
   

	-- CONSULTA GROUP BY SISTEMAS OPERATIVOS --

SELECT 
    os.Caption0 AS [Operating System], 
    os.Version0 AS [Version], 
    COUNT(*) AS [Count]
FROM 
    dbo.v_R_System AS sys
JOIN 
    dbo.v_GS_OPERATING_SYSTEM AS os ON sys.ResourceID = os.ResourceID
WHERE 
    os.Caption0 LIKE 'Microsoft Windows 11%'
GROUP BY 
    os.Caption0, 
    os.Version0
ORDER BY 
    os.Version0;


	
   

--SELECCION EQUIPOS POR VERSION WINDOWS 10 u 11 dependiendo Del where--

SELECT 
    sys.Name0 AS [Computer Name], 
    os.Caption0 AS [Operating System], 
    os.Version0 AS [Version], 
    os.CSDVersion0 AS [Service Pack]
FROM 
    dbo.v_R_System AS sys
JOIN 
    dbo.v_GS_OPERATING_SYSTEM AS os ON sys.ResourceID = os.ResourceID
WHERE 
    -- os.Version0 LIKE '10.0.14393' and os.Caption0 LIKE 'Microsoft Windows 10%'
  os.Caption0 LIKE 'Microsoft Windows 11%'
ORDER BY 
    os.Version0, sys.Name0;
