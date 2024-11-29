use strict;
use warnings;
use POSIX qw(strftime);
use Cwd;
use Getopt::Long qw(:config no_ignore_case);
use File::Copy;
use Sys::Hostname;
use Net::Ping;




our $wordDir=getcwd;
our $logDir=getcwd."/logs";
our $dateFormat=strftime "%Y%m%d%H%M%S", localtime;


###############
our $osType;
our $osRelease;
our $dbRelase;
our $isoPath;
our %hostList;
our $oracleInstallPath='/oracle';
our $osParameterList='fs.file-max = 6815744
kernel.sem = 10000  10240000 10000 1024
kernel.shmmni = 4096
kernel.shmall = 1073741824
kernel.shmmax = 751619276800
net.ipv4.ip_local_port_range = 9000 65500
net.core.rmem_default = 16777216
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.wmem_default = 16777216
fs.aio-max-nr = 6194304
vm.dirty_ratio=20
vm.dirty_background_ratio=3
vm.dirty_writeback_centisecs=100
vm.dirty_expire_centisecs=500
vm.swappiness=10
vm.min_free_kbytes=524288
kernel.randomize_va_space = 0
kernel.exec-shield = 0
net.core.netdev_max_backlog = 30000
net.core.somaxconn = 262144
net.core.netdev_budget = 600
net.ipv4.conf.all.rp_filter = 2
net.ipv4.conf.default.rp_filter = 2';
our %osParameterList;
###############
our $softwarePath;
our $oracleBase;
our $oracleOwner;
our $gridOwner;

#################

our $errorLog;
our $warrLog;
our $commandLog;
our $stepLog;
our $scriptDebug;

our $vipAddress;
our $userName;
our $userPassword;
our $hostList;
our $netMask=24;
our $targetHost;
our $hostPort=22;
#temp
our $ipList;

sub fileOpen
{
    unless (-e $logDir and -d $logDir){
        mkdir $logDir ||die("Failed mkdir $logDir and exits ,Error No :$!");
    }
    open $errorLog,">",getcwd."/logs/".$dateFormat.".err" || Die("Failed Open Error Logfle ,errpr $!\n");
    open $warrLog,">",getcwd."/logs/".$dateFormat.".warr" || Die("Failed Open Warring Logfle ,errpr $!\n");
    open $commandLog,">",getcwd."/logs/".$dateFormat.".command" || Die("Failed Open Command Logfle ,errpr $!\n");
    open $stepLog,">",getcwd."/logs/".$dateFormat.".step" || Die("Failed Open Command Logfle ,errpr $!\n");
}

sub printLog{
  my ($type,$msg,$step) = @_;
  my $date=strftime "%Y%m%d%H%M%S", localtime;
  if ($type eq "E"){
     if ($errorLog){
         printf $commandLog "%14s:%15s: %s\n",$date,"INFO",$msg;
         printf $errorLog "%14s:%15s: %s\n",$date,"ERROR",$msg;
         printf "%14s:%15s: %s\n",$date,"ERROR",$msg;
         exit;
      }
   }
   elsif ($type eq "W") {
     if ($warrLog){
         printf $warrLog "%14s:%15s: %s\n",$date,"WARRING",$msg;
     }
   }
   elsif ($type eq "I") {
     if ($warrLog){
         printf $commandLog "%14s:%15s: %s\n",$date,"INFO",$msg;
     }
   }
   elsif ($type eq "D") {
         printf $commandLog "%14s:%15s: %s\n",$date,"INFO",$msg;
         printf "%14s:%15s: %s\n",$date,"INFO",$msg;

    }
}

