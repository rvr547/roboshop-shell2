#!/bib/bash
DATE=$(date +%F-%H-%M)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"
LOGDIR=/tmp
LOGFILE=$LOGDIR/$0-$DATE.log
USERID=$(id -u)
#USERROBO=$(id roboshop)

if [ $USERID -ne 0 ]
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

yum install python36 gcc python3-devel -y &>>$LOGFILE

VALIDATE $? "Installing Python"

useradd roboshop &>>$LOGFILE

mkdir /app &>>$LOGFILE

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>>$LOGFILE

VALIDATE $? "Downloading payment artifact"

cd /app &>>$LOGFILE

VALIDATE $? "Moving to App directory"

unzip /tmp/payment.zip &>>$LOGFILE

VALIDATE $? "Unziping payment.zip"

pip3.6 install -r requirements.txt &>>$LOGFILE

VALIDATE $? "Installing libraries"

cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service &>>$LOGFILE

VALIDATE $? "coping payment.service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "daemon-reload"

systemctl enable payment &>>$LOGFILE

VALIDATE $? "Enabling Payment"

systemctl start payment &>>$LOGFILE

VALIDATE $? "Starting payment"