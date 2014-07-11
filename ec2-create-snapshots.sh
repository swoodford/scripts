#!/bin/bash
# This script takes a snapshot of each EC2 volume that is tagged with Backup=1
# TODO: Convert from EC2 CLI to AWS CLI
# TODO: Add error handling and loop breaks


TOTALBACKUPVOLUMES=$(aws ec2 describe-volumes --filter Name=tag:Backup,Values="1" | grep Name | cut -f 3 | nl | wc -l)
# echo $TOTALBACKUPVOLUMES
START=1

for (( COUNT=$START; COUNT<=$TOTALBACKUPVOLUMES; COUNT++ ))
do
  echo "====================================================="
  echo \#$COUNT
  # DESCRIBEVOLUMES=$(aws ec2 describe-volumes --filter Name=tag:Backup,Values="1")
  # VOLUME=$(echo $DESCRIBEVOLUMES | cut -f 8 | nl | grep -w $COUNT | cut -f 2)
  VOLUME=$(aws ec2 describe-volumes --filter Name=tag:Backup,Values="1" | cut -f 9 | nl | grep -w $COUNT | cut -f 2)
  echo "Volume ID: "$VOLUME
  # NAME=$(echo $DESCRIBEVOLUMES | grep Name | cut -f 3 | nl | grep -w $COUNT | cut -f 2)
  NAME=$(aws ec2 describe-volumes --filter Name=tag:Backup,Values="1" | grep Name | cut -f 3 | nl | grep -w $COUNT | cut -f 2)
  echo "Volume Name: "$NAME
  # CLIENT=$(echo $DESCRIBEVOLUMES | grep Client | cut -f 3 | nl | grep -w $COUNT | cut -f 2)
  CLIENT=$(aws ec2 describe-volumes --filter Name=tag:Backup,Values="1" | grep Client | cut -f 3 | nl | grep -w $COUNT | cut -f 2)
  echo "Client: "$CLIENT
  DESCRIPTION=$NAME-$(date +%m-%d-%Y)
  echo "Snapshot Name: "$DESCRIPTION

  # TODO: Convert from EC2 CLI to AWS CLI
  SNAPSHOTRESULT=$(ec2-create-snapshot $VOLUME -d $DESCRIPTION)
  # echo $SNAPSHOTRESULT
  SNAPSHOTID=$(echo $SNAPSHOTRESULT | cut -c 10-23)
  echo "Snapshot ID: "$SNAPSHOTID
  #echo $SNAPSHOTID | grep -E "snap-........"
  # sleep 3

  # TODO: Convert from EC2 CLI to AWS CLI
  TAGRESULT=$(ec2-create-tags $SNAPSHOTID --tag Client=$CLIENT --tag Name=$NAME)

  # echo "Snapshot result is: "$SNAPSHOTRESULT
  # echo $TAGRESULT
  # echo "Snapshot ID is: "$SNAPSHOTID
  # echo "Tag Result is: "$TAGRESULT
done
echo "Completed! Total Snapshots Created:"$TOTALBACKUPVOLUMES
