if [ -f ~/.profile ] ;then
   . ~/.profile
else
   . ~/.bash_profile
fi
echo "beging delete archived "`date +'%Y%m%d %T'`

log_date=`date +'%H%M%S'`
log_file=/tmp/rman_delete_archive_${log_date}.out

rman target / msglog ${log_file} append <<EOF
delete noprompt archivelog until time 'sysdate-&minute/1440';
exit
EOF