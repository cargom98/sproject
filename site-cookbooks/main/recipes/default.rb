#
# Cookbook Name:: main
# Recipe:: default
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "main::hhvm"
include_recipe "main::nginx"
include_recipe "main::database"
include_recipe "main::wp"