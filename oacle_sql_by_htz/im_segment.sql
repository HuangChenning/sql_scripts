#!/bin/sh
sqlplus / as sysdba <<EOF
spool /home/oracle/enmo/script/log/utlrp.log
@?/rdbms/admin/utlrp.sql
spool off
spool /home/oracle/enmo/script/log/check.log
@/home/oracle/enmo/script/checkobject_new.sql
EOF
sqlplus / as sysdba <<EOF
spool /home/oracle/enmo/script/log/dataverfy.log
@/home/oracle/enmo/script/dataverfy.sql
exit;
EOF