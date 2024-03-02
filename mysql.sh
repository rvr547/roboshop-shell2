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

yum module disable mysql -y &>>$LOGFILE

VALIDATE $? "disable mysql"

cp mysql.repo /etc/yum.repos.d/mysql.repo &>>$LOGFILE

VALIDATE $? "Copy mysql.repo"

yum install mysql-community-server -y &>>$LOGFILE

VALIDATE $? "Install mysql server"

systemctl enable mysqld &>>$LOGFILE

VALIDATE $? "enable mysqld"

systemctl start mysqld &>>$LOGFILE

VALIDATE $? "start mysqld"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOGFILE

VALIDATE $? "change password"

