#!/bin/bash
USERID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
LOGS_FOLDER="/var/log/shell-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1 )
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.log"

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 ... $R FAILURE"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS"
    fi
}

echo "script started executing at: $TIMESTAMP" &>>LOG_FILE_NAME
CHECK_ROOT(){

    if [ $USERID -ne 0 ]
    then 
        echo "ERROR:: you must have sudo access to execute this script"
        exit 1
    fi
}
echo "script started executing at: $TIMESTAMP" &>>LOG_FILE_NAME

CHECK_ROOT

dnf install mysql -y &>>LOG_FILE_NAME
VALIDATE $? "installing  MySQL"

systemctl enable mysqld &>>LOG_FILE_NAME
VALIDATE $? "enabling the MySQL"

systemctl start mysqld &>>LOG_FILE_NAME
VALIDATE $? "starting the MySQL"

mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATE $? "Settingup Root Password"