#!/bin/bash
#######################################

usage()
{

cat << EOF
Usage: $0 OPTIONS
  -h|--help ; help information
  --host    ; host ip address
  --port    ; app port
  --user    ; username
  --passwd  ; password 
EOF

}

parse_args() 
{
   [ $# -eq 0 ] && { usage; exit 1; }

   while [ $# -gt 0 ]; do
       case "$1" in
            --host)
              shift
              echo "$1" | grep -iE '^-'
              [ $? -ne 0 ] && { HOST_ADDR="$1"; }
              ;;
            --port)
              shift
              echo "$1" | grep -iE '^-'
              [ $? -ne 0 ] && { HOST_PORT="$1"; }
              ;;
            --user)
              shift
              echo "$1" | grep -iE '^-'
              [ $? -ne 0 ] && { USER_NAME="$1"; }
              ;;
            --passwd)
              shift
              echo "$1" | grep -iE '^-'
              [ $? -ne 0 ] && { PASSWD="$1"; }
              ;;
            *)
              echo "UNKNOWN ARGUMENTS:$1"
              usage
              exit 1
              ;;
       esac
       shift
   done    
}

parse_args "$@"

HOST_ADDR=${HOST_ADDR:="127.0.0.1"}
HOST_PORT=${HOST_PORT:="8888"}
USER_NAME=${USER_NAME:="terry"}
PASSWD=${PASSWD:="isme"}

echo "$HOST_ADDR // $HOST_PORT // $USER_NAME // $PASSWD" 


