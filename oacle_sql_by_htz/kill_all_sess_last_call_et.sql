set echo off
set lines 200 verify off pages 1000 serveroutput on


PRO Parameter 1:
PRO last_call_et for inactive (default 60m) (required)
PRO
DEF last_call_et = '&1';




DECLARE
    v_sql   VARCHAR2 (100);
BEGIN
    FOR cur_session
        IN (SELECT sid, serial#,last_call_et
              FROM v$session s
             WHERE    s.username not in ('SYSTEM','SYS','SYSMAN','DBSNMP')
                   AND S.USERNAME IS NOT NULL
                   AND s.status = 'INACTIVE'
                   and s.machine <>sys_context('userenv','host')
                   AND S.LAST_CALL_ET > nvl('&&last_call_et',60)*60
              order by 3 desc)
    LOOP
        BEGIN
        v_sql :=
               'alter system kill session '
            || CHR (39)
            || cur_session.sid
            || ','
            || cur_session.serial#
            || CHR (39)
            || ' immediate';

        DBMS_OUTPUT.put_line (cur_session.last_call_et||'-------------'||v_sql);
        EXECUTE IMMEDIATE v_sql;
        EXCEPTION
            WHEN OTHERS THEN
              DBMS_OUTPUT.put_line('Find Error on :'||cur_session.last_call_et);
        END;

    END LOOP;
END;
/
undefine last_call_et;
undefine 1;