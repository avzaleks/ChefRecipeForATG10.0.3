#
# Cookbook Name:: jenkins
# Recipe:: new_item_for_jenkins
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
hulf_stuff_file = "#{node['jenkins']['hulf_stuff_atr']}_for_item"
atr_in_encode_file = "#{node['jenkins']['encode_atr']}_for_item"
my_string = ''
uri = node['jenkins']['url']

ruby_block "timer2" do
  block do
    sleep 10.0
  end
end  

directory dir do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

template hulf_stuff_file do
  source   'new_job.erb'
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

execute "update_item_script" do
  command "grep -v '^$' #{hulf_stuff_file} > #{atr_in_encode_file}"
  action :run
  notifies :run, 'ruby_block[make_string_for_job]', :immediately
  notifies :run, 'execute[post_request_for_job]', :immediately
end 

ruby_block "make_string_for_job" do
  block do
    IO.foreach("#{atr_in_encode_file}") do |line|
      line = line.chomp + '&'    
      line = line.gsub("{","%7B").gsub("}","%7D").gsub("\"","%22").gsub(",","%2C")
	  line = line.gsub(":","%3A").gsub("[","%5B").gsub("]","%5D").gsub("$","%24")
	  my_string = my_string + line 
    end
    my_string.chop!
    File.open( atr_in_encode_file, 'w'){ |file| file.write  my_string }
  end
  action :nothing
end  

execute "post_request_for_job" do
  command "curl -d @#{atr_in_encode_file} #{uri}/createItem"
  action :nothing
end

#tmp_files.each { |file_for_remove|
#  file file_for_remove do
#    action :delete
#  end	
#}
