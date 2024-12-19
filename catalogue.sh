#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGODB_HOST=mongodb.devopstraining.space

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script stareted executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1 # you can give other than 0
else
    echo "You are root user"
fi # fi means reverse of if, indicating condition end

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "Disabling current Nodejs"  

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "Enabling Nodejs:18"  

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "Installing Nodejs:18"  

useradd roboshop &>> $LOGFILE

VALIDATE $? "Creating roboshop user"  

mkdir /app &>> $LOGFILE

VALIDATE $? "creating app directory"  

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

VALIDATE $? " downloading catalogue application"  

cd /app 

unzip /tmp/catalogue.zip &>> $LOGFILE

VALIDATE $? " unzipping catalogue"  

npm install &>> $LOGFILE

VALIDATE $? " installing dependencies"  

#use absolute path,because catalogue.servcie exists there
cp /home/centos/roboshop-shell/catalogue.service //etc/systemd/system/catalogue.service &>> $LOGFILE

VALIDATE $? "Copying catalogue.service file"  

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "catalogue daemon reload"

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "Enable catalogue" 

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "Start catalogue" 

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo  &>> $LOGFILE

VALIDATE $? "Copying mongodb repo"  

dnf install mongodb-org-shell -y  &>> $LOGFILE

VALIDATE $? "installing mongodb client"  

mongo --host $MONGODB_HOST </app/schema/catalogue.js &>> $LOGFILE

VALIDATE $? "Loading catalogue data into mongodb" 
