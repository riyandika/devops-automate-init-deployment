#!/bin/bash

# permissions
if [ "$(whoami)" != "root" ]; then
        echo "Root privileges are required to run this, try running with sudo..."
        exit 2
fi

echo "> set variables"
echo "Enter repo url"
read REPO
#REPO=git@gitlab.com:bigio/mipi/web.git
echo "Enter repo branch"
read REPO_BRANCH
#REPO_BRANCH=dev
echo "Enter domain name"
read DOMAIN_NAME
echo "Enter directory path"
read DIRECTORY
echo "Enter directory "
#DIRECTORY=/home/gakeslab/prod/cms/public_html/
read DIRECTORY_HOST
echo "Enter Apache Config file name"
read APACHE_CONF_NAME
echo "Enter Log Error file name"
read LOG_ERROR_NAME
echo "Enter Log Custom file name"
read LOG_CUSTOM_NAME

echo "> make directory and enter it"
if [ ! -d "$DIRECTORY" ]; then
        mkdir -p "$DIRECTORY"
fi

echo "> setup git "
cd "$DIRECTORY"
git init
git remote add origin "$REPO"
git pull origin
git checkout "$REPO_BRANCH"
chown -R www-data:www-data "$DIRECTORY"

APACHE_CONF_PATH=/etc/apache2/sites-available/$APACHE_CONF_NAME.conf
cp /root/automate/apache-vhost.conf $APACHE_CONF_PATH
sed -i 's/DOMAIN_NAME/$DOMAIN_NAME/g' $APACHE_CONF_PATH
sed -i 's/DIRECTORY_HOST/$DIRECTORY_HOST/g' $APACHE_CONF_PATH
sed -i 's/LOG_ERROR_NAME/$LOG_ERROR_NAME/g' $APACHE_CONF_PATH
sed -i 's/LOG_CUSTOM_NAME/$LOG_CUSTOM_NAME/g' $APACHE_CONF_PATH

