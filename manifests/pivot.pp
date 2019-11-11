# == Class: druid::pivot
#
# Deploy and configure Pivot
#
# === Parameters and Usage
#
#   See README.md
#

class druid::pivot (
  $home_dir                     = '/opt/imply/dist/pivot',
  $config_dir                   = '/opt/imply/conf/pivot',
  $state_store                  = {},
  $port                         = 9095,
  $broker_host                  = 'localhost:8082',
  $enable_stdout_log            = true,
  $enable_file_log              = true,
  $log_dir                      = '/var/log/pivot',
  $max_workers                  = 0,
  $use_segment_metadata         = false,
  $source_list_refresh_interval = 0,
  $source_list_refresh_onload   = false,
  $install_nodejs               = false,
  $nodejs_version               = 'latest',
  $pivot_license_source         = undef,
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
    $source_list_refresh_interval,
  ])
  validate_bool(
    $enable_stdout_log,
    $enable_file_log,
    $use_segment_metadata,
    $source_list_refresh_onload,
    $install_nodejs
  )

  Class['::druid']
  -> class { '::druid::pivot::install': }
  -> class { '::druid::pivot::config':  }
  ~> class { '::druid::pivot::service': }
  -> Class['::druid::pivot']

}
