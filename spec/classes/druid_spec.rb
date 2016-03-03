require 'spec_helper'

describe 'druid' do
  context 'fully supported operating systems' do
    ['Debian'].each do |osfamily|
      let(:facts) {{
        :osfamily => osfamily,
        :lsbdistid => 'Ubuntu',
        :lsbdistcodename => 'trusty',
        :lsbdistrelease => '14.04',
        :architecture => 'amd64',
        :puppetversion   => Puppet.version,
      }}
      describe "druid class without any parameters on #{osfamily}" do
        let(:params) {{ }}

        it { should compile.with_all_deps }

        it { should contain_class('druid') }
        it { should contain_class('druid::install').that_comes_before('druid::config') }
        it { should contain_class('druid::config') }

        it { should contain_user('druid') }
        it { should contain_group('druid') }
        it { should contain_archive('/usr/src/imply-1.1.0.tar.gz') }
        it { should contain_file('/opt/imply') }
        it { should contain_file('common.runtime.properties')\
          .with_path('/opt/imply/conf/druid/_common/common.runtime.properties')
        }
        it { should contain_file('log4j2.xml')\
          .with_path('/opt/imply/conf/druid/_common/log4j2.xml')
        }

        describe "with Java and PPA" do
          let(:params) {{
            :install_java => true,
          }}

          it { is_expected.to contain_apt__ppa('ppa:openjdk-r/ppa')\
            .that_comes_before('Class[java]') }
          it { is_expected.to contain_package('software-properties-common') }

          it { is_expected.to contain_class('java')\
            .with_package('openjdk-8-jdk')
          }
        end

        describe "with Java without PPA" do
          let(:params) {{
            :install_java => true,
            :java_ppa => :undef,
          }}

          it { is_expected.to contain_class('java')\
            .with_package('openjdk-8-jdk')
          }
        end
      end
    end
  end

  context 'not fully supported operating system' do
    describe 'curator class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
        :puppetversion   => Puppet.version,
      }}
      let(:params) {{
        :install_java => true,
        :java_ppa     => 'ppa:openjdk-r/ppa',
      }}

      it { expect { should contain_class('druid::install') }.to raise_error(Puppet::Error, /Solaris not supported to install the PPA/) }
    end
  end

end
