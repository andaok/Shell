#!/bin/bash

###################################
#
# Batch delete keys in the redis
# Author :  wye
# Date   :  20130513  
#
###################################

NoDelKeyFlag=( info date )

KeysList=$(redis-cli keys *info | awk '{print $1}')

for key in $KeysList
do
  echo $key
done
