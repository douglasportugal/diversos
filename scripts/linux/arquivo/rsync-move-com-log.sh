#!/bin/bash
#####################################
# Script feita por Douglas Portugal #
#####################################
# Variáveis
DATA=`date +%d-%B-%Y_%H-%M`
DIR=/path/work
LOGDIR=$DIR/log
LOG=$LOGDIR/rsync-$DATA.log
HOSTNAME=`hostname`
SRCDIR=/path/src
DSTDIR=/path/dst
TEMPDIR=$DIR/temp

echo "##############################################################################" > $LOG
echo >> $LOG
echo "Esse script fará uma cópia dos arquivos do DIR" >> $LOG
echo "Data de início da cópia às $DATA" >> $LOG
echo >> $LOG
echo "##############################################################################" >> $LOG
echo >> $LOG
cd $TEMPDIR
while read linha; do
	cd $TEMPDIR
	rsync -avzh --progress "$SRCDIR/$linha" $DSTDIR >> $LOG
done < $TEMPDIR/lista.txt
echo >> $LOG
echo "Data do fim da cópia às `date`" >> $LOG
echo "##############################################################################" >> $LOG
