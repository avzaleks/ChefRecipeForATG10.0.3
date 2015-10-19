#
# Cookbook Name:: jboss5.1
# Recipe:: jboss_setup
# Author: Alex <aleksandr.zaichko@gmail.com>
# 
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

jboss_dir = node['jboss']['dir_for_jboss']
jboss_home = node['jboss']['jboss_home']

if node['platform_family']=="rhel" 
 
   
  
   
 # bash '' do
 # end
  
  tamplate "#{jboss_home}/server/conf/props/jmx-console-users.properties" do
    owner 'jboss'
    group 'jboss'
    mode '0600'
    content "#{node['jboss']['admin_login']}=#{node['jboss']['admin_password']} "
  end
  
 # template '/home/jboss/.bash_profile' do
 #    mode 0644
  #   source 'bash_profile.erb'
 # end  
  
#  template '/etc/init.d/jboss' do
#     mode 0744
 #    source 'start_script.erb'
  #end   
  
#  service 'jboss' do
#    supports :status => true, :restart => true, :reload => true
#    action [ :enable, :start ]
#  end
  
  
#  execute 'chconfig' do
#    user 'root'
#    cwd '/etc/init.d'
#	command 'chkconfig --add jboss; chkconfig --level 234 jboss on '
#  end  

  
  
  
  
  
  
  
  
end

if node['platform_family']=="debian"
  
end

