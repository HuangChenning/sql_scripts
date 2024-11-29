set echo off
set lines 400 pages 100 verify off heading on serveroutput on  
PROMPT  "***************************************************************************"
PROMPT 	"session - Dump session group's event settings                              "
PROMPT 	"process - Dump process group's event settings                              "
PROMPT 	"system  - Dump system group's event settings(Ie the instance wide events)  "  
PROMPT  "***************************************************************************"
oradebug setmypid
oradebug eventdump &INPUT;

