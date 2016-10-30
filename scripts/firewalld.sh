#!/bin/bash

# install firewalld
yum install -y firewalld

# enable and start firewalld service
# systemctl enable firewalld
# systemctl start  firewalld

# # add IP address allowed to ssh into the server
# firewall-cmd --zone=trusted --permanent --add-port=22/tcp

# # remove ssh port from the public zone

# # reload the firewalld service
# firewall-cmd --reload