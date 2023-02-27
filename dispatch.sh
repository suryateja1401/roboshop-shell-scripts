COMPONENT=dispatch

source common.sh

LOG_FILE=/tmp/${COMPONENT}

echo install golang
yum install golang -y &>>$LOG_FILE
statuscheck $?

