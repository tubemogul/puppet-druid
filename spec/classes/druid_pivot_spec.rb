require 'spec_helper'

describe 'druid::pivot' do
  context 'supported operating systems' do
    ['Debian'].each do |osfamily|
      let(:facts) do
        {
          osfamily: osfamily,
          lsbdistid: 'Ubuntu',
          lsbdistrelease: '14.04',
          lsbdistcodename: 'trusty',
          operatingsystem: 'Ubuntu',
          puppetversion: Puppet.version
        }
      end

      describe "druid class without any parameters on #{osfamily}" do
        let(:params) { {} }

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('druid::pivot') }
        it { is_expected.to contain_class('druid::pivot::install').that_comes_before('Class[druid::pivot::config]') }
        it { is_expected.to contain_class('druid::pivot::config').that_notifies('Class[druid::pivot::service]') }
        it { is_expected.to contain_class('druid::pivot::service') }

        it { is_expected.to contain_file('pivot_config.yaml') }
        it { is_expected.to contain_file('/etc/init.d/pivot') }
        it { is_expected.to contain_service('pivot') }
      end

      describe 'with Nodejs with the APT source' do
        let(:params) { { install_nodejs: true } }

        it { is_expected.to contain_package('nodejs').with_ensure('latest') }
        it { is_expected.to contain_apt__source('apt-node_4.x') }
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

      it { expect { is_expected.to contain_class('Class[druid::pivot::install]') }.to raise_error(Puppet::Error, %r{Solaris not supported to install the specific APT Source for Nodejs}) }
    end
  end
end
