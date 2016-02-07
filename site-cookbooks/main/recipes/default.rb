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

service "hhvm" do
  action :start
end

template '/etc/hhvm/server.ini' do
  source 'server.ini.erb'
  mode '0644'
  owner 'root'
  group 'root'
  notifies :restart, 'service[hhvm]', :immediately  
end

template '/etc/nginx/hhvm.conf' do
  source 'hhvm.erb'
  mode '0644'
  owner 'root'
  group 'root'
  notifies :restart, 'service[nginx]', :immediately  
end

template '/etc/nginx/sites-available/default' do
  source 'default-nginx.erb'
  mode '0644'
  owner 'root'
  group 'root'
  notifies :restart, 'service[nginx]', :immediately  
end

mysql_service 'default' do
  port '3306'
  version '5.5'
  initial_root_password 'changeme'
  action [:create, :start]
end

socket = "/var/run/mysql-default/mysqld.sock"

link '/var/run/mysqld/mysqld.sock' do
      to socket
      not_if 'test -f /var/run/mysqld/mysqld.sock'
end

mysql_connection_info = {:host => node['awesome_customers']['database']['host'],
                         :username => 'root',
                         :password => node['main']['database']['rootpw']}

mysql2_chef_gem 'default' do
action :install
end

mysql_database node['main']['database']['dbname'] do
  connection mysql_connection_info
  action :create
end

mysql_database_user node['main']['database']['username'] do
  connection mysql_connection_info
  password node['main']['database']['password']
  database_name node['main']['database']['dbname']
  host          node['main']['database']['host']
  privileges    [:create,:select,:update,:insert,:delete]
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

execute 'deploying wordpress' do
  command 'unzip /usr/share/nginx/html/latest.zip -d /usr/share/nginx/html;mv /usr/share/nginx/html/wordpress/* /usr/share/nginx/html/;rmdir /usr/share/nginx/html/wordpress'
  creates '/usr/share/nginx/html/wp-config-sample.php'
end

template '/usr/share/nginx/html/wp-config.php' do
  source 'wp-config.erb'
  mode '0440'
  owner 'www-data'
  group 'www-data'
  variables({
     :name_database   => node['main']['database']['dbname'],
     :user_database   => node['main']['database']['username'],
     :passwd_database => node['main']['database']['password']
  })
end

execute 'change user ownership' do
  command 'chown -R www-data:www-data /usr/share/nginx/html/'
end

execute 'change perm directory' do
  command 'chmod -R 755 /usr/share/nginx/html/'
end