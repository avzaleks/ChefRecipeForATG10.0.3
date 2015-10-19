#
# Cookbook Name:: samba-server
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

if node['platform_family']=="rhel"
  platform_version = node['platform_version']
  version = platform_version[0].chr.to_i
  if (version >= 7)
    node.default['samba']['name_of_interface'] = 'enp0s3'
  end
end 
 
include_recipe 'user'

node.default['samba']['samba_user'] = node['user']['user_name']
	  
	  
if node['platform_family']=="debian" || node['platform_family']=="rhel"
  then

	package 'samba' do
	  action :install
	end   
	
	if node['platform_family']=="rhel"
	  ['samba-common', 'samba-client'].each do |pack|
	     package pack 
	  end   
	end
	
	samba_service = node['samba']['service']
	
	service samba_service do
	  supports :status => true, :restart => true, :reload => true
	  action [ :enable, :start ]
	end

	template "/etc/samba/smb.conf" do
	  mode '0644'
	  source "smb.conf.erb"
	  notifies :reload, "service[#{samba_service}]", :immediately
	end    

	if node['samba']['if_new_user']
	  then
	  groupe_for_samba = node['samba']['samba_group']
	  group groupe_for_samba do
		action :create
		append true
	  end
	  samba_user ='samba' + node['samba']['samba_user']
	  user samba_user do
		supports :manage_home => true
		comment 'Samba User'
		gid groupe_for_samba
		home "/home/#{samba_user}"
		shell '/bin/nologin'
	  end
	end

	if node['samba']['if_existed_user'] 
	  samba_user = node['samba']['samba_user']
	end  

	if samba_user
	  if node['samba']['samba_user_password'] == nil
		Chef::Application.fatal!("A password is required for the user")
	  else
		pswd = node['samba']['samba_user_password'] 
		pswd_file = "/root/samba_pswd_for_#{samba_user}"
		file pswd_file do
		  owner 'root'
		  group 'root'
		  mode '0600'
		  content "#{pswd}\n#{pswd}"
		end
		bash 'add_enable_samba_user' do
		  user 'root'
		  code <<-EOH
				  cat #{pswd_file} | smbpasswd -s -a #{samba_user}
				  smbpasswd -e #{samba_user}		
				  EOH
		end	
		service samba_service do
		  action :reload
		end	  
	  end
	end

	
	public_directory = node['samba']['public_directory']
    
	public_directory.each do |dir|
	  execute 'chmod' do
	    command "chmod 0755 #{dir}"
	  end
    end         
			
	if node['platform_family']=="rhel" 
      public_directory.each do |dir|
	    execute 'chcon' do
	      command "chcon -Rt samba_share_t #{dir}"
	    end
      end         
 	end	
  
  else
    Chef::Application.fatal!("Unsupported Operating System!!!!!!")
end

  