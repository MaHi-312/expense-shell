source common.sh
component=backend

echo install nodejs repos
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
if [ $? =eq 0 ] ; then
  echo -e "\e[32msucces\e[0m"
  else
    echo -e "\e[31mfailed\e[0m"
    exit
    fi


echo install nodejs
dnf install nodejs -y >>$log_file
if [ $? =eq 0 ] ; then
  echo -e "\e[32msucces\e[0m"
    else
      echo -e "\e[31mfailed\e[0m"
      exit
      fi

echo copy backend service file
cp backend.service /etc/systemd/system/backend.service &>>$log_file
if [ $? =eq 0 ] ; then
  echo -e "\e[32msucces\e[0m"
    else
      echo -e "\e[31mfailed\e[0m"
      exit
      fi

echo add application user
useradd expense &>>$log_file
if [ $? =eq 0 ] ; then
  echo -e "\e[32msucces\e[0m"
    else
      echo -e "\e[31mfailed\e[0m"
      exit
      fi

echo clean app content
rm -rf /app &>>$log_file
if [ $? =eq 0 ] ; then
  echo succes
  else
    echo failed
    fi

mkdir /app
cd /app

download_and_extract

echo download dependinces
npm install &>>$log_file
if [ $? =eq 0 ] ; then
  echo succes
  else
    echo failed
    fi

echo start backend service
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl start backend &>>$log_file
if [ $? =eq 0 ] ; then
  echo succes
  else
    echo failed
    fi

echo install mysql client
dnf install mysql -y &>>$log_file
if [ $? =eq 0 ] ; then
  echo succes
  else
    echo failed
    fi

echo load schema
mysql -h 2.malleswaridevops.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$log_file
if [ $? =eq 0 ] ; then
  echo succes
  else
    echo failed
    fi