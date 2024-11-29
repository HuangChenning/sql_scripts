echo -n "Enter your DB_NAME:"
read db_name
tar_name=`hostname`.`date +%Y%m%d%H%M%S`
echo -n "Enter your sid:"
read db_sid
echo -n "Enter your date(2013-07-10):"
read db_date
echo -n "Enter your catalog(/tmp)"
read catalog
cd $ORACLE_BASE/admin/`echo $db_name`/bdump/
grep "$db_date" $db_sid*|awk -F : '{print $1}'|sort -u|xargs tar -cvf $catalog/trace.`echo $tar_name`.tar
tar -cvf $catalog/alert_`echo $tar_name`.tar alert_`echo $db_sid`.log
gzip  $catalog/trace.`echo $tar_name`.tar
gzip $catalog/alert_`echo $tar_name`.tar

