#!/bin/bash


apt-get update -y

# apt-get install -y apt-transport-https ca-certificates curl software-properties-common
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
# apt-key fingerprint 0EBFCD88
# add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# apt-get update -y
# apt-get install -y docker-ce=17.03.2~ce-0~ubuntu-xenial

apt-get install -y  python

apt-get install -y software-properties-common 
apt-add-repository ppa:ansible/ansible 
apt-get update 
apt-get install -y ansible 

cat << EOF >> /etc/network/interfaces

auto ens7
iface ens7 inet static
    address $1
    netmask 255.255.240.0
    mtu 1450
EOF

ifup ens7