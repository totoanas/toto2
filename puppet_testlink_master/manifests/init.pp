# Class: testlink
#
# This class includes all resources regarding installation and configuration
# that needs to be performed exactly once and is therefore not testlink
# instance specific.
#
# === Parameters
#
# [*server_name*]      - the host name of the server
# [*admin_email*]      - email address Apache will display when rendering error page
# [*db_root_password*] - password for mysql root user
# [*doc_root*]         - the DocumentRoot directory used by Apache
# [*tarball_url*]      - the url to fetch the testlink tar archive
# [*package_ensure*]   - state of the package
# [*max_memory*]       - a memcached memory limit
#
# === Examples
#
# class { 'testlink':
#   server_name      => 'www.example.com',
#   admin_email      => 'admin@puppetlabs.com',
#   db_root_password => 'really_really_long_password',
#   max_memory       => '1024'
# }
#
# testlink::instance { 'my_testlink1':
#   db_name     => 'testlink1_user',
#   db_password => 'really_long_password',
# }
#
#
## === Authors
#
# Sahaja Koorapati
#
# === Copyright
#
# Copyright 2015 Sahaja Koorapati
#

class testlink (
  $admin_email,
  $db_root_password,
  $doc_root       = $testlink::params::doc_root,
  $tarball_url    = $testlink::params::tarball_url,
  $package_ensure = 'latest',
  $max_memory     = '2048'
  ) inherits testlink::params {

  #Class['testlink'] -> Testlink::Instance<| |>

  # Parse the url
  $tarball_dir              = regsubst($tarball_url, '^.*?/(\d\.\d+).*$', '\1')
  $tarball_name             = regsubst($tarball_url, '^.*?/(testlink-\d\.\d+.*tar\.gz)$', '\1')
  $testlink_dir            = regsubst($tarball_url, '^.*?/(testlink-\d\.\d+\.\d+).*$', '\1')
  $testlink_install_path   = "/var/www"
  #$testlink_instance_install_path   = "/var/www"
  
  # Specify dependencies
  Class['mysql::server'] -> Class['testlink']
  #Class['mysql::config'] -> Class['testlink']
  
  class { 'apache': 
    mpm_module => 'prefork',
  }
  class { 'apache::mod::php': }
  
  # Manages the mysql server package and service by default
  class { 'mysql::server':
    root_password => $db_root_password,
  }

  class { 'testlink::php': }

  package { $testlink::params::packages:
    ensure  => $package_ensure,
  }
  Package[$testlink::params::packages] ~> Service<| title == $testlink::params::apache |>
 
  
  # Download and install testlink from a tarball
  exec { "get-testlink":
    cwd       => '/var/www',
    command   => "/usr/bin/wget ${tarball_url}",
    creates   => "/var/www/${tarball_name}",
  }
    
  exec { "unpack-testlink":
    cwd       => '/var/www',
    command   => "/bin/tar -xvzf ${tarball_name} --strip-components=2",
    #creates   => $testlink_install_path,
    require => Exec['get-testlink'],
  }

  # Ensure gui/templates_c has right permissions
  file { "${testlink_install_path}/gui/templates_c":
    ensure => directory,
    owner  => $testlink::params::apache_user,
    group  => $testlink::params::apache_user,
    mode   => '0777',
    require => Exec['unpack-testlink'],
  }

  # Ensure logs has right permissions
  file { "${testlink_install_path}/logs/":
    ensure => directory,
    owner  => $testlink::params::apache_user,
    group  => $testlink::params::apache_user,
    mode   => '0755',
    require => Exec['unpack-testlink'],
  }

  # Ensure upload_area has right permissions
  file { "${testlink_install_path}/upload_area/":
    ensure => directory,
    owner  => $testlink::params::apache_user,
    group  => $testlink::params::apache_user,
    mode   => '0755',
    require => Exec['unpack-testlink'],
  }
  
  class { 'memcached':
    max_memory => $max_memory,
    max_connections => '1024',
  }
} 
