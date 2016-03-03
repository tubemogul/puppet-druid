# == Class druid::bard::service
#
# This class is called from druid::bard
#
class druid::bard::service {

  $ensure_bard = $druid::enable_service ? {
    true  => 'running',
    false => 'stopped',
  }

  service { 'bard':
    ensure => $ensure_bard,
    enable => true,
  }

}
