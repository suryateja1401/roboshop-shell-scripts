LOG_FILE=/tmp/frontend

source common.sh

yum install nginx -y &>>$LOG_FILE
statuscheck $?

echo Downloading nginx web content
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
statuscheck $?

echo Redirecting to nginx folder
cd /usr/share/nginx/html &>>$LOG_FILE
statuscheck $?

echo Removing Old web content
 rm -rf * &>>$LOG_FILE
statuscheck $?

echo Extracting nginx web content
unzip /tmp/frontend.zip &>>$LOG_FILE
statuscheck $?

echo Renaming and moving files and folders
mv frontend-main/static/* . &>>$LOG_FILE
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
statuscheck $?

echo update Roboshop config files
sed -e '/catalogue/s/localhost/catalogue.roboshop.internal/' -e '/user/s/localhost/user.roboshop.internal/' -e '/cart/s/localhost/cart.roboshop.internal/' -e '/shipping/s/localhost/shipping.roboshop.internal/' -e '/payment/s/localhost/payment.roboshop.internal/'/etc/nginx/default.d/roboshop.conf
statuscheck $?

echo Starting nginx services
systemctl enable nginx &>>$LOG_FILE
systemctl restart nginx&>>$LOG_FILE
statuscheck $?