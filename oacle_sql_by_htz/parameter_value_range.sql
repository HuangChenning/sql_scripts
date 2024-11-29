set echo off
set lines 300 pages 50 heading on verify off
col inst_id for 99 heading 'I'
col name for a40
col oradinal for 99999
col value for a40
col isdefault for a9
col desc for a70
break on inst_id on name 
SELECT a.inst_id,
         a.name_kspvld_values name,
         a.ordinal_kspvld_values ORDINAL,
         a.value_kspvld_values VALUE,
         a.isdefault_kspvld_values isdefault,
         b.ksppdesc "DESC"
    FROM X$KSPVLD_VALUES a, x$ksppi b
   WHERE     b.KSPPINM = nvl(LOWER ('&parameter_name'),b.ksppinm)
         AND a.name_kspvld_values(+) = b.KSPPINM
ORDER BY inst_id, name, ordinal;
