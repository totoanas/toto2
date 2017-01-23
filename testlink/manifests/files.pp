# == Define: testlink::files
#
# This defined type manages symbolic links to testlink configuration files.
# WARNING: Only for internal use!
#
# === Parameters
#
# [*target_dir*]    - testlink installation directory
#
# === Examples
#
#  testlink::files { $link_files:
#    target_dir => $target_dir,
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
define testlink::files (
  $target_dir
  ) {
  include testlink::params
  file { $name:
    ensure  => link,
    owner   => $testlink::params::apache_user,
    group   => $testlink::params::apache_user,
    mode    => '0755',
    target  => gen_target_path($target_dir, $name),
  }
}
