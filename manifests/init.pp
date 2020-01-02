# == Class: druid
#
# This module manage Druid based on the Imply Analytics Platform version.
# It is able to manage all the Druid daemons and Bard.
#
# Documentation : http://imply.io
#
# === Parameters and Usage
#
#   See README.md
#

class druid (
  $imply_version             = '3.0.16',
  $install_method            = 'tarball',
  $install_dir               = '/opt',
  $install_link              = 'imply',
  $install_java              = false,
  $java_ppa                  = 'ppa:openjdk-r/ppa',
  $java_package              = 'openjdk-8-jdk',
  $java_home                 = '/usr/lib/jvm/java-8-openjdk-amd64',
  $config_dir                = '/opt/imply/conf/druid',
  $dist_dir                  = '/opt/imply/dist/druid',
  $extensions_dir           = '/opt/imply/dist/druid/extensions',
  $user                      = 'druid',
  $group                     = 'druid',
  $enable_service            = true,
  $notify_service            = true,
  $java_classpath            = '/opt/imply/dist/druid/lib/*',
  $java_classpath_extensions = [],
  $log_dir                   = '/var/log/druid',
  $log_size                  = '1 GB',
  $common_config             = {},
  $logstash_server           = undef,
  $logstash_port             = 4561,
  $logstash_user_fields      = '',

) {
  validate_hash($common_config)
  validate_string(
    $imply_version,
    $install_method,
    $install_dir,
    $install_link,
    $config_dir,
    $dist_dir,
    $user,
    $group,
    $java_home,
    $java_classpath,
    $java_package,
    $java_ppa,
    $log_dir
  )
  validate_bool($enable_service)
  validate_array($java_classpath_extensions)

  contain '::druid::install'
  contain '::druid::config'

Class['::druid::install'] -> Class['::druid::config']

if $logstash_server {
  class {'::druid::logstash':
    require => Class['::druid::install'],
    before  => Class['::druid::config'],
  }
}
}
