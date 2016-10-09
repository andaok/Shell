#!/bin/bash


MAILDAEMON=/usr/local/keepalived/bin/sendmail.sh

notify_master() {
  echo "$(date +%F\ %T\ %s%N) [NOTIFY] state change to MASTER"
}

notify_backup() {
  echo "$(date +%F\ %T\ %s%N) [NOTIFY] state change to BACKUP"
}

notify_fault() {
  echo "$(date +%F\ %T\ %s%N) [NOTIFY] state change to FAULT"
}

notify_stop() {
  echo "$(date +%F\ %T\ %s%N) [NOTIFY] state change to STOP"
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

