sonarqube_mirror = node['sonarqube']['mirror']
sonarqube_version = node['sonarqube']['version']
sonarqube_checksum = node['sonarqube']['checksum']
sonarqube_os_kernel = node['sonarqube']['os_kernel']

sonarqube_jdbc_username = node['sonarqube']['jdbc']['username']
sonarqube_jdbc_password = node['sonarqube']['jdbc']['password']
sonarqube_jdbc_url = node['sonarqube']['jdbc']['url']

sonarqube_zipfile_destination = ::File.join(Chef::Config[:file_cache_path], "sonarqube-#{sonarqube_version}.zip")
sonarqube_zipfile_source = "#{sonarqube_mirror}/sonarqube-#{sonarqube_version}.zip"
sonarqube_runscript = "/opt/sonarqube-#{sonarqube_version}/bin/#{sonarqube_os_kernel}/sonar.sh"

remote_file sonarqube_zipfile_destination do
  source sonarqube_zipfile_source
  mode 0644
  checksum sonarqube_checksum
end

package 'unzip'

bash 'unzip installation' do
  code <<-EOF
    unzip #{sonarqube_zipfile_destination} -d /opt/
  EOF
  not_if { ::File.directory?("/opt/sonarqube-#{sonarqube_version}/") }
end

sonarqube_jdbc "/opt/sonarqube-#{sonarqube_version}/conf/sonar.properties" do
  username sonarqube_jdbc_username
  password sonarqube_jdbc_password
  url sonarqube_jdbc_url
  notifies :restart, 'service[sonarqube]', :delayed
end

link '/usr/bin/sonarqube' do
  to sonarqube_runscript
end

cookbook_file '/etc/init.d/sonarqube' do
  source 'sonarqube'
  mode 0755
  owner 'root'
  group 'root'
end

service 'sonarqube' do
  supports restart: true, reload: false, status: true
  action [:enable, :start]
end
