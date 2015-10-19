#
# Cookbook Name:: oracle11
# Recipe:: fwld
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
version = nil

if node['platform_family']=="rhel"  
  platform_version = node['platform_version']
  version = platform_version[0].chr.to_i
end
 
if (node['platform_family']=="debian" || (node['platform_family']=="rhel" && version < 7)) 
    
	template '/etc/iptables_rules' do
      source "iptables_rules.erb"
      mode '0400'
      owner 'root'
      group 'root'
    end

    execute 'restore' do
	  user 'root' 
      command 'cat /etc/iptables_rules | iptables-restore'
	end 
    
	file '/usr/sbin/iptbls' do
      owner 'root'
      group 'root'
      mode '0755'
      content "cat /etc/iptables_rules | iptables-restore\n"
      action :create_if_missing   
   end
	
	execute 'restore_persist' do
	  user 'root' 
      command 'echo "/usr/sbin/iptbls" >> /etc/rc.local'
      not_if "cat /etc/rc.local | grep '/usr/sbin/iptbls'" 
	end 
      
end

if (node['platform_family']=="rhel" && version >= 7)  
  
  template '/etc/firewalld_rules' do
    source "firewalld_rules.erb"
    mode '0700'
    owner 'root'
    group 'root'
  end

  execute 'firewall' do
    command '/etc/firewalld_rules' 
  end
    
end
