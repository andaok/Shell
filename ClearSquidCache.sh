#!/bin/sh
squidcache_path="/home/squid"
squidclient_path="/usr/bin/squidclient"

RawUrls=$1

UrlStr=`echo $RawUrls | awk -F"#" '{split($1,myarr,"|") ;for(i in myarr){print myarr[i]}}'`

UrlArray=( $UrlStr )

UrlsNum=${#UrlArray[*]}

for ((i=0;i<$UrlsNum;i++))
do
   echo ${UrlArray[i]}
   grep -a -r ${UrlArray[i]} $squidcache_path/* | strings | grep "http:" |awk -F"http:" '{print "http:"$2;}'> cache_list.txt
   for url in `cat cache_list.txt`; do
      echo $url
      $squidclient_path -m PURGE -p 80 "$url"
   done
done
