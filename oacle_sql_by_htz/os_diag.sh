#!/bin/bash

echo
echo Diagnostics Collection Tool
echo

if [ $(/usr/bin/id -u) -ne 0 ]; then
    echo Must be executed as the root user
    exit 1
fi

VERSION=1.1

# OS specific locations
OSTYPE=`uname`
if [ "$OSTYPE" = 'SunOS' ] ; then
# Solaris Locations
    LOGLOCATION=/var/adm
    BIN=/usr/bin
    USRBIN=/usr/bin
    SBIN=/usr/sbin
    USRSBIN=/usr/sbin
    HOSTMGMTNAME=`$BIN/hostname | $BIN/awk '{FS = "."}; {print $1}'`
elif [[ "$OSTYPE" = 'Linux' ]]; then
# Linux Locations
    LOGLOCATION=/var/log
    BIN=/bin
    USRBIN=/usr/bin
    SBIN=/sbin
    USRSBIN=/usr/sbin
    USRLOCAL=/usr/local/bin
    HOSTMGMTNAME=`$BIN/hostname -s`
elif [[ "$OSTYPE" = 'AIX' ]]; then
# Mac os Locations
    LOGLOCATION=/var/adm
    BIN=/usr/bin
    USRBIN=/usr/bin
    SBIN=/usr/sbin
    USRSBIN=/usr/sbin
    USRLOCAL=/usr/local/bin
    HOSTMGMTNAME=`$BIN/hostname -s`
elif [[ "$OSTYPE" = 'Darwin' ]]; then
# Mac os Locations
    LOGLOCATION=/var/log
    BIN=/bin
    USRBIN=/usr/bin
    SBIN=/usr/sbin
    USRSBIN=/usr/sbin
    USRLOCAL=/usr/local/bin
    HOSTMGMTNAME=`$BIN/hostname -s`
else
  echo "This scritps don't support this os ${OSTYPE}"
  exit;
fi

## Output file setup
#
datestamp="`$BIN/date +%Y_%m_%d_%H_%M`"
outfile=osdiag_"$HOSTMGMTNAME"_"$datestamp"
outdir=/tmp/$outfile
$BIN/mkdir -p $outdir
pwd=`$BIN/pwd`
# save & restore stty settings in case interrupt is sent during snapshot password read where echo is turned off
stty_orig=`$BIN/stty -g`

## Cleanup Function
#
cleanup ()
{
      cd $pwd
      $BIN/rm -rf $outdir
      stty $stty_orig
      trap - INT TERM EXIT
}

## Usage Function
#
usage ()
{
      echo "Version: $VERSION"
      echo
      echo "Usage: $0 $options"
      echo "   osw      - Copy ExaWatcher or OSWatcher log files (Can be several 100MB's) "
      $BIN/rm -rf $outdir
      return $STATUS
}

trap "cleanup ; exit 2" INT TERM EXIT

cd $outdir

## Process Command-line Arguments
#
options="[osw] "
for arg in "$@"
do
  case "$arg" in
    -V|-version)
      echo "Version: $VERSION"
      echo
      cleanup
      exit 0
      ;;
    -h|-?|-help)
      usage
      cleanup
      exit 0
      ;;
    *)
      echo "ERROR Unknown option: $arg"
      echo
      usage
      cleanup
      exit 2
      ;;
  esac
done

## sundiag info
echo "VERSION= $VERSION" > $outdir/.version_sundiag
echo "CLI_OPTIONS= $@" >> $outdir/.version_sundiag
echo "RUNTIME= $datestamp" >> $outdir/.version_sundiag

## Node Configuration Information
#
$BIN/mkdir -p $outdir/messages
$BIN/mkdir -p $outdir/sysconfig
$BIN/mkdir -p $outdir/net
$BIN/mkdir -p $outdir/raid
$BIN/mkdir -p $outdir/version
$BIN/mkdir -p $outdir/cpu
$BIN/mkdir -p $outdir/memory
$BIN/mkdir -p $outdir/disk
$BIN/mkdir -p $outdir/vm
$BIN/mkdir -p $outdir/Kernel
$BIN/mkdir -p $outdir/perf

$USRBIN/uptime > $outdir/sysconfig/"uptime.out"

