#!/bin/bash
#########################################

ji=$(redis-cli keys *info) 

echo $ji
