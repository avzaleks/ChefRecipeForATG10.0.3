name "jenkins"
maintainer        "Alex"
maintainer_email  "aleksandr.zaichko@gmail.com"
license           "Apache 2.0"
description       "Installs Jenkins and setap job"



%w{ centos redhat fedora ubuntu debian }.each do |os|
  supports os
end
