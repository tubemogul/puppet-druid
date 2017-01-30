require 'spec_helper'

['broker', 'coordinator', 'historical', 'middle_manager', 'overlord'].each do |node|

  describe 'druid::node', :type => :define do

    let(:facts) {{
      :osfamily => 'Debian',
      :lsbdistid => 'Ubuntu',
      :lsbdistcodename => 'trusty',
      :lsbdistrelease => '14.04',
      :puppetversion   => Puppet.version,
    }}

    let :pre_condition do
      'class { "druid": }'
    end

    let :title do
      node
    end

    describe "deploy a Druid node : #{node}" do
      let :params do
        {
          :config     => 'CONFIGURATION',
          :initscript => 'START_ME',
          :java_opts  => ['-server', '-Xms10g', '-Xmx10g'],
        }
      end
      it { is_expected.to contain_class('druid') }
      # it { is_expected.to contain_druid__node(node) }

      it { is_expected.to contain_file("/opt/imply/conf/druid/#{node}/runtime.properties") }
      it { is_expected.to contain_file("/etc/init.d/druid-#{node}") }
      it { is_expected.to contain_service("druid-#{node}") }
    end
  end
end
