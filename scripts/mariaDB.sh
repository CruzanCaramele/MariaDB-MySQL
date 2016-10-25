#/bin/bash

# install mariadb
yum install -y mariadb-server

# enable and start mariadb
systemctl enable mariadb
systemctl start  mariadb