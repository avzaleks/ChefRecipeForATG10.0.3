#!/bin/bash

OLD_SWAP=`free -m | grep wap | sed 's/\s\+/,/g' | cut -d , -f4`
echo $OLD_SWAP
if (( $OLD_SWAP < 2500 ))
then
echo "Swap is small"
ADD_SWAP=$(( 2500 - $OLD_SWAP ))
echo $ADD_SWAP
dd if=/dev/zero of=/swapfile bs=1M count=$ADD_SWAP
mkswap /swapfile
chmod 600 /swapfile
swapon /swapfile
echo '/swapfile	swap swap defaults 0 0' >> /etc/fstab
echo `swapon -s`
else
echo "Swap is good"
fi
