# == Class druid::pivot::config
#
# This class is called from druid::pivot
#
class druid::pivot::config {

  $notify_pivot = $druid::notify_service ? {
    true  => Class['druid::pivot::service'],
    false => undef,
  }

  file { 'pivot_config.yaml':
    path    => "${druid::pivot::config_dir}/config.yaml",
    content => template('druid/pivot_config.yaml.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    notify  => $notify_pivot,
  }

  if $::service_provider == 'systemd' {

    file { 'environment_file':
      ensure  => file,
      path    => "${druid::pivot::config_dir}/druid-pivot-environment",
      mode    => '0664',
      content => template('druid/pivot.env.erb'),
    }
    file { '/etc/systemd/druid-pivot.service':
      ensure  => file,
      mode    => '0664',
      content => template('druid/pivot.service.erb'),
      require => File['environment_file'],
    }
    exec { 'pivot-systemd-reload':
      command     => '/bin/systemctl daemon-reload',
      refreshonly => true,
      subscribe   => File['/etc/systemd/druid-pivot.service'],
    }
  }
  else {
    file { '/etc/init.d/pivot':
      ensure  => file,
      mode    => '0755',
      content => template('druid/pivot.init.erb'),
    }
  }
  if $druid::pivot::pivot_license_source {
    file {"${druid::pivot::config_dir}/pivot-license":
      ensure => file,
      source => $druid::pivot::pivot_license_source,
    }
  }
}
