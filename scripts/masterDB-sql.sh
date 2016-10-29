#!/bin/bash
# If /root/.my.cnf exists then it won't ask for root password
if [ -f /etc/my.cnf ]; then

    mysql -e "CREATE USER 'replication'@'%' identified by 'password';"
    mysql -e "GRANT REPLICATION SLAVE ON *.* TO replication;"
    mysql -e "CREATE USER 'backup'@'%' identified by 'password';"
    mysql -e "GRANT SELECT, LOCK TABLES, SHOW VIEW, EVENT, TRIGGER ON *.* TO 'backup'@'%';"
fi