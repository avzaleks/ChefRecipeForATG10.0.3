#
# Cookbook Name:: postfix
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

sasl_file = "/etc/postfix/#{node['postfix']['identity_file_name']}"
mail_domain = node['postfix']['mail_server_domain']
mail_port = node['postfix']['server_port']
user_name = node['postfix']['user_account_name']
passwd = node['postfix']['user_account_passwd']


if node['platform_family']=="rhel" 
  ['postfix', 'mailx', 'cyrus-sasl-plain'].each { |pack|
    package pack do
	action :install
    end 
    } 

	file sasl_file do
      mode '0600'
      content "smtp.#{mail_domain}    #{user_name}:#{passwd}"
    end   

    execute 'postmap' do
      command "postmap hash:/#{sasl_file}"
	end	
	
	template '/etc/postfix/main.cf' do
      mode '0644'
      source 'main.cf.rhel.erb'
    end 

	service 'postfix' do
	  action :reload
	end
end
	
if node['platform_family']=="debian"
  then
    [ 'libsasl2-2', 'ca-certificates', 'libsasl2-modules', 'postfix', 'mailutils'].each { |pack|
    package pack do
	  action :install
    end   
  }

  mailname_file = '/etc/mailname'

  file sasl_file do
    mode '0600'
    content "smtp.#{mail_domain}:#{mail_port}   #{user_name}@#{mail_domain}:#{passwd}"
  end   

  file mailname_file do
    mode '0600'
    content "#{node['postfix']['host_domain']}"
  end   
   
  template '/etc/postfix/main.cf' do
    mode '0644'
    source 'main.cf.erb'
  end 
   
  bash 'post_install' do
    user 'root'
    code <<-EOH
            postmap "#{sasl_file}"
	        cat /etc/ssl/certs/Thawte_Premium_Server_CA.pem | sudo tee -a /etc/postfix/cacert.pem
	        /etc/init.d/postfix reload
	        EOH
  end	
end
  
  
address = node['postfix']['test_mail_address']

ruby_block "timer" do
  block do
    sleep 10.0
  end
end  
  
bash 'test_mail' do
    user 'root'
    code <<-EOH
            echo "Test mail from postfix" | mail -s "Test Postfix" "#{address}"
            EOH
end	

  
   

  