# OS Specific items
$BIN/uname -a > $outdir/sysconfig/"uname-a.out"
if [ $OSTYPE = 'SunOS' ] ; then
    #Solaris Version
    $BIN/last > $outdir/sysconfig/last-x.out
    $BIN/df -hl > $outdir/sysconfig/df-hl.out
    $SBIN/zfs list > $outdir/sysconfig/zfs_list.out
    $SBIN/prtdiag -v > $outdir/sysconfig/"prtdiag-v.out"
    $SBIN/prtconf -v > $outdir/sysconfig/"prtconf-v.out"
    $SBIN/swap -l > $outdir/sysconfig/"swap-l.out"
    $SBIN/format </dev/null > $outdir/raid/"format-l.out"
    $SBIN/zpool status -v > $outdir/raid/"zpool_status-v.out"
    $BIN/ps -ef > $outdir/sysconfig/"ps-ef.out"
    $BIN/pkg publisher > $outdir/sysconfig/"pkg-publisher.out"
    $BIN/pkg list > $outdir/sysconfig/"pkg-list.out"
    $BIN/svcs -a > $outdir/sysconfig/"svcs-a.out"
    $SBIN/ifconfig -a > $outdir/net/"ifconfig-a.out"
    $SBIN/ipadm show-if > $outdir/net/"ipadm_show-if.out"
    $SBIN/ipadm show-addr > $outdir/net/"ipadm_show-addr.out"
    $SBIN/ipadm show-ifprop > $outdir/net/"ipadm_show-ifprop.out"
    $SBIN/ipadm show-prop > $outdir/net/"ipadm_show-prop.out"
    $SBIN/dladm show-link > $outdir/net/"dladm_show-link.out"
    $SBIN/dladm show-linkprop > $outdir/net/"dladm_show-linkprop.out"
    $SBIN/dladm show-ether > $outdir/net/"dladm_show-ether.out"
    $SBIN/dladm show-phys > $outdir/net/"dladm_show-phys.out"
    $SBIN/dladm show-part > $outdir/net/"dladm_show-part.out"
    $SBIN/dladm show-ib > $outdir/net/"dladm_show-ib.out"
    $SBIN/dladm show-vlan > $outdir/net/"dladm_show-vlan.out"
    $SBIN/dladm show-bridge > $outdir/net/"dladm_show-bridge.out"
    $SBIN/dladm show-etherstub > $outdir/net/"dladm_show-etherstub.out"
    $SBIN/dladm show-vnic > $outdir/net/"dladm_show-vnic.out"
    $SBIN/dlstat > $outdir/net/"dlstat.out"
    $SBIN/dlstat -a > $outdir/net/"dlstat-a.out"
    $SBIN/dlstat -A > $outdir/net/"dlstat-A.out"
    $SBIN/dlstat show-phys > $outdir/net/"dlstat_show-phys.out"
    $SBIN/dlstat show-link > $outdir/net/"dlstat_show-link.out"
    $BIN/netstat -nr > $outdir/net/"netstat-nr.out"
    $SBIN/ipfstat -i > $outdir/net/"ipfstat-i.out" 2>> $outdir/sysconfig/"ipfstat-i.err"
    $SBIN/ipfstat -o > $outdir/net/"ipfstat-o.out" 2>> $outdir/sysconfig/"ipfstat-o.err"
    $BIN/cp -p /etc/release $outdir/sysconfig/"release_etc.out"
    $USRBIN/ipcs > $outdir/sysconfig/"ipcs.out"
    $BIN/cp -p $LOGLOCATION/messages* $outdir/messages
    $BIN/dmesg > $outdir/messages/dmesg
