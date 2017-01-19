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

class testlink {
   $admin_email,
  $db_root_password,
  $doc_root       = $testlink::params::doc_root,
  $tarball_url    = $testlink::params::tarball_url,
  $package_ensure = 'latest',
  $max_memory     = '2048'
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
  

  #Class['testlink'] -> Testlink::Instance<| |>

  # Parse the url
  $tarball_dir              = regsubst($tarball_url, '^.*?/(\d\.\d+).*$', '\1')
  $tarball_name             = regsubst($tarball_url, '^.*?/(testlink-\d\.\d+.*tar\.gz)$', '\1')
  $testlink_dir            = regsubst($tarball_url, '^.*?/(testlink-\d\.\d+\.\d+).*$', '\1')
  $testlink_install_path   = "/var/www"
  notice($tarball_dir)
  notice($tarball_name)
  notice($testlink_dir)
  notice($testlink_install_path)
  }
  
