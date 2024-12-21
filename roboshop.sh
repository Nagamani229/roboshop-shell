#!/bin/bash

AMI=ami-0b4f379183e5706b9 #this keeps on changing
SG_ID=sg-0cd7597a2d7a778cd #replace with your SG ID
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")


for i in "${INSTANCES[@]}"
do
    if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    IP_ADDRESS=$(aws ec2 run-instances --image-id ami-0b4f379183e5706b9 --instance-type $INSTANCE_TYPE --security-group-ids sg-0cd7597a2d7a778cd --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'instances[0].PrivateIPAddress' --ouput text)
    echo "$i: $IP_ADDRESS"
done