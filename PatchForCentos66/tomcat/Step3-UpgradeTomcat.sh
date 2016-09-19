#!/bin/bash
# ##############################
# Purpose:
#    Upgrade tomcat  
#
# Author : weiye
# Date : 20160720
# ##############################

RELDIR=`dirname $0`
ABSDIR=`cd $RELDIR;pwd`
export ABSDIR

ProTomcatDir="/usr/tomcat7.0.5"

ProTomcatDirName=$(basename ${ProTomcatDir})

TomcatPkgName=apache-tomcat-7.0.70

# ----------------------
# IS EXIST TOMCAT WORK DIR
# ----------------------

if [ ! -d $ProTomcatDir ]; then
   echo "Can't Find Tomcat Dir,Quit!"
   exit 1
fi 

# ----------------------
# TO IUDGE WHETHER IT HAS BEEN UPGRADED.
# ----------------------
flagnum=$(${ProTomcatDir}/bin/catalina.sh version | grep 7.0.70 | wc -l)

if [ "$flagnum" -gt "1" ]; then
   echo "HAS BEEN UPGRADE TO NEW VERSION,QUIT!" 
   exit 1
fi

# -----------------------
# IS SYMBOL LINK TOMCAT WORK DIR
# -----------------------

if [ -h $ProTomcatDir ]; then
   echo "TOMCAT WORK DIR IS SYMBOL LINK,QUIT"
   exit 1
fi

# -----------------------
# SHUTDOWN TOMCAT 
# -----------------------

javanums=$(ps aux | grep java | grep $(basename ${ProTomcatDir}) | grep -v grep | wc -l)

if [ "$javanums" -eq "1" ]; then
    username=$(ps aux | grep java | grep $(basename ${ProTomcatDir}) | grep -v grep | awk '{print $1}')
else
  echo "NO RUNNING OR RUNNING MANY JAVA PROCESS,ERROR QUIT,PLAESE CHECK ..."
    exit 1
fi

echo "SHUTDOWN TOMCAT ..."
$ProTomcatDir/bin/shutdown.sh

sleep 2

javanums=$(ps aux | grep java | grep $(basename ${ProTomcatDir}) | grep -v grep | wc -l)

if [ "$javanums" -gt "0" ]; then
  echo "java process is not closed,quit!"
  exit 1
fi

# ----------------------
# UPGRADE TOMCAT
# ----------------------

echo "START UPGRADE TOMCAT ..."

mkdir $ABSDIR/$ProTomcatDirName

cp -r $ProTomcatDir/{conf,webapps,lib}  $ABSDIR/$ProTomcatDirName

tar zxvf ${TomcatPkgName}.tar.gz

cp -r $ProTomcatDirName/conf/*   $TomcatPkgName/conf/
rm -rf $TomcatPkgName/webapps/*
cp -r $ProTomcatDirName/webapps/*   $TomcatPkgName/webapps/

if [ -d $ProTomcatDir/tingyun ]; then
   cp -r $ProTomcatDir/tingyun  $TomcatPkgName/
fi

cp -r $TomcatPkgName/lib/*  $ProTomcatDirName/lib/
cp -r $ProTomcatDirName/lib/*  $TomcatPkgName/lib/

mv $ProTomcatDir ${ProTomcatDir}.old
cp -r $TomcatPkgName  $ProTomcatDir

#set owner and authority for tomcat workdir
if [ "$username" -gt 0 ] 2>/dev/null ;then
  echo "Please Manually set owner and authority for tomcat workdir."
else 
  chown -R ${username}:${username} $ProTomcatDir
  chmod -R 755 $ProTomcatDir
fi

echo "UPGRADE TOMCAT SUCCESS"

echo "############Attention#############"
echo "Please manual modification catalina.sh,startup.sh and start tomcat"
echo "##################################"
