package 'Install unzip' do
  package_name ['unzip']
  action :install
end

remote_file '/usr/share/nginx/html/latest.zip' do
  source 'http://wordpress.org/latest.zip'
  owner 'root'
  group 'root'
  mode '0755'
end

execute 'deploying wordpress' do
  command 'unzip /usr/share/nginx/html/latest.zip -d /usr/share/nginx/html;
  mv /usr/share/nginx/html/wordpress/* /usr/share/nginx/html/;
  rmdir /usr/share/nginx/html/wordpress'
  creates '/usr/share/nginx/html/wp-config-sample.php'
end

template '/usr/share/nginx/html/wp-config.php' do
  source 'wp-config.erb'
  mode '0440'
  owner 'www-data'
  group 'www-data'
  variables(
    name_database: node['main']['database']['dbname'],
    user_database: node['main']['database']['username'],
    passwd_database: node['main']['database']['password'])
end

execute 'change user ownership' do
  command 'chown -R www-data:www-data /usr/share/nginx/html/'
end

execute 'change perm directory' do
  command 'chmod -R 755 /usr/share/nginx/html/'
end
