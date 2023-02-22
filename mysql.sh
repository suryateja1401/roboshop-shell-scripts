LOG_FILE=/tmp/mysql

source common.sh


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

DEFAULT_PASSWORD=$( grep  'temporary password'  /var/log/mysqld.log |awk '{print $NF}')
echo "SET PASSWORD FOR 'root''@'localhost' =PASSWORD('ROBOSHOP_MYSQL_PASSWORD'); FLUSH PREVILEGES;" >/tmp/root-pass.sql

echo "show databases"; |mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD}  &>>$LOG_FILE
if [$? -ne is 0];
then
  echo Change the default root password
  mysql --connect-expired-password mysql -uroot -p"${DEFAULT_PASSWORD}" </tmp/root-pass.sql &>>$LOG_FILE
  statuscheck $?
fi


# grep temp /var/log/mysqld.log  &>>$LOG_FILE
# mysql_secure_installation  &>>$LOG_FILE
# mysql -uroot -pRoboShop@1  &>>$LOG_FILE
# unin#install plugin validate_password  &>>$LOG_FILE
# curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"  &>>$LOG_FILE
# cd /tmp  &>>$LOG_FILE
# unzip mysql.zip  &>>$LOG_FILE
# cd mysql-main  &>>$LOG_FILE
# mysql -u root -pRoboShop@1 <shipping.sql  &>>$LOG_FILE