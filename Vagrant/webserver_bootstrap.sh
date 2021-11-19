#!/usr/bin/env bash

source /vagrant/webserver_variables.sh 2>/dev/null ||
  source /home/vagrant/webserver_variables.sh 2>/dev/null ||
  echo "Unable to locate webserver_variables.sh"

apt-get update
apt-get install -y libaprutil1-dev gcc libpcre3-dev make vim
wget https://archive.apache.org/dist/httpd/httpd-$APACHE_VERSION.tar.bz2
bzip2 -d httpd-$APACHE_VERSION.tar.bz2
tar xvf httpd-$APACHE_VERSION.tar
cd httpd-$APACHE_VERSION
./configure --enable-cgid
make
make install
chown -R daemon:daemon /usr/local/apache2/
sudo sed -i '0,/Require all denied/{s/Require all denied/Require all granted/}' /usr/local/apache2/conf/httpd.conf
sudo sed -i 's=#LoadModule cgid_module modules/mod_cgid.so=LoadModule cgid_module modules/mod_cgid.so=g' /usr/local/apache2/conf/httpd.conf
sudo /usr/local/apache2/bin/apachectl start