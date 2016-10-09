#!/bin/bash


PS_COUNT=$(ps -C nginx --no-headers|wc -l)
if [ $PS_COUNT -gt 0 ]; then
  # status OK
  #echo "$(date +%F\ %T\ %s%N) [CHECK] OK"
  exit 0
else
  # status KO
  echo "$(date +%F\ %T\ %s%N) [CHECK] KO"
  /usr/local/nginx/sbin/nginx
  sleep 3
  PS_COUNT=$(ps -C nginx --no-headers|wc -l)
  if [ $PS_COUNT -eq 0 ]; then
    /usr/local/keepalived/sbin/shutdown.sh
  fi
  exit 1
fi

