
#/bin/ksh
echo "****The relevant files contained within this archive and status's associated with them " 
echo "****Automatic Storage Mgt ON=kfon.o                                                    " 
echo "****Automatic Storage Mgt OFF=kfoff.o                                                  " 
echo "****                                                                                   " 
echo "****Context Management Text ON=kciwcx.o                                                " 
echo "****<<CTX is always enabled and cannot be disabled.                                    " 
echo "****                                                                                   " 
echo "****Oracle Data Mining ON=dmwdm.o                                                      " 
echo "****Oracle Data Mining OFF=dmndm.o                                                     " 
echo "****                                                                                   " 
echo "****Oracle Database Vault ON=kzvidv.o                                                  " 
echo "****Oracle Database Vault OFF=kzvndv.o                                                 " 
echo "****                                                                                   " 
echo "****Oracle OLAP ON=xsyeolap.o                                                          " 
echo "****Oracle OLAP OFF=xsnoolap.o                                                         " 
echo "****                                                                                   " 
echo "****Oracle Label Security ON= kzlilbac.o                                               " 
echo "****Oracle Label Security OFF= kzlnlbac.o                                              " 
echo "****                                                                                   " 
echo "****Oracle Partitioning ON=kkpoban.o                                                   " 
echo "****Oracle Partitioning OFF=ksnkkpo.o                                                  " 
echo "****                                                                                   " 
echo "****Real Application Cluster ON=kcsm.o                                                 " 
echo "****Real Application Cluster OFF=ksnkcs.o                                              " 
echo "****                                                                                   " 
echo "****Oracle Real Application Testing ON=kecwr.o                                         " 
echo "****                                                                                   " 
echo "****Oracle Real Application Testing OFF=kecnr.o                                        " 
echo "***************************************************************************************"    
os_type=`uname -a|awk '{print $1}'`
if [ $os_type = 'AIX' ];then
echo "AIX SYSTEM"
ar -X64 -tv $ORACLE_HOME/rdbms/lib/libknlopt.a
else
ar -tv $ORACLE_HOME/rdbms/lib/libknlopt.a
fi
