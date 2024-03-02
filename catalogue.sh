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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $? "Node js repo"

yum install nodejs -y &>>$LOGFILE

VALIDATE $? "Install nodejs"

useradd roboshop &>>$LOGFILE

mkdir /app &>>$LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGFILE

VALIDATE $? "Download catalogue services"

cd /app &>>$LOGFILE

VALIDATE $? "chnage to app directory"

unzip /tmp/catalogue.zip

VALIDATE $? "unzip catalogue services"

npm install &>>$LOGFILE

VALIDATE $? "Installing dependencies"

cp /home/centos/roboshop-shell2/catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE

VALIDATE $? "copy catalogue services"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "daemon-reload"

systemctl enable catalogue &>>$LOGFILE

VALIDATE $? "enable catalogue"

systemctl start catalogue &>>$LOGFILE

VALIDATE $? "Start catalogue services"

cp /home/centos/roboshop-shell2/emongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "Copy mongo repo"

yum install mongodb-org-shell -y &>>$LOGFILE

VALIDATE $? "Install mongo shell"

mongo --host mongodb.preprv.online </app/schema/catalogue.js &>>$LOGFILE

VALIDATE $? "Load Schema data"

