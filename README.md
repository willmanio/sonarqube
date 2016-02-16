# sonarqube

Installs and configures [SonarQube server](http://www.sonarqube.org/) and the [SonarQube Scanner](http://docs.sonarqube.org/display/SONAR/Analyzing+with+SonarQube+Scanner).
Provides a LWRP for for installing
[SonarQube plugins](http://docs.sonarqube.org/display/PLUG/Plugin+Library).

## Requirements

### Platforms
- CentOS
- Ubuntu

Tested on:
  - CentOS 6.4
  - Ubuntu 12.04

### Dependencies
SonarQube requires JDK 1.7 or later. Use the [Java Cookbook](https://github.com/agileorbit-cookbooks/java)
to install a suitable Oracle JDK or OpenJDK.

## Recipes

### default
Installs SonarQube Server and manages `sonar.properties`.

### scanner
Installs SonarQube Scanner and manages `sonar-runner.properties`.
Adds the SonarQube Scanner to all users' `PATH` via `/etc/profile.d`.

## LWRP

### sonarqube_plugin
This LWRP manages SonarQube plugins.

The `:install` action installs a SonarQube plugin to an existing SonarQube Server instance.
Plugins are retrieved from
[SonarSource's distribution mirror](https://sonarsource.bintray.com/Distribution/).
The plugin version __must__ be specifed.

```ruby
# Installs version 1.3 of the SonarQube Groovy plugin
sonarqube_plugin 'groovy' do
  version 1.3
end
```

The `:uninstall` action removes a SonarQube plugin.

```ruby
sonarqube_plugin 'groovy' do
  version 1.3
  action :uninstall
end
```

## Usage

### SonarQube Server
On systems that should be SonarQube servers, add `recipe[sonarqube]` to the runlist.

By default, the SonarQube server will connect to an embedded H2 database.
To connect to a different database, override:

- `node['sonarqube']['jdbc']['username']`
- `node['sonarqube']['jdbc']['password']`
- `node['sonarqube']['jdbc']['url']`

### SonarQube Scanner
On systems that need to invoke SonarQube analyses against an existing SonarQube Server
(such as a CI machine), add `recipe[sonarqube::scanner]` to the runlist.

By default, the SonarQube Scanner will search for a SonarQube server running on `localhost:9000`.
To connect to a different SonarQube Server, override:

- `node['sonarqube']['scanner']['host']['url']`

If the SonarQube Server prohibits anonymous users from executing analyses, also override:

- `node['sonarqube']['scanner']['host']['username']`
- `node['sonarqube']['scanner']['host']['password']`

### Advanced Attributes
Browse the `attributes` directory to view advanced attributes.

## Notes

- Does not run `apt::default` on Ubuntu
  - add `apt::default` to your run list before anything else if you need it (ie. for the Java installation as described in the previous bullet)
- Does not configure firewall settings, again, in case you have specific needs

## Contributing

### Prerequisites

- [ChefDK](http://downloads.getchef.com/chef-dk/ "ChefDK")
- Recent RuboCop

  ```
  chef gem install rubocop
  ```

### Testing

Test changes using

```
chef exec rake
chef exec kitchen verify
```

### Publishing

```
chef exec knife cookbook site share sonarqube "Monitoring & Trending"
```
