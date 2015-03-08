#!/bin/bash -e

# reference
#  https://gist.github.com/bgallagh3r/2853221

#
_WP_SITE=https://ja.wordpress.org/
_WP_FILE=latest-ja.tar.gz
_WP_DL=${_WP_SITE}${_WP_FILE}

#
_LEN=32

#
if [ $# -eq 0 ]; then
  echo "$0 [install-directory]"
  exit 1
fi

_DIR=$1

if [ ! -d ${_DIR} ]; then
  mkdir -p ${_DIR}
fi

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
exit
else
echo "============================================"
echo "A robot is now installing WordPress for you."
echo "============================================"
#download wordpress
curl -O -o ${_WP_FILE} ${_WP_DL}
#unzip wordpress
tar -zxvf ${_WP_FILE}

#change dir to wordpress
cd wordpress
#copy file to parent dir
cp -rf . ..
#move back to parent dir
cd ..
#remove files from wordpress folder
rm -R wordpress
#create wp config
cp wp-config-sample.php wp-config.php
#set database details with perl find and replace
perl -pi -e "s/database_name_here/$dbname/g" wp-config.php
perl -pi -e "s/username_here/$dbuser/g" wp-config.php
perl -pi -e "s/password_here/$dbpass/g" wp-config.php
#create uploads folder and set permissions
mkdir wp-content/uploads
chmod 777 wp-content/uploads
#remove zip file
rm ${_WP_FILE}
echo "========================="
echo "Installation is complete."
echo "========================="
fi
