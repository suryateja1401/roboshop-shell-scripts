LOG_FILE=/tmp/frontend

source common.sh

yum install nginx -y &>>$LOG_FILE
statuscheck $?

echo Downloading nginx web content
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
statuscheck $?

echo Redirecting to nginx folder
cd /usr/share/nginx/html &>>$LOG_FILE
statuscheck $?

echo Removing Old web content
 rm -rf * &>>$LOG_FILE
statuscheck $?

echo Extracting nginx web content
unzip /tmp/frontend.zip &>>$LOG_FILE
statuscheck $?

echo Renaming and moving files and folders
mv frontend-main/static/* . &>>$LOG_FILE
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
statuscheck $?

echo Starting nginx services
systemctl enable nginx &>>$LOG_FILE
systemctl restart nginx&>>$LOG_FILE
statuscheck $?