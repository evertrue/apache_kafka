# encoding: UTF-8
# Cookbook Name:: et_apache_kafka
# Recipe:: default
#

%w(
  install
  configure
  service
).each do |r|
  include_recipe "et_apache_kafka::#{r}"
end
