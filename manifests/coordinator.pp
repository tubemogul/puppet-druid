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

  druid::node { 'coordinator':
    config     => template('druid/service.runtime.properties.erb'),
    initscript => template('druid/druid.init.erb'),
    java_opts  => $java_opts,
  }

}

