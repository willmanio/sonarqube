require 'serverspec'

set :backend, :exec

describe file('/opt/sonarqube-5.1.2/extensions/plugins/sonar-groovy-plugin-1.3.jar') do
  it { should be_file }
  it { should be_readable.by_user('sonarqube') }
  it { should be_executable.by_user('sonarqube') }
end
