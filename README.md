# sonarqube

Installs/Configures sonarqube

## Notes

- See `test/integration/cookbooks/test` for usage examples
- Set the `node['sonarqube']['os_kernel']` attribute to match your architecture (ie. 32 or 64 bit)
  - `linux-x86-64` - 64 bit (default)
  - `linux-x86-32` - 32 bit
- Does not install Java in case there are specific Java needs on your system
  - add `java::default` to your run list before `sonarqube::default` for a simple installation
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
