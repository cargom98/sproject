#
# Cookbook Name:: main
# Recipe:: default
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'nginx'
include_recipe 'hhvm'

mysql_service 'default' do
  port '3306'
  version '5.5'
  initial_root_password 'changeme'
  action [:create, :start]
end

mysql_connection_info = {:host => "127.0.0.1",
                         :username => 'root',
                         :password => 'changeme'}

mysql2_chef_gem 'default' do
action :install
end

mysql_database 'wordpress' do
  connection mysql_connection_info
  action :create
end

mysql_database_user 'wpuser' do
  connection mysql_connection_info
  password 'wp123'
  database_name 'wordpress'
  host          '%'
  privileges    [:select,:update,:insert]
  action        :grant
end

package 'Install unzip' do
  package_name ['unzip']
  action :install
end

remote_file '/usr/share/nginx/html/latest.zip' do
  source 'http://wordpress.org/latest.zip'
  owner 'root'
  group 'root'
  mode '755'
end

# execute 'deploying wordpress' do
#   command 'unzip /usr/share/nginx/html/latest.zip -d /usr/share/nginx/html;mv /usr/share/nginx/html/wordpress/* /usr/share/nginx/html/;rmdir /usr/share/nginx/html/wordpress'
# end

template '/etc/nginx/sites-available/default' do
  source 'default-nginx.erb'
  mode '0644'
  owner 'root'
  group 'root'
  notifies :restart, 'service[nginx]', :immediately  
end

template '/usr/share/nginx/html/wp-config.php' do
  source 'wp-config.erb'
  mode '0440'
  owner 'root'
  group 'root'
  variables({
     :name_database   => 'wpdb',
     :user_database   => 'wpuser',
     :passwd_database => 'wp123'
  })
end