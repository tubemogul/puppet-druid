# == Class druid::bard::service
#
# This class is called from druid::bard
#
class druid::bard::service {
  service { 'bard':
    ensure => running,
    enable => true,
  }
}
