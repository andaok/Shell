#!/bin/sh

MAIL=$(which mail)
MAILFROM=keepalived@test.com
MAILLIST="$(cat /usr/local/keepalived/bin/maillist | tr '\n' ' ')"
IP=$(ip -4 addr list|grep ine|grep -vE '127.0.0.1|172.30.32.246'|awk '{print $2}'|cut -d'/' -f1)

STATUS=$(echo $1|tr [A-Z] [a-z])

if [ "$STATUS" = "fault" ] || [ "$STATUS" = "stop" ]; then
# FAULT or STOP
$MAIL -r $MAILFROM -s "Keepalived notify" $MAILLIST <<EOF

位于 $IP 的 Keepalived 状态变为 $STATUS。
将尝试自动修复。如长时间未收到恢复通知，请手动修复故障。

EOF
elif [ "$STATUS" = "master" ]; then
# MASTER
$MAIL -r $MAILFROM -s "Keepalived notify" $MAILLIST <<EOF

位于 $IP 的 Keepalived 状态变为 $STATUS。
收到该通知邮件表示另外一台Keepalived故障，请排查另一台Keepalived机器。
您并不需要对本机做任何操作。

EOF
elif [ "$STATUS" = "backup" ]; then
$MAIL -r $MAILFROM -s "Keepalived notify" $MAILLIST <<EOF

位于 $IP 的 Keepalived 状态变为 $STATUS。
收到该通知邮件表示该机器为首次启动，或者故障已修复。
您并不需要做任何操作。

EOF
fi
