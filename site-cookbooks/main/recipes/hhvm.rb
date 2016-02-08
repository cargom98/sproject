include_recipe 'hhvm'

service 'hhvm' do
  action :start
end

template '/etc/hhvm/server.ini' do
  source 'server.ini.erb'
  mode '0644'
  owner 'root'
  group 'root'
  notifies :restart, 'service[hhvm]', :immediately
end
