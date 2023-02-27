COMPONENT=dispatch

source common.sh

LOG_FILE=/tmp/${COMPONENT}

echo install golang
yum install golang -y &>>$LOG_FILE
statuscheck $?

APP_PREREQ

echo initialising golang
go mod init dispatch &>>$LOG_FILE
statuscheck $?

echo getting dependies of golang
go get &>>$LOG_FILE
statuscheck $?

echo build golang
go build &>>$LOG_FILE
statuscheck $?