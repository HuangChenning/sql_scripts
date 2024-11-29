find /dev -type b -maxdepth 2 -exec '/etc/init.d/oracleasm' 'querydisk' '{}' ';' 2>/dev/null | grep "is marked an ASM disk"
