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

DEFAULT_PASSWORD=$( sudo grep 'temporary password'  /var/log/mysqld.log |awk '{print $NF}')  &>>$LOG_FILE

echo "SET PASSWORD FOR 'root'@'localhost' =PASSWORD ('${ROBOSHOP_MYSQL_PASSWORD}');FLUSH PRIVILEGES;" >/tmp/root-pass.sql  &>>$LOG_FILE

echo "show databases;" |mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD}  &>>$LOG_FILE
if [ $? -ne 0 ];then
  echo Change the default root password
  mysql --connect-expired-password  -uroot -p"${DEFAULT_PASSWORD}" </tmp/root-pass.sql &>>$LOG_FILE
  statuscheck $?
fi

echo 'show plugins'| mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} 2>/dev/null | grep  validate_password &>>$LOG_FILE
if [ $? -eq 0 ]; then
  echo uninsall password validation plugin
  echo "uninstall plugin validate_password;" |mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} &>>$LOG_FILE
  statuscheck $?
fi

echo Download the schema
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"  &>>$LOG_FILE
statuscheck $?

echo extract schema
cd /tmp  &>>$LOG_FILE
unzip mysql.zip  &>>$LOG_FILE
statuscheck $?

echo Load schema
cd mysql-main  &>>$LOG_FILE
mysql -u root -p${ROBOSHOP_MYSQL_PASSWORD} <shipping.sql  &>>$LOG_FILE
statuscheck $?