echo installing nginx
yum install nginx -y &>>/tmp/frontend
echo status $?

echo Downloading nginx web content
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>/tmp/frontend
echo status $?

echo Redirecting to nginx folder
cd /usr/share/nginx/html &>>/tmp/frontend
echo status $?

echo Removing Old web content
 rm -rf * &>>/tmp/frontend
echo status $?

echo Extracting nginx web content
unzip /tmp/frontend.zip &>>/tmp/frontend
echo status $?

echo Renaming and moving files and folders
mv frontend-main/static/* . &>>/tmp/frontend
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>/tmp/frontend
echo status $?

echo Starting nginx services
systemctl enable nginx &>>/tmp/frontend
systemctl restart nginx&>>/tmp/frontend
echo status $?