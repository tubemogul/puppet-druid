require 'spec_helper'

describe 'druid::pivot' do
  context 'supported operating systems' do
    ['Debian'].each do |osfamily|
      describe "druid class without any parameters on #{osfamily}" do
        let(:params) { {} }
        let :facts do
          {
            lsbdistrelease: '14.04',
            lsbdistcodename: 'trusty',
            operatingsystem: 'Ubuntu',
            osfamily: 'Debian',
            lsbdistid: 'Ubuntu',
            puppetversion: Puppet.version
          }
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('druid::pivot') }
        it { is_expected.to contain_class('druid::pivot::install').that_comes_before('druid::pivot::config') }
        it { is_expected.to contain_class('druid::pivot::config').that_notifies('druid::pivot::service') }
        it { is_expected.to contain_class('druid::pivot::service') }

        it { is_expected.to contain_file('pivot_config.yaml') }
        it { is_expected.to contain_file('/etc/init.d/pivot') }
        it { is_expected.to contain_service('pivot') }

        describe 'with Nodejs with the APT source' do
          let(:params) { { install_nodejs: true } }
          it { is_expected.to contain_package('nodejs')\
            .with_ensure('latest')
          }
          it { is_expected.to contain_apt__source('apt-node_4.x') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'curator class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          osfamily: 'Solaris',
          operatingsystem: 'Nexenta',
          puppetversion: Puppet.version
        }
      end
      let(:params) { { install_nodejs: true } }

      it { expect { should contain_class('druid::pivot::install') }.to raise_error(Puppet::Error, /Solaris not supported to install the specific APT Source for Nodejs/) }
    end
  end
end
