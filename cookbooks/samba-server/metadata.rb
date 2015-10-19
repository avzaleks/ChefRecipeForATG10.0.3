name "samba-server"
maintainer        "Alex"
maintainer_email  "aleksandr.zaichko@gmail.com"
license           "Apache 2.0"
description       "Installs samba and public directory"



%w{ centos redhat fedora ubuntu debian }.each do |os|
  supports os
end
