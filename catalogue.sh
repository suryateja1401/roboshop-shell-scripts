LOG_FILE=/tmp/catalogue

echo Create catalogue repo
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE
if [ $? -eq 0 ]; then
  echo status Success
  else
    echo status Failure
    exit 1

fi
echo Installing Nodejs
yum install nodejs -y &>>$LOG_FILE
if [ $? -eq 0 ]; then
  echo status Success
  else
    echo status Failure
    exit 1

fi

echo Adding Roboshop Application User
useradd roboshop &>>$LOG_FILE
if [ $? -eq 0 ]; then
  echo status Success
  else
    echo status Failure
    exit 1

fi

echo Downloading Catalogue Applicaton code
curl -s -L -o  /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
if [ $? -eq 0 ]; then
  echo status Success
  else
    echo status Failure
    exit 1

fi
cd /home/roboshop &>>$LOG_FILE

echo Extracting Catalogue Application code
unzip /tmp/catalogue.zip &>>$LOG_FILE
if [ $? -eq 0 ]; then
  echo status Success
  else
    echo status Failure
    exit 1

fi

mv catalogue-main catalogue &>>$LOG_FILE
cd /home/roboshop/catalogue &>>$LOG_FILE

echo Installing Nodejs Dependencies
npm install &>>$LOG_FILE
if [ $? -eq 0 ]; then
  echo status Success
  else
    echo status Failure
    exit 1

fi

echo Setup catalogue services
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG_FILE
if [ $? -eq 0 ]; then
  echo status Success
  else
    echo status Failure
    exit 1

fi

echo start catalogue services
systemctl start catalogue &>>$LOG_FILE
systemctl enable catalogue &>>$LOG_FILE
if [ $? -eq 0 ]; then
  echo status Success
  else
    echo status Failure
    exit 1

fi
