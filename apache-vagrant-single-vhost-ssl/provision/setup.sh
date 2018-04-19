#!/bin/bash

## certificate settings
country="FR"
region="Haut de France"
city="Lille"
organisation="Foo Bar Baz"
service="Lorem Ipsum"
domain="192.168.33.10"

# update repositories
apt-get update

# install apache
apt-get install -y apache2

# backup original apache config
cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.orig

# configure apache (enable .htaccess)
cp /vagrant/provision/apache2.conf /etc/apache2/

# create an SSL certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt -subj "/C=$country/ST=$region/L=$city/O=$organisation/OU=$service/CN=$domain"

# create a strong Diffie-Hellman group
openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

# configure ssl
cp /vagrant/provision/ssl-params.conf /etc/apache2/conf-available/ssl-params.conf

# backup original apache default ssl virtual host
cp /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.orig

# configure apache default ssl virtual host
cp /vagrant/provision/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf

# backup original apache default regular virtual host
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.orig

# configure apache default regular virtual host
cp /vagrant/provision/000-default.conf /etc/apache2/sites-available/000-default.conf

# enable apache ssl and headers modules
sudo a2enmod ssl
sudo a2enmod headers

# enable apache ssl params configuration
a2enconf ssl-params

# enable apache default ssl virtual host
a2ensite default-ssl

# test apache config
apache2ctl configtest

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
