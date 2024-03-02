#!/bin/bash

DATE=$(date +%F-%H-%M)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"
LOGDIR=/tmp
LOGFILE=$LOGDIR/$0-$DATE.log
USER_ID=$(id -u)

if [ $USER_ID -ne 0 ]
then
    echo -e "$R ERROR: Root access required to install the package $N"
    exit 1
fi

VALIDATE()
{
  if [ $1 -ne 0 ]
then 
    echo -e "$2  ........$R Failure $N"
    exit 1
else
    echo  -e "$2  ......$G Successful $N"
fi  
}

yum install nginx -y &>>$LOGFILE

VALIDATE $? "Install nginx"

systemctl enable nginx &>>$LOGFILE

VALIDATE $? "Enable nginx"

systemctl start nginx &>>$LOGFILE

VALIDATE $? "Start nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE

VALIDATE $? "Remove files"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$LOGFILE

VALIDATE $? "Downloading roboshop"

cd /usr/share/nginx/html &>>$LOGFILE

VALIDATE $? "moving html directory"

unzip /tmp/web.zip &>>$LOGFILE

VALIDATE $? "Unzip roboshop"

cp  /home/centos/roboshop-shell2/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$LOGFILE

VALIDATE $? "copy conf file"

systemctl restart nginx &>>$LOGFILE

VALIDATE $? "Restart nginx"