elif [[ "$OSTYPE" = 'Linux' ]]; then
   #Linux version
    echo Collection Os version
    #version
    $BIN/uname -a > $outdir/version/"version.out"
    $BIN/cp -p /etc/redhat-release $outdir/version/"release_etc.out"
    $BIN/cp -p /proc/version $outdir/version/"kernel_version.out"
    $USRBIN/lsb_release -a > $outdir/version/"lsb_release.out"
    #vm
    echo Collection Os VM
    $SBIN/swapon -s > $outdir/vm/"swapon-s.out"
    $BIN/cp -p /proc/swaps $outdir/vm/"swaps.out"
    #memory info
    echo Collection Os memory Information
    $BIN/cp -p /proc/meminfo $outdir/memory/
    $USRBIN/free > $outdir/memory/"free.out"
    #cpu info
    echo Collection Os CPU Information
    $BIN/cp -p /proc/cpuinfo $outdir/cpu/

    #Kernel
    echo Collection Os Kernel Information
    $SBIN/modprobe -l > $outdir/Kernel/"modprobe.out"
    $SBIN/lsmod > $outdir/Kernel/"lsmod.out"
    $BIN/cp -p /etc/sysconfig/kernel   $outdir/Kernel/
    $BIN/cp -p /etc/sysctl.conf  $outdir/Kernel/
    $SBIN/sysctl -a > $outdir/Kernel/"run_sysctl.out"

    #filesystem
    echo Collection Os filesystem Information
    $BIN/cp /etc/fstab $outdir/disk/fstab
    $BIN/df -hl > $outdir/disk/"df-hl.out"
    $BIN/mount > $outdir/disk/"mounts.out"
    $BIN/cat /proc/mounts > $outdir/disk/"proc_mounts.out"
    $SBIN/fdisk -l > $outdir/disk/"fdisk-l.out" 2>> $outdir/disk/"fdisk-l.err"
    { for PART in  /dev/sd* ; do  $SBIN/parted -s $PART print ; done ; } > $outdir/disk/"parted.out" 2>> $outdir/disk/"parted.err"

    #vg and lv
    $USRSBIN/pvdisplay > $outdir/disk/"pvdisplay.out"
    $USRSBIN/vgdisplay > $outdir/disk/"vgdisplay.out"
    $USRSBIN/lvdisplay > $outdir/disk/"lvdisplay.out"
    #pageage
    # Verifying installed rpms may take 3-4 minutes
    $BIN/rpm -qa --queryformat '%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}.rpm\n' | sort > $outdir/sysconfig/"rpm-qa.out"
    $BIN/rpm -qaV > $outdir/sysconfig/"rpm-qaV.out" 2>> $outdir/sysconfig/"rpm-qaV.err"

    #network
    echo Collection Os network Information
    $BIN/cp -p /etc/resolv.conf $outdir/net/resolv.conf
    $BIN/cp -p /etc/nsswitch.conf $outdir/net/nsswitch.conf
    $BIN/cp -p /etc/hosts $outdir/net/hosts
    $SBIN/ifconfig -a > $outdir/net/"ifconfig-a.out"
    $BIN/cp -p /etc/sysconfig/network $outdir/net/
    $BIN/cp -p /etc/sysconfig/network-scripts/ifcfg* $outdir/net/
    $BIN/netstat -nr > $outdir/net/"netstat-nr.out"
    $BIN/netstat -i > $outdir/net/"netstat-i.out"
    $BIN/mkdir -p $outdir/net/ethtool
    for ETH in `$SBIN/ifconfig -a | $BIN/grep eth | $BIN/awk ' {print $1} ' `; do
        $SBIN/ethtool $ETH > $outdir/net/ethtool/"ethtool_$ETH.out" 2>> $outdir/net/ethtool/"ethtool_$ETH.err"
          if [ ! -s $outdir/net/ethtool/"ethtool_$ETH.err" ]; then
              $BIN/rm -f $outdir/net/ethtool/"ethtool_$ETH.err"
          fi
          ethtool_options="-a -c -g -i -k -S"
          for ETHOPT in $ethtool_options ; do
             $SBIN/ethtool $ETHOPT $ETH > $outdir/net/ethtool/"ethtool$ETHOPT"_"$ETH.out" 2>> $outdir/net/ethtool/"ethtool$ETHOPT"_"$ETH.err"
             if [ ! -s $outdir/net/ethtool/"ethtool$ETHOPT"_"$ETH.err" ]; then
                $BIN/rm -f $outdir/net/ethtool/"ethtool$ETHOPT"_"$ETH.err"
             fi
          done
    done
    $SBIN/iptables-save > $outdir/net/"iptables.out"
    if [ -f $SBIN/ip6tables-save ] ; then
       $SBIN/ip6tables-save > $outdir/net/"ip6tables.out"
    fi
    echo Collection Os Configuration Information
    $BIN/ps aux > $outdir/perf/"ps-aux.out"
    $USRBIN/uptime > $outdir/perf/"uptime.out"
    $USRBIN/ipcs > $outdir/sysconfig/"ipcs.out"
    $USRBIN/vmstat 1 10 > $outdir/perf/"vmstat.out"
    $USRBIN/last -x > $outdir/sysconfig/"last-x.out"
    $SBIN/chkconfig --list > $outdir/sysconfig/"chkconfig-list.out"
    $SBIN/service --status-all > $outdir/sysconfig/"service_-status-all.out" 2>> $outdir/sysconfig/"service_-status-all.err"
    $SBIN/lspci > $outdir/sysconfig/"lspci.out"
    $SBIN/lspci -vvv > $outdir/sysconfig/"lspci-vvv.out" 2>> $outdir/sysconfig/"lspci-vvv.err"
    $SBIN/lspci -xxxx > $outdir/sysconfig/"lspci-xxxx.out" 2>> $outdir/sysconfig/"lspci-xxxx.err"
    $USRSBIN/dmidecode > $outdir/sysconfig/"dmidecode.out"
    $USRSBIN/biosdecode > $outdir/sysconfig/"biosdecode.out"
    $USRBIN/pstree -aApu > $outdir/sysconfig/"pstree-aApu.out"
    $BIN/cp -p /proc/cmdline $outdir/sysconfig/"kernel_cmdline.out"
    $BIN/cp -p /proc/modules $outdir/sysconfig/"kernel_modules.out"
    $BIN/cp -p /etc/security/limits.conf $outdir/sysconfig/
    echo Collection Os Log Information
    $BIN/cp -p $LOGLOCATION/messages* $outdir/messages
    $BIN/dmesg > $outdir/messages/dmesg

