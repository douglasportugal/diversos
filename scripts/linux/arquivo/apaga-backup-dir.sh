#!/bin/bash

# Apaga os arquivos com mais de 3 dias de existência

bkpdir='/home/douglas/Documents/backup'

cd /tmp
$(ls $bkpdir > txtdir.txt)

while read linha; do
        cd $bkpdir/$linha
        a=`ls -t | wc -l`;
        if [ $a -gt 3 ];then
                let a=a-3;
                for j in $(ls -t | tail -n $a);do
                        rm -f $j

                done
        fi
done < txtdir.txt
