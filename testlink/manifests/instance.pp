# == Define: testlink::instance
#
# This defined type allows the user to create a testlink instance.
#
# === Parameters
#
# [*db_name*]        - name of the testlink instance mysql database
# [*db_user*]        - name of the mysql database user
# [*db_password*]    - password for the mysql database user
# [*ip*]             - ip address of the testlink web server
# [*port*]           - port on testlink web server
# [*server_aliases*] - an array of testlink web server aliases
# [*ensure*]         - the current status of the testlink instance
#                    - options: present, absent, deleted
#
# === Examples
#
# class { 'testlink':
#   admin_email      => 'admin@puppetlabs.com',
#   db_root_password => 'really_really_long_password',
#   max_memory       => '1024'
# }
#
# testlink::instance { 'my_testlink1':
#   db_password => 'really_long_password',
#   db_name     => 'testlink1',
#   db_user     => 'testlink1_user',
#   port        => '80',
#   ensure      => 'present'
# }
#
# === Authors
#
# Sahaja Koorapati
#
# === Copyright
#
# Copyright 2015 Sahaja Koorapati
#
define testlink::instance (
  $db_password,
  $db_name                = $name,
  $db_user                = "testlink",
  $db_prefix              = 'tl',
  $ip                     = '*',
  $port                   = '80',
  $server_aliases         = '',
  $ensure                 = 'present',
  $allow_html_email      = 'false',
  $additional_mail_params = 'none',
  $logo_url               = false,
  $external_smtp          = false,
  $ssl                    = false,
  $smtp_idhost,
  $smtp_host,
  $smtp_port,
  $smtp_auth,
  $smtp_username,
  $smtp_password,
  $vhost_name_def,
  ) {

  include testlink::params
  
  validate_re($ensure, '^(present|absent|deleted)$',
  "${ensure} is not supported for ensure.
  Allowed values are 'present', 'absent', and 'deleted'.")

  include testlink::params

  # testlink needs to be installed before a particular instance is created
  #Class['testlink'] -> testlink::Instance[$name]

  # Make the configuration file more readable
  $admin_email             = $testlink::admin_email
  $db_root_password        = $testlink::db_root_password
  $doc_root                = $testlink::doc_root
  $testlink_install_path  = $testlink::testlink_install_path
  $testlink_install_files = $testlink::params::installation_files
  $apache_daemon           = $testlink::params::apache_daemon

  if $external_smtp {
    if ! $smtp_idhost   { fail("'smtp_idhost' required when 'external_smtp' is true.") }
    if ! $smtp_host     { fail("'smtp_host' required when 'external_smtp' is true.") }
    if ! $smtp_port     { fail("'smtp_port' required when 'external_smtp' is true.") }
    if ! $smtp_auth     { fail("'smtp_auth' required when 'external_smtp' is true.") }
    if ! $smtp_username { fail("'smtp_username' required when 'external_smtp' is true.") }
    if ! $smtp_password { fail("'smtp_password' required when 'external_smtp' is true.") }
    $wgsmtp = "array('host' => '${smtp_host}', 'idhost' => '${smtp_idhost}', 'port' => '${smtp_port}', 'auth' => '${smtp_auth}', 'username' => '${smtp_username}', 'password' => '${smtp_password}')"
  } else {
    $wgsmtp = "false"
  }

  # Figure out how to improve db security (manually done by
  # mysql_secure_installation)
  case $ensure {
    'present', 'absent': {
    
      mysql::db { $db_name:
        user     => $db_user,
        password => $db_password,
        host     => 'localhost',
        grant    => ['SELECT','UPDATE','INSERT','DELETE'],
        #sql      => '/var/www/install/sql/mysql/testlink_create_tables.sql',
        require => Exec['unpack-testlink'],
      }

      # Find a way to execute multiple sql files at the above step
      exec{ "testlink-create-tables":
        command     => "/usr/bin/mysql -u root -p$db_root_password ${db_name} < '/var/www/install/sql/mysql/testlink_create_tables.sql'",
        require   => Mysql_database[$db_name],
      }

      # Find a way to execute multiple sql files at the above step
      exec{ "${db_name}-import-default-data":
        command     => "/usr/bin/mysql -u root -p$db_root_password ${db_name} < '/var/www/install/sql/mysql/testlink_create_default_data.sql'",
        require   => Exec['testlink-create-tables'],
      }

      file { "${testlink::testlink_install_path}/config_db.inc.php":
        #ensure => file,
        ensure  =>  present,
        #force => true,
        content =>  template('testlink/config_db.inc.php.erb'),
      }

      file { "${testlink::testlink_install_path}/config.inc.php":
        ensure => file,
        #force => true,
        content =>  template('testlink/config.inc.php.erb'),
      }

      # Ensure resource attributes common to all resources
      File {
        ensure => directory,
        owner  => $testlink::params::apache_user,
        group  => $testlink::params::apache_user,
        mode   => '0755',
      }

      # Each instance has a separate vhost configuration
      apache::vhost { $name:
        port          => $port,
        docroot       => $doc_root,
        serveradmin   => $admin_email,
        vhost_name    => $vhost_name_def,
        serveraliases => $server_aliases,
        ensure        => $ensure,
        ssl           => $ssl,
      }
    }
    'deleted': {

      # Remove the symlink for the testlink instance directory
      file { "${doc_root}/${name}":
        ensure   => absent,
        recurse  => true,
      }

      mysql::db { $db_name:
        user     => $db_user,
        password => $db_password,
        host     => 'localhost',
        grant    => ['all'],
        ensure   => 'absent',
      }

      apache::vhost { $name:
        port          => $port,
        docroot       => $doc_root,
        ensure        => 'absent',
      } 
    }
  }
}
