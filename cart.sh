DATE=$(date +%F-%H-%M)
LOGDIR=/tmp
LOGFILE=$LOGDIR/$0-$DATE.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
USER_ID=$(id -u)

if [ $USER_ID != 0 ]
then
    echo -e "$R ERROR: Please use root access $N"
    exit 1
fi

VALIDATE()
{
    if [ $1 != 0 ]
    then
        echo -e "$R $2....FAILED $N"
        exit 1
    else
        echo -e "$G $2....SUCCESS $N"
    fi
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE

VALIDATE $? "Npm setup"

yum install nodejs -y &>> $LOGFILE

VALIDATE $? "Install nodejs"

useradd roboshop &>> $LOGFILE

mkdir /app &>> $LOGFILE

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOGFILE

VALIDATE $? "Download cart artifcat" 

cd /app &>> $LOGFILE

VALIDATE $? "chnage to app directory"

unzip /tmp/cart.zip &>> $LOGFILE

VALIDATE $? "unzip cart services"

npm install &>> $LOGFILE

VALIDATE $? "Installing dependencies"

cp cart.service /etc/systemd/system/cart.service &>> $LOGFILE

VALIDATE $? "copy cart.service"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "daemon-reload"

systemctl enable cart &>> $LOGFILE

VALIDATE $? "enable cart"

systemctl start cart &>> $LOGFILE

VALIDATE $? "Start cart services"



