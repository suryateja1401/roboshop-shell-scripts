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

APP_PREREQ(){
  id roboshop &>>${LOG_FILE}
    if [ $? -ne 0 ]; then
        echo Adding Roboshop Application User
        useradd roboshop &>>${LOG_FILE}
      statuscheck $?
       fi

    echo Downloading ${COMPONENT}Applicaton code
    curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG_FILE}
    statuscheck $?

    cd /home/roboshop &>>${LOG_FILE}
    echo Clean Old App Content
    rm -rf ${COMPONENT} &>>${LOG_FILE}
    statuscheck $?

    echo Extracting ${COMPONENT} Application code
    unzip -o /tmp/${COMPONENT}.zip &>>${LOG_FILE}
    statuscheck $?

    mv ${COMPONENT}-main ${COMPONENT} &>>${LOG_FILE}

    cd /home/roboshop/${COMPONENT} &>>${LOG_FILE}

}

SYSTEMD_SETUP(){
  echo Update SystemD servicefile
    sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e  's/MONGO_DNSNAME/mongobd.roboshop.internal/'/home/roboshop/${COMPONENT}/systemd.service
    -e 's/CARTENDPOINT/catalogue.roboshop.internal'
    -e 's/DBHOST/mysql.roboshop.internal/'&>>${LOG_FILE}
    statuscheck $?

    echo Setup ${COMPONENT} services
    mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>${LOG_FILE}
    statuscheck $?

    systemctl daemon-reload &>>${LOG_FILE}
    systemctl enable ${COMPONENT} &>>${LOG_FILE}

    echo start  ${COMPONENT}services
    systemctl start ${COMPONENT} &>>${LOG_FILE}
    statuscheck $?


}

NODEJS(){
  echo create Nodejs  repo
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
  statuscheck $?

  echo Installing Nodejs
  yum install nodejs -y &>>${LOG_FILE}
  statuscheck $?

  APP_PREREQ

  echo Installing Nodejs Dependencies
  npm install &>>${LOG_FILE}
  statuscheck $?

  SYSTEMD_SETUP
}

JAVA(){
  echo Installing maven
  yum install maven -y &>>${LOG_FILE}
  statuscheck $?

  APP_PREREQ

  echo download dependies and make package
  mvn clean package &>>${LOG_FILE}
  mv target/shipping-1.0.jar shipping.jar &>>${LOG_FILE}
  statuscheck $?

  SYSTEMD_SETUP
}
PYTHON(){
  echo install python
  yum install python36 gcc python3-devel -y &>>$LOG_FILE
  statuscheck $?

  APP_PREREQ

  echo install python dependencies
  pip3 install -r requirements.txt  &>>$LOG_FILE
  statuscheck $?

  APP_UID=${id -u roboshop}
  APP_GID=${id -g roboshop}

  echo update payment configuration file
  sed -i -e "/uid/ c uid = ${APP_UID}" -e "/gid/ c gid ${APP_GID}" /home/roboshop/${COMPONENT}/${COMPONENT}.in  &>>$LOG_FILE
  statuscheck $?


}