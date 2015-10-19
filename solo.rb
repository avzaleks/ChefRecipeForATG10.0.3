root = File.absolute_path(File.dirname(__FILE__))

file_cache_path  root
cookbook_path    root + '/cookbooks'
data_bag_path    root + '/data_bags'
encrypted_data_bag_secret  root + '/data_bags/oracle/secret_key'
role_path        root + '/roles'
file_cache_path '/tmp/chef-solo'
