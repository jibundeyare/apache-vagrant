#!/bin/bash

# update repositories
apt-get update

# install apache
apt-get install -y apache2

# backup original apache config
cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.orig

# configure apache (enable .htaccess)
cp /vagrant/provision/apache2.conf /etc/apache2/

# backup original virtual host
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.orig

# configure new virtual hosts
cp /vagrant/provision/000-default.conf /etc/apache2/sites-available/
cp /vagrant/provision/monsite2.localhost.conf /etc/apache2/sites-available/

# enable additional virtual hosts
a2ensite monsite2.localhost.conf

# install php
apt-get install -y php7.0
apt-get install -y php7.0-fpm

# disable mod_php
a2dismod php7.0
# disable prefork multi-processing
a2dismod mpm_prefork

# enable event multi-processing
a2enmod mpm_event
# enable php-fpm
a2enconf php7.0-fpm
# enable proxy fcgi
a2enmod proxy_fcgi

# restart apache2
systemctl restart apache2

# install mysql
apt-get install -y mysql-client mysql-server

# install debconf utils
# @info debconf utils is needed to configure phpmyadmin install
apt-get install -y debconf-utils

# phpmyadmin password settings
phpmyadmin_password="123"

# mysql password
# @info mysql password is empty by default
mysql_password=""

# configure phpmyadmin install
echo "dbconfig-common dbconfig-common/mysql/admin-pass password $mysql_password" | debconf-set-selections
echo "dbconfig-common dbconfig-common/mysql/app-pass password $phpmyadmin_password" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $mysql_password" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $phpmyadmin_password" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $phpmyadmin_password" | debconf-set-selections

# install phpmyadmin
DEBIAN_FRONTEND=noninteractive apt-get -y install phpmyadmin

# enable phpmyadmin virtual host
cp /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
a2enconf phpmyadmin

# restart apache2
systemctl restart apache2
