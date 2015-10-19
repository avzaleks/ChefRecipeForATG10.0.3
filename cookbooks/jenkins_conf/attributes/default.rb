# Cookbook name: jenkins_conf
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
default['jenkins']['jvm_options'] = ''
default['jenkins']['maven_global_options'] = ''

default['jenkins']['admin_addr_email'] = 'aleksandr.zaichko@gmail.com'
default['jenkins']['jenkins_args'] = false
default['jenkins']['url'] = "http:"+"//localhost:#{node['jenkins']['jenkins_port']}"
default['jenkins']['dir_for_atr'] = '/tmp/jenkins_atr'
default['jenkins']['hulf_stuff_atr'] = "#{node['jenkins']['dir_for_atr']}/jenkins_half_staff"
default['jenkins']['encode_atr'] = "#{node['jenkins']['dir_for_atr']}/jenkins_atr_in_encode"
default['jenkins']['ip_jenkins_host'] = "127.0.0.1"
default['jenkins']['smtp_host'] = "localhost"


default['jenkins']['need_another_jdk'] = true
default['jenkins']['another_jdk_name'] = 'java6'
default['jenkins']['another_jdk_home'] = '/usr/lib/jvm/jdk1.6.0_45'
default['jenkins']['another_jdk_var'] = '$JAVA_HOME'


#=================================================================================




  
