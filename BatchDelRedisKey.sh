#!/bin/bash

###################################
#
# Batch delete keys in the redis
# Author :  wye
# Date   :  20130513  
#
###################################

NoDelKeyFlag=( info )

NoDelKeyFlagNum=${#NoDelKeyFlag[*]}

AllKeyList=$(redis-cli keys \* | awk '{print $1}' | xargs echo )

AllKeyArray=( $AllKeyList )

AllKeyNum=${#AllKeyArray[*]}


for ((j=0;j<$AllKeyNum;j++))
do
   keyname=${AllKeyArray[j]}

   KeyDel="True"

   for ((i=0;i<$NoDelKeyFlagNum;i++))
   do
      KeysList=$(redis-cli keys *${NoDelKeyFlag[i]} | awk '{print $1}')  
      for key in $KeysList
      do
         if [ "$keyname" == "$key" ]; then
            KeyDel="False"
         fi      
      done
   done

   if [ "$KeyDel" == "True" ]; then
      echo $(redis-cli del $keyname)
   fi

done
