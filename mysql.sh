L0G_FILE=/tmp/mysql

source common.sh
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG_FILE
# dnf module disable mysql  &>>$LOG_FILE
# yum install mysql-community-server -y  &>>$LOG_FILE
# systemctl enable mysqld  &>>$LOG_FILE
# systemctl start mysqld  &>>$LOG_FILE
# grep temp /var/log/mysqld.log  &>>$LOG_FILE
# mysql_secure_installation  &>>$LOG_FILE
# mysql -uroot -pRoboShop@1  &>>$LOG_FILE
# unin#install plugin validate_password  &>>$LOG_FILE
# curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"  &>>$LOG_FILE
# cd /tmp  &>>$LOG_FILE
# unzip mysql.zip  &>>$LOG_FILE
# cd mysql-main  &>>$LOG_FILE
# mysql -u root -pRoboShop@1 <shipping.sql  &>>$LOG_FILE