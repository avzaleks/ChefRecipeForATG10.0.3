#
# Cookbook Name:: oracle11
# Recipe:: import
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

dump_files = node['ora']['dump_files']
user = node['ora']['user']
group = node['ora']['group']
pswd = node['ora']['db_password']

dump_files.each do |file|
  execute 'dmp_files' do
    command "su - #{user} -c \"cp /tmp/Atg/#{file} #{node['ora']['dump_dir']}\""
  end   
end
  
dump_files.each do |file|
  execute 'dmp_files' do
    command "su - #{user} -c \"cp /tmp/Atg/#{file} #{node['ora']['second_dump_dir']}\""
  end   
end

  
  
file "#{node['ora']['ora_home']}/bin/dump_script.sh" do
  owner "#{user}"
  group "#{group}"
  mode '0755'
  content "#!/bin/bash
source /etc/profile.d/ora.sh\n"
  action :create
end
	
dump_files.each do |file|  
  schemas = file.split('.')[0]
  execute 'write' do
    cwd "#{node['ora']['ora_home']}/bin"
	command "echo \"./impdp system/#{pswd}@XE  schemas=#{schemas} dumpfile=#{file} logfile=#{file}.log \" >> dump_script.sh" 
  end
end

flag_for_dump = "/tmp/dump_is_done"
  
execute 'write_end' do
  cwd "#{node['ora']['ora_home']}/bin"
  command "echo \"touch #{flag_for_dump}
exit 0\n\" >> dump_script.sh" 
end

execute 'import' do
  user 'root'
  cwd "#{node['ora']['ora_home']}/bin"
  command './dump_script.sh' 
  not_if { ::File.exists?(flag_for_dump) } 
end
  
  