#!/bin/bash
### version 1.12
###crontab中调用
###delete arch log ,when archive directory space greater than 85%
#### if > 70 delete archivelog   backuped 1 time and send to adg
#### if > 80 delete archivelog   by send to adg
#### if > 95 delete archivelog   all force
###*/4 * * * * sh /home/oracle/enmo/delete_arch.sh > /home/oracle/enmo/delete.log 2>&1
###modify by htz  20180724
###修改awk获取比例的变量
###modify by htz  20180726
###修改归档路径获取的内容，FRA是文件系统的BUG,添加文件系统和FRA空间比较
###添加路径为ERROR的判断
###modify by htz  20180731
###添加备库的判断条件
###modify by htz  20180806
###修改归档路径为+arch/datafile/这种路径获取报错
###modify by htz 20180926
###修改文件系统模式下获取的归档路径错误。

###modify by htz 20181008
###将v$asm_diskgroup修改为v$asm_diskgroup_stat。


###modify by htz 20190310

###添加大于95%后，先删除最近能删除的，如果还不能满足条件，在删除所有的。

source ~/.bash_profile

CHKLOG_PATH=/tmp
CURRDATE=`date +%Y%m%d`
CURRTIME=`date +%Y%m%d_%T`
CHKLOG_FILE=${CHKLOG_PATH}/delete_archive_${CURRDATE}.log
CHKNUM=30

echo "_____**** ${CURRTIME} BEGIN DELETE ****______" >>${CHKLOG_FILE}


