include_recipe 'nginx'

template '/etc/nginx/sites-available/default' do
  source 'default-nginx.erb'
  mode '0644'
  owner 'www-data'
  group 'www-data'
  notifies :restart, 'service[nginx]', :immediately
end

template '/etc/nginx/hhvm.conf' do
  source 'hhvm.erb'
  mode '0664'
  owner 'root'
  group 'root'
  notifies :restart, 'service[nginx]', :immediately
end
