#!/bin/bash

current_user=`whoami`
SCHEDULER_NAME=$1

lsscsi_value=`which lsscsi`
lsscsi_value_return=$?
if [ $current_user != 'root' ]
then
    echo 'please run as root'
elif [ -z $SCHEDULER_NAME ]
then
    echo 'Invalid SCHEDULER_NAME,Please run it as ./set_scheduler.sh deadline/noop/anticipatory/cfq '
elif [ $SCHEDULER_NAME != 'noop' ] && [ $SCHEDULER_NAME != 'anticipatory' ] && [ $SCHEDULER_NAME != 'deadline' ] && [ $SCHEDULER_NAME != 'cfq' ]
then
    echo 'Invalid SCHEDULER_NAME,Please run it as ./set_scheduler.sh deadline/noop/anticipatory/cfq '
elif [ $lsscsi_value_return -eq 1 ]
then
    echo 'lsscsi RPM package is not installed,please install it'
else
    for disk_name in `lsscsi |grep disk|cut -d'/' -f3`
    do
        #echo $disk_name
        if [ -f /sys/block/$disk_name/queue/scheduler ]
        then
            #echo ' scheduler exists'
            is_deadline=`cat /sys/block/$disk_name/queue/scheduler | grep "\[$SCHEDULER_NAME\]" |wc -l`
            if [ $is_deadline -eq 1 ]
            then
                echo $disk_name  "current is $SCHEDULER_NAME"
            else
                value_noop=`cat /sys/block/$disk_name/queue/scheduler|awk '{print $1}'|grep '\['|wc -l`
                value_anti=`cat /sys/block/$disk_name/queue/scheduler|awk '{print $2}'|grep '\['|wc -l`
                value_deadline=`cat /sys/block/$disk_name/queue/scheduler|awk '{print $3}'|grep '\['|wc -l`
                value_cfq=`cat /sys/block/$disk_name/queue/scheduler|awk '{print $4}'|grep '\['|wc -l`

                if [ $value_noop -eq 1 ]
                then
                    echo $disk_name  'current is noop'
                elif [ $value_anti -eq 1 ]
                then
                    echo $disk_name  'current is anticipatory' 
                elif [ $value_deadline -eq 1 ]
                then
                    echo  $disk_name  'current is deadline' 
                elif [ $value_cfq -eq 1 ]
                then
                    echo $disk_name 'current is cfq' 
                fi
                echo $SCHEDULER_NAME > /sys/block/$disk_name/queue/scheduler
            fi
        else
            echo 'scheduler not exists'
        fi
    done
fi