get_path (){
     temp_file_path_name=$1;
     temp_count=`grep $temp_file_path_name /etc/mtab|wc -l`;
     if [ $temp_count -eq 0 ];then
         temp_file_path_name=${temp_file_path_name%/*};
         if [ ! ${temp_file_path_name} ]; then
             temp_file_path_name=${temp_file_path_name}/;
         fi

         get_path $temp_file_path_name;

     else
        ARCHLOG_PATH=$temp_file_path_name
     fi
}

calculate_space_used()
{



echo "_____**** ${CURRTIME} Get DB  Role ****______" >>${CHKLOG_FILE}


DB_ROLE=`sqlplus -silent "/as sysdba" <<EOF
set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
select database_role from v\\\$database;
exit;
EOF`

echo "_____**** ${CURRTIME} Get DB  Role Is ${DB_ROLE} ****______" >>${CHKLOG_FILE}

if [ "${DB_ROLE}" = "PRIMARY" ];then
TEMP_NUMBER=`sqlplus -silent "/as sysdba" <<EOF
set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
set serveroutput on
DECLARE
    i_count       NUMBER;
    v_sql         VARCHAR2 (100);
    v_arch_path   VARCHAR2 (100);
BEGIN
    SELECT DESTINATION
      INTO v_arch_path
      FROM v\\\$archive_dest
     WHERE TARGET = 'PRIMARY' AND STATUS in ('ERROR', 'VALID');

    IF v_arch_path = 'USE_DB_RECOVERY_FILE_DEST'
    THEN
        SELECT COUNT (*)
          INTO i_count
          FROM v\\\$parameter
         WHERE name = 'db_recovery_file_dest' AND SUBSTR (VALUE, 1, 1) = '+';

        IF i_count = 1
        THEN
            DBMS_OUTPUT.put_line (0);
        ELSE
            DBMS_OUTPUT.put_line (1);
        END IF;
    ELSIF v_arch_path LIKE '/%'
    THEN
        DBMS_OUTPUT.put_line (1);
    ELSIF v_arch_path LIKE '+%'
    THEN
        DBMS_OUTPUT.put_line (0);
    END IF;
END;
/
exit;
EOF`





if [ $TEMP_NUMBER -eq 1 ];then

echo "_____**** ${CURRTIME} Arch Path  type   File System  ****______" >>${CHKLOG_FILE}

   ARCHLOG_PATH=`sqlplus -silent "/as sysdba" <<EOF
set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130 serveroutput on
DECLARE
    i_count   NUMBER;
    i_path    VARCHAR2 (100);
BEGIN
    SELECT COUNT (*)
      INTO i_count
      FROM v\\\$archive_dest
     WHERE     TARGET = 'PRIMARY'
           AND STATUS IN ('ERROR', 'VALID')
           AND DESTINATION LIKE '/%';

    IF i_count > 0
    THEN
        SELECT VALUE
          INTO i_path
          FROM (SELECT DESTINATION VALUE
                  FROM v\\\$archive_dest
                 WHERE     TARGET = 'PRIMARY'
                       AND STATUS IN ('ERROR', 'VALID')
                       AND DESTINATION LIKE '/%')
         WHERE ROWNUM = 1;

        DBMS_OUTPUT.put_line (i_path);
    ELSE
        SELECT VALUE
          INTO i_path
          FROM v\\\$parameter
         WHERE name = 'db_recovery_file_dest' AND ROWNUM = 1;

        DBMS_OUTPUT.put_line (i_path);
    END IF;
END;
/
exit;
EOF`

     file_path_name=${ARCHLOG_PATH};
     get_path ${file_path_name};
    echo "_____**** ${CURRTIME} Arch Path   File System  IS ${file_path_name} ****______" >>${CHKLOG_FILE};
     Os_Used=`df -k $ARCHLOG_PATH|awk '$NF=="'$ARCHLOG_PATH'"{print $(NF-1)}'|awk -F% '{print $1}'|head -1`



     Fra_Used=`sqlplus -silent "/as sysdba" <<EOF
         set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
         set serveroutput on
         DECLARE
             v_arch_path   VARCHAR2 (100);
             v_pert        NUMBER;
             v_number      NUMBER;
             v_free        NUMBER;
             v_diskgroup   VARCHAR2 (100);
         BEGIN
             SELECT DESTINATION
               INTO v_arch_path
               FROM v\\\$archive_dest
              WHERE TARGET = 'PRIMARY' AND STATUS in ('ERROR', 'VALID');

             IF v_arch_path = 'USE_DB_RECOVERY_FILE_DEST'
             THEN
                 SELECT TRUNC (SUM (PERCENT_SPACE_USED))
                   INTO v_pert
                   FROM v\\\$flash_recovery_area_usage;

                 DBMS_OUTPUT.put_line (v_pert);
             ELSE
                 DBMS_OUTPUT.put_line (0);
             END IF;
         END;
         /
exit;
EOF`
   if [ $Fra_Used -ge $Os_Used ];then
      Used=$Fra_Used;
   else
      Used=$Os_Used;
   fi

else

ARCHLOG_PATH=`sqlplus -silent "/as sysdba" <<EOF
         set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
         set serveroutput on
         DECLARE
             v_arch_path   VARCHAR2 (100);
             v_pert        NUMBER;
             v_number      NUMBER;
             v_free        NUMBER;
             v_diskgroup   VARCHAR2 (100);
         BEGIN
             SELECT DESTINATION
               INTO v_arch_path
               FROM v\\\$archive_dest
              WHERE TARGET = 'PRIMARY' AND status in ('ERROR', 'VALID');

             IF v_arch_path = 'USE_DB_RECOVERY_FILE_DEST'
             THEN
                 SELECT VALUE
                   INTO v_diskgroup
                   FROM v\\\$parameter
                  WHERE name = 'db_recovery_file_dest';

                 DBMS_OUTPUT.put_line (v_diskgroup);
             ELSE
                 DBMS_OUTPUT.put_line (v_arch_path);
             END IF;
         END;
         /
exit;
EOF`


echo "_____**** ${CURRTIME} Arch Path  Is ASM  and Path Is  ${ARCHLOG_PATH} ****______" >>${CHKLOG_FILE};
Used=`sqlplus -silent "/as sysdba" <<EOF
         set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
         set serveroutput on
         DECLARE
             v_arch_path   VARCHAR2 (100);
             v_pert        NUMBER;
             v_number      NUMBER;
             v_free        NUMBER;
             v_diskgroup   VARCHAR2 (100);
         BEGIN
             SELECT DESTINATION
               INTO v_arch_path
               FROM v\\\$archive_dest
              WHERE TARGET = 'PRIMARY' AND status in ('ERROR', 'VALID');

             IF v_arch_path = 'USE_DB_RECOVERY_FILE_DEST'
             THEN
                 SELECT MAX (pert) into v_pert
                           FROM (SELECT TRUNC (100 * (TOTAL_MB - FREE_MB) / TOTAL_MB) pert
                    FROM v\\\$asm_diskgroup_stat
                   WHERE '+' || UPPER (NAME) IN (SELECT UPPER (VALUE)
                                                   FROM v\\\$parameter
                                                  WHERE NAME = 'db_recovery_file_dest')
                  UNION ALL
                  SELECT TRUNC (SUM (PERCENT_SPACE_USED)) pert
                    FROM v\\\$flash_recovery_area_usage) tt;


                 DBMS_OUTPUT.put_line (v_pert);
             ELSE

                 SELECT TRUNC (100 * (TOTAL_MB - FREE_MB) / TOTAL_MB) pert,
                        TRUNC (FREE_MB)                               free_mb
                   INTO v_pert, v_free
                   FROM v\\\$asm_diskgroup_stat
                  WHERE name IN (SELECT upper(ltrim(regexp_substr(DESTINATION,'[^/]+',1,1),'+'))
                                   FROM v\\\$archive_dest
                                  WHERE TARGET = 'PRIMARY' AND status in ('ERROR', 'VALID') and DESTINATION like '+%');

                 SELECT UPPER (ltrim(regexp_substr(DESTINATION,'[^/]+',1,1),'+'))
                   INTO v_diskgroup
                   FROM v\\\$archive_dest
                  WHERE TARGET = 'PRIMARY' AND  status in ('ERROR', 'VALID');

                 SELECT COUNT (*)
                   INTO v_number
                   FROM v\\\$datafile
                  WHERE name LIKE v_diskgroup || '%';

                 IF v_number > 0
                 THEN
                     IF v_pert > 80 AND v_pert < 90
                     THEN
                         DBMS_OUTPUT.put_line ('55');
                     ELSIF v_pert >= 90 AND v_pert < 95
                     THEN
                         DBMS_OUTPUT.put_line ('70');
                     ELSIF v_pert >= 95 AND v_free > 50 * 1024
                     THEN
                         DBMS_OUTPUT.put_line ('70');
                     ELSIF v_pert >= 95 AND v_free <= 50 * 1024
                     THEN
                         DBMS_OUTPUT.put_line ('95');
                     ELSE
                         DBMS_OUTPUT.put_line ('30');
                     END IF;
                 ELSE
                     DBMS_OUTPUT.put_line (v_pert);
                 END IF;
             END IF;
         END;
         /
         exit;
EOF`
fi
elif [ "${DB_ROLE}" = "PHYSICAL STANDBY" ];then
  Used=85;
  ARCHLOG_PATH=${DB_ROLE}
fi
}

rman_delete_archive() {
echo "_____**** ${ARCHLOG_PATH}  is $Used****______" >>${CHKLOG_FILE}

if [ $Used -gt 70 ]  && [  $Used -le 80 ]; then

        echo "_____***** rman exec delete noprompt archivelog all backed up 1 times to device type disk; ****______" >>${CHKLOG_FILE}
        rman target / msglog ${CHKLOG_FILE}  append <<EOF
        run {
        crosscheck archivelog all;
        delete noprompt archivelog all backed up 1 times to device type SBT_TAPE;
        }
EOF
elif [ $Used -gt 80 ] && [  $Used -le 95 ];  then

        echo "_____***** rman exec delete noprompt archivelog all; ****______" >>${CHKLOG_FILE}
        rman target / msglog ${CHKLOG_FILE} append<<EOF
        run {
        crosscheck archivelog all;
        delete noprompt archivelog all;
        }
EOF

elif [  $Used -gt 95 ];  then
        while [ $Used -gt 80 ]
        do
        echo "_____***** rman exec delete noprompt archivelog until time sysdate-${CHKNUM} ****______" >>${CHKLOG_FILE}
        rman target / msglog ${CHKLOG_FILE}  append<<EOF
        run {
        crosscheck archivelog all;
        delete noprompt  archivelog until time 'sysdate-${CHKNUM}';
        }
EOF
        if [ $CHKNUM -eq 1 ];then
        echo "_____***** rman exec delete noprompt archivelog all  force ****______" >>${CHKLOG_FILE}
        rman target / msglog ${CHKLOG_FILE}  append<<EOF
        run {
        crosscheck archivelog all;
        delete noprompt  force  archivelog all;
        }
EOF
        fi
        calculate_space_used;
        CHKNUM=`expr $CHKNUM - 1`;
        done

fi


  echo "_____**** ${CURRTIME} END   DELETE ****______" >>${CHKLOG_FILE}
}

calculate_space_used
rman_delete_archive