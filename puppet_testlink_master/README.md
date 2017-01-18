# testlink module for Puppet 

## Description

This module deploys and manages multiple testlink instances using a single testlink installation. This module has been designed and tested for CentOS 6, Red Hat Enterprise Linux 6, Debian Squeeze, Debian Wheezy, and Ubuntu Precise.

## Usage

First, install the testlink package which will be used by all testlink instances:

  class { 'testlink':
    server_name      => 'www.example.com',
    admin_email      => 'admin@puppetlabs.com',
    db_root_password => 'really_really_long_password',
    doc_root         => '/var/www/testlinks'
    max_memory       => '1024'
  }
    
Next, create an individual testlink instance:

  testlink::instance { 'my_testlink1':
    db_password => 'super_long_password',
    db_name     => 'testlink1',
    db_user     => 'testlink1_user',
    port        => '80',
    ensure      => 'present'
  }

Using this module, one can create multiple independent testlink instances. To create another testlink instance, add the following puppet code:

  testlink::instance { 'my_testlink2':
    db_password => 'another_super_long_password',
    db_user     => 'another_testlink_user'
    port        => '80',
    ensure      => 'present'
  }

## Usage in yaml file

---
classes:
  - testlink
  - hiera2resource::resources
testlink::admin_email: 'sahaja.koorapati@nexusis.com'
testlink::db_root_password: 'super_long_password'
testlink::max_memory: '1024'
hiera2resource::resources::resources:
  testlink::instance:
      'mytestlink':
        ensure: present
        db_name: testlink
        db_password: 'super_long_password'
        port: '80'
        smtp_username: 'AKIAJKSNZRMGC25GBQYA'
        smtp_password: 'AkGudhhsgfaX9RZXdXPYBdbhuRazjYGtFtIW7bW26V5E'
        smtp_port: 25
        smtp_host: 'email-smtp.us-east-1.amazonaws.com'
        smtp_idhost: 'testlintestcentos.denicacloud.com'
        smtp_auth: ''
        vhost_name_def: 'testlintestcentos.denicacloud.com'


## Preconditions

Since puppet cannot ensure that all parent directories exist you need to
manage these yourself. Therefore, make sure that all parent directories of
`doc_root` directory, an attribute of `testlink` class, exist.

## Notes On Testing

Puppet module tests reside in the `spec` directory. To run tests, execute 
`rake spec` anywhere in the module's directory. More information about module 
testing can be found here:

[The Next Generation of Puppet Module Testing](http://puppetlabs.com/blog/the-next-generation-of-puppet-module-testing)

## Reference

This module is based on puppet-testlink by martasd available at
https://github.com/martasd/puppet-testlink.
