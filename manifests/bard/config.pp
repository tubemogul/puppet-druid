# == Class druid::bard::config
#
# This class is called from druid::bard
#
class druid::bard::config {
  file { 'bard_config.yaml':
    path    => "${druid::bard::config_dir}/bard_config.yaml",
    content => template('druid/bard_config.yaml.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }

  file { '/etc/init.d/bard':
    ensure  => file,
    mode    => '0755',
    content => template('druid/bard.init.erb'),
  }
}
