#!/bin/bash

#############################
#THIS SCRIPT FOR EASY TO MANAGE GITHUB
#############################

PROJECTDIR=$1

#SWITCH TO PROJECT DIR
cd $PROJECTDIR

CMD=$2
COMMIT=$3
DATE=$(date "+%Y%m%d/%H%M")

if [ "X$CMD" == "Xadd" ]; then
{
   echo "START ADD AND UPDATE DATA TO GITHUB IN $DATE"
   echo "-----------------------"
   git add $PROJECTDIR 
   git commit -m "$COMMIT" $PROJECTDIR 
   git push -u origin master
   echo "-----------------------"
} >> /tmp/github.log 2>&1
fi

if [ "X$CMD" == "Xupdate" ]; then
{
   echo "START UPDATE DATA TO GITHUB IN $DATE"
   echo "-----------------------"
   git commit -m "$COMMIT" $PROJECTDIR
   git push -u origin master
   echo "-----------------------"
} >> /tmp/github.log 2>&1
fi

#############################
exit 0

