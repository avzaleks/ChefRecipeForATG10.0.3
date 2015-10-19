name "java6"
maintainer        "Alex"
maintainer_email  "aleksandr.zaichko@gmail.com"
license           "Apache 2.0"
description       "Install java6"



%w{ centos redhat fedora ubuntu debian }.each do |os|
  supports os
end
