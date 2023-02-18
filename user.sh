LOG_FILE=/tmp/user

source common.sh

COMPONENT=user

NODEJS()

echo Update SystemD servicefile
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/roboshop/user/systemd.service &>>${LOG_FILE}
statuscheck $?

echo Setup user services
mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service &>>${LOG_FILE}
statuscheck $?

systemctl daemon-reload &>>${LOG_FILE}
systemctl enable user &>>${LOG_FILE}

echo start user services
systemctl start user &>>${LOG_FILE}
statuscheck $?
