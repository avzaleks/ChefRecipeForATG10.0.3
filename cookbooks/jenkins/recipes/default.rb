#
# Cookbook Name:: jenkins
# Recipe:: default
#
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


package 'wget'

directory "#{node['jenkins']['jenkins_java_dir']}" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

cache = Chef::Config[:file_cache_path]
file_cache_path = "#{cache}/#{node['jenkins']['jenkins_java_distro']}"

remote_file file_cache_path do
  source "#{node['jenkins']['jenkins_java_url']}"
  mode '0644'
  not_if { ::File.exists?(file_cache_path) }
end

file_for_check = node['jenkins']['jenkins_java_cmd']

execute 'tar' do
  cwd "#{node['jenkins']['jenkins_java_dir']}"
  command "tar -xvf #{file_cache_path} -C #{node['jenkins']['jenkins_java_dir']}"
  not_if { ::File.exists?( file_for_check ) }
end

port = node['jenkins']['jenkins_port']
platform_version = node['platform_version']
version = platform_version[0].chr.to_i
command = ''

if (version >=7 && node['platform_family']=="rhel" ) 
  command = "systemctl status jenkins"
else  
  command = "service jenkins status"
end

if  ! command 
  execute "Chef::Application.fatal!(#{node['jenkins']['error_port_message']}Current port = #{port})" do
    only_if "netstat -lntup | grep #{port}" 
  end
end

if node['platform_family']=="rhel" 

#  bash 'jenkins_repo' do
#    user 'root'
#	code <<-EOF 
#        wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
#         rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
#         EOF
#  end
  
#  execute "update script" do
#    command "yum -y update"
#    action :run
#  end 

package 'jenkins' do
  action :install 
  source '/tmp/Atg/jenkins-1.609.1-1.1.noarch.rpm'
end 
 
 
  template '/etc/sysconfig/jenkins' do
    source   'jenkins-config-rhel.erb'
    mode     '0644'
    notifies :restart, 'service[jenkins]', :immediately
  end
end


if node['platform_family']=="debian"
  
   
  bash 'jenkins_repo' do
    user 'root'
	code <<-EOF 
         wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
         sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
         EOF
  end
   
  execute "update" do
    command "apt-get update"
    action :run
  end
 
  package 'jenkins' do
    action :install 
  end 
 
  template '/etc/default/jenkins' do
    source   'jenkins-config-debian.erb'
    mode     '0644'
  notifies :restart, 'service[jenkins]', :immediately
  notifies :run, 'ruby_block[timer]', :immediately
 end
end   

service 'jenkins' do
  supports :status => true, :restart => true, :reload => true
  action  [:enable, :start]
  notifies :run, 'ruby_block[timer]', :immediately
end

ruby_block "timer" do
  block do
    sleep 30.0
  end
  action :nothing
end  


if node['jenkins']['need_authority']
  include_recipe "jenkins::authority_rules"
end

