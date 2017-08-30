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
  $environment_file,
  $service_name = $title,
) {
  require ::druid

  validate_string(
    $config,
    $initscript,
    $service_name
  )
  validate_array($java_opts)

  $notify_node = $druid::notify_service ? {
    true  => Service["druid-${service_name}"],
    false => undef,
  }

  $ensure_node = $druid::enable_service ? {
    true  => 'running',
    false => 'stopped',
  }

  file { "${druid::config_dir}/${service_name}/runtime.properties":
    ensure  => file,
    content => $config,
    notify  => $notify_node,
  }

  if $::service_provider == 'systemd' {

    validate_string($environment_file)

    file { "${service_name}_environment_file":
      ensure  => file,
      path    => "${::druid::config_dir}/druid-${service_name}-environment",
      mode    => '0664',
      content => $environment_file,
    }
    file { "${service_name}_init":
      ensure  => file,
      path    => "/etc/systemd/system/druid-${service_name}.service",
      mode    => '0664',
      content => $initscript,
      require => File["${service_name}_environment_file"],
    }
    exec { "${service_name}_systemd-reload":
      command     => '/bin/systemctl daemon-reload',
      refreshonly => true,
      subscribe   => File["${service_name}_init"],
    }
  }
  else {
    file { "${service_name}_init":
      ensure  => file,
      path    => "/etc/init.d/druid-${service_name}",
      mode    => '0755',
      content => $initscript,
    }
  }

  service { "druid-${service_name}":
    ensure  => $ensure_node,
    enable  => true,
    require => File[
      "${service_name}_init",
      "${druid::config_dir}/${service_name}/runtime.properties"
    ],
  }
}

