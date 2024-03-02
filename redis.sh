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

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOGFILE

VALIDATE $? "npm install"

yum module enable redis:remi-6.2 -y &>>$LOGFILE

VALIDATE $? "Enable Redis 6.2"

yum install redis -y &>>$LOGFILE

VALIDATE $? "Install Redis"

sed i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf /etc/redis/redis.conf &>>$LOGFILE

VALIDATE $? "Allow all connections"

systemctl enable redis &>>$LOGFILE

VALIDATE $? "Enable redis"

systemctl start redis &>>$LOGFILE

VALIDATE $? "Start Redis"