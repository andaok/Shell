#!/bin/sh
LOGFILE=/usr/local/keepalived/bin/check.log
/usr/local/keepalived/bin/notify_nginx.sh $1 >> $LOGFILE 2>&1
#/usr/local/keepalived/bin/notify_nginx.sh $1
