# == Class druid::logstash
#
# installs jars needed for logstash json output
#
class druid::logstash {
  archive {"${druid::dist_dir}/lib/json-smart-1.1.1.jar":
    ensure => present,
    source => 'https://repo1.maven.org/maven2/net/minidev/json-smart/1.1.1/json-smart-1.1.1.jar',
  }
  archive {"${druid::dist_dir}/lib/jsonevent-layout-2.1.jar":
    ensure => present,
    source => 'https://github.com/br0ch0n/log4j-jsonevent-layout/releases/download/jsonevent-layout-2.1/jsonevent-layout-2.1.jar',
  }
}
