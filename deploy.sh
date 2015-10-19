#!/bin/bash

host="$1"
if [ "$host" = "" ];
then
    echo "Usage: $0 user@host ssh-params"
    exit 1
fi

node=${host#*@}

# The host key might change when we instantiate a new VM, so
# we remove (-R) the old host key from known_hosts
#ssh-keygen -R "$node" 2> /dev/null

if ssh $host ! chef-solo -v 2>/dev/null  
then
	ssh $host mkdir /tmp/chef_install 
	scp adistro/chef-12.1.2-1.el6.x86_64.rpm $host:/tmp/chef_install
fi

tar cz . --exclude 'adistro' | ssh -t -o 'StrictHostKeyChecking no' $@ "
rm -rf ~/chef &&
mkdir ~/chef &&
cd ~/chef &&
tar xz &&
sh install.sh $node"
