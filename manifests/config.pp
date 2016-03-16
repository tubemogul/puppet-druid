# == Class druid::config
#
# This class is called from druid
#
class druid::config {

  group { $druid::group:
    ensure => present,
  }

  user { $druid::user:
    ensure  => present,
    require => Group[$druid::group],
  }

  if $druid::notify_service {
    File['common.runtime.properties'] ~> Druid::Node <| |>
    File['log4j2.xml'] ~> Druid::Node <| |>
  }

  file { 'common.runtime.properties':
    path    => "${druid::config_dir}/_common/common.runtime.properties",
    content => template('druid/common.runtime.properties.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }

  file { 'log4j2.xml':
    path    => "${druid::config_dir}/_common/log4j2.xml",
    content => template('druid/log4j2.xml.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }

}
