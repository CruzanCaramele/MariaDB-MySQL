#/bin/bash

# install mariadb
yum install -y mariadb-server

# enable mariadb
systemctl enable mariadb
systemctl start  mariadb