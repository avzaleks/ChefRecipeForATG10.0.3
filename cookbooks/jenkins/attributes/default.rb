# Cookbook name: jenkins
# Author: Alex <aleksandr.zaichko@gmail.com>
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#



#Global settings--------------------------------------------------------------------------------------

default['jenkins']['jenkins_port'] = '10000'
default['jenkins']['error_port_message'] = 'You must specify a different port!!! The default port is used!!!'
default['jenkins']['jvm_options'] = ''
default['jenkins']['maven_global_options'] = ''
default['jenkins']['if_jenkins_run_standalone'] = true

if node['jenkins']['if_jenkins_run_standalone'] == false
  default['jenkins']['jenkins_port'] = '-1'
end

default['jenkins']['jenkins_java_dir'] = '/opt/java7'
default['jenkins']['jenkins_java_distro'] = 'jdk-7u79-linux-x64.tar.gz'
default['jenkins']['jenkins_java_url'] ="file:///tmp/Atg/#{node['jenkins']['jenkins_java_distro']}"
default['jenkins']['jenkins_java_home'] = "#{node['jenkins']['jenkins_java_dir']}/jdk1.7.0_79"
default['jenkins']['jenkins_java_cmd'] = "#{node['jenkins']['jenkins_java_home']}/bin/java"
default['jenkins']['listen_address'] = '0.0.0.0'
default['jenkins']['jenkins_args'] = false

default['jenkins']['need_authority'] = false

default['jenkins']['disable_remember_me'] = false
if node['jenkins']['disable_remember_me'] == true
  default['jenkins']['turn_on_disable_remember_me'] = '_.disableRememberMe=on'
else 
  default['jenkins']['turn_on_disable_remember_me'] = nil
end 



#=================================================================================




  
