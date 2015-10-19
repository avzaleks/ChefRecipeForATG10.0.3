name "postfix"
maintainer        "Alex"
maintainer_email  "aleksandr.zaichko@gmail.com"
license           "Apache 2.0"
description       "Installs postfix and mailutils (only for send mail) with related packages"



%w{ centos redhat fedora ubuntu debian }.each do |os|
  supports os
end
