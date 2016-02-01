# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  #
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  #
  config.vm.provider "virtualbox" do |vb|
    # For a complete reference, please see the online documentation at
    # https://docs.vagrantup.com/v2/virtualbox/configuration.html

    # Name used in Oracle VM VirtualBox Manager GUI
    vb.name = "berkshelf-ubuntu-kitchen"

    # Customize the amount of memory on the VM (in MB):
    vb.memory = "2048"

    # Customize the amount of video memory on the VM (in MB):
    vb.customize ["modifyvm", :id, "--vram", "128"]
  end

  # Install the latest version of Chef.
  # For more information see https://github.com/chef/vagrant-omnibus
  #
  config.omnibus.chef_version = :latest

  # Enabling the Berkshelf plugin.
  config.berkshelf.enabled = true

  # Provision with Chef Zero
  #
  config.vm.provision :chef_zero do |chef|
    # Specify the local paths where Chef data is stored
    chef.cookbooks_path = [ 'cookbooks', 'site-cookbooks' ]
    chef.data_bags_path = "data_bags"
    chef.roles_path = "roles"

    # Add a recipe
    chef.add_recipe "main::default"
  end
end