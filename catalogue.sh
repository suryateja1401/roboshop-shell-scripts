LOG_FILE=/tmp/catalogue

echo Create catalogue repo
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>LOG_FILE
echo status $?

echo Installing Nodejs
yum install nodejs -y &>>LOG_FILE
echo status $?

echo Adding Roboshop Application User
useradd roboshop &>>LOG_FILE
echo status $?

echo Downloading Catalogue Applicaton code
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>LOG_FILE
echo status $?

cd /home/roboshop &>>LOG_FILE

echo Extracting Catalogue Application code
unzip /tmp/catalogue.zip &>>LOG_FILE
echo status $?

mv catalogue-main catalogue &>>LOG_FILE
cd /home/roboshop/catalogue &>>LOG_FILE

echo Installing Nodejs Dependencies
npm install &>>LOG_FILE
echo status $?

echo Setup catalogue services
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>LOG_FILE
echo status $?

echo start catalogue services
systemctl start catalogue &>>LOG_FILE
ystemctl enable catalogue &>>LOG_FILE
echo ststus $?
