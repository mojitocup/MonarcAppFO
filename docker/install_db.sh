#!/bin/bash

service mariadb start

# Secure MariaDB installation and setup initial database and user
mysql -e "CREATE USER 'monarc'@'%' IDENTIFIED BY 'password';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'monarc'@'%';"
mysql -e "FLUSH PRIVILEGES;"
mysql -e "CREATE DATABASE monarc_cli DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
mysql -e "CREATE DATABASE monarc_common DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"

# Initialize the database

mysql -u monarc -ppassword monarc_common < /var/lib/monarc/db-bootstrap/monarc_structure.sql
mysql -u monarc -ppassword monarc_common < /var/lib/monarc/db-bootstrap/monarc_data.sql