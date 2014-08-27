include_recipe 'apt' if platform?('ubuntu')
include_recipe 'java'
include_recipe 'sonarqube'
