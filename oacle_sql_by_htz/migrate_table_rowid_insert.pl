#!/usr/bin/perl
use strict;
use warnings;
use POSIX qw(strftime);

our $configtable    ='migrate_table';
our $configdbname   ='to_old';
our $configowner    ='system';
our $parallel       =10;
our @row;
our $DEBUG          = 0;

#########################################################################
##                                                                     ##
## Log and Debug Printer                                               ##
##                                                                     ##
#########################################################################
sub printlog{

    my $date = strftime "%Y-%m-%d %H:%M:%S", localtime;
    if (not defined $_[1]){
        printf STDOUT "%20s :              %s\n", $date, $_[0];
    }
    else{
        printf STDOUT "%20s :[%10s]  %s\n", $date, $_[1], $_[0];
    }
}

#########################################################################
##                                                                     ##
## Execute SQLs in Given String                                        ##
##                                                                     ##
#########################################################################
sub executesql{

    # Build SQL Scripts
    my $scriptsFile = '.sql_script.tmp';
    my $resultFile = '.sql_result.tmp';
    open SQLSCRIPTTEMP, ">", $scriptsFile;
    printf SQLSCRIPTTEMP "%s\n%s\n", "SET LINES 11111 PAGES 0 TRIM ON TRIMS ON TI OFF TIMI OFF AUTOT OFF FEED OFF SERVEROUTPUT ON SIZE UNLIMITED", "SPOOL $resultFile";
    printf SQLSCRIPTTEMP "%s\n", "$_[0]";
    printf SQLSCRIPTTEMP "%s\n%s\n%s\n", "SPOOL OFF", "COMMIT;", "EXIT";
    close SQLSCRIPTTEMP;

    if ( 1 == $DEBUG )
    {
        &printlog("SQL is :\n $_[0]", 'DEBUG');
    }
    # Execute SQL With SQL*Plus
    `sqlplus -s '/ as sysdba' \@$scriptsFile`;

    # Check Result File
    my $errcnt = 0;
    open SQLRESULTTEMP, "<", $resultFile;
    while (<SQLRESULTTEMP>){
        chomp;
        my $errorline = $_;
        if ($errorline =~ m/\AORA\-[0-9]{5}/){
            printlog("Error : [$errorline]");
            $errcnt ++;
        }
    }
    close SQLRESULTTEMP;

    return $errcnt;
}
#########################################################################
##                                                                     ##
## checklogfile                                                        ##
##                                                                     ##
#########################################################################
sub checklogfile{
    my $errcnt = 0;
    my $processstatus='.processstatus.log';
    open PROCESSROW,"<",$processstatus;
    while(<PROCESSROW>){
    next if /^s*$/;
    chomp;
    my $PROCESSLOG=$_;
    open SQLRESULTTEMP, "<",$PROCESSLOG;
    while (<SQLRESULTTEMP>){
        chomp;
        my $errorline = $_;
        if ($errorline =~ m/\AORA\-[0-9]{5}/){
            printlog("Error : [$errorline]");
            $errcnt ++;
        }
    }
    close SQLRESULTTEMP;
    }
    close PROCESSROW;
    return $errcnt;
}
#########################################################################
##                                                                     ##
## Read Data from Database by Given SQL String                         ##
##                                                                     ##
#########################################################################
sub readdb{

    # Build SQL Scripts
    my $scriptsFile = '.sql_script.tmp';
    my $resultFile = '.sql_result.tmp';
    open SQLSCRIPTTEMP, ">", $scriptsFile;
    printf SQLSCRIPTTEMP "%s\n%s\n", "SET LINES 11111 PAGES 0 TRIM ON TRIMS ON TI OFF TIMI OFF AUTOT OFF FEED OFF SERVEROUTPUT ON SIZE UNLIMITED", "SPOOL $resultFile";
    printf SQLSCRIPTTEMP "%s\n", "$_[0]";
    printf SQLSCRIPTTEMP "%s\n%s\n%s\n", "SPOOL OFF", "COMMIT;", "EXIT";
    close SQLSCRIPTTEMP;

    # Execute SQL With SQL*Plus
    `sqlplus -s '/ as sysdba' \@$scriptsFile`;

    # Check Result File
    my $errcnt = 0;
    open SQLRESULTTEMP, "<", $resultFile;
    while (<SQLRESULTTEMP>){
        chomp;
        my $errorline = $_;
        if ($errorline =~ m/\AORA\-[0-9]{5}/){
            printlog("Error : [$errorline]");
            $errcnt ++;
        }
    }
    close SQLRESULTTEMP;

    return -1 if $errcnt;

    my @ROWRESULT;
    open SQLRESULTTEMP, "<", $resultFile;
    while (<SQLRESULTTEMP>){
        chomp;
        push(@ROWRESULT,$_);
    }
    close SQLRESULTTEMP;
    return @ROWRESULT;
}




