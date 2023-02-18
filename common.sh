ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo You should execute code as root user or with sudo previlages
fi

statuscheck() {
  if [ $1 -eq 0 ]; then
    echo -e status = "\e[32mSuccess\e[0m"
    else
      echo -e status ="\e[31mFailure\e[0m"
      exit 1

  fi
}

NODEJS(){
  echo create Nodejs  repo
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

  echo Downloading {COMPONENT}Applicaton code
  curl -s -L -o /tmp/{COMPONENT}.zip "https://github.com/roboshop-devops-project/{COMPONENT}/archive/main.zip" &>>${LOG_FILE}
  statuscheck $?

  cd /home/roboshop &>>${LOG_FILE}
  echo Clean Old App Content
  rm -rf {COMPONENT} &>>${LOG_FILE}
  statuscheck $?

  echo Extracting {COMPONENT}Application code
  unzip -o /tmp/{COMPONENT}.zip &>>${LOG_FILE}
  statuscheck $?

  mv {COMPONENT}-main{COMPONENT} &>>${LOG_FILE}
  cd /home/roboshop/{COMPONENT} &>>${LOG_FILE}

  echo Installing Nodejs Dependencies
  npm install &>>${LOG_FILE}
  statuscheck $?

}