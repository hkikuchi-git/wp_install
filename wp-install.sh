#!/bin/bash -e

# reference
#  https://gist.github.com/bgallagh3r/2853221

_PWD=`pwd`

#
_APACHE_LOG="/var/log/httpd"
_TMP="/tmp"

#
_WP_SITE=https://ja.wordpress.org/
_WP_FILE=latest-ja.tar.gz
_WP_DL=${_WP_SITE}${_WP_FILE}

_WPUSER="wp_user"
_WPPASS="WPpass"

#
#
_MYSQL_HOST="localhost"
_MYSQL_USER="root"
_MYSQL_PW=""
_MYSQL_SQL=${_TMP}"/mysql_cmd.sql"


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

#
_DIR_PATH=$(cd $(dirname ${_DIR}) && pwd)
_file=$(basename ${_DIR})
_ABSPATH=${_DIR_PATH}/${_file}

#move directory
cd ${_DIR}

######################
clear
echo "============================================"
echo "WordPress Install Script (Japanese)"
echo "============================================"

echo "Enter your WordPress URL? [e.g. mywebsite.com]: "
read -e wphost

echo "Database Name: "
read -e dbname
# echo "Database User: "
# read -e dbuser
# echo "Database Password: "
# read -s dbpass
echo "run install? (y/n)"
read -e run
if [ "$run" == n ] ; then
  exit 0
fi

echo "============================================"
echo "A robot is now installing WordPress for you."
echo "============================================"

#download wordpress
curl -O -o ${_WP_FILE} ${_WP_DL}

# wget -q -O ${_WP_FILE} ${_WP_DL}
# curl -s -S -O -o ${_WP_FILE} ${_WP_DL}

#unzip wordpress
tar -zxf ${_WP_FILE}

#######################################################
##
#change directory-name
mv wordpress wp
#move directory
cd wp

#create wp config
cp wp-config-sample.php wp-config.php

#set database details with perl find and replace
perl -pi -e "s/database_name_here/$dbname/g" wp-config.php
perl -pi -e "s/username_here/${_WPUSER}/g" wp-config.php
perl -pi -e "s/password_here/${_WPPASS}/g" wp-config.php


##
## ** Set up secret keys
## ** AUTH_KEY、SECURE_AUTH_KEY、LOGGED_IN_KEY,NONCE_KEY 
## ** AUTH_SALT, SECURE_AUTH_SALT, LOGGED_IN_SALT, NONCE_SALT


#create uploads folder and set permissions
mkdir wp-content/uploads
chmod 777 wp-content/uploads

#move back to parent dir
cd ..

#
cp -p wp/index.php .
perl -pi -e "s|/wp-blog-header.php|/wp/wp-blog-header.php|g" index.php


## 
## ** permission (chown / chmod)
##


#remove zip file
rm ${_WP_FILE}


#######################################################
##
echo "============================================"
echo "Database Setup"
echo "============================================"

# generate SQL
cat << _EOS > ${_MYSQL_SQL}
CREATE DATABASE $dbname CHARACTER SET utf8;
GRANT ALL PRIVILEGES ON ${dbname}.* TO ${_WPUSER}@localhost;
FLUSH PRIVILEGES;
exit
_EOS

mysql -u ${_MYSQL_USER} -p${_MYSQL_PW} -f < ${_MYSQL_SQL}

rm -f ${_MYSQL_SQL}

echo "Create DataBase: " $dbname

#######################################################
##
echo "============================================"
echo "Apache sample config"
echo "============================================"

cat << _EOS > ${wphost}.conf
#
<VirtualHost *:80>
        ServerAdmin webmaster@example.domain
        ServerName $wphost

        DirectoryIndex index.php index.html

        DocumentRoot ${_ABSPATH}

        ErrorLog ${_APACHE_LOG}/error.${wphost}.log
        CustomLog ${_APACHE_LOG}/access.${wphost}.log combined

        # Possible values include: debug, info, notice, warn, error, crit,
        # alert, emerg.
        LogLevel warn

        <Directory "${_ABSPATH}">
                Options FollowSymLinks MultiViews
                AllowOverride All
                Order allow,deny
                allow from all
        </Directory>
</VirtualHost>

_EOS

cat ${wphost}.conf
echo ""




echo "========================="
echo "Installation is complete."
echo "========================="

cd ${_PWD}

exit 1

