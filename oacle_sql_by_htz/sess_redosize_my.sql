set lines 170
select se.sid, st.name, se.value
  from v$sesstat se, v$statname st
 where se.STATISTIC# = st.STATISTIC#
   and st.name = 'redo size'
   and se.sid = (select sid from v$mystat where rownum = 1);
