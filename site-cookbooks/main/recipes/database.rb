mysql_service 'default' do
  port '3306'
  version '5.5'
  initial_root_password node['main']['database']['rootpw']
  action [:create, :start]
end

socket = "/var/run/mysql-default/mysqld.sock"

link '/var/run/mysqld/mysqld.sock' do
      to socket
      not_if 'test -f /var/run/mysqld/mysqld.sock'
end

mysql2_chef_gem 'default' do
action :install
end

mysql_database node['main']['database']['dbname'] do
  connection(
    :host => node['main']['database']['host'],
    :username => 'root',
    :password => node['main']['database']['rootpw']
  )
  action :create
end

mysql_database_user node['main']['database']['username'] do
  connection(
    :host => node['main']['database']['host'],
    :username => 'root',
    :password => node['main']['database']['rootpw']
  )
  password node['main']['database']['password']
  database_name node['main']['database']['dbname']
  host          node['main']['database']['host']
  privileges    [:create,:select,:update,:insert,:delete]
  action        :grant
end
