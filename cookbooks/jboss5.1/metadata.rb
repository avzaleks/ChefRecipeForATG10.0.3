name "jboss5.1"
maintainer        "Alex"
maintainer_email  "aleksandr.zaichko@gmail.com"
license           "Apache 2.0"
description       "Installs jBoss-5.1"



%w{ centos redhat fedora ubuntu debian }.each do |os|
  supports os
end
