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

yum install maven -y &>>$LOGFILE

VALIDATE $? "Install Maven"

useradd roboshop &>>$LOGFILE

mkdir /app &>>$LOGFILE

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>$LOGFILE

VALIDATE $? "downloading shipping artifact"

cd /app &>>$LOGFILE

VALIDATE $? "moving to app directory"

unzip /tmp/shipping.zip &>>$LOGFILE

VALIDATE $? "Unzip shipping"

cd /app &>>$LOGFILE

VALIDATE $? "moving to app directory"

mvn clean package &>>$LOGFILE

VALIDATE $? "clean package"

mv target/shipping-1.0.jar shipping.jar &>>$LOGFILE

VALIDATE $? "rename  file"

cp shipping.service /etc/systemd/system/shipping.service &>>$LOGFILE

VALIDATE $? "copy shipping.service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "daemon reload"

systemctl enable shipping &>>$LOGFILE

VALIDATE $? "Enable shipping"

systemctl start shipping &>>$LOGFILE

VALIDATE $? "Start shipping"

yum install mysql -y &>>$LOGFILE

VALIDATE $? "Install mysql"

mysql -h mysql.preprv.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>$LOGFILE

VALIDATE $? "Load schema from mysql db"

systemctl restart shipping &>>$LOGFILE

VALIDATE $? "Restart Shipping"