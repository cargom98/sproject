include_recipe 'nginx'

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