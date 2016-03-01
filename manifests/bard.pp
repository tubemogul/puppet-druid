# == Class: druid::bard
#
# Deploy and configure Bard
#
# === Parameters and Usage
#
#   See README.md
#

class druid::bard (
  $config_dir                   = '/opt/imply/conf/bard',
  $port                         = 9095,
  $broker_host                  = 'localhost:8082',
  $enable_stdout_log            = true,
  $enable_file_log              = true,
  $log_dir                      = '/var/log/bard',
  $max_workers                  = 0,
  $use_segment_metadata         = false,
  $source_list_refresh_interval = 0,
  $source_list_refresh_onLoad   = false,
  $install_nodejs               = false,
  $nodejs_version               = 'latest',
){
  require '::druid'

  validate_string(
    $broker_host,
    $log_dir,
    $nodejs_version
  )
  validate_integer([
    $port,
    $max_workers,
    $source_list_refresh_interval
  ])
  validate_bool(
    $enable_stdout_log,
    $enable_file_log,
    $use_segment_metadata,
    $source_list_refresh_onLoad,
    $install_nodejs
  )

  Class['druid'] ->
  class { 'druid::bard::install': } ->
  class { 'druid::bard::config':  } ~>
  class { 'druid::bard::service': } ->
  Class['druid::bard']

}