elif [[ "$OSTYPE" = 'AIX' ]]; then
   #Aix version
    echo Collection Os version
    #version
    $BIN/oslevel -r > $outdir/version/"version.out"
    $BIN/oslevel -s >> $outdir/version/"version.out"
    $SBIN/bootinfo -K >> $outdir/version/"version.out"
    $BIN/lslpp -l bos.64bit >> $outdir/version/"version.out"
    $BIN/genkex |grep 64 >> $outdir/version/"version.out"
    #vm
    echo Collection Os VM
    echo "-----------------------------------"  > $outdir/vm/"lsps.out"
    echo "lsps -a" >> $outdir/vm/"lsps.out"
    $SBIN/lsps -a  >> $outdir/vm/"lsps.out"
    echo "-----------------------------------"  >> $outdir/vm/"lsps.out"
    echo "lsps -s" >> $outdir/vm/"lsps.out"
    $SBIN/lsps -s  >> $outdir/vm/"lsps.out"
    #memory info
    echo Collection Os memory Information
    echo "-----------------------------------" > $outdir/memory/"memory.out"
    echo "vmo -L" > $outdir/memory/"memory.out"
    $SBIN/vmo -L >> $outdir/memory/"memory.out"
    echo "-----------------------------------" >> $outdir/memory/"memory.out"
    echo "vmstat -v" >>$outdir/memory/"memory.out"
    $BIN/vmstat -v >> $outdir/memory/"memory.out"
    echo "-----------------------------------" >> $outdir/memory/"memory.out"
    echo "lparstat -i ">> $outdir/memory/"memory.out"
    $BIN/lparstat -i >> $outdir/memory/"memory.out"
    echo "-----------------------------------" >> $outdir/memory/"memory.out"
    echo "svmon -G">> $outdir/memory/"memory.out"
    $BIN/svmon -G >> $outdir/memory/"memory.out"
    echo "-----------------------------------" >> $outdir/memory/"memory.out"
    echo "lsattr -E -l mem0">> $outdir/memory/"memory.out"
    $SBIN/lsattr -E -l mem0 >> $outdir/memory/"memory.out"
    echo "-----------------------------------" >> $outdir/memory/"memory.out"
    echo "lsattr -E -l sys0 -a realmem ">> $outdir/memory/"memory.out"
    $SBIN/lsattr -E -l sys0 -a realmem >> $outdir/memory/"memory.out"
    echo "-----------------------------------" >> $outdir/memory/"memory.out"
    echo "bootinfo -r">> $outdir/memory/"memory.out"
    $SBIN/bootinfo -r >> $outdir/memory/"memory.out"

    #cpu info
    echo Collection Os CPU Information
    echo "-----------------------------------" > $outdir/cpu/"cpuinfo.out"
    echo "lparstat -i" > $outdir/cpu/"cpuinfo.out"
    $BIN/lparstat -i >> $outdir/cpu/"cpuinfo.out"
    echo "-----------------------------------" >> $outdir/cpu/"cpuinfo.out"
    echo "pmcycles -m" >> $outdir/cpu/"cpuinfo.out"
    $BIN/pmcycles -m  >> $outdir/cpu/"cpuinfo.out"
    echo "-----------------------------------" >> $outdir/cpu/"cpuinfo.out"
    echo "lsattr -El proc0" >> $outdir/cpu/"cpuinfo.out"
    $SBIN/lsattr -El proc0  >> $outdir/cpu/"cpuinfo.out"
    echo "-----------------------------------" >> $outdir/cpu/"cpuinfo.out"
    echo "lscfg | grep proc " >> $outdir/cpu/"cpuinfo.out"
    $SBIN/lscfg | grep proc >> $outdir/cpu/"cpuinfo.out"
    echo "-----------------------------------" >> $outdir/cpu/"cpuinfo.out"
    echo "pstat -S" >> $outdir/cpu/"cpuinfo.out"
    $SBIN/pstat -S  >> $outdir/cpu/"cpuinfo.out"
    echo "-----------------------------------" >> $outdir/cpu/"cpuinfo.out"
    echo "mpstat" >> $outdir/cpu/"cpuinfo.out"
    $BIN/mpstat   >> $outdir/cpu/"cpuinfo.out"
    echo "-----------------------------------" >> $outdir/cpu/"cpuinfo.out"
    echo "lsdev -Cc processor" >> $outdir/cpu/"cpuinfo.out"
    $SBIN/lsdev -Cc processor  >> $outdir/cpu/"cpuinfo.out"

    #Kernel
    echo Collection Os Kernel Information
    echo "-----------------------------------" > $outdir/Kernel/"Kernel.out"
    echo "genkex" > $outdir/Kernel/"Kernel.out"
    $BIN/genkex >> $outdir/Kernel/"Kernel.out"
    echo "-----------------------------------" >> $outdir/Kernel/"Kernel.out"
    echo "vmo -a" >> $outdir/Kernel/"Kernel.out"
    $SBIN/vmo -a >> $outdir/Kernel/"Kernel.out"
    echo "-----------------------------------" >> $outdir/Kernel/"Kernel.out"
    echo "no -a" >> $outdir/Kernel/"Kernel.out"
    $SBIN/no -a >> $outdir/Kernel/"Kernel.out"
    echo "-----------------------------------" >> $outdir/Kernel/"Kernel.out"
    echo "ioo -a" >> $outdir/Kernel/"Kernel.out"
    $SBIN/ioo -a >> $outdir/Kernel/"Kernel.out"
    echo "-----------------------------------" >> $outdir/Kernel/"Kernel.out"
    echo "schedo -a" >> $outdir/Kernel/"Kernel.out"
    $SBIN/schedo -a >> $outdir/Kernel/"Kernel.out"
    echo "-----------------------------------" >> $outdir/Kernel/"Kernel.out"
    echo "lsattr -El sys0  -a" >> $outdir/Kernel/"Kernel.out"
    $SBIN/lsattr -El sys0 >> $outdir/Kernel/"Kernel.out"
    #filesystem
    echo Collection Os filesystem Information
    $BIN/cp /etc/filesystems $outdir/disk/filesystems
    $BIN/df -g > $outdir/disk/"df.out"
    $SBIN/mount > $outdir/disk/"mounts.out"
    $SBIN/lsdev -Cc disk > $outdir/disk/"lsdev-disk.out"
    $SBIN/lspv> $outdir/disk/"disk_info.out"
    for DISK in `$SBIN/lspv | $BIN/awk ' {print $1} ' `; do
        echo "--------------------------------" >> $outdir/disk/"disk_info.out"
        echo "Disk : $DISK Information" >> $outdir/disk/"disk_info.out"
        echo "--------------------------------" >> $outdir/disk/"disk_info.out"
        $SBIN/lspv -p $DISK >> $outdir/disk/"disk_info.out"
        $SBIN/lspv -l $DISK >> $outdir/disk/"disk_info.out"
    done
    #vg and lv
    $SBIN/lsvg> $outdir/disk/"vg_info.out"
    for VG in `$SBIN/lsvg | $BIN/awk ' {print $1} ' `; do
        echo "--------------------------------" >> $outdir/disk/"vg_info.out"
        echo "Vg : $VG Information" >> $outdir/disk/"vg_info.out"
        echo "--------------------------------" >> $outdir/disk/"vg_info.out"
        $SBIN/lsvg $VG >> $outdir/disk/"vg_info.out"
        $SBIN/lsvg -p $VG >> $outdir/disk/"vg_info.out"
        $SBIN/lsvg -l $VG >> $outdir/disk/"vg_info.out"
        for lv in `$SBIN/lsvg -l $VG | $BIN/awk ' {print $1} ' | grep -v $VG | grep -v LV`; do
          echo "--------------------------------" >> $outdir/disk/"vg_info.out"
          echo "lv : $lv Information" >> $outdir/disk/"vg_info.out"
          echo "--------------------------------" >> $outdir/disk/"vg_info.out"
          $SBIN/lslv -l $lv >> $outdir/disk/"vg_info.out"
          $SBIN/lslv $lv >> $outdir/disk/"vg_info.out"
        done
    done
    #pageage
    $BIN/lslpp -l > $outdir/sysconfig/"packages.out"

    #network
    echo Collection Os network Information
    if [ -f /etc/resolv.conf ] ; then
        $BIN/cp -p /etc/resolv.conf $outdir/net/resolv.conf
    fi
    if [ -f /etc/named.conf ] ; then
    $BIN/cp -p /etc/named.conf $outdir/net/named.conf
    fi
    $BIN/cp -p /etc/netsvc.conf $outdir/net/netsvc.conf
    $BIN/cp -p /etc/hosts $outdir/net/hosts
    $BIN/cp -p /etc/inetd.conf $outdir/net/inetd.conf
    $SBIN/lsdev -Cc adapter | grep ent > $outdir/net/"ent_adapter.out"
    $SBIN/lsdev -Cc if > $outdir/net/"ent_if.out"
    for ETH in `$SBIN/lsdev -Cc if | $BIN/awk ' {print $1} ' `; do
        $SBIN/lsattr -El $ETH > $outdir/net/"net_$ETH.out" 2>> $outdir/net/"net_$ETH.err"
        $SBIN/ifconfig $ETH >> $outdir/net/"net_$ETH.out"
        if [ "$ETH" != "lo0" ] ; then
            $BIN/entstat -d $ETH >> $outdir/net/"net_$ETH.out"
        fi
    done
    $SBIN/ifconfig -a > $outdir/net/"ifconfig.out"
    $BIN/netstat -nr > $outdir/net/"netstat-nr.out"
    $BIN/ps aux > $outdir/perf/"ps-aux.out"
    $BIN/uptime > $outdir/perf/"uptime.out"
    $BIN/ipcs > $outdir/perf/"ipcs.out"
    $BIN/vmstat 1 10 > $outdir/perf/"vmstat.out"
    $SBIN/prtconf >> $outdir/memory/"prtconf.out"
    $BIN/last > $outdir/sysconfig/"last-x.out"
    echo Collection Os Log Information
    $BIN/errpt > $outdir/messages/errpt.out
    $BIN/errpt -a > $outdir/messages/errpt_a.out
fi

# Package and clean up
#
echo Generating diagnostics tarball and removing temp directory
cd $outdir/..
$BIN/chmod -R a+r $outdir
$BIN/tar -cvf $outfile.tar $outfile > /dev/null
$BIN/gzip $outfile.tar
echo

echo "=============================================================================="
echo "Done. The report files are gzip compressed in `pwd`/$outfile.tar.gz"
echo "=============================================================================="
cleanup
exit 0
