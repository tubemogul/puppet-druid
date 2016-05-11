# == Class druid::pivot::service
#
# This class is called from druid::pivot
#
class druid::pivot::service {

  $ensure_pivot = $druid::enable_service ? {
    true  => 'running',
    false => 'stopped',
  }

  service { 'pivot':
    ensure => $ensure_pivot,
    enable => true,
  }

}
