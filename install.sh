#!/bin/sh
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
mkdir -p /opt/oracle
rm -rf /opt/oracle/instantclient_12_2 /opt/oracle/instantclient-basic-linux.x64-12.2.0.1.0.zip /opt/oracle/instantclient-sdk-linux.x64-12.2.0.1.0.zip
cp instantclient-basic-linux.x64-12.2.0.1.0.zip /opt/oracle
cp instantclient-sdk-linux.x64-12.2.0.1.0.zip /opt/oracle
cd /opt/oracle
unzip instantclient-basic-linux.x64-12.2.0.1.0.zip
unzip instantclient-sdk-linux.x64-12.2.0.1.0.zip
ln -s /opt/oracle/instantclient_12_2/libclntsh.so.12.1 /opt/oracle/instantclient_12_2/libclntsh.so
ln -s /opt/oracle/instantclient_12_2/libocci.so.12.1 /opt/oracle/instantclient_12_2/libocci.so
echo /opt/oracle/instantclient_12_2 > /etc/ld.so.conf.d/oracle-instantclient
ldconfig
apt-get install php-dev php-pear build-essential libaio1 -y
pecl channel-update pecl.php.net
echo instantclient,/opt/oracle/instantclient_12_2 | pecl install oci8
echo "extension =oci8.so" >> /etc/php/7.4/fpm/php.ini
echo "extension =oci8.so" >> /etc/php/7.4/cli/php.ini
echo "extension =oci8.so" >> /etc/php/7.4/apache2/php.ini
echo "export LD_LIBRARY_PATH=/opt/oracle/instantclient_12_2" >> /etc/apache2/envvars
echo "export ORACLE_HOME=/opt/oracle/instantclient_12_2" >> /etc/apache2/envvars
echo "LD_LIBRARY_PATH=/opt/oracle/instantclient_12_2:$LD_LIBRARY_PATH" >> /etc/environment
php -m | grep 'oci8'
echo "finish"