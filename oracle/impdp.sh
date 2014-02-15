export ORACLE_HOME="/u01/app/oracle/product/11.2.0/xe"
/u01/app/oracle/product/11.2.0/xe/bin/impdp $1/$2@localhost full=Y directory=import_dir dumpfile=$1.dmp logfile=$1_imp.log remap_tablespace=$1:users remap_tablespace=temp1:temp remap_tablespace=$1_index:users
