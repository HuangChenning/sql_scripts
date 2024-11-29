SELECT DISTINCT p.tablespace_name
  FROM dba_tablespaces p,
       dba_xml_tables x,
       dba_users u,
       all_all_tables t
 WHERE     t.table_name = x.table_name
       AND t.tablespace_name = p.tablespace_name
       AND x.owner = u.username
/