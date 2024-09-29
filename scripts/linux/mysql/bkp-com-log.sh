#!/bin/bash

# Variáveis
DATA=`date +%d-%B-%Y_%H-%M`
LOGDIR=/backup/log
LOG=$LOGDIR/dumps-$DATA.log
HOSTNAME=`hostname`
DUMPTEMPDIR=/backup/temp
SQLCREDFILE=/root/.sqlpwd
DUMPDIR=/backup/dump

echo "##############################################################################" > $LOG
echo >> $LOG
echo "Esse script fará um DUMP das bases de dados no servidor "$HOSTNAME >> $LOG
echo "Data de início do backup às $DATA" >> $LOG
echo >> $LOG
echo "##############################################################################" >> $LOG
echo >> $LOG
echo "Preprarativos para o backup" >> $LOG
echo >> $LOG
echo "Verifica se existe as pastas necessárias para o backup estão criadas" >> $LOG
echo >> $LOG

if [ ! -d $DUMPDIR ]; then
        mkdir -p $DUMPDIR
fi >> $LOG
if [ ! -d $LOGDIR ]; then
	mkdir -p $LOGDIR
fi >> $LOG
if [ ! -d $DUMPTEMPDIR ]; then
	mkdir -p $DUMPTEMPDIR
fi >> $LOG
echo >> $LOG
#echo "##############################################################################" >> $LOG
#echo >> $LOG
#echo "Verificando a integridade do Banco de Dados" >> $LOG
#echo >> $LOG
#mysqlcheck -e --user=$ADMMYSQL --password=$PASSMYSQL --auto-repair --all-databases >> $LOG 
# Arrumar, não aceita essa veriavél --defaults-exatra-file
#mysqlcheck -e --defaults-extra-file=$SQLCREDFILE --auto-repair --all-databases >> $LOG 
#echo >> $LOG
#echo "Checagem Finalizada!!! " >> $LOG
echo "##############################################################################" >> $LOG
#echo "Fazendo DUMP das Bases"  >> $LOG
echo >> $LOG
# Coletas as bases e faz uma lista
#mysql --user=$ADMMYSQL --password=$PASSMYSQL -N -e "SELECT SCHEMA_NAME FROM information_schema.SCHEMATA WHERE SCHEMA_NAME NOT IN ('mysql', 'performance_schema', 'information_schema', 'sys');" > $DUMPTEMPDIR/databases-$DATA.txt
mysql --defaults-extra-file=$SQLCREDFILE -N -e "SELECT SCHEMA_NAME FROM information_schema.SCHEMATA WHERE SCHEMA_NAME NOT IN ('mysql', 'performance_schema', 'information_schema', 'sys');" > $DUMPTEMPDIR/databases-$DATA.txt
cd $DUMPTEMPDIR
while read linha; do
	cd $DUMPTEMPDIR
	if [ ! -d "$DUMPDIR/$linha" ]; then
	mkdir -p $DUMPDIR/$linha
	fi >> $LOG
	#/usr/bin/mysqldump --user=$ADMMYSQL --password="$PASSMYSQL" -R -B $linha 2> /dev/null > $linha-$DATA.sql
	/usr/bin/mysqldump --defaults-extra-file=$SQLCREDFILE -R -B $linha > $linha-$DATA.sql
	# Armazenamento .tar
	/bin/tar -cf $linha-$DATA.tar $linha-$DATA.sql
	# Compressão GZIP
	/bin/gzip $linha-$DATA.tar
	######  CUIDADO - Compressão absurda com pbzip2
	######	/usr/bin/pbzip2 $linha-$DATA.tar
	# Move se a compactação é GZIP
	mv $linha-$DATA.tar.gz $DUMPDIR/$linha
	##### Move se a compactação for BZ2
	##### mv $linha-$DATA.tar.bz2 $DUMPDIR
	echo >> $LOG
	echo "Apaga os arquivos de backup com mais de 3 dias de existência" >> $LOG
	cd $DUMPDIR/$linha
	echo "Arquivos de backup na pasta: "$DUMPDIR/$linha >> $LOG
	ls $DUMPDIR/$linha >> $LOG
	echo >> $LOG
        for i in $(ls); do
	                a=`ls -t | wc -l`;
	                if [ $a -gt 3 ];then
	                        let a=a-3;
	                        for j in $(ls -t | tail -n $a);do
	                                /bin/rm $j
					echo "Removendo "$j
                        done >> $LOG
		echo >> $LOG
                fi >> $LOG
        done >> $LOG
done < databases-$DATA.txt
echo >> $LOG
echo "##############################################################################" >> $LOG
echo >> $LOG
echo "Dumps realizados" >> $LOG
echo >> $LOG
cat $DUMPTEMPDIR/databases-$DATA.txt >> $LOG
echo >> $LOG
echo "##############################################################################" >> $LOG
echo >> $LOG
echo "Limpa o diretório temporário" >> $LOG
echo $DUMPTEMPDIR >> $LOG
cd $DUMPTEMPDIR
/bin/rm -v *$DATA.sql *$DATA.txt >> $LOG
echo >> $LOG
echo "Apaga os LOG's  de backup com mais de 7 dias de existencia" >> $LOG
echo >> $LOG
cd $LOGDIR
        for i in $(ls); do
                a=`ls -t | wc -l`;
                if [ $a -gt 7 ];then
                        let a=a-7;
                        for j in $(ls -t | tail -n $a);do
                                /bin/rm $j
				echo "Removido "$j
                        done >> $LOG
                fi >> $LOG
	cd $LOGDIR
        done >> $LOG

echo >> $LOG
echo "Backup Finalizado" >> $LOG
echo >> $LOG
echo "##############################################################################" >> $LOG
