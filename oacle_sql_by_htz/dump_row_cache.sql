PROMPT "    0x0001   Dump Statistics      "
PROMPT "    0x0002   Dump Bucket Summary      "
PROMPT "    0x0008   Dump Row Cache Objects      "
oradebug setmypid
oradebug unlimit
oradebug dump row_cache 10;
oradebug tracefile_name;
