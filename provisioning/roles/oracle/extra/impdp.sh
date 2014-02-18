export ORACLE_HOME="/u01/app/oracle/product/11.2.0/xe"
/u01/app/oracle/product/11.2.0/xe/bin/impdp $1/$2@localhost full=Y directory=import_dir dumpfile=$1.dmp logfile=$1_imp.log remap_tablespace=$1:users remap_tablespace=temp1:temp remap_tablespace=$1_index:users

if [ "$1" == "cc_admin_holding" ]; then
  # cc_admin_holding has a weird tablespace. ಠ_ಠ
  /u01/app/oracle/product/11.2.0/xe/bin/impdp $1/$2@localhost full=Y directory=import_dir dumpfile=$1.dmp logfile=$1_imp.log remap_tablespace=cc_admin_storage:users remap_tablespace=temp:temp remap_tablespace=cc_admin_storage_index:users
else
  /u01/app/oracle/product/11.2.0/xe/bin/impdp $1/$2@localhost full=Y directory=import_dir dumpfile=$1.dmp logfile=$1_imp.log remap_tablespace=$1:users remap_tablespace=temp1:temp remap_tablespace=$1_index:users
fi
