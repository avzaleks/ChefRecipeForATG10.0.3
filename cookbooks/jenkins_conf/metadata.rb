name "jenkins_conf"
maintainer        "Alex"
maintainer_email  "aleksandr.zaichko@gmail.com"
license           "Apache 2.0"
description       "Configure Jenkins"



%w{ centos redhat fedora ubuntu debian }.each do |os|
  supports os
end
