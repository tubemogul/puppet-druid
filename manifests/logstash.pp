# == Class druid::logstash
#
# installs jars needed for logstash json output
#
class druid::logstash {
  archive {"${druid::dist_dir}/lib/json-smart-1.1.1.jar":
    ensure => present,
    source => 'http://central.maven.org/maven2/net/minidev/json-smart/1.1.1/json-smart-1.1.1.jar',
  }
}
