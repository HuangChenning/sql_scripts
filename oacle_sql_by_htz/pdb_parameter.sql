col pdb_name for a20
col inst_id for a2
col paraname for a50
col value$ for a80
SELECT a.pdb_name pdb_name,
       b.sid inst_id,
       b.name paraname,
       b.value$
FROM dba_pdbs a,
     pdb_spfile$ b
WHERE a.CON_UId=b.pdb_uid
/