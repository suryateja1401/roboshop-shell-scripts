LOG_FILE=/tmp/catalogue
ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo You should execute code as root user or with sudo previlages
fi

status check(){
  if [ $1 -eq 0 ]; then
    echo -e status = "\e[32mSuccess\e[0m"
    else
      echo -e status ="\e[31mFailure\e[0m"
      exit 1

  fi
}

echo Create catalogue repo
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE
status check $?

echo Installing Nodejs
yum install nodejs -y &>>$LOG_FILE
status check $?

id roboshop &>>$LOG_FILE
if [ $? -ne 0 ]; then
    echo Adding Roboshop Application User
    useradd roboshop &>>$LOG_FILE
  status check $?
   fi

echo Downloading Catalogue Applicaton code
curl -s -L -o  /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
status check $?

cd /home/roboshop
echo Clean Old App Content
rm -rf catalogue &>>$LOG_FILE
status check $?


echo Extracting Catalogue Application code
unzip /tmp/catalogue.zip &>>$LOG_FILE
status check $?

mv catalogue-main catalogue &>>$LOG_FILE
cd /home/roboshop/catalogue &>>$LOG_FILE

echo Installing Nodejs Dependencies
npm install &>>$LOG_FILE
status check $?

echo Setup catalogue services
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG_FILE
status check $?

echo start catalogue services
systemctl start catalogue &>>$LOG_FILE
systemctl enable catalogue &>>$LOG_FILE
status check $?
