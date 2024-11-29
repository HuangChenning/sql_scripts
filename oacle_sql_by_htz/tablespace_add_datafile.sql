set verify off serveroutput on
DECLARE
   v_tbname     VARCHAR2 (100);
   v_size       NUMBER;
   v_dgname     VARCHAR2 (100);
   v_sql        VARCHAR2 (1000);
   v_dbsize     NUMBER;
   v_addnum     NUMBER;
   v_freesize   NUMBER;
   v_num        NUMBER;
   v_cnt        NUMBER;
   v_free_mb    NUMBER;
   v_time       VARCHAR2 (20);
BEGIN
   v_tbname := '&tablespacename';--表空间的名字
   v_size := '&size_m';          --需要添加或者创建的大小
   v_dgname := '&diskgroupname'; --磁盘组的名字
   v_dbsize := '&datafilesize';  --每个数据文件的大小

   SELECT name, free_mb
     INTO v_dgname, v_free_mb
     FROM v$asm_diskgroup
    WHERE name = upper(v_dgname);

   IF v_free_mb > v_size
   THEN
      DBMS_OUTPUT.put_line (v_dgname || ' HAS ENOUGH SPACE FOR ADD DATAFILE');

      SELECT COUNT (*)
        INTO v_cnt
        FROM dba_tablespaces t
       WHERE t.TABLESPACE_NAME = upper(v_tbname);

      IF v_cnt = 0
      THEN
         DBMS_OUTPUT.put_line (
            v_tbname || ' IS NOT EXISTS, AND WILL BE CREATE');

         IF v_size < v_dbsize
         THEN
            v_sql :=
                  'create tablespace '
               || v_tbname
               || ' datafile '
               || '''+'
               || v_dgname
               || ''' size '
               || v_size
               || 'm';
            DBMS_OUTPUT.put_line (
               'TOTAL SIZE OF TABLESPACE  IS LESS THAN THE SIZE OF A DATAFILE,SO CREATE ONLY ONE DATAFILE');

            SELECT TO_CHAR(SYSDATE, 'yyyy-mm-dd hh24:mi:ss')
              INTO v_time
              FROM DUAL;

            DBMS_OUTPUT.PUT_LINE (v_time || '     BEGIN EXEC:' || v_sql);

            EXECUTE IMMEDIATE v_sql;

            SELECT TO_CHAR(SYSDATE, 'yyyy-mm-dd hh24:mi:ss')
              INTO v_time
              FROM DUAL;

            DBMS_OUTPUT.PUT_LINE (v_time || '     END EXEC:' || v_sql);
         ELSE
            DBMS_OUTPUT.put_line (
               'CALCULATION DATAFILE NUMBER OF TABLESPACE AND CALCULATION THE SIZE OF LAST DATAFILE');

            SELECT TRUNC (v_size / v_dbsize), MOD (v_size, v_dbsize)
              INTO v_addnum, v_freesize
              FROM DUAL;

            DBMS_OUTPUT.put_line (
                  ' DATAFILE NUMBER IS '
               || v_addnum
               || ' , THE SIZE OF LAST DATAFILE IS '
               || v_freesize);


            v_sql :=
                  'create tablespace '
               || v_tbname
               || ' datafile '
               || '''+'
               || v_dgname
               || ''' size '
               || v_dbsize
               || 'm';

            SELECT TO_CHAR(SYSDATE, 'yyyy-mm-dd hh24:mi:ss')
              INTO v_time
              FROM DUAL;

            DBMS_OUTPUT.PUT_LINE (v_time || '     BEGIN EXEC:' || v_sql);

            EXECUTE IMMEDIATE v_sql;

            SELECT TO_CHAR(SYSDATE, 'yyyy-mm-dd hh24:mi:ss')
              INTO v_time
              FROM DUAL;

            DBMS_OUTPUT.PUT_LINE (v_time || '     END EXEC:' || v_sql);
            v_num := 1;

            WHILE v_num < v_addnum
            LOOP
               v_sql :=
                     'alter tablespace '
                  || v_tbname
                  || ' add datafile '
                  || '''+'
                  || v_dgname
                  || ''' size '
                  || v_dbsize
                  || 'm';
               v_num := v_num + 1;

               SELECT TO_CHAR(SYSDATE, 'yyyy-mm-dd hh24:mi:ss')
                 INTO v_time
                 FROM DUAL;

               DBMS_OUTPUT.PUT_LINE (v_time || '     BEGIN EXEC:' || v_sql);

               EXECUTE IMMEDIATE v_sql;

               SELECT TO_CHAR(SYSDATE, 'yyyy-mm-dd hh24:mi:ss')
                 INTO v_time
                 FROM DUAL;

               DBMS_OUTPUT.PUT_LINE (v_time || '     END EXEC:' || v_sql);
            END LOOP;

            v_sql :=
                  'alter tablespace '
               || v_tbname
               || ' add datafile '
               || '''+'
               || v_dgname
               || ''' size '
               || v_freesize
               || 'm';

            SELECT TO_CHAR(SYSDATE, 'yyyy-mm-dd hh24:mi:ss')
              INTO v_time
              FROM DUAL;

            DBMS_OUTPUT.PUT_LINE (v_time || '     BEGIN EXEC:' || v_sql);

            EXECUTE IMMEDIATE v_sql;

            SELECT TO_CHAR(SYSDATE, 'yyyy-mm-dd hh24:mi:ss')
              INTO v_time
              FROM DUAL;

            DBMS_OUTPUT.PUT_LINE (v_time || '     END EXEC:' || v_sql);
         END IF;
      ELSIF v_cnt > 0
      THEN
         DBMS_OUTPUT.put_line (
            v_tbname || ' IS  EXISTS, AND WILL ADD DATAFILE ');
         DBMS_OUTPUT.put_line (
            'CALCULATION DATAFILE NUMBER OF TABLESPACE AND CALCULATION THE SIZE OF LAST DATAFILE');

         SELECT TRUNC (v_size / v_dbsize), MOD (v_size, v_dbsize)
           INTO v_addnum, v_freesize
           FROM DUAL;

         DBMS_OUTPUT.put_line (
               ' DATAFILE NUMBER IS '
            || v_addnum
            || ' THE SIZE OF LAST DATAFILE IS '
            || v_freesize);
         v_num := 1;

         WHILE v_num < v_addnum
         LOOP
            v_sql :=
                  'alter tablespace '
               || v_tbname
               || ' add datafile '
               || '''+'
               || v_dgname
               || ''' size '
               || v_dbsize
               || 'm';
            v_num := v_num + 1;

            SELECT TO_CHAR(SYSDATE, 'yyyy-mm-dd hh24:mi:ss')
              INTO v_time
              FROM DUAL;

            DBMS_OUTPUT.PUT_LINE (v_time || '     BEGIN EXEC:' || v_sql);

            EXECUTE IMMEDIATE v_sql;

            SELECT TO_CHAR(SYSDATE, 'yyyy-mm-dd hh24:mi:ss')
              INTO v_time
              FROM DUAL;

            DBMS_OUTPUT.PUT_LINE (v_time || '     END EXEC:' || v_sql);
         END LOOP;

         v_sql :=
               'alter tablespace '
            || v_tbname
            || ' add datafile '
            || '''+'
            || v_dgname
            || ''' size '
            || v_freesize
            || 'm';

         SELECT TO_CHAR(SYSDATE, 'yyyy-mm-dd hh24:mi:ss')
           INTO v_time
           FROM DUAL;

         DBMS_OUTPUT.PUT_LINE (v_time || '     BEGIN EXEC:' || v_sql);

         EXECUTE IMMEDIATE v_sql;

         SELECT TO_CHAR(SYSDATE, 'yyyy-mm-dd hh24:mi:ss')
           INTO v_time
           FROM DUAL;

         DBMS_OUTPUT.PUT_LINE (v_time || '     END EXEC:' || v_sql);
      END IF;
   ELSE
      DBMS_OUTPUT.put_line (
            v_dgname
         || ' HAS NOT ENOUGH SPACE FOR ADD DATAFILE，SO SCRIPT WILL EXIST');
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (SQLCODE || '-' || SQLERRM);
END;
/