#!/usr/bin/env bash

ACCOUNT=$2
DATE=`date +%Y-%m-%d-%Hh%M-%Z`

function get_volumes_sizes()
{
    echo $DATE
    echo "quantity,size(GB)"
    euca-describe-volumes --region "$ACCOUNT@" | grep VOLUM | awk '{print $3}' | sort | uniq -c | awk '{print $1","$2}'
}

function get_instances_count()
{
    echo $DATE
    echo "quantity,size(instance-type)"
    euca-describe-instances --region "$ACCOUNT@" | grep INST | grep running | awk '{print $9}' | sort | uniq -c | awk '{print $1","$2}'
}

function get_volume_gb()
{
    euca-describe-volumes --region "$ACCOUNT@" | grep VOLUM | awk '{sum += $3} END {print sum" GB"}'
}

function get_stacks_quantity()
{
    euform-describe-stacks --region "$ACCOUNT@" | grep STA | wc -l
}

case $1 in
    stacks_quantity)
	get_stacks_quantity
	;;
    volumes_gb)
	get_volume_gb
	;;
    volumes_sizes)
	get_volumes_sizes
	;;
    instances_count)
	get_instances_count
	;;
esac
