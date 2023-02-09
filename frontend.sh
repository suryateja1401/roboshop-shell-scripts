echo installing nginx
yum install nginx -y

echo Downloading nginx web content
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

echo Redirecting to nginx folder
cd /usr/share/nginx/html

echo Removing Old web content
 rm -rf *

echo Extracting nginx web content
unzip /tmp/frontend.zip

echo Renaming and moving files and folders
mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf

echo Starting nginx services
systemctl enable nginx
systemctl restart nginx