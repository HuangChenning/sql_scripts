## --------------------------------------------------------------------------------
## --
## -- File name:   get_advanced_scn_info.sh
## -- Author:      zhangqiao
## -- Copyright:   zhangqiaoc@olm.com.cn
## --
## --------------------------------------------------------------------------------
runsql(){
sqlplus -silent "/as sysdba" <<EOF
set pagesize 0 feedback off verify off heading off echo off long 9999 linesize 130
$1
EOF
}
ALERTLOG=`runsql "SELECT /*+no_merge(DIR) no_merge(FILENAME)*/ VALUE || '/alert_' || INSTANCE_NAME || '.log'  FROM (SELECT VALUE FROM V\\$PARAMETER WHERE NAME = 'background_dump_dest') DIR,(SELECT INSTANCE_NAME FROM V\\$INSTANCE) FILENAME;"`
awk -v HOST=`hostname` -v SID=`echo $ORACLE_SID` '{
if($0 ~ /[A-Z][a-z][a-z] [A-Z][a-z][a-z] [0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]/){DATE=$0}
if($0 ~ /^Advanced SCN by /){
  MESS1=$0;MESS3=DATE;
  while(1<2){
    getline;
    if($0 ~ /^ Client info.*DB /){
      MESS2=$0;break;
    }else{
      MESS1=MESS1" "$0
    }#end if
  }#end while
}#end if
}#end main 
END{ 
sub("Advanced SCN by ","",MESS1);
sub(" minutes worth to ",",",MESS1);
sub(/ by remote .* \( *DESCRIPTION/,"(DESCRIPTION",MESS1);
sub(/ by .* DB:/,"",MESS1);
sub(/ by .*\./,"",MESS1);
sub(/\.$/,"",MESS1);
gsub(/\t/,"",MESS1);
gsub(/ /,"",MESS1);
sub(/ Client info.*DB logon user /,"",MESS2);
sub(", machine",",",MESS2);
sub(", program ",",",MESS2);
sub(", and OS user",",",MESS2);
gsub(/\t/,"",MESS2);
gsub(/ /,"",MESS2);
# x=split(MESS1,m,",");
y=split(MESS2,n,",");
# while (i <= x) {print i" "m[i]; i++;} 
# while (j <= y) {print j" "n[j]; j++;} 
ACTION=(n[3]~/oracle@.*\(TNS.*\)/||n[3]~/[Oo][Rr][Aa][Cc][Ll][Ee]\.[Ee][Xx][Ee]/?"ACCESSED":"ACCESS")
print HOST","SID","MESS3","MESS1","MESS2","ACTION
}' $ALERTLOG