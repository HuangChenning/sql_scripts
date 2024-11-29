rman target / nocatalog msglog /tmp/rman_backup.log append << EOF
RUN {
ALLOCATE CHANNEL ch00 TYPE DISK;
ALLOCATE CHANNEL ch01 TYPE DISK;
ALLOCATE CHANNEL ch02 TYPE DISK;
ALLOCATE CHANNEL ch03 TYPE DISK;
ALLOCATE CHANNEL ch04 TYPE DISK;
ALLOCATE CHANNEL ch05 TYPE DISK;
ALLOCATE CHANNEL ch06 TYPE DISK;
BACKUP
    SKIP INACCESSIBLE
    TAG hot_db_bk_level0
    FORMAT '/soft/rman/bk_%s_%p_%t'
    DATABASE;
    sql 'alter system archive log current';
BACKUP
 		FORMAT '/soft/rman/ar_%s_%p_%t'
 		ARCHIVELOG ALL DELETE INPUT;
BACKUP
    FORMAT '/soft/rman/sp_%s_%p_%t'
    SPFILE;
BACKUP
 		FORMAT '/soft/rman/con_%s_%p_%t'
 		CURRENT CONTROLFILE;
RELEASE CHANNEL ch00;
}
exit
EOF
