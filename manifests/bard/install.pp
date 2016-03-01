# == Class druid::bard::install
#
# This class is called from druid::bard
#
class druid::bard::install {

  if $druid::bard::install_nodejs {
    case $::osfamily {
      'Debian': {
        include apt
        apt::source { 'apt-node_4.x':
          location => 'https://deb.nodesource.com/node_4.x',
          repos    => 'main',
          key      => {
            'id'     => '1655A0AB68576280',
            'server' => 'pgp.mit.edu',
          },
          before   => Package['nodejs'],
          notify   => Class['apt::update'],
        }
      }
      default: {
        fail("${::osfamily} not supported to install the specific APT Source for Nodejs")
      }
    }

    package { 'nodejs':
      ensure  => $druid::bard::nodejs_version,
    }
  }

}
