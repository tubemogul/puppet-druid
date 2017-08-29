# == Class: druid::middle_manager
#
# Manage the Druid Middle Manager service.
#
# === Parameters and Usage
#
#   See README.md
#

class druid::middle_manager (
  $service   = 'middleManager',
  $host      = 'localhost',
  $port      = 8083,
  $config    = {},
  $java_opts = [],
){
  require ::druid

  validate_string(
    $service,
    $host
  )
  validate_integer($port)
  validate_hash($config)
  validate_array($java_opts)

  $init = $::service_provider ? {
    'systemd' => 'druid/druid.service.erb',
    default   => 'druid/druid.init.erb',
  }
  $env_file = $::service_provider ? {
    'systemd' => 'druid/druid.env.erb',
    default   => 'undef',
  }

  druid::node { 'middleManager':
    config           => template('druid/service.runtime.properties.erb'),
    initscript       => template($init),
    java_opts        => $java_opts,
    environment_file => $env_file,
  }

}

