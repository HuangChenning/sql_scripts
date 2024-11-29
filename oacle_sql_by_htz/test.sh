IP_ADDR=192.168.111.5
exec_cmd="'""ls -l $1/$2'"
echo $exec_cmd
ssh -l oracle $IP_ADDR `echo $exec_cmd`
