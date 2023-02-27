COMPONENT=dispatch

LOG_FILE=/tmp/${COMPONENT}

source common.sh

echo install golang
yum install golang -y