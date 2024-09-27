
-- CONSULTA COLLECCIONES A LAS QUE PERTENECE UN EQUIPO--
USE CM_012

SELECT
    FCM.CollectionID,
    COLL.Name as CollectionName,
    SYS.Name0 as ComputerName
FROM
    v_FullCollectionMembership FCM
JOIN
    v_Collection COLL ON FCM.CollectionID = COLL.CollectionID
JOIN
    v_R_System SYS ON FCM.ResourceID = SYS.ResourceID
WHERE
    SYS.Name0 = 'pc29dd9l'






