sonarqube_mirror = node['sonarqube']['mirror']
sonarqube_version = node['sonarqube']['version']
sonarqube_checksum = node['sonarqube']['checksum']
sonarqube_os_kernel = node['sonarqube']['os_kernel']

sonarqube_user = node['sonarqube']['user']
sonarqube_group = node['sonarqube']['group']

sonarqube_config_dir = node['sonarqube']['config']['dir'] % { version: sonarqube_version }
sonarqube_config_file = node['sonarqube']['config']['file']

sonarqube_zipfile_destination = ::File.join(Chef::Config[:file_cache_path], "sonarqube-#{sonarqube_version}.zip")
sonarqube_zipfile_source = "#{sonarqube_mirror}/sonarqube-#{sonarqube_version}.zip"
sonarqube_runscript = "/opt/sonarqube-#{sonarqube_version}/bin/#{sonarqube_os_kernel}/sonar.sh"

group sonarqube_group do
  system true
end

user sonarqube_user do
  gid sonarqube_group
  system true
end

remote_file sonarqube_zipfile_destination do
  source sonarqube_zipfile_source
  mode 0644
  checksum sonarqube_checksum
end

package 'unzip'

bash 'unzip installation' do
  code <<-EOF
    unzip #{sonarqube_zipfile_destination} -d /opt/
    chown -R #{sonarqube_user}:#{sonarqube_group} /opt/sonarqube-#{sonarqube_version}
  EOF
  not_if { ::File.exist?(sonarqube_runscript) }
end

directory sonarqube_config_dir do
  recursive true
  mode 0700
  owner sonarqube_user
  group sonarqube_group
end

template "#{sonarqube_config_dir}/#{sonarqube_config_file}" do
  source 'sonar.properties.erb'
  notifies :restart, 'service[sonarqube]', :delayed
  mode 0600
end

link '/usr/bin/sonarqube' do
  to sonarqube_runscript
end

template '/etc/init.d/sonarqube' do
  source 'sonarqube.erb'
  mode 0755
  owner 'root'
  group 'root'
  variables(
    user: sonarqube_user
  )
end

service 'sonarqube' do
  supports restart: true, reload: false, status: true
  action [:enable, :start]
end
