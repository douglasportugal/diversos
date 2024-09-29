#!/bin/bash

# Douglas Portugal
DATA=`date +%d-%B-%Y_%H-%M`
DIR=/repo/www/html/repo
LOG=/RSM/repo/logs/sync-$DATA.log


echo "##############################################################################" > $LOG
echo >> $LOG
echo "Esse script fará sync dos repositórios" >> $LOG
echo "Data início: $DATA" >> $LOG
echo >> $LOG
echo "##############################################################################" >> $LOG
echo >> $LOG

# Lista dos diretórios
ls $DIR > /tmp/repos.txt
# Exclui repositórios que não precisam sincronia
cat /tmp/repos.txt | grep -v "redhat511-64" > /tmp/repos2.txt

while read LINHA; do
    echo >> $LOG
    echo >> $LOG
    echo "# $LINHA # " >> $LOG
    echo >> $LOG
    dnf reposync -p $DIR --newest-only --download-metadata --repoid=$LINHA >> $LOG
    echo >> $LOG
    echo "Criando repodata" >> $LOG
    createrepo -v $DIR/$LINHA >> $LOG
done < /tmp/repos2.txt

echo >> $LOG
echo "##############################################################################" >> $LOG
echo "Sincronismo finalizado" >> $LOG
echo "Data fim: $DATA" >> $LOG
echo >> $LOG
echo "##############################################################################" >> $LOG
