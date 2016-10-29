#!/bin/bash
# If /root/.my.cnf exists then it won't ask for root password
if [ -f /etc/my.cnf ]; then
	mysql -e "SET GLOBAL server_id=2;"
	mysql -e "RESET SLAVE;"
    mysql -e "CHANGE MASTER TO MASTER_HOST='master.prod.internal', MASTER_USER='replication', MASTER_PASSWORD='password', MASTER_PORT=3306, MASTER_CONNECT_RETRY=10;"
    mysql -e "START SLAVE;"
fi