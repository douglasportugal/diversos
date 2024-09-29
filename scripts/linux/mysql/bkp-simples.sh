#!/bin/bash

# Variáveis
DATA=`date +%d-%B-%Y_%H-%M`
HOSTNAME=`hostname`
DUMPTEMPDIR=/tmp/zabbix
DUMPDIR=/home/douglas/Documents/backup/zabbix
SQLCREDFILE=/home/douglas/Documents/scripts/Linux/zabbix/.sqlpwd

if [ ! -d $DUMPTEMPDIR ]; then
	mkdir -p $DUMPTEMPDIR
fi

mysql --defaults-extra-file=$SQLCREDFILE -N -e "SELECT SCHEMA_NAME FROM information_schema.SCHEMATA WHERE SCHEMA_NAME NOT IN ('mysql', 'performance_schema', 'information_schema', 'sys');" > $DUMPTEMPDIR/databases-$DATA.txt
cd $DUMPTEMPDIR
while read linha; do
	cd $DUMPTEMPDIR
	/usr/bin/mysqldump --defaults-extra-file=$SQLCREDFILE -R -B --single-transaction --no-tablespaces $linha > $linha-$DATA.sql
	/bin/tar -cf $linha-$DATA.tar $linha-$DATA.sql
	/bin/gzip $linha-$DATA.tar
	mv $linha-$DATA.tar.gz $DUMPDIR
done < databases-$DATA.txt
cat $DUMPTEMPDIR/databases-$DATA.txt
cd $DUMPTEMPDIR
/bin/rm -v *$DATA.sql *$DATA.txt
