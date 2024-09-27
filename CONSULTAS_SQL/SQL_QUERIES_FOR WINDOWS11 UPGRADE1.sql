USE CM_012
SELECT *
FROM v_GS_UPGRADE_EXPERIENCE_INDICATORS
WHERE UpgExProp0 LIKE '%RED%'


--

select * from v_r_system
from from v_r_system

-- QUERY EQUIPOS GREEN READY TO UPGRADE WINDOWS 11

select distinct htmd1.Name0 as 'Hostname',
htmd2.Caption0 as 'Operating System',
htmd2.BuildNumber0 as 'Build Number',
htmd3.UpgExProp0 as 'Windows Upgrade Status',
htmd3.Reason0 as 'Reason',
case
when htmd3.Version0 = '21H1' then 'Windows 10 21H1'
when htmd3.Version0 = '21H2' then 'Windows 10 21H2'
when htmd3.Version0 = 'CO21H2' then 'Windows 11 21H2'
else 'Unknown or Future Versions of Windows'
End as 'Upgrade to'
from v_r_system as htmd1
inner join v_gs_operating_system as htmd2
on htmd1.ResourceID=htmd2.ResourceID
left outer join v_GS_UPGRADE_EXPERIENCE_INDICATORS as htmd3
on htmd1.ResourceID=htmd3.ResourceID
where htmd1.Operating_System_Name_and0 like '%Microsoft Windows NT Workstation 10.0%'  
and htmd3.Version0 = 'CO21H2'
and htmd2.BuildNumber0 < 22000
order by htmd1.Name0



----- COMPUTERS READY FOR WINDOWS UPDATE 11----
select distinct htmd1.Name0 as 'Hostname',
htmd2.Caption0 as 'Operating System',
htmd2.BuildNumber0 as 'Build Number',
htmd3.UpgExProp0 as 'Windows Upgrade Status',
htmd3.Reason0 as 'Reason',
case
when htmd3.Version0 = '21H1' then 'Windows 10 21H1'
when htmd3.Version0 = '21H2' then 'Windows 10 21H2'
when htmd3.Version0 = 'CO21H2' then 'Windows 11 21H2'
else 'Unknown or Future Versions of Windows'
End as 'Upgrade to'
from v_r_system as htmd1
inner join v_gs_operating_system as htmd2
on htmd1.ResourceID=htmd2.ResourceID
left outer join v_GS_UPGRADE_EXPERIENCE_INDICATORS as htmd3
on htmd1.ResourceID=htmd3.ResourceID
where htmd1.Operating_System_Name_and0 like '%Microsoft Windows NT Workstation 10.0%'  and  htmd3.UpgExProp0 like 'GREEN'
and htmd3.Version0 = 'CO21H2'
and htmd2.BuildNumber0 < 22000
order by htmd1.Name0

----- COMPUTERS DON'T MEET REQIRMENTS FOR WINDOWS UPDATE 11----
select distinct htmd1.Name0 as 'Hostname',
htmd2.Caption0 as 'Operating System',
htmd2.BuildNumber0 as 'Build Number',
htmd3.UpgExProp0 as 'Windows Upgrade Status',
htmd3.Reason0 as 'Reason',
case
when htmd3.Version0 = '21H1' then 'Windows 10 21H1'
when htmd3.Version0 = '21H2' then 'Windows 10 21H2'
when htmd3.Version0 = 'CO21H2' then 'Windows 11 21H2'
else 'Unknown or Future Versions of Windows'
End as 'Upgrade to'
from v_r_system as htmd1
inner join v_gs_operating_system as htmd2
on htmd1.ResourceID=htmd2.ResourceID
left outer join v_GS_UPGRADE_EXPERIENCE_INDICATORS as htmd3
on htmd1.ResourceID=htmd3.ResourceID
where htmd1.Operating_System_Name_and0 like '%Microsoft Windows NT Workstation 10.0%'  and  htmd3.UpgExProp0 like 'red'
and htmd3.Version0 = 'CO21H2'
and htmd2.BuildNumber0 < 22000
order by htmd1.Name0

------- COMPUTERS NEED PREVIOUS ACTIONS  FOR WINDOWS UPDATE 11----
select distinct htmd1.Name0 as 'Hostname',
htmd2.Caption0 as 'Operating System',
htmd2.BuildNumber0 as 'Build Number',
htmd3.UpgExProp0 as 'Windows Upgrade Status',
htmd3.Reason0 as 'Reason',
case
when htmd3.Version0 = '21H1' then 'Windows 10 21H1'
when htmd3.Version0 = '21H2' then 'Windows 10 21H2'
when htmd3.Version0 = 'CO21H2' then 'Windows 11 21H2'
else 'Unknown or Future Versions of Windows'
End as 'Upgrade to'
from v_r_system as htmd1
inner join v_gs_operating_system as htmd2
on htmd1.ResourceID=htmd2.ResourceID
left outer join v_GS_UPGRADE_EXPERIENCE_INDICATORS as htmd3
on htmd1.ResourceID=htmd3.ResourceID
where htmd1.Operating_System_Name_and0 like '%Microsoft Windows NT Workstation 10.0%'  and  htmd3.UpgExProp0 like 'ORANGE'
and htmd3.Version0 = 'CO21H2'
and htmd2.BuildNumber0 < 22000
order by htmd1.Name0



-- ADD FIELS NO COMPATIBLE OR COMPATIBLE

select distinct htmd1.Name0 as 'Hostname',
htmd2.Caption0 as 'Operating System',
htmd2.BuildNumber0 as 'Build Number',
htmd3.Reason0 as 'Reason',
case
when htmd3.Version0 = '21H1' then 'Windows 10 21H1'
when htmd3.Version0 = '21H2' then 'Windows 10 21H2'
when htmd3.Version0 = 'CO21H2' then 'Windows 11 21H2'
else 'Unknown or Future Versions of Windows'
End as 'Upgrade to',
case
when htmd3.UpgExProp0 = 'Red' then 'Not Compatible'
when htmd3.UpgExProp0 = 'Green' then 'Compatible'
else 'Unknown'
End as 'Compatible?'
from v_r_system as htmd1
inner join v_gs_operating_system as htmd2
on htmd1.ResourceID=htmd2.ResourceID
left outer join v_GS_UPGRADE_EXPERIENCE_INDICATORS as htmd3
on htmd1.ResourceID=htmd3.ResourceID
where htmd1.Operating_System_Name_and0 like '%Microsoft Windows NT Workstation 10.0%' 
and htmd3.Version0 = 'CO21H2'
and htmd2.BuildNumber0 < 22000
order by htmd1.Name0