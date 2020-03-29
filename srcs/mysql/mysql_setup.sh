#!/bin/sh

if [[ ! -d /var/lib/mysql/wordpress ]];
then
		mysql_install_db --user=mysql --datadir=${DB_DATA_PATH}
		rc-service mariadb start
		echo "CREATE DATABASE wordpress;" > tmpsql
		echo "GRANT ALL ON *.* TO 'wordpress'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;" >> tmpsql
		echo "GRANT ALL ON *.* TO 'wordpress'@'localhost' IDENTIFIED BY 'password' WITH GRANT OPTION;" >> tmpsql
		echo "FLUSH PRIVILEGES;" >> tmpsql
		cat /tmpsql | mysql -u root --password="${DB_ROOT_PASS}"
		mysql -u root --password="${DB_ROOT_PASS}"  wordpress < "/tmp/wordpress.sql"
fi
cat ./mariadb_default_run > /etc/runlevels/default/mariadb
rc-service mariadb restart
