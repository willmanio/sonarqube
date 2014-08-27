require_relative '../spec_helper'

describe 'sonarqube::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'should enable and start the sonarqube service' do
    expect(chef_run).to enable_service('sonarqube')
    expect(chef_run).to start_service('sonarqube')
  end
end
