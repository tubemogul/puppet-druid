# == Class: druid::broker
#
# Manage the Druid Broker service.
#
# === Parameters and Usage
#
#   See README.md
#

class druid::router (
  $service   = 'router',
  $host      = 'localhost',
  $port      = 8888,
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

  druid::node { 'router':
    config     => template('druid/service.runtime.properties.erb'),
    initscript => template('druid/druid.init.erb'),
    java_opts  => $java_opts,
  }

}

