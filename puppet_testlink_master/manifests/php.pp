# == Class: testlink::php
#
# This modifies the default php.ini to the required testlink settings.
#

class testlink::php (
  $gc_maxlifetime         = 2400,
  $max_execution_time     = 120,
) {

  ini_setting { "gc_maxlifetime setting":
    ensure  => present,
    path    => $testlink::params::php_file_location,
    section => 'Session',
    setting => 'session.gc_maxlifetime',
    value   => '2400',
    notify  => Service[$testlink::params::apache_service],
    require => Package[$testlink::params::packages],
  }

  ini_setting { "max_execution_time setting":
    ensure  => present,
    path    => $testlink::params::php_file_location,
    section => 'PHP',
    setting => 'max_execution_time',
    value   => '120',
    notify  => Service[$testlink::params::apache_service], 
    require => Package[$testlink::params::packages],
  }

  include testlink::params

}
