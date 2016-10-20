#!/bin/bash

# install firewalld
yum install -y firewalld

# enable and start firewalld service
systemctl enable firewalld
systemctl start  firewalld

# add IP address allowed to ssh into the server
firewall-cmd --zone=trusted --permanent --add-source=61.6.109.231/32
firewall-cmd --zone=trusted --add-port=22/tcp

# remove ssh port from the public zone
firewall-cmd --zone=public --permanent --remove-service=ssh

# reload the firewalld service
firewall-cmd --reload