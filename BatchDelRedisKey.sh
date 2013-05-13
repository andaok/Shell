#!/bin/bash

###################################
#
# Batch delete keys in the redis
# Author :  wye
# Date   :  20130513  
#
###################################

NoDelKeyFlag=( info date )

NoDelKeyFlagNum=${#NoDelKeyFlag[*]}

AllKeyList=$(redis-cli keys \* | awk '{print $1}' | xargs echo )

AllKeyArray=( $AllKeyList )

echo ${#AllKeyArray[*]}

for ((i=0;i<$NoDelKeyFlagNum;i++))
do
   KeysList=$(redis-cli keys *${NoDelKeyFlag[i]} | awk '{print $1}') 
   
   for key in $KeysList
   do
      echo $key      
   done  
done




