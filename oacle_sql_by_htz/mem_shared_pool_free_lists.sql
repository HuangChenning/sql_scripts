set lines 200
set pages 40
break on ksmchidx on ksmchdur
select
   ksmchidx,ksmchdur,
   case
         when ksmchsiz < 1672 then trunc((ksmchsiz-32)/8)
         when ksmchsiz < 4120 then trunc((ksmchsiz+7928)/48)
         when ksmchsiz < 8216 then 250
         when ksmchsiz < 16408 then 251
         when ksmchsiz < 32792 then 252
         when ksmchsiz < 65560 then 253
         when ksmchsiz >= 65560 then 253
    end bucket,
   sum(ksmchsiz)  free_space,
   count(*)  free_chunks,
   trunc(avg(ksmchsiz))  average_size,
   max(ksmchsiz)  biggest
 from
   sys.x$ksmsp
 where
   inst_id = userenv('Instance') and
   ksmchcls = 'free'
 group by
   case
         when ksmchsiz < 1672 then trunc((ksmchsiz-32)/8)
         when ksmchsiz < 4120 then trunc((ksmchsiz+7928)/48)
         when ksmchsiz < 8216 then 250
         when ksmchsiz < 16408 then 251
         when ksmchsiz < 32792 then 252
         when ksmchsiz < 65560 then 253
         when ksmchsiz >= 65560 then 253
    end ,
   ksmchidx, ksmchdur
 order by ksmchidx , ksmchdur
 /
