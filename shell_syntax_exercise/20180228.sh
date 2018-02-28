#!/bin/bash

function xcase()
{

   foo=$1

   case $foo in
        "a") echo "a";exit 0;;
        "b") echo "b";exit 0;;
          *) echo "c";exit 0;;	
   esac
	
}

#xcase "a"

function xarray()
{
   raw_str="a b c d e f"
   myarray=( $raw_str )

   array_num=${#myarray[*]}

   echo "array item num is $array_num"   

   for ((i=0;i<$array_num;i++))
      do
      echo "my array item is ${myarray[i]}"
      done

   for k in $raw_str
      do
      echo " k is $k"
      done

   while read line
      do
      echo "this is line content is $line"
      done < tmp.txt
     

}

#xarray

function other()
{
   # IsFile
   [ -f "$(pwd)/tmp.txt" ] || echo "no find file"
   # IsExistVar
   str="xiha"
   [ -z $str ] && echo "no this var"   
}

#other

function num_cmp()
{
    [ 5 -gt 4 ] && echo " 5 gt 4"
    [ 4 -lt 5 ] && echo " 4 lt 5"
    [ 6 -eq 6 ] && echo " 6 eq 6"
    [ 7 -ne 9 ] && echo " 7 ne 9"
}

#num_cmp


function xwhile()
{
    i=0
    while read line
      do
        let i=i+1
        echo " $i line content is $line" 

        loop="true"
        while [ "$loop" == "true" ]
          do
            echo "this $i line"
            loop=false
          done
    
      done < tmp.txt
   
}

#xwhile


function cal()
{
  i=10
  ((i=i*6))
  echo $i
}

#cal

function and_or()
{

  if [ 5 -gt 4 -a 5 -lt 7 ]; then
     echo "succ"
  else
     echo "fail"
  fi

  if [ 5 -gt 4 -o 5 -lt 4 ]; then
     echo "succ"
  else
     echo "fail"
  fi

}

and_or