sub parseArgv{
    my ($hostlist,$softwarepath,$oracleowner,$oraclebase,$gridowner,$help,$debug);
    &usage if ($#ARGV<0);
    GetOptions(
               'l|hostlist=s'    =>\$hostlist,
               'h|help:i'        =>\$help,
               's|softpath=s'    =>\$softwarepath,
               'o|oracleowner=s' =>\$oracleowner,
               'b|oraclebase=s'  =>\$oraclebase,
               'g|gridowner=s'   =>\$gridowner,
               'd|debug:i'       =>\$debug,
               );
    &usage if (defined $help);

    if(defined $hostlist){
             %hostList=map {if (/:/){
                              if (/(.+):(.*)/)
                                  {
                                    printLog("D","    User Input Argv:$1=$2");
                                    $1,$2
                                  }
                                }
                             else {
                                     printLog("D","    User Input Argv:$_=");
                                     $_,''
                                  }
                                } split /,/,$hostlist;
    }
    else{
        my $hostname=hostname;
        $hostList{$hostname}='';
        printLog("D","Default Input Argv:\%hostList=$hostname");
    }
    if (not defined $oraclebase){
        $oracleBase='/oracle';
        printLog("D","Default  Input Argv:\$oracleBase=$oracleBase");
    }
    elsif (defined $oraclebase){
       if (/^\//){
        $oracleBase=$oraclebase;
        printLog("D","   User  Input Argv:\$oracleBase=$oracleBase");
       }
       else {&usage};
   }
   if (not defined $softwarepath){
       $softwarePath=$oracleBase."/".'soft';
       printLog("D","Default  Input Argv:\$softwarePath=$softwarePath");
   }
   elsif (defined $softwarepath){
     if ($softwarepath=~/^\//){
        $softwarePath=$softwarepath;
        printLog("D","   User  Input Argv:\$softwarePath=$softwarePath");
        }
    }
   if (not defined $oracleowner){
       $oracleOwner='oracle';
       printLog("D","Default  Input Argv:\$oracleOwner=$oracleOwner");
   }
   else
   {
        $oracleOwner=$oracleowner;
        printLog("D","   User  Input Argv:\$oracleOwner=$oracleOwner");
   }
   if (not defined $gridowner){
       $gridOwner='grid';
       printLog("D","Default  Input Argv:\$gridgridOwnerowner=$gridOwner");
   }
   else
   {
        $gridOwner=$gridowner;
        printLog("D","   User  Input Argv:\$gridOwner=$gridOwner");
   }
  if (not defined $debug){
        $scriptDebug='0';
        printLog("D","Default  Input Argv:\$scriptDebug=$scriptDebug");
    }
  else{
      $scriptDebug='1';
      printLog("D","   User  Input Argv:\$scriptDebug=$scriptDebug");
  }
}


sub usage{
        print "configos.pl -l hostname:permanent ip,hostname:permanent ip \n";
        print "            -l           hostname:permanent ip,hostname:permanent ip\n";
        print "            -s           software path\n";
        print "            -o           oracle owner\n";
        exit 0;
}

sub checkOsType{
    my $ostype=$^O;
    if ($ostype eq 'linux'){
      $osType='Linux';
      my $commandresult=executeOsCommand("uname -r","1");
      if ($commandresult=~/2.6.32/){
         $osRelease=6;
      }
      elsif ($commandresult=~/el7/){
         $osRelease=7;
      }
    }
    printLog("D","Os Type :$osType");
    printLog("D","Os Release :$osRelease");

}

sub trim{
  my $string = $_[0];
  $string =~ s/^\s+//;
  $string =~ s/\s+$//;
  return $string;
}

sub trimExtraSpace{
  my $string = $_[0];
  $string =~ s/\s+/ /g;
  return $string;
}
sub checkIp{
     my $address=shift;
     if ($address=~/((25[0-5])|(2[0-4]\d)|(1\d\d)|([1-9]\d)|\d)(\.((25[0-5])|(2[0-4]\d)|(1\d\d)|([1-9]\d)|\d)){3}/){
       return "ok";
     }
     else{
      return "failed";
     }
}

sub checkServerPing {
  (my $server)=shift;
  my $temp1=Net::Ping->new();
              if ($temp1->ping($server)){
                  $temp1->close();
                  return 'ok';
              }
              else{
                 return 'failed';
              }
}

sub checkServerPort {
     printLog("D","Begin Execute :checkServerPort");
     printLog("E","checkServerPort: The Number Of Parameter Is Invalid,Must Input 2 Parameter,Current is :@_") if (@_ !=2);
     (my $server, my $port) = @_;
     my $sock = IO::Socket::INET->new(PeerAddr => $server,PeerPort => $port,Proto => 'tcp',Timeout=>4);
     if ( defined($sock) ){
         printLog("I","Check Server--->$server and Port--->$port Is Ok");
         return "ok";
    }
    else {
         printLog("I","Check Server--->$server and Port--->$port Is Failed");
         return "failed";
    }
}

sub checkVipConfig{
     printLog("D","Begin Execute :checkVipConfig");
     printLog("E","checkVipConfig: The Number Of Parameter Is Invalid,Must Input 2 Parameter,Current is :@_") if (@_ !=2);
     my ($address,$port)=@_;
     if (checkServerPort("$address","$port") eq 'ok' or checkServerPing("$address") eq 'ok'){
      return 'ok';
     }
     else{
      return 'failed';
     }
}

sub executeOsCommand{
    exit if (@_ eq 0);
    my ($command,$single)=@_;
    printLog("I","Exec Comamnd:$command");
    if (! open CMD,"$command 2>&1 |"){
        printLog("E","executeOsCommand : Exec Command Failed:$command");
    }
    else{
        my @output=<CMD>;
        close CMD;
        printLog("I","Result :@output");
        if (defined $single && $single eq '1'){
            return join(' ',@output);
        }
        esle{
            return @output;
      }
    }
}


sub executeOsCommandRoot{
    exit if (@_ != 2);
    my ($command,$username)=@_;
    printLog("I","Exec Comamnd:$command");
    my $result=`su - $username -c \"$command\"`;
    if (defined $result){
        chomp $result;
        printLog("I","Result :$result");
        return $result;
    }
    else{
        printLog("E","executeOsCommand : Exec Command Failed:$command");
    }
}

sub executeOsCommandSsh{
    my ($command,$username,$password,$remoteip,$hostport,$targetusername,$targetpassword)=@_;
    my $checkportresult=checkServerPort("$remoteip","$hostport");
    printLog("E","Host---->$remoteip and Port---->$hostPort Is Not Config ,So Exit") if ($checkportresult eq 'failed');
    my $execcommand=q^expect -c '
                         set timeout 1
                         spawn ssh -p ^.$hostport." ".$username.'@'.$remoteip.
                         q^
                         expect {
                                  "yes/no" { send "yes\r" ;exp_continue}
                                  "password:" { send "^.$password.q^\r";}
                                  }^;
    if (defined $targetusername and defined $targetpassword){
                         $execcommand=$execcommand.q^
                                 expect "$"
                                 send "su  - ^.$targetusername.q^\r"
                         expect "assword:"
                                 send "^.$targetpassword.q^\r"^;
    }
                         $execcommand=$execcommand.q^
                         expect "#"
                                 send "^.$command.q^\r"
                         expect "#"
                                  send "exit;\r"
                         expect eof
                         '^;
    my $result=executeOsCommand("$execcommand");
    if (defined $result){
      if ($result=~/Last login/){
            return $result;
        }
        else{
            printLog("E","executeOsCommandSsh Failed Command:$execcommand");
        }
    }
}

sub checkIpSameSubnet{
     printLog("E","CheckIpSameSubnet: The Number Of Parameter Is Invalid,Must Input 3 Parameter,Current is :@_") if (@_ !=3);
     (my $source,my $target,my $mask)=@_;
     if (substr(calculateIpBit($source),0,$mask) eq substr(calculateIpBit($target),0,$mask)){
     return "ok";
     }
     else{
         return "failed";
     }
}


sub calculateIpBit{
      my $ip=shift;
      my $checkip=checkIp($ip);
      if ($checkip eq 'ok'){
         return unpack("B32",pack("C4", (split/\./,$ip)));
       }
      else{
          printLog("D","$ip Is Not Valid Ip Address,Please Check;")
      }
}

sub analysisOsParameter{
  printLog("D","Begin Exec :analysisOsParameter");
  chomp $osParameterList;
  my @osparameter=split /\r?\n/, $osParameterList;
     foreach (@osparameter){
          chomp;
          if (/(.*)=(.*)/){
            printLog("I","Os Parameter :$1=$2");
            $osParameterList{trim($1)}=trimExtraSpace(trim($2));
          }
     }

}

sub checkOsParameter{
    printLog("D","Begin Exec :checkOsParameter");
    my $osparametername=shift @_;
    my $osparametervalue=executeOsCommand("sysctl -n $osparametername");
    return $osparametervalue;
}

sub generateFilename{
  my  @char=(0..9,'a'..'z','A'..'Z');
  my  $filename=join '',map {$char[int rand @char]} 0..9;
    return $filename;
}

sub generateOsParameterFile{
    printLog("D","Begin Exec :generateOsParameterFile");
    my $count=0;
    my $osparameterhash=shift @_;
    my $filename=generateFilename.'.sh';
    printLog("D","Generate Script FileName is :$filename") if ($scriptDebug==1);
    open FILENAME, '>',$filename;
    foreach (keys %$osparameterhash){
      my $tempvalue1=trimExtraSpace(trim(executeOsCommand("sysctl -n $_")));
      if (trim($tempvalue1) ne trim($$osparameterhash{$_})){
          printLog('D',"Os Paramete $_ Current value :$tempvalue1:Change Value :$$osparameterhash{$_}:");
          print FILENAME "echo \"$_=$$osparameterhash{$_}\">>/etc/sysctl.d/oracle.conf\n";
          $count=1;
      }
    }
     do {print FILENAME "sysctl -p /etc/sysctl.d/oracle.conf\n";
         close FILENAME;
         printLog("D","Exectue Sh :$filename For Modify Os Parameter");
         executeOsCommand("sh $filename");
         } if $count == 1;
      unlink $filename;
}


sub createOsUser{
    printLog("D","Begin Exec :createOsUser");
    my $count=0;
    my $filename=generateFilename.'.sh';
    printLog("D","Generate Script FileName is :$filename") if ($scriptDebug==1);
    my $password=generateFilename;
    printLog("D","User $oracleOwner And $gridOwner Password Is :$password");
    open FILENAME, '>',$filename;
    print FILENAME "/usr/sbin/groupadd -g 501 oinstall\n";
    print FILENAME "/usr/sbin/groupadd -g 501 oinstall\n";
    print FILENAME "/usr/sbin/groupadd -g 502 dba\n";
    print FILENAME "/usr/sbin/useradd -u 502 -g oinstall -G dba $oracleOwner  -m -s /bin/bash\n";
    print FILENAME "/usr/sbin/useradd -u 501 -g oinstall -G dba $gridOwner  -m -s /bin/bash\n";
    print FILENAME "echo \"$password\"|passwd $oracleOwner --stdin\n";
    print FILENAME "echo \"$password\"|passwd $gridOwner  --stdin\n";
    my @result=executeOsCommand("sh $filename");
    foreach (@result){
      if (/(not unique)|Unknown/){
         $count++;
         printLog("E","Create User and Group Failed ,Please Check $filename and passwd or group File");
        }
    }
    unless ($scriptDebug==1) {
       unlink $filename if $count ==0;
    }
}

sub disableOsSelinux{
    printLog("D","Begin Exec :disableOsSelinux");
    my $filename=generateFilename.'.sh';
    printLog("D","Generate Script FileName is :$filename") if ($scriptDebug==1);
    open FILENAME, '>',$filename;
    print FILENAME "sed -i 's/SELINUX\\=enforcing/SELINUX\\=disabled/g' /etc/selinux/config";
    my $result=executeOsCommand("sh $filename");
    unlink $filename unless ($scriptDebug==1);
    printLog("I","$result");
}

sub installOsSoftware{
    printLog("D","Begin Exec :installOsSoftware");
    my $count=1;
    my $filename=generateFilename.'.sh';
    printLog("D","Generate Script FileName is :$filename") if ($scriptDebug==1);
    open FILENAME, '>',$filename;
    print FILENAME "mount /dev/sr0 /media\n";
    close FILENAME;
    my @result=executeOsCommand("sh $filename");
    unlink $filename unless ($scriptDebug==1);
    my @temp=grep {/mounting read-only/} @result;
    if (@temp){
        printLog("D","Mount cdrom To /media :Success");
        unlink $filename unless ($scriptDebug==1);
    }
    elsif (defined $isoPath){
        open FILENAME, '>',$filename;
        print FILENAME "mount  –o loop $isoPath /media\n";
        close FILENAME;
        @result=executeOscommand("sh $filename");
        unlink $filename unless ($scriptDebug==1);
    }
    else{
      my $count=0;
      printLog("D","Mount Iso File And Cdrom Failed:");
    }
    if ($count == 1){
        $filename=generateFilename.'.sh';
        printLog("D","Generate Script FileName is :$filename") if ($scriptDebug==1);
        if ($osRelease == 6){
            open FILENAME, '>',$filename;
            print FILENAME "echo \"[HTZ]\n";
            print FILENAME "name = Enterprise Linux 6.6 DVD\n";
            print FILENAME "baseurl=file:///media/Server/\n";
            print FILENAME "gpgcheck=0\n";
            print FILENAME "enabled=1\">/etc/yum.repos.d/htz.repo\n";
            print FILENAME "yum -y install binutils compat-libstdc++-33 gcc gcc-c++ glibc glibc-common  glibc-devel ksh libaio libaio-devel --disablerepo=\\* --enablerepo=\"HTZ\"\n";
            print FILENAME "yum -y install libgcc libstdc++ libstdc++-devel make sysstat openssh-clients compat-libcap1   xorg-x11-utils  --disablerepo=\\* --enablerepo=\"HTZ\"\n";
            print FILENAME "yum -y groupinstall \"Chinese Support\"   --disablerepo=\\* --enablerepo=\"HTZ\"\n";
            print FILENAME "yum -y install lrzsz screen --disablerepo=\\* --enablerepo=\"HTZ\"\n";
            close FILENAME;
            executeOsCommand("sh $filename");
        }
        elsif ($osRelease == 7){
             open FILENAME, '>',$filename;
            print FILENAME "echo \"[HTZ]\n";
            print FILENAME "name = Enterprise Linux 7 DVD\n";
            print FILENAME "baseurl=file:///media\n";
            print FILENAME "gpgcheck=0\n";
            print FILENAME "enabled=1\">/etc/yum.repos.d/htz.repo\n";
            print FILENAME "yum -y install  binutils compat-libcap1 compat-libstdc++-33 e2fsprogs e2fsprogs-libs glibc glibc-devel ksh libX11 libXau libXi libXtst libaio libaio-devel libgcc libs libstdc++ libstdc++-devel libxcb make net-tools nfs-utils smartmontools sysstat gcc gcc-c++ --disablerepo=\\* --enablerepo=\"HTZ\"\n";
            print FILENAME "yum -y install unzip  sysstat setuptool telnet iotop openssh-clients net-tools unzip libvncserver tigervnc-server device-mapper-multipath dstat lsof ntp psmisc redhat-lsb-core parted xhost strace showmount expect tcl --disablerepo=\\* --enablerepo=\"HTZ\"\n";
            print FILENAME "yum -y groupinstall \"Chinese Support\" --disablerepo=\\* --enablerepo=\"HTZ\"\n";
            print FILENAME "yum -y install lrzsz screen --disablerepo=\\* --enablerepo=\"HTZ\"\n";
            close FILENAME;
            executeOsCommand("sh $filename");
        }

        unlink $filename unless ($scriptDebug==1);
    }
}

sub disableOsService{
    printLog("D","Begin Exec :disableOsService");
    my $filename=generateFilename.'.sh';
    printLog("D","Generate Script FileName is :$filename") if ($scriptDebug==1);
    open FILENAME, '>',$filename;
    if ($osRelease == 6){
      print FILENAME "chkconfig --level 2345 iptables off\n";
      print FILENAME "chkconfig --level 2345 rhnsd off\n";
      print FILENAME "chkconfig --level 2345 isdn off\n";
      print FILENAME "chkconfig --level 2345 avahi-daemon off\n";
      print FILENAME "chkconfig --level 2345 avahi-dnsconfd off\n";
      print FILENAME "chkconfig --level 2345 bluetooth off\n";
      print FILENAME "chkconfig --level 2345 hcid off\n";
      print FILENAME "chkconfig --level 2345 capi off\n";
      print FILENAME "chkconfig --level 2345 hidd off\n";
      print FILENAME "chkconfig --level 2345 irqbalance off\n";
      print FILENAME "chkconfig --level 2345 libvirtd off\n";
      print FILENAME "chkconfig --level 2345 libvirt-guests off\n";
      print FILENAME "chkconfig --level 2345 mcstrans off\n";
      print FILENAME "chkconfig --level 2345 pcscd off\n";
      print FILENAME "chkconfig --level 2345 gpm off\n";
      print FILENAME "chkconfig --level 2345 portmap off\n";
      print FILENAME "chkconfig --level 2345 rpcgssd off\n";
      print FILENAME "chkconfig --level 2345 rpcidmapd off\n";
      print FILENAME "chkconfig --level 2345 rpcsvcgssd off\n";
      print FILENAME "chkconfig --level 2345 sendmail off\n";
      print FILENAME "chkconfig --level 2345 xend off\n";
      print FILENAME "chkconfig --level 2345 cups off\n";
      print FILENAME "chkconfig --level 2345 iptables off\n";
      print FILENAME "chkconfig --level 2345 ip6tables off\n";
      print FILENAME "chkconfig --level 2345 blk-availability off\n";
      print FILENAME "chkconfig --level 2345 abrt-ccpp off\n";
      print FILENAME "chkconfig --level 2345 abrtd off\n";
      print FILENAME "chkconfig --level 2345 certmonger  off\n";
      print FILENAME "chkconfig --level 2345 cpuspeed off\n";
      print FILENAME "chkconfig --level 2345 irqbalance off\n";
      print FILENAME "chkconfig --level 2345 trace-cmd off\n";
      print FILENAME "chkconfig --level 2345 NetworkManager off\n";
      print FILENAME "chkconfig --level 2345 tuned off\n";
      print FILENAME "chkconfig --level 2345 ktune off\n";
    }
    elsif ($osRelease == 7){
      print FILENAME "systemctl stop    tuned.service ktune.service   firewalld.service postfix.service  avahi-daemon.socket avahi-daemon.service atd.service bluetooth.service wpa_supplicant.service accounts-daemon.service atd.service cups.service  postfix.service ModemManager.service debug-shell.service rtkit-daemon.service rpcbind.service rngd.service upower.service rhsmcertd.service  rtkit-daemon.service ModemManager.service mcelog.service colord.service gdm.service libstoragemgmt.service  ksmtuned.service brltty.service avahi-dnsconfd.service\n";
      print FILENAME "systemctl disable tuned.service ktune.service   firewalld.service postfix.service  avahi-daemon.socket avahi-daemon.service atd.service bluetooth.service wpa_supplicant.service accounts-daemon.service atd.service cups.service  postfix.service ModemManager.service debug-shell.service rtkit-daemon.service rpcbind.service rngd.service upower.service rhsmcertd.service  rtkit-daemon.service ModemManager.service mcelog.service colord.service gdm.service libstoragemgmt.service  ksmtuned.service brltty.service avahi-dnsconfd.service\n";
    }
     close FILENAME;
     executeOsCommand("sh $filename");
     unlink $filename unless ($scriptDebug==1);
}

sub configOsNtpProcess{
    printLog("D","Begin Exec :configOsNtpProcess");
    my $filename=generateFilename.'.sh';
    printLog("D","Generate Script FileName is :$filename") if ($scriptDebug==1);
    open FILENAME, '>',$filename;
    if ($osRelease eq '6'){
    print FILENAME "echo \"OPTIONS=\"-u ntp:ntp -p /var/run/ntpd.pid -g -x\"\" > /etc/sysconfig/ntpd \&\& /etc/init.d/ntpd restart";
    }
    elsif ($osRelease eq '7'){
     print FILENAME "sed -i 's/\"-g\"/\"-g -x\"/g' /etc/sysconfig/ntpd\n";
     print FILENAME "echo \"SYNC_HWCLOCK = yes\" >> /etc/sysconfig/ntpd\n";
     print FILENAME "systemctl restart  ntpd.service\n";
    }
    close FILENAME;
    executeOsCommand("sh $filename");
    unlink $filename unless ($scriptDebug==1);
}

sub configOsUlimit{
  printLog("D","Begin Exec :configOsulimit");
    my $filename=generateFilename.'.sh';
    printLog("D","Generate Script FileName is :$filename") if ($scriptDebug==1);
    open FILENAME, '>',$filename;
    print FILENAME "echo \"\n";
    print FILENAME "oracle  soft    nproc   655350\n";
    print FILENAME "oracle  hard    nproc   655350\n";
    print FILENAME "oracle  soft    nofile  655360\n";
    print FILENAME "oracle  hard    nofile  655360\n";
    print FILENAME "grid    soft    nproc   655350\n";
    print FILENAME "grid    hard    nproc   655350\n";
    print FILENAME "grid    soft    nofile  655360\n";
    print FILENAME "grid    hard    nofile  655360\n";
    print FILENAME "oracle  soft    stack  102400\n";
    print FILENAME "oracle  hard    stack  327680\n";
    print FILENAME "grid    soft    stack  102400\n";
    print FILENAME "grid    hard    stack  327680\n";
    print FILENAME "oracle  soft    memlock -1\n";
    print FILENAME "oracle  hard    memlock -1\n";
    print FILENAME "grid    soft    memlock -1\n";
    print FILENAME "grid    hard    memlock -1\n";
    print FILENAME "root    soft    memlock -1\n";
    print FILENAME "root    hard    memlock -1\" >>/etc/security/limits.conf\n";
    print FILENAME "echo \"\n";
    print FILENAME "if [ \$USER = \"oracle\" ] || [ \$USER = \"grid\" ] || [ \$USER = \"root\" ]; then\n";
    print FILENAME "        if  [ \$SHELL = \"/bin/ksh\" ];  then\n";
    print FILENAME "              ulimit -p 655350\n";
    print FILENAME "              ulimit -n 655350\n";
    print FILENAME "        else\n";
    print FILENAME "              ulimit -u 655350 -n 655350\n";
    print FILENAME "        fi\n";
    print FILENAME "fi\">>/etc/profile\n";
    if ($osRelease eq '6'){
      print FILENAME "sed -i 's/*          soft    nproc     1024/*          soft    nproc     655350/' /etc/security/limits.d/90-nproc.conf";
    }
    elsif ($osRelease eq '7'){
      print FILENAME "sed -i 's/*          soft    nproc     4096/*          soft    nproc     655350/' /etc/security/limits.d/20-nproc.conf";
    }
    close FILENAME;
    executeOsCommand("sh $filename");
    unlink $filename unless ($scriptDebug==1);
}


sub configUserEnv{
    printLog("D","Begin Exec :configUserEnv");
    my $filename=generateFilename.'.sh';
    printLog("D","Generate Script FileName is :$filename") if ($scriptDebug==1);
    open FILENAME, '>',$filename;
    print FILENAME "echo \"export PATH\n";
    print FILENAME "export ORACLE_BASE=/oracle/app/oracle\n";
    print FILENAME "export ORACLE_HOME=\\\$ORACLE_BASE/product/11.2.0/dbhome_1\n";
    print FILENAME "export ORACLE_SID=cisser1\n";
    print FILENAME "export PATH=\\\$ORACLE_HOME/bin:\$PATH\n";
    print FILENAME "export TNS_ADMIN=\\\$ORACLE_HOME/network/admin\n";
    print FILENAME "export LD_LIBRARY_PATH=\\\$ORACLE_HOME/lib:\\\$ORACLE_HOME/lib32:/lib/usr/lib:/usr/local/lib\n";
    print FILENAME "export TEMP=/tmp\n";
    print FILENAME "export TMP=/tmp\n";
    print FILENAME "export LC_ALL=en_US.UTF-8\n";
    print FILENAME "export LANG=en_US.UTF-8\n";
    print FILENAME "export NLS_OS_CHARSET=ZHS16GBK\n";
    print FILENAME "export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK\n";
    print FILENAME "set -o vi\n";
    print FILENAME "stty erase ^h\n";
    print FILENAME "umask 022\">>/home/oracle/.bash_profile\n";
    print FILENAME "echo \"export PATH\n";
    print FILENAME "export ORACLE_BASE=/oracle/app/grid\n";
    print FILENAME "export ORACLE_HOME=/oracle/app/11.2.0/grid\n";
    print FILENAME "export ORACLE_SID=+ASM1\n";
    print FILENAME "export PATH=\\\$ORACLE_HOME/bin:\$PATH\n";
    print FILENAME "export TNS_ADMIN=\\\$ORACLE_HOME/network/admin\n";
    print FILENAME "export LD_LIBRARY_PATH=\\\$ORACLE_HOME/lib:\\\$ORACLE_HOME/lib32:/lib/usr/lib:/usr/local/lib\n";
    print FILENAME "export TEMP=/tmp\n";
    print FILENAME "export TMP=/tmp\n";
    print FILENAME "export LC_ALL=en_US.UTF-8\n";
    print FILENAME "export LANG=en_US.UTF-8\n";
    print FILENAME "export NLS_OS_CHARSET=ZHS16GBK\n";
    print FILENAME "export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK\n";
    print FILENAME "set -o vi\n";
    print FILENAME "stty erase ^h\n";
    print FILENAME "umask 022\">>/home/grid/.bash_profile\n";
    close FILENAME;
    executeOsCommand("sh $filename");
    unlink $filename unless ($scriptDebug==1);
}

sub configOsHostName{
    printLog("D","Begin Exec :configOsHostName");
    my $hostname=shift @_;
    my $filename=generateFilename.'.sh';
    printLog("D","Generate Script FileName is :$filename") if ($scriptDebug==1);
    open FILENAME, '>',$filename;
    print FILENAME "hostname\n";
    close FILENAME;
    my $result=executeOsCommand("sh $filename","1");
    if ($result ne $hostname){
        open FILENAME, '>',$filename;
        if ($osRelease eq '6'){
        print FILENAME "sed -i '/HOSTNAME=/d' /etc/sysconfig/network \&\& echo \"HOSTNAME\=$hostname\" >>/etc/sysconfig/network \&\& hostname $hostname\n";
        }
        elsif ($osRelease ne '7'){
          print FILENAME "hostnamectl set-hostname $hostname\n";
        }
      close FILENAME;
      executeOsCommand("sh $filename");
      unlink $filename unless ($scriptDebug==1);
    }
}

sub checkOsLocalIp{
    my $hostname=hostname;
    if ($hostList{$hostname}){
    my $ethname=trim(executeOsCommand("ip r|grep default|awk '{print \$5}'","1"));
    my $ipaddr=trim(executeOsCommand(qq#ip addr show $ethname|grep "$ethname"|grep "inet"|awk '{print \$2}'|awk -F/ '{print \$1}'#,"1"));
    #my $ipaddr=executeOsCommand("ip addr show eth0|grep \"eth0\"|grep \"inet\"|awk '{print \$2}'|awk -F/ '{print \$1}'","1");
    $hostList{$hostname}=$ipaddr;
    }
}

sub configOshostFile{
    printLog("D","Begin Exec :configOshostFile");
    my $filename=generateFilename.'.sh';
    printLog("D","Generate Script FileName is :$filename") if ($scriptDebug==1);
    open FILENAME, '>',$filename;
    foreach my $key (keys %hostList){
      print FILENAME "echo \"$hostList{$key} $key \" >>/etc/hosts";
    }
    close FILENAME;
    executeOsCommand("sh $filename");
    unlink $filename unless ($scriptDebug==1);
}


fileOpen;
parseArgv;
checkOsType;
analysisOsParameter;
generateOsParameterFile(\%osParameterList);
createOsUser;
disableOsSelinux;
installOsSoftware;
disableOsService;
configOsNtpProcess;
configOsUlimit;
configUserEnv;
configOsHostName(keys %hostList);
checkOsLocalIp;
configOshostFile;
