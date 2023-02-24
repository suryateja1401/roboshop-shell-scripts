COMPONENT=rabbitmq
source common.sh
LOG_FILE=/tmp/${COMPONENT}

echo setup rabbitmq repo
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>$LOG_FILE
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG_FILE
statuscheck $?

echo install erlang
yum install erlang -y &>>$LOG_FILE
statuscheck $?

echo install rabbitmq
yum install rabbitmq-server -y &>>$LOG_FILE
statuscheck $?

echo start rabbitmq server
systemctl enable rabbitmq-server &>>$LOG_FILE
systemctl start rabbitmq-server &>>$LOG_FILE
statuscheck $?

echo Add Application user in rabbitmq
rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE
statuscheck $?

echo Add Application user tags in rabbitmq
rabbitmqctl set_user_tags roboshop administrator &>>$LOG_FILE
statuscheck $?

echo Add permissions for App user in rabbitmq
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE
statuscheck $?