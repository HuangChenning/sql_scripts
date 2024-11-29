awk \
  'BEGIN {printf "%-30s %-10s %-10s %-10s\n","Name                          ","Target    ","State     ","Host   ";
          printf "%-30s %-10s %-10s %-10s\n","------------------------------","----------", "---------","-------";}'
crs_stat | awk \
'BEGIN { FS="=| ";state = 0;}
  $1~/NAME/ {appname = $2; state=1};
  state == 0 {next;}
  $1~/TARGET/ && state == 1 {apptarget = $2; state=2;}
  $1~/STATE/ && state == 2 {appstate = $2; apphost = $4; state=3;}
  state == 3 {printf "%-30s %-10s %-10s %-10s\n", appname,apptarget,appstate,apphost; state=0;}'
