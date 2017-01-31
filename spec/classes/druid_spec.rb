require 'spec_helper'

describe 'druid' do
  context 'fully supported operating systems' do
    ['Debian'].each do |osfamily|
      let(:facts) do
        {
          osfamily: osfamily,
          lsbdistid: 'Ubuntu',
          lsbdistcodename: 'trusty',
          lsbdistrelease: '14.04',
          architecture: 'amd64',
          puppetversion: Puppet.version
        }
      end
      describe "druid class without any parameters on #{osfamily}" do
        let(:params) { {} }

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('druid') }
        it { is_expected.to contain_class('druid::install').that_comes_before('druid::config') }
        it { is_expected.to contain_class('druid::config') }

        it { is_expected.to contain_user('druid') }
        it { is_expected.to contain_group('druid') }
        it { is_expected.to contain_archive('/usr/src/imply-1.2.1.tar.gz') }
        it { is_expected.to contain_file('/opt/imply') }
        it do
          is_expected.to contain_file('common.runtime.properties').\
            with_path('/opt/imply/conf/druid/_common/common.runtime.properties')
        end
        it do
          is_expected.to contain_file('log4j2.xml').\
            with_path('/opt/imply/conf/druid/_common/log4j2.xml')
        end

        describe 'with Java and PPA' do
          let(:params) { { install_java: true } }

          it { is_expected.to contain_apt__ppa('ppa:openjdk-r/ppa').that_comes_before('Class[java]') }
          it { is_expected.to contain_package('software-properties-common') }

          it { is_expected.to contain_class('java').with_package('openjdk-8-jdk') }
        end

        describe 'with Java without PPA' do
          let(:params) do
            {
              install_java: true,
              java_ppa: :undef
            }
          end

          it { is_expected.to contain_class('java').with_package('openjdk-8-jdk') }
        end
      end
    end
  end

  context 'not fully supported operating system' do
    describe 'curator class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          osfamily: 'Solaris',
          operatingsystem: 'Nexenta',
          puppetversion: Puppet.version
        }
      end
      let(:params) do
        {
          install_java: true,
          java_ppa: 'ppa:openjdk-r/ppa'
        }
      end

      it { expect { is_expected.to contain_class('druid::install') }.to raise_error(Puppet::Error, %r{Solaris not supported to install the PPA}) }
    end
  end
end
