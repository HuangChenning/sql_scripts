echo "For Database PSUs, enter the following command:"
$ORACLE_HOME/OPatch/opatch lsinventory -bugs_fixed | egrep -i 'PSU|DATABASE PATCH SET UPDATE'
echo "For CRS (Cluster Ready Services) PSUs, enter the following command:"
$ORA_CRS_HOME/OPatch/opatch lsinventory -bugs_fixed | grep -i 'TRACKING BUG' | grep -i 'PSU'
echo "For GI (Grid Infrastructure) PSUs, enter the following command:"
su - grid
$ORACLE_HOME/OPatch/opatch lsinventory -bugs_fixed | grep -i 'GRID INFRASTRUCTURE PATCH SET UPDATE'