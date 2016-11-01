#!/usr/bin/env bash

set -eux
set -o pipefail

echo Installing pre-requisites...
yum install -y wget unzip

cd /tmp/
wget https://releases.hashicorp.com/consul/0.7.0/consul_0.7.0_linux_amd64.zip -O consul.zip
echo Installing Consul...
unzip consul.zip
sudo chmod +x consul
sudo mv consul /usr/local/bin
sudo mkdir /etc/consul.d
sudo mkdir /var/consul
sudo mkdir -p /opt/consul
sudo chmod -R 777 /etc/consul.d
sudo chmod -R 777 /opt/consul
sudo chmod -R 777 /var/consul

echo Installing consul web-ui...
wget https://releases.hashicorp.com/consul/0.7.0/consul_0.7.0_web_ui.zip -O consul-web_ui.zip
unzip consul-web_ui.zip -d /opt/consul/ui

