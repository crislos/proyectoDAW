yum clean all

yum -y update

yum -y install httpd
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tc
firewall-cmd --reload

systemctl start httpd
systemctl enable httpd
systemctl status httpd

#Quitar pagina de inicio
rm /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.save.conf

#Instalacion MariaDB
touch /etc/yum.repos.d/MariaDB.repo
echo "# MariaDB 10.3 CentOS repository list - created 2018-05-25 19:02 UTC
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.3/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1" >> /etc/yum.repos.d/MariaDB.repo

yum -y install MariaDB-server MariaDB-client

systemctl enable mariadb
systemctl start mariadb

systemctl status mariadb

#!/bin/bash
mysql -e "UPDATE mysql.user SET Password = PASSWORD('') WHERE User = 'root'"
mysql -e "DROP USER ''@'localhost'"
mysql -e "DROP USER ''@'$(hostname)'"
mysql -e "DROP DATABASE test"
mysql -e "FLUSH PRIVILEGES"

#Instalacion PHP
yum -y install rpm
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum -y install epel-release yum-utils
yum-config-manager --disable remi-php54
yum-config-manager --enable remi-php73
yum -y install php php-cli php-fpm php-mysqlnd php-zip php-devel php-gd php-mcrypt php-mbstring php-curl php-xml php-pear php-bcmath php-json
yum  -y install php-mysql
yum -y install php-mysqlnd
rpm -qi php-mysqlnd

systemctl restart httpd.service
php -v


#Descargar proyecto
yum -y install git
cd /var/www/html
git clone https://github.com/crislos/proyectoDAW.git
cd proyectoDAW/


chown -R apache.apache /var/www/html
chmod -R 777 /var/www/html/proyectoDAW


#Preparacion proyecto
echo "DocumentRoot \"/var/www/html/proyectoDAW/\"
<Directory \"/var/www/html/proyectoDAW\">
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>" >> /etc/httpd/conf/httpd.conf

systemctl restart httpd
chmod -R 777 /var/www/html/proyectoDAW

setenforce 0
setenforce 1
chcon -R -t httpd_sys_rw_content_t storage
setsebool -P httpd_can_network_connect_db=1
