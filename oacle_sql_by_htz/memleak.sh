#!/bin/sh
until test 0 -eq 1
do
sqlplus /nolog <<END
connect / as sysdba
@ pga_2010script1.sql
END
sleep $1
done
