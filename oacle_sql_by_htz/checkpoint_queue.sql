set lines 170
col lowrba for a30
col onrba for a30 heading 'ON DISK RBA'
col cpods for 9999999999 heading 'ON DISK SCN'
col cpodt for a19 heading 'ON DISK TIME'
col cphbt for 99999999999999 heading 'heartbeat'
SELECT CPDRT,
       CPLRBA_SEQ || '.' || CPLRBA_BNO || '.' || CPLRBA_BOF "LowRBA",
       CPODR_SEQ || '.' || CPODR_BNO || '.' || CPODR_BOF "OnRBA",
       CPODS,
       CPODT,
       CPHBT
  FROM x$kcccp;