#########################################################################
##                                                                     ##
## gettablerowid                                                       ##
##                                                                     ##
#########################################################################
sub gettablerowid{

                &printlog('get table rowid info', 'Begin');
                my $rowidsql = '';
                $rowidsql =qq#set serveroutput on;
                 DECLARE
                 l_owner              VARCHAR2(30);
                 l_tablename          VARCHAR2(40);
                 l_table_sql_filename VARCHAR2(30);
                 l_sql                VARCHAR2(1000);
                 l_number             NUMBER := 10;
               BEGIN
                 FOR c_table IN (SELECT * FROM SYSTEM.migrate_table_big\@to_old) LOOP
                     FOR c_table_rowid IN (SELECT 'where rowid between ''' ||
                                                  sys.DBMS_ROWID.rowid_create(1,
                                                                              d.oid,
                                                                              c.fid1,
                                                                              c.bid1,
                                                                              0) ||
                                                  ''' and ''' ||
                                                  sys.DBMS_ROWID.rowid_create(1,
                                                                              d.oid,
                                                                              c.fid2,
                                                                              c.bid2,
                                                                              9999) || '''' || ' ;' as "TABLE_ROWID"
                                             FROM (SELECT DISTINCT b.rn,
                                                                   FIRST_VALUE(a.fid) OVER(PARTITION BY b.rn ORDER BY a.fid, a.bid ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) fid1,
                                                                   LAST_VALUE(a.fid) OVER(PARTITION BY b.rn ORDER BY a.fid, a.bid ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) fid2,
                                                                   FIRST_VALUE(DECODE(SIGN(range2 -
                                                                                           range1),
                                                                                      1,
                                                                                      a.bid +
                                                                                      ((b.rn -
                                                                                      a.range1) *
                                                                                      a.chunks1),
                                                                                      a.bid)) OVER(PARTITION BY b.rn ORDER BY a.fid, a.bid ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) bid1,
                                                                   LAST_VALUE(DECODE(SIGN(range2 -
                                                                                          range1),
                                                                                     1,
                                                                                     a.bid +
                                                                                     ((b.rn -
                                                                                     a.range1 + 1) *
                                                                                     a.chunks1) - 1,
                                                                                     (a.bid +
                                                                                     a.blocks - 1))) OVER(PARTITION BY b.rn ORDER BY a.fid, a.bid ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) bid2
                                                     FROM (SELECT fid,
                                                                  bid,
                                                                  blocks,
                                                                  chunks1,
                                                                  TRUNC((sum2 - blocks + 1 - 0.1) /
                                                                        chunks1) range1,
                                                                  TRUNC((sum2 - 0.1) /
                                                                        chunks1) range2
                                                             FROM (SELECT /*+ rule */
                                                                    relative_fno fid,¬l
                                                                    block_id bid,
                                                                    blocks,
                                                                    SUM(blocks) OVER() sum1,
                                                                    TRUNC((SUM(blocks) OVER()) /
                                                                          l_number) chunks1,
                                                                    SUM(blocks) OVER(ORDER BY relative_fno, block_id) sum2
                                                                     FROM dba_extents\@to_old
                                                                    WHERE segment_name =
                                                                          UPPER(c_table.table_name)
                                                                      AND OWNER =
                                                                          UPPER(c_table.owner))
                                                            WHERE sum1 > l_number) a,
                                                          (SELECT ROWNUM - 1 rn
                                                             FROM DUAL
                                                           CONNECT BY LEVEL <= l_number) b
                                                    WHERE b.rn BETWEEN a.range1 AND a.range2) c,
                                                  (SELECT MAX(data_object_id) oid
                                                     FROM dba_objects\@to_old
                                                    WHERE object_name =
                                                          UPPER(c_table.table_name)
                                                      AND OWNER = UPPER(c_table.owner)
                                                      AND data_object_id IS NOT NULL) d) LOOP
                       l_sql := 'insert into ' || c_table.owner||'.'||c_table.table_name||
                                ' select * from ' || c_table.owner || '.' ||
                                c_table.table_name || '\@to_old a ' ||
                                c_table_rowid.table_rowid;
                       DBMS_OUTPUT.put_line(l_sql);
                     END LOOP;
                 END LOOP;
               END;
               /#;
    @row=readdb($rowidsql);
    &printlog('get table rowid info', 'end');
}

#########################################################################
##                                                                     ##
## executemigrate                                                      ##
##                                                                     ##
#########################################################################
sub executemigrate{
                printlog('Execute Migrate Work', 'Begin');
                my $rowinfo;
                printlog('1,Make Execution Script');
    open EXECSCRIPT, '>', "./.executemigrate.sh";
    print EXECSCRIPT "TASKNO=\$1\n";
    print EXECSCRIPT "sqlplus '/ AS SYSDBA' <<EOF\n";
    print EXECSCRIPT "set echo on heading on time on timing on feedback on pages 10000;\n";
    print EXECSCRIPT "\$2\n";
    print EXECSCRIPT "COMMIT;\n";
    print EXECSCRIPT "EXIT\n";
    print EXECSCRIPT "EOF\n";
    print EXECSCRIPT "echo .processlog_\${TASKNO}.log >> .processstatus.log\n";
    close EXECSCRIPT;
    chmod 0755, "./.executemigrate.sh";
    `echo > .processstatus.log`;
    my $totalcount =0;
    my $count      =0;
    my $errorno    =0;
    foreach(@row) {
        $rowinfo =$_;
        $totalcount=$totalcount+1;
        $count=$count+1;
        printlog("$totalcount. Execution Script $totalcount",'EXEC');
        printlog("$rowinfo",'SQL');
        `nohup ./.executemigrate.sh $totalcount "$rowinfo">>.processlog_${totalcount}.log 2>&1 &`;
        while ($count >=30)
              {
                 sleep 10;
                 $count =0 + `ps -ef|grep executemigrate|grep -v grep | wc -l`;
                 exit 0 if checklogfile;
              }
        }
        exit 0 if checklogfile;
}
sub rmlogfile{
   my $filename='.process';
   my @file_name=<${filename}*.log>;
   if (@file_name >0)
   {
       foreach(@file_name)
       {
          printlog ("remove file :$_",'REMOVE');
          unlink $_;
       }
   }
}
rmlogfile;
gettablerowid;
executemigrate;