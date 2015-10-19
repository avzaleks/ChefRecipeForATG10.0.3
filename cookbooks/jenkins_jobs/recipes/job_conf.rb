#
# Cookbook Name:: jenkins
# Recipe:: item_conf
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
tmp_files = []
dir = node['jenkins']['dir_for_atr']
hulf_stuff_file = "#{node['jenkins']['hulf_stuff_atr']}_for_item_conf"
atr_in_encode_file = "#{node['jenkins']['encode_atr']}_for_item_conf"
my_string = ''
uri = node['jenkins']['url']
items_name = node['jenkins']['name_of_new_job'] 

ruby_block "timer5" do
  block do
    sleep 3.0
  end
end  

directory dir do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

template hulf_stuff_file do
  source   'conf_job.erb'
  mode     '0644'
  tmp_files.push(hulf_stuff_file)
end

file atr_in_encode_file do
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  tmp_files.push(atr_in_encode_file)
end

shell_script = node['jenkins']['path_to_script_in_system'] 

template shell_script do
  source   'script_job.sh.erb'
  mode     '0755'
  tmp_files.push(hulf_stuff_file)
end

directory "#{node['jenkins']['jenkins_dir_for_artifakts']}" do
  owner 'jenkins'
  group 'jenkins'
  mode '0777'
  action :create
end


execute "update_item_conf_script" do
  command "grep -v '^$' #{hulf_stuff_file} > #{atr_in_encode_file}"
  action :run
  notifies :run, 'ruby_block[make_string_for_item_conf]', :immediately
  notifies :run, 'execute[post_request_for_item_conf]', :immediately
  notifies :run, 'execute[post_request_for_run_job]', :immediately
end 

ruby_block "make_string_for_item_conf" do
  block do
    IO.foreach("#{atr_in_encode_file}") do |line|
      line = line.chomp + '&'    
      line = line.gsub("{","%7B").gsub("}","%7D").gsub("\"","%22").gsub(",","%2C").gsub(" ","+")
	  line = line.gsub(":","%3A").gsub("[","%5B").gsub("]","%5D").gsub("$","%24").gsub("/","%2F")
	  my_string = my_string + line 
    end
    my_string.chop!
    File.open( atr_in_encode_file, 'w'){ |file| file.write  my_string }
  end
  action :nothing
end  

execute "post_request_for_item_conf" do
  command "curl -d @#{atr_in_encode_file} #{uri}/job/#{items_name}/configSubmit"
  action :nothing
end

execute "post_request_for_run_job" do
  command "curl -d \"delay=0sec\" #{uri}/job/#{items_name}/build?delay=0sec"
  action :nothing
end





#tmp_files.each { |file_for_remove|
#  file file_for_remove do
#    action :delete
#  end	
#}
