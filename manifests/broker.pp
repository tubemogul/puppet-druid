# == Class: druid::broker
#
# Manage the Druid Broker service.
#
# === Parameters and Usage
#
#   See README.md
#

class druid::broker (
  $service   = 'broker',
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
  $environment_file = $::service_provider ? {
    'systemd' => 'druid/druid.env.erb',
    default   => 'undef',
  }

  druid::node { 'broker':
    config           => template('druid/service.runtime.properties.erb'),
    initscript       => template($init),
    java_opts        => $java_opts,
    environment_file => template($environment_file),
  }

}

