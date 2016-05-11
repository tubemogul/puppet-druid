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
    path    => "${druid::pivot::config_dir}/pivot_config.yaml",
    content => template('druid/pivot_config.yaml.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    notify  => $notify_pivot,
  }

  file { '/etc/init.d/pivot':
    ensure  => file,
    mode    => '0755',
    content => template('druid/pivot.init.erb'),
  }
}
