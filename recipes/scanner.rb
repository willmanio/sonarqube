sonarqube_scanner_mirror = node['sonarqube']['scanner']['mirror']
sonarqube_scanner_version = node['sonarqube']['scanner']['version']
sonarqube_scanner_checksum = node['sonarqube']['scanner']['checksum']

sonarqube_user = node['sonarqube']['user']
sonarqube_group = node['sonarqube']['group']

sonarqube_scanner_zipfile_destination = ::File.join(Chef::Config[:file_cache_path], "sonar-scanner-#{sonarqube_scanner_version}.zip")
sonarqube_scanner_zipfile_source = "#{sonarqube_scanner_mirror}/sonar-scanner-#{sonarqube_scanner_version}.zip"

sonarqube_scanner_root_dir = "/opt/sonar-scanner-#{sonarqube_scanner_version}"
sonarqube_scanner_bin_dir = "#{sonarqube_scanner_root_dir}/bin"
sonarqube_scanner_properties_file = "#{sonarqube_scanner_root_dir}/conf/sonar-runner.properties"
sonarqube_scanner_profile_d_file = '/etc/profile.d/sonarqube-scanner.sh'

group sonarqube_group do
  system true
end

user sonarqube_user do
  gid sonarqube_group
  system true
end

remote_file sonarqube_scanner_zipfile_destination do
  source sonarqube_scanner_zipfile_source
  mode 0644
  checksum sonarqube_scanner_checksum
end

package 'unzip'

bash 'unzip SonarQube Scanner' do
  code <<-EOF
    unzip #{sonarqube_scanner_zipfile_destination} -d /opt/
  EOF
  not_if { ::File.exist?(sonarqube_scanner_root_dir) }
end

directory sonarqube_scanner_root_dir do
  recursive true
  mode 0755
  owner sonarqube_user
  group sonarqube_group
end

template sonarqube_scanner_properties_file do
  source 'sonar-runner.properties.erb'
  mode 0700
  owner sonarqube_user
  group sonarqube_group
end

template sonarqube_scanner_profile_d_file do
  source 'sonar-scanner.profile.d.erb'
  mode 0755
  owner 'root'
  group 'root'
  variables(
    sonarqube_scanner_bin_dir: sonarqube_scanner_bin_dir,
    sonarqube_scanner_root_dir: sonarqube_scanner_root_dir
  )
end
