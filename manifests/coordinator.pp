# == Class: druid::coordinator
#
# Manage the Druid Coordinator service.
#
# === Parameters and Usage
#
#   See README.md
#

class druid::coordinator (
  $service   = 'coordinator',
  $host      = 'localhost',
  $port      = 8083,
  $java_opts = [],
  $config    = {},
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

  druid::node { 'coordinator':
    config           => template('druid/service.runtime.properties.erb'),
    initscript       => template($init),
    java_opts        => $java_opts,
    environment_file => template($environment_file),
  }

}

