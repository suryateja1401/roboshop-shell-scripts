LOG_FILE=/tmp/mongobd/
echo Setting MongoDb Repo
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>/tmp/mongobd
echo status $?

echo installing mongodb
yum install -y mongodb-org &>>LOG_FILE
echo status $?

echo updating monodb LIsten address
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
echo status $?

echo starting mongodb
systemctl enable mongod &>>LOG_FILE
systemctl start mongod &>>LOG_FILE
echo status $?