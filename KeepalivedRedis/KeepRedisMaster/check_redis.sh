#!/bin/bash


REDIS_CLI=/home/redisadmin/redis-3.0.7/bin/redis-cli
REDIS_CLI_OPTS="-h 127.0.0.1 -p 6379"
CHECK_CMD=ping # check command for redis alive
EXP_STATUS=PONG # expect status
STATUS_TMP=/usr/local/keepalived/bin/status.tmp

if [ -f "${STATUS_TMP}" ]; then
  # 如果存在临时文件，检测其时间戳
  start=$(stat "${STATUS_TMP}" | grep 'Modify'|awk '{print $2" "$3" "$4}')
  start=$(date -d "$start" +%s)
  end=$(date +%s)
  diff=$(echo "scale=0;$end-$start"|bc)
  if [ $diff -lt 300 ]; then
    # 300s(5分钟)之内直接返回OK
    echo "$(date +%F\ %T\ %s%N) [CHECK] STATUS_TMP: $STATUS_TMP already exist, OK"
    exit 0
  else
    # 超过300s(5分钟)，删除临时文件，继续下面的检测逻辑
    rm -f ${STATUS_TMP}
    echo "$(date +%F\ %T\ %s%N) [CHECK] File removed: $STATUS_TMP"
  fi
fi

STATUS=$(${REDIS_CLI} ${REDIS_CLI_OPTS} ${CHECK_CMD})
#STATUS=$EXP_STATUS
if [ "$STATUS" = "$EXP_STATUS" ]; then
  # status OK
  #echo "$(date +%F\ %T\ %s%N) [CHECK] OK"
  exit 0
else
  # status KO
  echo "$(date +%F\ %T\ %s%N) [CHECK] KO"
  exit 1
fi

