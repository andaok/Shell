#!/bin/bash



REDIS_CLI=/home/redisadmin/redis-3.0.7/bin/redis-cli
REDIS_MASTER=172.30.33.12 # where is the master when local server become BACKUP
REDIS_MASTER_PORT=6379
MAILDAEMON=/usr/local/keepalived/bin/sendmail.sh
STATUS_TMP=/usr/local/keepalived/bin/status.tmp

notify_master() {
  # Change to master，disconnect from previous Master
  echo "$(date +%F\ %T\ %s%N) [NOTIFY] state change to MASTER"
  touch -f ${STATUS_TMP}
  ${REDIS_CLI} slaveof no one
#  ${REDIS_CLI} config set save ""
#  ${REDIS_CLI} config set appendonly no
}

notify_backup() {
  # Change to backup，establish the Master-Slave relations
  echo "$(date +%F\ %T\ %s%N) [NOTIFY] state change to BACKUP"
  touch ${STATUS_TMP} # 创建临时文件记录时间戳,增加BACKUP状态检测时间
  ${REDIS_CLI} slaveof ${REDIS_MASTER} ${REDIS_MASTER_PORT}
#  ${REDIS_CLI} config set save "900 1"
}

notify_fault() {
  # Change to fault, shutdown local redis service and keepalived daemon
  echo "$(date +%F\ %T\ %s%N) [NOTIFY] state change to FAULT"
  rm -f ${STATUS_TMP}
#  ${REDIS_CLI} -h 127.0.0.1 shutdown 2>&1
  ps -ef|grep keepalived|awk '$0 !~ /grep/ {print $2}'|xargs kill -15
}

notify_stop() {
  echo "$(date +%F\ %T\ %s%N) [NOTIFY] state change to STOP"
  rm -f ${STATUS_TMP}
}


# =================
#     MAIN
# =================

$MAILDAEMON $1

case "$1" in
  master)
    notify_master
    ;;
  backup)
    notify_backup
    ;;
  fault)
    notify_fault
    ;;
  stop)
    notify_stop
    ;;
  *)
    echo "Unknown arguments"
    exit 1
    ;;
esac

