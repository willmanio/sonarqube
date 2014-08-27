require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe 'Sonarqube service' do

  it 'is listening on port 9000' do
    expect(port(9000)).to be_listening
  end

  it 'has a running service of sonarqube' do
    expect(service('sonarqube')).to be_running
  end

end
