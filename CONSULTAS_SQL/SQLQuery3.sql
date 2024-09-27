USE CM_012
SELECT DISTINCT 
  v_R_System.Name0 as [Computer Name],
  v_R_System.User_Name0 as [User Name],
  v_Add_Remove_Programs.DisplayName0 as [Product Name],
  v_Add_Remove_Programs.Version0 as [Version]
FROM 
  v_R_System 
  INNER JOIN v_Add_Remove_Programs ON v_R_System.ResourceID = v_Add_Remove_Programs.ResourceID
WHERE 
  v_Add_Remove_Programs.DisplayName0 LIKE '%Excel%'
  AND v_Add_Remove_Programs.Version0 LIKE '2010%' -- Version number for Excel 2010 starts with 14
