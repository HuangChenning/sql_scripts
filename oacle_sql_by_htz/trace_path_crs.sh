#!/bin/bash
#-- 文件名 : trace_cd_crs.sh
#-- 描述 : 快速进入12C CRS进程的日志
#-- 使用 : sh ./trace_cd_crs.sh
#-- 作者 : 认真就输
#-- QQ : 7343696
adrci exec='show homepath'| awk '/diag\/crs/ {print  homepath"/"$1"/trace"}' homepath=$ORACLE_BASE