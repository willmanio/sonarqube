include_recipe 'apt' if platform?('ubuntu')

node.override['java']['jdk_version'] = '7'
include_recipe 'java'

include_recipe 'sonarqube'
