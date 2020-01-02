require 'spec_helper'

describe 'druid::router' do
  context 'supported operating systems' do
    ['Debian'].each do |osfamily|
      describe "druid::router class without any parameters on #{osfamily}" do
        let(:params) { {} }
        let(:facts) do
          {
            osfamily: osfamily,
            lsbdistid: 'Ubuntu',
            lsbdistcodename: 'trusty',
            lsbdistrelease: '14.04',
            puppetversion: Puppet.version
          }
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('druid') }
        it { is_expected.to contain_class('druid::router') }
        it { is_expected.to contain_druid__node('router') }
      end
    end
  end
end
