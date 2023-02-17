LOG_FILE=/tmp/mongobd

source common.sh

echo Setting MongoDb Repo
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
statuscheck $?

echo installing mongodb
yum install -y mongodb-org &>>$LOG_FILE
statuscheck $?

echo updating monodb LIsten address
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
statuscheck $?

echo starting mongodb
systemctl enable mongod &>>$LOG_FILE
systemctl start mongod &>>$LOG_FILE
statuscheck $?

echo Downloading Schema
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
statuscheck $?

cd /tmp
echo Extract Schema file
unzip mongodb.zip &>>$LOG_FILE
statuscheck $?

cd  mongodb-main

echo load catalogue schema file
mongo < catalogue.js &>>$LOG_FILE
statuscheck $?

echo load service schema file
mongo < users.js &>>$LOG_FILE
statuscheck $?
