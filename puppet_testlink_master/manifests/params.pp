# === Class: testlink::params
#
#  The testlink configuration settings idiosyncratic to different operating
#  systems.
#
# === Parameters
#
# None
#
# === Examples
#
# None
#
# === Authors
#
# Sahaja Koorapati
#
# === Copyright
#
# Copyright 2015 Sahaja Koorapati
#
class testlink::params {

  #include testlink::instance

  $tarball_url        = 'http://downloads.sourceforge.net/project/testlink/TestLink%201.9/TestLink%201.9.3/testlink-1.9.3.tar.gz'
  $apache_daemon      = '/usr/sbin/apache2'
  $installation_files = ['api.php',
                         'api.php5',
                         'docs',
                         'install',
                         'third_party',
                         'upload_area',
                         'logs',
                         'locale',
                         'lnl.php',
                         'linkto.php',
                         'lib',
                         'gui',
                         'custom',
                         'cfg',
                         'extensions',
                         'img_auth.php',
                         'img_auth.php5',
                         'includes',
                         'index.php',
                         'index.php5',
                         'languages',
                         'load.php',
                         'load.php5',
                         'maintenance',
                         'mw-config',
                         'opensearch_desc.php',
                         'opensearch_desc.php5',
                         'profileinfo.php',
                         'redirect.php',
                         'redirect.php5',
                         'redirect.phtml',
                         'resources',
                         'serialized',
                         'skins',
                         'StartProfiler.sample',
                         'tests',
                         'thumb_handler.php',
                         'thumb_handler.php5',
                         'thumb.php',
                         'thumb.php5',
                         'testlink.phtml']
  
  case $::operatingsystem {
    redhat, centos:  {
      $doc_root           = "/var/www/$vhost_name_def"
      $packages           = [ 'php', 'php-mysql', 'php-gd', 'php-ldap', 'wget']
      $apache             = 'httpd'
      $apache_user        = 'apache'
      $php_file_location  = '/etc/php.ini'
      $apache_service     = 'httpd'
    }
    debian:  {
      $doc_root           = "/var/www/$vhost_name_def"
      $packages           = [ 'php5', 'php5-mysql', 'php5-gd', 'php5-ldap', 'wget']
      $apache             = 'apache2'
      $apache_user        = 'www-data'
      $php_file_location  = '/etc/php5/apache2/php.ini'
      $apache_service     = 'apache2'
    }
    ubuntu:  {
      $doc_root           = "/var/www/$vhost_name_def"
      $packages           = [ 'php5', 'php5-mysql', 'php5-gd', 'php5-ldap', 'wget']
      $apache             = 'apache2'
      $apache_user        = 'www-data'
      $php_file_location  = '/etc/php5/apache2/php.ini'
      $apache_service     = 'apache2'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}
