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