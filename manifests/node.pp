# == Define Type: druid::node
#
# Private Puppet Type used to define the Druid Services.
#
# Using a druid::node to deploy the configuration and the initscripts
# for a specific Druid Node.
#
# See : http://druid.io/docs/latest/design/design.html
#
# === Parameters and Usage
#
#   See README.md
#

define druid::node (
  $config,
  $initscript,
  $java_opts,
  $service_name = $title,
) {
  require druid

  validate_string(
    $config,
    $initscript,
    $service_name
  )
  validate_array($java_opts)

  case $druid::enable_service {
    true: {
      $ensure_service = 'running'
      $notify_service = Service["druid-${service_name}"]
    }
    default: {
      $ensure_service = 'stopped'
      $notify_service = undef
    }
  }

  file { "${druid::config_dir}/${service_name}/runtime.properties":
    ensure  => file,
    content => $config,
    notify  => $notify_service,
  }

  file { "/etc/init.d/druid-${service_name}":
    ensure  => file,
    mode    => '0755',
    content => $initscript,
  }

  service { "druid-${service_name}":
    ensure  => $ensure_service,
    enable  => true,
    require => File[
      "/etc/init.d/druid-${service_name}",
      "${druid::config_dir}/${service_name}/runtime.properties"
    ],
  }
}

