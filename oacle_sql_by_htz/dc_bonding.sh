#!/bin/sh
#
# $Id: dc_bonding.sh,v 1.6 2009/10/20 14:46:33 rwen Exp $
#
# Data collection for bonding issues
#

run_cmd()
{
    local basecmd="${1%% *}"

    if type $basecmd >/dev/null 2>&1
    then
        echo "# $1"
        eval "$1"
    else
        echo "# command not exist: $basecmd"
    fi
}


dump_bonding_info()
{
    local DIR="$1/*"

    for i in `ls -1 $DIR`
    do
        run_cmd "cat $i" | sed 's/\x0//g'
    done
}

get_generic_info()
{
    run_cmd "date"
    run_cmd "uname -a"
}

get_static_info()
{
    run_cmd "cat /etc/modprobe.conf"

    for i in `ls -1 /etc/sysconfig/network-scripts/ifcfg*`
    do
        run_cmd "grep -vE '(^#.*|^$)' $i"
    done

    run_cmd "grep -vE '(^#.*|^$)' /etc/sysconfig/network"
    run_cmd "grep -vE '(;.*|^$)' /etc/resolv.conf"

    run_cmd "modinfo bonding"
}

get_runtime_info()
{
    # hw layer, including NIC, drivers
    run_cmd "lspci -v | sed -n '/Ethernet/, /^$/ p'"
    run_cmd "lsmod"

    # physical link
    for i in `get_if_list`
    do
        run_cmd "ethtool $i"
    done

    # bonding
    run_cmd "lsmod | grep bond"
    if [ -d /proc/net/bonding ]
    then
        run_cmd "cat /sys/class/net/bonding_masters"

        for i in `get_if_list | grep bond`
        do
            run_cmd "cat /proc/net/bonding/$i"
            dump_bonding_info "/sys/class/net/$i/bonding"
        done
    fi

    # interface
    run_cmd "ls -l /sys/class/net/"
    run_cmd "cat /proc/net/dev"
    run_cmd "ifconfig -a"
    run_cmd "ip link ls"
    run_cmd "ip addr ls"

    # IP layer
    run_cmd "ip route ls"
    run_cmd "route -n"
}

get_log_info()
{
    run_cmd "dmesg | grep -i bond"
    run_cmd "tail -n10000 /var/log/messages | grep -iE '(Linux version|bond)'"
}

get_if_list()
{
    sed -n '3,$ p' /proc/net/dev | cut -d: -f1
}

#
# main routine start HERE
#

get_generic_info

get_static_info

get_runtime_info

get_log_info

