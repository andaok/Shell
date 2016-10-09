#!/bin/sh
LOGFILE=/usr/local/keepalived/bin/check.log
/usr/local/keepalived/bin/check_redis.sh >> $LOGFILE 2>&1
#/usr/local/keepalived/bin/check_redis.sh
