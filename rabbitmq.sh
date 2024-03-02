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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$LOGFILE

VALIDATE $? "configure rebitt repos "

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOGFILE

VALIDATE $? "configure rabitmq server repo"

yum install rabbitmq-server -y &>>$LOGFILE

VALIDATE $? "Install rabitmq server"

systemctl enable rabbitmq-server &>>$LOGFILE

VALIDATE $? "Enable rabitmq server"

systemctl start rabbitmq-server &>>$LOGFILE

VALIDATE $? "Start rabitmq sever"

rabbitmqctl add_user roboshop roboshop123 &>>$LOGFILE

VALIDATE $? "Add default user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGFILE

VALIDATE $? "set permissions"

