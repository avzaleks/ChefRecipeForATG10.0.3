#!/bin/bash

#clear
echo
echo "Now we should create and import the public keys to the remote hosts"
echo
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "It is very important - now root password is  -- avzdevops --"
echo "Later you can change it"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo
echo -n "Enter please ip for $F_NAME host [$F_IP]: "
read F_IP_FOR_IMPORT
if [[ $F_IP_FOR_IMPORT == '' ]]
then
F_IP_FOR_IMPORT=$F_IP
fi
echo
echo -n "Enter please ip for $S_NAME host [$S_IP]: "
read S_IP_FOR_IMPORT
if [[ $S_IP_FOR_IMPORT == '' ]]
then
S_IP_FOR_IMPORT=$S_IP
fi
echo


if_present(){
echo 'Keys are presetn. Importing'
scp "$HOME"/.ssh/id_dsa.pub root@$1:/root/.ssh/authorized_keys 
}

if_abcent(){
echo "Keys is abcent. Creating DSA"
ssh-keygen -b 1024 -t dsa -f "$HOME"/.ssh/id_dsa -q -N ""
if_present $1
}

import_keys(){
if [ -e "$HOME"/.ssh/id_dsa.pub ]
then
if_present $1 
else
if_abcent $1
fi
}

import_keys $F_IP_FOR_IMPORT
import_keys $S_IP_FOR_IMPORT

