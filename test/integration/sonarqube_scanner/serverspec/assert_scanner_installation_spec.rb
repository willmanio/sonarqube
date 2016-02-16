require 'serverspec'

set :backend, :exec

describe file('/opt/sonar-scanner-2.5') do
  it { should be_directory }
  it { should be_readable.by_user('sonarqube') }
  it { should be_executable.by_user('sonarqube') }
end

describe file('/opt/sonar-scanner-2.5/conf/sonar-runner.properties') do
  it { should be_file }
  it { should be_mode 700 }
  it { should be_owned_by 'sonarqube' }
end

describe file('/etc/profile.d/sonarqube-scanner.sh') do
  it { should be_file }
  it { should be_readable.by_user('root') }
end
