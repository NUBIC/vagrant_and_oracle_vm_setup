export ORACLE_HOME="/u01/app/oracle/product/11.2.0/xe"

rm -rf dump/$1_test_dump.dmp
rm -rf dump/$1_test_dump.log
/u01/app/oracle/product/11.2.0/xe/bin/expdp $1/$2@localhost directory=import_dir schemas=$1 dumpfile=$1_test_dump.dmp logfile=$1_test_dump.log
/u01/app/oracle/product/11.2.0/xe/bin/impdp $1_test/$2@localhost directory=import_dir dumpfile=$1_test_dump.dmp logfile=$1_test_imp.log remap_schema=$1:$1_test content=metadata_only
