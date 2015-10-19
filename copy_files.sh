#!/bin/bash

run_recipe.sh


host="$1"

user="root" 
if [ "$host" = "" ];
then
    echo;
    echo "Specifies ip of node !!!!!!!!!!!!!!!!!!!!!!"
    echo "Usage: $0 user@host ssh-params"
    exit 1
fi

node=$user@$host

echo "$node"

files=adistro/arch_for_atg10.0.3_java6_jBoss5.1/*.*
dir="/tmp/Atg"
echo;
echo;
echo;
echo "Do I need to copy the files to a remote machine (Y/N):"
read YES_OR_NO 
echo;
echo;
case "$YES_OR_NO" in  
Y|y ) echo "I will copy files" ; 
echo
echo "For what - ATG or Oracle(A/O):"
read for_what 
case "$for_what" in
ATG|A|a ) files=adistro/arch_for_atg10.0.3_java6_jBoss5.1/*.*;;
Oracle|O|o ) files=adistro/arch_for_oracle/*.*;;

esac

ssh $node mkdir $dir;
scp $files $node:$dir;;

N|n ) echo "I will start chef";;
esac
echo;
echo;
exit 0;


