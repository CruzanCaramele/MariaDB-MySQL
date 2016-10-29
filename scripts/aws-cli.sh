#!/bin/bash

# add epel repo
yum-config-manager --add-repo http://dl.fedoraproject.org/pub/epel/7/x86_64/

cat <<EOF > /etc/yum.repos.d/dl.fedoraproject.org_pub_epel_7_x86_64_.repo
[dl.fedoraproject.org_pub_epel_7_x86_64_]
name=added from: http://dl.fedoraproject.org/pub/epel/7/x86_64/
baseurl=http://dl.fedoraproject.org/pub/epel/7/x86_64/
enabled=1
gpgcheck=0
EOF

# install aws-cli
yum install -y python-pip
pip install awscli