#!/bin/bash -e

# reference
#  https://gist.github.com/bgallagh3r/2853221

#
_WP_SITE=https://ja.wordpress.org/
_WP_FILE=latest-ja.tar.gz
_WP_DL=${_WP_SITE}${_WP_FILE}

#
#
_MYSQL_HOST="localhost"
_MYSQL_USER="root"
_MYSQL_PW=""
_MYSQL_SQL=" mysql_cmd.sql"

#
#
_APACHE_LOG="/var/log/httpd"


#
_LEN=32

#
if [ $# -eq 0 ]; then
  echo "$0 [install-directory]"
  exit 1
fi

_DIR=$1

# make install-directory
if [ ! -d ${_DIR} ]; then
  mkdir -p ${_DIR}
fi

#move directory
cd ${_DIR}

######################
clear
echo "============================================"
echo "WordPress Install Script (Japanese)"
echo "============================================"
echo "Database Name: "
read -e dbname
echo "Database User: "
read -e dbuser
echo "Database Password: "
read -s dbpass
echo "run install? (y/n)"
read -e run
if [ "$run" == n ] ; then
  exit 0
fi

echo "============================================"
echo "Database Setup"
echo "============================================"

# generate SQL
cat << _EOS > ${_MYSQL_SQL}
CREATE DATABASE $dbname CHARACTER SET utf8;
GRANT ALL PRIVILEGES ON ${dbname}.* TO ${dbuser}@localhost IDENTIFIED BY '$dbpass';
FLUSH PRIVILEGES;
exit
_EOS

# 
mysql -u ${_MYSQL_USER} -p${_MYSQL_PW} < ${_MYSQL_SQL}

rm -f ${_MYSQL_SQL}


echo "============================================"
echo "A robot is now installing WordPress for you."
echo "============================================"

#download wordpress
curl -O -o ${_WP_FILE} ${_WP_DL}

# wget -q -O ${_WP_FILE} ${_WP_DL}
# curl -s -S -O -o ${_WP_FILE} ${_WP_DL}

#unzip wordpress
tar -zxvf ${_WP_FILE}

#change directory-name
mv wordpress wp
#move directory
cd wp

#create wp config
cp wp-config-sample.php wp-config.php

#set database details with perl find and replace
perl -pi -e "s/database_name_here/$dbname/g" wp-config.php
perl -pi -e "s/username_here/$dbuser/g" wp-config.php
perl -pi -e "s/password_here/$dbpass/g" wp-config.php

#create uploads folder and set permissions
mkdir wp-content/uploads
chmod 777 wp-content/uploads

#move back to parent dir
cd ..

#remove zip file
rm ${_WP_FILE}


echo "============================================"
echo "Apache sample config"
echo "============================================"





echo "========================="
echo "Installation is complete."
echo "========================="

exit 1

