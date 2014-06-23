#!/bin/bash
#This script takes a snapshot of each EC2 volume that is tagged with Backup=1

TOTALBACKUPVOLUMES=$(aws ec2 describe-volumes --filter Name=tag:Backup,Values="1" | grep Name | cut -f 3 | nl | wc -l)
START=1

for (( COUNT=$START; COUNT<=$TOTALBACKUPVOLUMES; COUNT++ ))
do
  echo \#$COUNT
  VOLUME=$(aws ec2 describe-volumes --filter Name=tag:Backup,Values="1" | cut -f 8 | nl | grep -w $COUNT | cut -f 2)
  NAME=$(aws ec2 describe-volumes --filter Name=tag:Backup,Values="1" | grep Name | cut -f 3 | nl | grep -w $COUNT | cut -f 2)
  DESCR=$NAME-$(date +%m-%d-%Y)
  ec2-create-snapshot $VOLUME -d $DESCR
  sleep 3
done
echo "Completed! Total Snapshots Created:"$TOTALBACKUPVOLUMES
