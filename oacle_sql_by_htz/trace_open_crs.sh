#!/bin/bash
#-- 文件名 : trace_open_crs.sh
#-- 描述 : 快速打开12C CRS进程的日志
#-- 使用 : sh ./trace_open_crs.sh ocssd
#-- 作者 : 认真就输
#-- QQ : 7343696
cd `adrci exec='show homepath'| awk '/diag\/crs/ {print  homepath"/"$1"/trace"}' homepath=$ORACLE_BASE` && tail -f &1.trc