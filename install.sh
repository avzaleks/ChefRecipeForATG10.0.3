#!/bin/bash

node="$1"
if [ "$node" = "" ];
then
    echo "Usage: $0 node"
    exit 1
fi

if !(command -v chef-solo &> /dev/null);
then
yum -y localinstall --nogpgcheck /tmp/chef_install/chef-12.1.2-1.el6.x86_64.rpm
rm -rf /tmp/chef_install
#curl -L https://www.opscode.com/chef/install.sh | bash
fi

chef-solo -c solo.rb -j "nodes/${node}.json"
