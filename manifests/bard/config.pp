# == Class druid::bard::config
#
# This class is called from druid::bard
#
class druid::bard::config {

  $notify_bard = $druid::notify_service ? {
    true  => Class['druid::bard::service'],
    false => undef,
  }

  file { 'bard_config.yaml':
    path    => "${druid::bard::config_dir}/bard_config.yaml",
    content => template('druid/bard_config.yaml.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    notify  => $notify_bard,
  }

  file { '/etc/init.d/bard':
    ensure  => file,
    mode    => '0755',
    content => template('druid/bard.init.erb'),
  }
}
