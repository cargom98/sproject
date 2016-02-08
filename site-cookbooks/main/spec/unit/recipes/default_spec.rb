require 'chefspec'
require_relative '../../spec_helper'


describe 'main::default' do
  before(:each) do
      	stub_command("which nginx").and_return(true)
  	    stub_command("test -f /var/run/mysqld/mysqld.sock").and_return(true)
  end

  let (:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'should include the nginx recipe' do
      expect(chef_run).to include_recipe 'main::nginx'
  end
  it 'should include the hhvm recipe' do
      expect(chef_run).to include_recipe 'main::hhvm'
  end
    
end

describe 'main::nginx' do
    before(:each) do
      	stub_command("which nginx").and_return(true)
  	    stub_command("test -f /var/run/mysqld/mysqld.sock").and_return(true)
    end
   
   let (:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }
   
  it 'should include the nginx recipe' do
    expect(chef_run).to include_recipe 'nginx'
  end

  it 'creates a hhvm file with attributes, content' do
    expect(chef_run).to create_template('/etc/nginx/hhvm.conf').with(
      user: 'root',
      group: 'root',
      mode: '0664',
    )

    expect(chef_run).to_not create_template('/etc/nginx/hhvm.conf').with(
      user: 'bacon',
      group: 'fat',
      mode: '0444',
    )
    expect(chef_run).to render_file('/etc/nginx/hhvm.conf').with_content(/fastcgi_keep_conn on/)
  end
  
  it 'should notify nginx' do
    template = chef_run.template('/etc/nginx/hhvm.conf')
    expect(template).to notify('service[nginx]').to(:restart).immediately
  end
  
  it 'creates a default site file with attributes, content' do
    expect(chef_run).to create_template('/etc/nginx/sites-available/default').with(
      user: 'www-data',
      group: 'www-data',
      mode: '0644',
    )

    expect(chef_run).to_not create_template('/etc/nginx/sites-available/default').with(
      user: 'bacon',
      group: 'fat',
      mode: '0444',
    )
    expect(chef_run).to render_file('/etc/nginx/sites-available/default').with_content(/include hhvm.conf;/)
  end
  it 'should notify nginx' do
    template = chef_run.template('/etc/nginx/sites-available/default')
    expect(template).to notify('service[nginx]').to(:restart).immediately
  end
end

describe 'main::hhvm' do
  before(:each) do
      	stub_command("which nginx").and_return(true)
  	    stub_command("test -f /var/run/mysqld/mysqld.sock").and_return(true)
  end

  let (:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'should include the hhvm recipe' do
      expect(chef_run).to include_recipe 'hhvm'
  end
  
  it 'should start hhvm service' do
  	expect(chef_run).to start_service('hhvm')
  end

  it 'creates a server.ini file with attributes, content' do
    expect(chef_run).to create_template('/etc/hhvm/server.ini').with(
      user: 'root',
      group: 'root',
      mode: '0644',
    )

    expect(chef_run).to_not create_template('/etc/hhvm/server.ini').with(
      user: 'bacon',
      group: 'fat',
      mode: '0444',
    )
    expect(chef_run).to render_file('/etc/hhvm/server.ini').with_content(/hhvm.server.file_socket=\/var\/run\/hhvm\/hhvm.sock/)
  end
  
  it 'should notify hhvm' do
    template = chef_run.template('/etc/hhvm/server.ini')
    expect(template).to notify('service[hhvm]').to(:restart).immediately
  end  
end

describe 'main::wp' do
  before(:each) do
      	stub_command("which nginx").and_return(true)
  	    stub_command("test -f /var/run/mysqld/mysqld.sock").and_return(true)
  end

  let (:chef_run) { ChefSpec::SoloRunner.new do |node|
  		               node.set['main']['database']['dbname'] = 'nowordpress'
  					end.converge(described_recipe) }

  it 'should install unzip' do
      expect(chef_run).to install_package('Install unzip')
  end
  it 'should get a remote file fro WP' do
      expect(chef_run).to create_remote_file('/usr/share/nginx/html/latest.zip').with(
            user: 'root',
            group: 'root',
            mode: '0755',
            source: 'http://wordpress.org/latest.zip'
      	)
  end
  it 'should execute deploy wordpress' do
     expect(chef_run).to run_execute('deploying wordpress').with_creates('/usr/share/nginx/html/wp-config-sample.php')
  end
  it 'should execute change ownership' do
     expect(chef_run).to run_execute('change user ownership').with_command('chown -R www-data:www-data /usr/share/nginx/html/')
  end
  it 'should execute change perm' do
     expect(chef_run).to run_execute('change perm directory').with_command('chmod -R 755 /usr/share/nginx/html/')
  end

  it 'should modify /usr/share/nginx/html/wp-config.php' do
    expect(chef_run).to create_template('/usr/share/nginx/html/wp-config.php').with(
      user: 'www-data',
      group: 'www-data',
      mode: '0440',
    )

    expect(chef_run).to_not create_template('/usr/share/nginx/html/wp-config.php').with(
      user: 'bacon',
      group: 'fat',
      mode: '0444',
    )
    expect(chef_run).to render_file('/usr/share/nginx/html/wp-config.php').with_content(/define\('DB_NAME', 'nowordpress'\);/)
  end  
end

describe 'main::database' do
  before(:each) do
      	stub_command("which nginx").and_return(true)
  	    stub_command("test -f /var/run/mysqld/mysqld.sock").and_return(true)
  end

  let (:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'should create a mysql service' do
      expect(chef_run).to create_mysql_service('default')
  end
  it 'should install a mysql2 gem' do
      expect(chef_run).to install_mysql2_chef_gem('default')
  end
  it 'should create a wordpress database' do
      expect(chef_run).to create_mysql_database('wordpress')
  end
  it 'should create a user for wordpress database' do
      expect(chef_run).to grant_mysql_database_user('wpuser')      
  end
  it 'should create a link for the socket' do
        expect(chef_run).to create_link('/var/run/mysqld/mysqld.sock').with(to: '/var/run/mysql-default/mysqld.sock')
  end

end

