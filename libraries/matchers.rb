if defined?(ChefSpec)
  def update_sonarqube_jdbc(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sonarqube_jdbc, :update, resource_name)
  end
end
