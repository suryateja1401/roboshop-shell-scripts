LOG_FILE=/tmp/user

source common.sh

echo create user repo
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
statuscheck $?

echo Installing Nodejs
yum install nodejs -y &>>${LOG_FILE}
statuscheck $?

id roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
    echo Adding Roboshop Application User
    useradd roboshop &>>${LOG_FILE}
  statuscheck $?
   fi

echo Downloading user Applicaton code
curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>${LOG_FILE}
statuscheck $?

cd /home/roboshop &>>${LOG_FILE}
echo Clean Old App Content
rm -rf user &>>${LOG_FILE}
statuscheck $?

echo Extracting user Application code
unzip -o /tmp/user.zip &>>${LOG_FILE}
statuscheck $?

mv user-main user &>>${LOG_FILE}
cd /home/roboshop/user &>>${LOG_FILE}

echo Installing Nodejs Dependencies
npm install &>>${LOG_FILE}
statuscheck $?

echo Setup user services
mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service &>>${LOG_FILE}
statuscheck $?

systemctl daemon-reload &>>${LOG_FILE}
systemctl enable user &>>${LOG_FILE}

echo start user services
systemctl start user &>>${LOG_FILE}
statusheck $?
