USE CM_012
SELECT DISTINCT 
  v_R_System.Name0 as [Computer Name],
  v_R_User.Full_User_Name0 as [User Name],
  v_Add_Remove_Programs.DisplayName0 as [Product Name]
FROM 
  v_R_System 
  INNER JOIN v_Add_Remove_Programs ON v_R_System.ResourceID = v_Add_Remove_Programs.ResourceID
  INNER JOIN v_R_User ON v_R_System.User_Name0 = v_R_User.User_Name0
WHERE 
  v_Add_Remove_Programs.DisplayName0 LIKE '%excel 2007%'
