#!/bin/bash

clear
echo -n "Would you like to create virtual machines ? (Y/N)"
read VM

if [[ $VM = Y || $VM = y ]]
then

echo -n "Enter please name of first machine: "
read F_NAME
export F_NAME
echo

echo -n "Enter please name of second machine: "
read S_NAME
export S_NAME
echo


VBoxManage import adistro/Centos6.6.GA.ova > /dev/null
sleep 5
VBoxManage modifyvm Centos6.6.GA --name $F_NAME > /dev/null
#VBoxManage modifyvm ATG --memory 2048
#VBoxManage modifyvm ATG --vrde off
#VBoxManage modifyvm ATG --cpus 2
#VBoxManage modifyvm ATG --nic1 bridged

export F_MAC=`VBoxManage showvminfo $F_NAME | findstr MAC | cut -d ":" -f 3 | cut -d "," -f 1`

echo -------------------------------
echo "MAC of $F_NAME = $F_MAC"
echo -------------------------------

VBoxManage startvm $F_NAME 
echo
echo

VBoxManage import adistro/Centos6.6.GA.ova > /dev/null
sleep 5
VBoxManage modifyvm Centos6.6.GA --name $S_NAME > /dev/null
#VBoxManage modifyvm ATG --memory 2048
#VBoxManage modifyvm ATG --vrde off
#VBoxManage modifyvm ATG --cpus 2
#VBoxManage modifyvm ATG --nic1 bridged

export S_MAC=`VBoxManage showvminfo $S_NAME | findstr MAC | cut -d ":" -f 3 | cut -d "," -f 1`
echo -------------------------------
echo "MAC of $S_NAME = $S_MAC"
echo -------------------------------

VBoxManage startvm $S_NAME 


progress_bar(){
count=0
total=$1
pstr="[=============================================================================================]"

while [ $count -lt $total ]; do
  sleep 1 # this is work
  count=$(( $count + 1 ))
  pd=$(( $count * 94 / $total ))
  printf "\r%3d.%1d%% %.${pd}s" $(( $count * 100 / $total )) $(( ($count * 1000 / $total) % 10 )) $pstr
done
}

determine_ip(){
progress_bar 30
echo

echo "Determine ip of machines"
echo

export F_IP=`VBoxManage guestproperty enumerate $F_NAME | grep IP | cut -d " " -f4 | cut -d "," -f1`

export S_IP=`VBoxManage guestproperty enumerate $S_NAME | grep IP | cut -d " " -f4 | cut -d "," -f1`
echo
echo
echo "Ip address of $F_NAME is - $F_IP "
echo
echo
echo "Ip address of $S_NAME is - $S_IP "
echo
echo "IP of $F_NAME host = $F_IP" > adistro/ip.txt
echo "IP of $S_NAME host = $S_IP" >> adistro/ip.txt
}


echo -n "Do you want to automatically determaine the ip addresses of the new machines?(y/n): "
read AUTO_YES_OR_NO
if [[ $AUTO_YES_OR_NO == "y" ]]
then
    determine_ip
fi
fi

echo "Do you have access to hosts by public kyes ?"
echo -n "If you want to attache remote hosts without typing password - press I (import) else S (skip):" 
read YES_NO

case "$YES_NO" in
I|i|'' ) adistro/import_keys.sh;;
S|s ) echo "O'K";;
esac
 








