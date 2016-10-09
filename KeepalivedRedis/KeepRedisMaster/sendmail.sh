#!/bin/sh

MAIL=$(which mail)
MAILFROM=keepalived@test.com
MAILLIST="test@test.com"
IP=$(ip -4 addr list|grep ine|grep -vE '127.0.0.1|172.30.33.16'|awk '{print $2}'|cut -d'/' -f1)

STATUS=$(echo $1|tr [A-Z] [a-z])

if [ "$STATUS" = "fault" ] || [ "$STATUS" = "stop" ]; then
# FAULT or STOP
$MAIL -r $MAILFROM -s "Keepalived notify" $MAILLIST <<EOF

位于 $IP 的 Keepalived 状态变为 $STATUS。
请手动修复故障。

可参考如下步骤：
1. 登录 $IP
2. 执行如下命令切换为root用户
sudo su

3. 启动redis
3.1 执行如下命令检查redis状态
redis-cli ping
如果返回"Connection refused"，表示redis服务已关闭
如果阻塞，可能redis服务异常，通过如下命令找出并kill相关进程
ps -ef|grep 'redis-server'|awk '\$0 !~ /grep/ {print \$2}'|xargs kill -9

3.2 执行如下命令重新启动redis
source /etc/rc.local
等待启动完成

4. 执行如下命令启动keepalived
/usr/local/keepalived/sbin/startup.sh

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
