/* Formatted on 2017/12/14 0:12:20 (QP5 v5.300) */
-- File Name : kill_sess_by_scn.sql
-- Purpose : 根据scn，回话的状态来kill进程
-- 支持 10g,11g,12c
-- Date : 2017/12/14
-- 认真就输、QQ:7343696
-- http://www.htz.pw
-- 2017.12.14 改写为引用游标
SET ECHO OFF;
SET HEADING OFF SERVEROUTPUT ON VERIFY OFF
PRO
PRO Parameter 1:
PRO kill session scn <=scn_value  (default scn of sysdate-1)
PRO
DEF scn_value=nvl('&1','1')
PRO
PRO
PRO Parameter 2:
PRO session status (ACTIVE OR INACTIVE  OR ALL default INACTIVE)
PRO
DEF sess_status = decode(upper('&2'),'INACTIVE','INACTIVE','ACTIVE','ACTIVE','ALL','ALL','INACTIVE');

PRO Parameter 3:
PRO mark  (<= >= = < >  default <=)
PRO
DEF MARK=nvl('&3','<=');


DECLARE
    v_sql           VARCHAR2 (1000);
    v_scn_value     VARCHAR2 (20);
    v_mark          VARCHAR2 (100);
    v_sess_status   VARCHAR2 (100);
    v_count         NUMBER;
    v_scn_wrap      NUMBER;
    v_scn_base      NUMBER;
    v_sql_status    VARCHAR2 (100);

    TYPE v_cursor_def IS REF CURSOR;

    v_cursor        v_cursor_def;
    v_sid           NUMBER;
    v_serial        NUMBER;
    v_inst          NUMBER;
BEGIN
    v_scn_value := &&scn_value;
    v_mark := &&mark;

    SELECT &&sess_status INTO v_sess_status FROM DUAL;

    IF v_sess_status <> 'ALL'
    THEN
        v_sql_status :=
            ' and status=' || CHR (39) || v_sess_status || CHR (39);
    END IF;

    IF v_scn_value <> '1'
    THEN
        SELECT INSTR (v_scn_value, '.') INTO v_count FROM DUAL;

        IF v_count > 0
        THEN
            SELECT TO_NUMBER (
                       SUBSTR (v_scn_value, 1, INSTR (v_scn_value, '.')),
                       '999999999999999')
              INTO v_scn_wrap
              FROM DUAL;

            IF v_scn_wrap > 0
            THEN
                SELECT TO_NUMBER (
                           SUBSTR (v_scn_value, INSTR (v_scn_value, '.') + 1),
                           '99999999999999999999999')
                  INTO v_scn_base
                  FROM DUAL;

                v_sql :=
                       'SELECT inst_id, sid, serial#  FROM gv$session WHERE (inst_id, saddr) IN (SELECT inst_id, ses_addr FROM gv$transaction WHERE    start_scn'
                    || v_mark
                    || '(4294967296*'
                    || v_scn_wrap
                    || '+'
                    || v_scn_base
                    || ') '
                    || v_sql_status
                    || ' ) ';
            ELSE
                DBMS_OUTPUT.put_line (
                    ' ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ');
                DBMS_OUTPUT.put_line (
                       ' ** ** ** ** ** ** ** ** ** * error scn : '
                    || v_scn_value);
                DBMS_OUTPUT.put_line (
                    ' ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ');
            END IF;
        ELSE
            SELECT TO_NUMBER (v_scn_value, ' 999999999999999999999 ')
              INTO v_scn_value
              FROM DUAL;


            v_sql :=
                   ' SELECT inst_id , sid , serial# FROM gv$session WHERE ( inst_id , saddr ) IN ( SELECT inst_id , ses_addr FROM gv$transaction WHERE ( start_scn '
                || v_mark
                || ' '
                || v_scn_value
                || ' ) '
                || v_sql_status
                || ' ) ';
        END IF;
    ELSE
        SELECT TIMESTAMP_TO_SCN (SYSDATE - 1) INTO v_scn_value FROM DUAL;


        v_sql :=
               ' SELECT inst_id , sid , serial# FROM gv$session WHERE ( inst_id , saddr ) IN ( SELECT inst_id , ses_addr FROM gv$transaction WHERE ( start_scn '
            || v_mark
            || ' '
            || v_scn_value
            || ' ) '
            || v_sql_status
            || ' ) ';
    END IF;


    OPEN v_cursor FOR v_sql;

    LOOP
        FETCH v_cursor INTO v_inst,v_sid, v_serial;

        EXIT WHEN v_cursor%NOTFOUND;

        v_sql :=
               'alter system kill session '
            || CHR (39)
            || v_sid
            || ','
            || v_serial
            || ',@'
            || v_inst
            || CHR (39)
            || ' immediate';
        DBMS_OUTPUT.put_line (v_sql);

        EXECUTE IMMEDIATE v_sql;
    END LOOP;
END;
/

UNDEFINE 1;
UNDEFINE 2;
UNDEFINE 3;