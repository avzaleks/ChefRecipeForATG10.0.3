name "oracle11"
maintainer        "Alex"
maintainer_email  "aleksandr.zaichko@gmail.com"
license           "Apache 2.0"
description       "Installs oracle XE 11"



%w{ centos redhat }.each do |os|
  supports os
end
