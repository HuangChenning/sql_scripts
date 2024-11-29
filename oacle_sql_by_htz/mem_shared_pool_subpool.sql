set lines 200
set pages 40
break on KSMCHIDX on KSMCHDUR
  SELECT KSMCHIDX,
         KSMCHDUR,
         KSMCHCLS CLASS,
         COUNT (KSMCHCLS) NUM,
         SUM (KSMCHSIZ) SIZ,
            TO_CHAR ( ( (SUM (KSMCHSIZ) / COUNT (KSMCHCLS) / 1024)),
                     '999,999.00')
         || 'k'
            "AVG SIZE"
    FROM X$KSMSP   WHERE inst_id = userenv('Instance')
GROUP BY KSMCHIDX, KSMCHDUR, KSMCHCLS
ORDER BY 1, 2, 3;

