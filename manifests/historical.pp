# == Class: druid::historical
#
# Manage the Druid Historical service.
#
# === Parameters and Usage
#
#   See README.md
#

class druid::historical (
  $service   = 'historical',
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
    default   =>  'druid/druid.init.erb',
  }

  druid::node { 'historical':
    config     => template('druid/service.runtime.properties.erb'),
    initscript => template($init),
    java_opts  => $java_opts,
  }

}

