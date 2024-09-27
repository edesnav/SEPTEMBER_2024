USE CM_012
SELECT DISTINCT
  R.Name0 AS [Computer Name],
  R.UserName0 AS [User Name],
  ARP.DisplayName0 AS [Display Name],
  ARP.Version0 AS [Version]
FROM
  v_R_System R
  JOIN v_Add_Remove_Programs ARP ON R.ResourceID = ARP.ResourceID
WHERE
  ARP.DisplayName0 LIKE '%Microsoft Excel 2010%'
  OR (ARP.DisplayName0 LIKE '%Microsoft Office%' AND ARP.DisplayName0 LIKE '%2010%' AND ARP.DisplayName0 LIKE '%Excel%')
