LOG_FILE=/tmp/user

source common.sh

echo create user repo
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE
statuscheck $?
# yum install nodejs -y &>>$LOG_FILE
useradd roboshop &>>$LOG_FILE
$ curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>$LOG_FILE
$ cd /home/roboshop &>>$LOG_FILE
$ unzip /tmp/user.zip &>>$LOG_FILE
$ mv user-main user &>>$LOG_FILE
$ cd /home/roboshop/user &>>$LOG_FILE
$ npm install &>>$LOG_FILE