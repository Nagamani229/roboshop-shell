#!/bin/bash

AMI="ami-0b4f379183e5706b9"
SG_ID="sg-0cd7597a2d7a778cd"
INSTANCES=("mongodb" "redis" "rabbitmq" "mysql" "shipping" "cart" "user" "catalogue" "payment" "dispatch" "web")

for i in "${INSTANCES[@]}"
do 
echo "instance is: $i"
  if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
  then
     INSTANCE_TYPE="t3.small"
  else
    INSTANCE_TYPE="t2.micro"
  fi

  aws ec2 run-instances --image-id ami-0b4f379183e5706b9 --instance-type $INSTANCE_TYPE --security-group-ids sg-0cd7597a2d7a778cd

done