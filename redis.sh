LOG_FILE=/tmp/redis

source common.sh

echo Setting Yum repos for Redis
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>LOG_FILE
statuscheck $?

echo Enabling redis Yum Modules
dnf module enable redis:remi-6.2 -y &>>LOG_FILE
statuscheck $?

echo INstalling redis
yum install redis -y &>>LOG_FILE
statuscheck $?

echo Updating Listen ip address
sed -i -e 's/127.0.0.1/0.0.0.0' /etc/redis.conf /etc/redis/redis.conf
statuscheck $?

echo Start Redis
systemctl restart redis &>>LOG_FILE
statuscheck $?
