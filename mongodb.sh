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

cp /home/centos/roboshop-shell2/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "Copy mongo repo"

yum install mongodb-org -y &>>$LOGFILE

VALIDATE $? "Install moongodb"

systemctl enable mongod &>>$LOGFILE

VALIDATE $? "enable mongod "

systemctl start mongod &>>$LOGFILE

VALIDATE $? "start mongod"

sed -i 's/127.0.0.1/0.0.0.0' /etc/mongod.conf &>>$LOGFILE

VALIDATE $? "Allow all traffic"

systemctl restart mongod &>>$LOGFILE

VALIDATE $? "restart mongod"