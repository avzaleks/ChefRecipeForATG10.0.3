name "jenkins_jobs"
maintainer        "Alex"
maintainer_email  "aleksandr.zaichko@gmail.com"
license           "Apache 2.0"
description       "Setup Jenkins job"



%w{ centos redhat fedora ubuntu debian }.each do |os|
  supports os
end
