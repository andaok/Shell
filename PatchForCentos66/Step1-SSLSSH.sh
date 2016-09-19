#!/bin/bash
##################################
# Purpose:
#   upgrade openssl and openssh
#
# Author: weiye
# Date: 20160705
##################################

RELDIR=`dirname $0`
ABSDIR=`cd $RELDIR;pwd`
export ABSDIR

#----------------------
# TO IUDGE WHETHER IT HAS BEEN UPGRADED.
#----------------------

flagnum=$(`ssh -V 2>/tmp/tmp.txt` && cat /tmp/tmp.txt | grep 7.2p2 | grep 1.0.2h | wc -l)

if [ "$flagnum" -eq "1" ]; then
   echo "HAS BEEN UPGRADE TO NEW VERSION,QUIT"
   rm -f /tmp/tmp.txt
   exit 1
fi

#----------------------
# CREATE BACKUP DIR 
#----------------------

mkdir $ABSDIR/backup

# ----------------------
# INSTALL OPENSSL
# ----------------------

yum install openssl openssl-devel gcc -y
tar zxvf openssl-1.0.2h.tar.gz
cd openssl-1.0.2h

./config shared zlib
make depend
make
make install

cd /usr/lib64/

mv /usr/bin/openssl  /usr/bin/openssl.old
mv /usr/include/openssl  /usr/include/openssl.old
ln -s /usr/local/ssl/bin/openssl  /usr/bin/openssl
ln -s /usr/local/ssl/include/openssl/  /usr/include/openssl

# libssl
rm -f libssl.so  libssl.so.10
mv libssl.so.1.0.1e  $ABSDIR/backup
ln -s /usr/local/ssl/lib/libssl.so.1.0.0  libssl.so
ln -s /usr/local/ssl/lib/libssl.so.1.0.0  libssl.so.10

#libcrypto
rm -f libcrypto.so  libcrypto.so.10
mv libcrypto.so.1.0.1e  $ABSDIR/backup
ln -s  /usr/local/ssl/lib/libcrypto.so.1.0.0  libcrypto.so
ln -s  /usr/local/ssl/lib/libcrypto.so.1.0.0  libcrypto.so.10

echo "/usr/local/ssl/lib" >> /etc/ld.so.conf
ldconfig

# ------------------------
# ALERT SELINUX TYPE
# ------------------------
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/'  /etc/selinux/config

# -------------------------
# INSTALL OPENSSH
# -------------------------
cd $ABSDIR
yum install  zlib zlib-devel  -y
tar -xvf openssh-7.2p2.tar.gz

cd openssh-7.2p2
./configure --prefix=/usr --sysconfdir=/etc/ssh --with-md5-passwords --with-privsep-path=/var/lib/sshd
make
rm -rf /etc/ssh/*
make install

cp contrib/redhat/sshd.init  /etc/init.d/sshd
sed -i 's#/sbin/restorecon /etc/ssh/ssh_host_key.pub#\#/sbin/restorecon /etc/ssh/ssh_host_key.pub#g'   /etc/init.d/sshd

sed -i  '$a Protocol 2\nCiphers aes192-ctr,aes256-ctr'  /etc/ssh/sshd_config
sed -i  '$a Protocol 2\nCiphers aes192-ctr,aes256-ctr'  /etc/ssh/ssh_config

# ------------------------
# CHECK RESULT
# ------------------------
service sshd restart
ssh -V

