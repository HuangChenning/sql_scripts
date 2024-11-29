set pagesize 40
set linesize 200 
col own for a15 heading 'OBJECT_OWNER'
col name for a40 heading 'OBJECT_NAME'
SELECT A.owner own,
       A.object_Name name,
       A.object_Type TYPE,
       a.status,
       'Miss Pkg Body' Prob
  FROM DBA_OBJECTS A
 WHERE     A.object_type = 'PACKAGE'
       AND A.owner NOT IN ('SYS', 'SYSTEM')
       AND NOT EXISTS
                  (SELECT 'x'
                     FROM DBA_OBJECTS B
                    WHERE     B.object_Name = A.object_Name
                          AND B.owner = A.owner
                          AND B.object_Type = 'PACKAGE BODY')
UNION
SELECT owner own,
       object_Name name,
       object_Type TYPE,
       status,
       'Invalid Obj' prob
  FROM DBA_OBJECTS
 WHERE owner NOT IN ('SYS', 'SYSTEM') AND Status != 'VALID'
ORDER BY 1,
         4,
         3,
         2
/
