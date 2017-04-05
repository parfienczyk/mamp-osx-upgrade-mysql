#!/bin/sh

wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.17-macos10.12-x86_64.tar.gz
tar xfvz mysql-5.7*

echo "stopping mamp"
sudo /Applications/MAMP/bin/stop.sh
sudo killall httpd mysqld

echo "creating backup"
sudo rsync -a /Applications/MAMP ~/Desktop/MAMP-Backup

echo "copy bin"
sudo rsync -av mysql-5.7.*/bin/* /Applications/MAMP/Library/bin/ --exclude=mysqld_multi --exclude=mysqld_safe

echo "copy share"
sudo rsync -av mysql-5.7.*/share/* /Applications/MAMP/Library/share/

echo "fixing access (workaround)"
sudo chmod -R o+rw  /Applications/MAMP/db/mysql/
sudo chmod -R o+rw  /Applications/MAMP/tmp/mysql/

echo "starting mamp"
ln -s /Applications/MAMP/tmp/mysql/mysql.sock /tmp/mysql.sock
sudo /Applications/MAMP/bin/start.sh

echo "migrate to new version"
sudo chmod -R 777 /Applications/MAMP/db/mysql/
/Applications/MAMP/Library/bin/mysql_upgrade --user=root --password=root --host=localhost --port=3306