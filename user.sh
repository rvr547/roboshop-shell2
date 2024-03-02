DATE=$(date +%F-%H-%M)
LOGDIR=/tmp
LOGFILE=$LOGDIR/$0-$DATE.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
USER_ID=$(id -u)

if [ $USER_ID != 0]
then
    echo -e "$R ERROR: Please use root access $N"
    exit 1
fi

VALIDATE()
{
    if [ $1 != 0 ]
    then
        echo -e "$G $2....FAILED $N"
        exit 1
    else
        echo -e "$G $2....SUCCESS $N"
    fi
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &<<$LOGFILE

VALIDATE $? "npm setup"

yum install nodejs -y &<<$LOGFILE

VALIDATE $? "Installing nodejs"

useradd roboshop

mkdir /app

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &<<$LOGFILE

VALIDATE $? "Downloading User"

cd /app &<<$LOGFILE

VALIDATE $? "Change to app directory"

npm install &<<$LOGFILE

VALIDATE $? "Installing dependencies"

cp user.service /etc/systemd/system/user.service &<<$LOGFILE

VALIDATE $? "Copy user.service"

systemctl daemon-reload &<<$LOGFILE

VALIDATE $? "daemon-reload"

systemctl enable user &<<$LOGFILE

VALIDATE $? "enable user"

systemctl start user &<<$LOGFILE

VALIDATE $? "start user"

cp mongo.repo /etc/yum.repos.d/mongo.repo &<<$LOGFILE

VALIDATE $? "copy mongo repo"

yum install mongodb-org-shell -y &<<$LOGFILE

VALIDATE $? "Install mongo db"

mongo --host mongodb.preprv.online </app/schema/user.js &<<$LOGFILE

VALIDATE $? "Load schema DB data"