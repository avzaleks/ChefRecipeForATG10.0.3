name "atg10.0.3"
maintainer        "Alex"
maintainer_email  "aleksandr.zaichko@gmail.com"
license           "Apache 2.0"
description       "Install ATG and CommerceReferenceStore"



%w{ centos redhat fedora ubuntu debian }.each do |os|
  supports os
end
