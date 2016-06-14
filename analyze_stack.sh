#!/usr/bin/env bash

ACCOUNT=$1
DATE=`date +%Y%m%d-%H%M-%Z`

for STACK_NAME in `euform-describe-stacks --region "$ACCOUNT"@ | grep STA | awk '{print $2}'` ; do
    echo $STACK_NAME >> $DATE.csv
    echo "Instances" >> $DATE.csv
    echo "quantity,instance-type" >> $DATE.csv
    euca-describe-instances --region aimia@ | grep TAG | grep environment_name | grep $STACK_NAME | awk '{print $3}' | xargs -i -P10 euca-describe-instances {} --region aimia@ | \
	grep INST | grep running | awk '{print $9}' | sort | uniq -c | awk '{print $1","$2}' >> $DATE.csv

    echo "Volumes" >> $DATE.csv
    echo "quantity,size(GB)" >> $DATE.csv
    euca-describe-volumes --region aimia@ | grep TAG | grep stack-name | grep $STACK_NAME | awk '{print $3}' | xargs -i -P1 euca-describe-volumes --region aimia@ {} | grep VOL | awk '{print $3}' | sort | uniq -c | awk '{print $1","$2}' >> $DATE.csv
    echo
done
