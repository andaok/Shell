#!/bin/bash
##################################
# Purpose:
#    upgrade nginx
# 
# Author: weiye
# Date: 20160705 
##################################

RELDIR=`dirname $0`
ABSDIR=`cd $RELDIR;pwd`
export ABSDIR

NginxPkgName="tengine-2.1.2"

ProNginxDir="/usr/local/nginx"

ProNginxPid=${ProNginxDir}/logs/nginx.pid

NginxConfDir=${ProNginxDir}/conf/vhost

SSL_CIPHERS="ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:!DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA;"

# --------------------------
# IS EXIST NGINX WORK DIR 
# --------------------------

if [ ! -d $ProNginxDir ]; then
   echo "CAN'T FIND NGINX WORK DIR,QUIT"
   exit 1 
fi

# ---------------------------
# NGINX WHETHER IT IS COMPATIBLE WITH
# THE NEW VERSION OF OPENSSL
# ---------------------------

flagnum=$(ldd ${ProNginxDir}/sbin/nginx | grep libssl.so.1.0.0 | wc -l)
if [ "$flagnum" -eq "1" ]; then
    echo "Nginx is compatible with the new version of OpenSSL!,QUIT!"
    exit 1
fi

# -------------------------
# IS SYMBOL LINK NGINX WORK DIR
# -------------------------

if [  -h $ProNginxDir ]; then
   echo "NGINX WORK DIR IS SYMBOL LINK ,QUIT"
   exit 1 
fi


# --------------------------
# IS EXIST NGINX PID FILE
# --------------------------

if [ ! -f $ProNginxPid ]; then
   echo "CAN'T FIND NGINX PID FILE,QUIT"
   exit 1 
fi

# -------------------------
# IS EXIST NGINX CONF DIR
# -------------------------

if [ ! -d $NginxConfDir ]; then
   echo "CAN'T FIND NGINX CONF DIR,QUIT"
   exit 1 
fi

# ---------------------------
# BACKUP OLD NGINX
# ---------------------------

echo "START BACKUP OLD NGINX ..."
#tar zcvf nginx.old.tar.gz  --exclude=${ProNginxDir}/logs/*   $ProNginxDir

tar zcvf nginx.old.tar.gz  --exclude=${ProNginxDir}/logs/*  --exclude=${ProNginxDir}/winshare/*   $ProNginxDir


# ---------------------------
# UPGRADE NGINX FUNCTION
# ---------------------------

function UpgradeNginx() 
{
	echo "START UPGRADE NGINX ..."
	yum install pcre-devel -y
	tar zxvf ${NginxPkgName}.tar.gz
	cd $NginxPkgName

	./configure  --prefix=${ProNginxDir} --with-http_ssl_module --with-http_stub_status_module --add-module=${ABSDIR}/modules/nginx-module-vts
	make
	cp -f ${ProNginxDir}/sbin/nginx  ${ProNginxDir}/sbin/nginx.old
	cp -f objs/nginx  ${ProNginxDir}/sbin/

	${ProNginxDir}/sbin/nginx -t

	kill -USR2 `cat $ProNginxPid`
	sleep 4
	kill -QUIT `cat ${ProNginxPid}.oldbin`

	#${ProNginxDir}/sbin/nginx -V
}

# ---------------------------
# ALERT NGINX ssl_ciphers 
# ---------------------------

function AlertNginxSSL()
{
   NgConfFiles=( $(cd ${NginxConfDir} && ls *.conf) )
   FileNums=${#NgConfFiles[*]}
   for ((j=0;j<$FileNums;j++))
   do
     sed -i "s/ssl_ciphers.*$/#&/g"  ${NginxConfDir}/${NgConfFiles[j]} && sed -i "s/#ssl_ciphers.*$/&\n         $SSL_CIPHERS/g"   ${NginxConfDir}/${NgConfFiles[j]}
   done   
}

# -------------------------
# RELOAD NGINX
# -------------------------

function ReloadNginx()
{
	echo "RELOAD NGINX ..."
	${ProNginxDir}/sbin/nginx -s reload
}


# -------------------------
# MAIN
# -------------------------

if [ $? -eq 0 ]; then
   UpgradeNginx
else
   exit 1
fi

if [ $? -eq 0 ]; then
   AlertNginxSSL
else
   exit 1
fi

if [ $? -eq 0 ]; then
	ReloadNginx
else
	exit 1
fi

echo "UPGRADE NGINX SUCCESS!"
exit 0

