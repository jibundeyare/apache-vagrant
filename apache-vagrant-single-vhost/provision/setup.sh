#!/bin/bash

# update repositories
apt-get update

# install apache
apt-get install -y apache2

# backup original apache config
cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.orig

# configure apache (enable .htaccess)
cp /vagrant/provision/apache2.conf /etc/apache2/

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
apt-get install -y mysql-server mysql-client
