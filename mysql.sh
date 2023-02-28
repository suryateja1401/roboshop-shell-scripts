LOG_FILE=/tmp/mysql

source common.sh

if [ -z "${ROBOSHOP_MYSQL_PASSWORD}" ]; then
  echo -e "\e[31m ROBOSHOP_MYSQL_PASSWORD env variable is needed \e[0m"
  exit 1
    
fi


echo setting up Mysql Repo
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG_FILE
statuscheck $?

echo Disable Mysql default module  to enable Mysql 5.7 module
dnf module disable mysql -y  &>>$LOG_FILE
statuscheck $?

echo Install Mysql
yum install mysql-community-server -y  &>>$LOG_FILE
statuscheck $?

echo start mysql services
systemctl enable mysqld  &>>$LOG_FILE
systemctl restart mysqld  &>>$LOG_FILE
statuscheck $?

